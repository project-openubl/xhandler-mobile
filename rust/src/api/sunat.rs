use base64::engine::general_purpose;
use base64::Engine;
use xhandler::prelude::{
    CdrMetadata, Credentials, FileSender, FileSenderError, SendFileAggregatedResponse, Status,
    SunatClientError, SunatFault, UblFile, Urls, VerifyTicketAggregatedResponse,
};

pub enum SunatEnvironment {
    /// SUNAT's testing services ("MODO PRUEBA")
    Beta,
    Production,
}

pub struct SunatCredentials {
    /// SOL user, e.g. "20123456789MODDATOS"
    pub username: String,
    pub password: String,
    /// API client for guias de remision
    pub client_id: Option<String>,
    pub client_secret: Option<String>,
}

/// Status of a document by SUNAT's answer (see xsender's `Status`), or
/// `NotDelivered` when SUNAT could not be reached and the same request can
/// be retried later
pub enum SunatStatus {
    Accepted,
    Rejected,
    Exception,
    InProgress,
    Unknown,
    NotDelivered,
}

pub struct SunatResponse {
    pub status: SunatStatus,
    /// CDR `ResponseCode`, fault code or ticket status code
    pub code: Option<String>,
    pub description: Option<String>,
    /// CDR observations
    pub notes: Vec<String>,
    /// CDR zip, as SUNAT returned it
    pub cdr_zip: Option<Vec<u8>>,
    /// To check later with [`verify_ticket`]
    pub ticket: Option<String>,
}

/// Sends a signed document. Guias de remision can't be sent to beta, which
/// SUNAT doesn't have for them.
pub async fn send_document(
    xml: String,
    environment: SunatEnvironment,
    credentials: SunatCredentials,
) -> anyhow::Result<SunatResponse> {
    let result = sender(environment, credentials)
        .send_file(&UblFile::from(xml))
        .await;
    delivered(result, |sent| match sent.response {
        SendFileAggregatedResponse::Cdr(cdr_base64, cdr) => from_cdr(&cdr_base64, cdr),
        SendFileAggregatedResponse::Ticket(ticket) => Ok(SunatResponse {
            ticket: Some(ticket),
            ..response(SunatStatus::InProgress, None, None)
        }),
        SendFileAggregatedResponse::Fault(fault) => Ok(from_fault(fault)),
    })
}

/// Checks the ticket SUNAT answered when the signed `xml` was sent
pub async fn verify_ticket(
    xml: String,
    ticket: String,
    environment: SunatEnvironment,
    credentials: SunatCredentials,
) -> anyhow::Result<SunatResponse> {
    let result = sender(environment, credentials)
        .verify_file_ticket(&UblFile::from(xml), &ticket)
        .await;
    delivered(result, |verified| match verified.response {
        VerifyTicketAggregatedResponse::Cdr(status, cdr) => from_cdr(&status.cdr_base64, cdr),
        VerifyTicketAggregatedResponse::NoCdr { status_code } => Ok(response(
            Status::from_code_str(&status_code).into(),
            Some(status_code),
            None,
        )),
        VerifyTicketAggregatedResponse::Fault(fault) => Ok(from_fault(fault)),
    })
}

fn sender(environment: SunatEnvironment, credentials: SunatCredentials) -> FileSender {
    FileSender {
        urls: match environment {
            SunatEnvironment::Beta => Urls::beta(),
            SunatEnvironment::Production => Urls::production(),
        },
        credentials: Credentials {
            username: credentials.username,
            password: credentials.password,
            client_id: credentials.client_id,
            client_secret: credentials.client_secret,
        },
    }
}

/// Maps SUNAT's answer with `on_answer`; network and HTTP errors become
/// `NotDelivered`, other errors (e.g. an XML whose type is unknown) fail.
fn delivered<T>(
    result: Result<T, FileSenderError>,
    on_answer: impl FnOnce(T) -> anyhow::Result<SunatResponse>,
) -> anyhow::Result<SunatResponse> {
    match result {
        Ok(answer) => on_answer(answer),
        Err(FileSenderError::SunatClient(
            error @ (SunatClientError::HttpClient(_) | SunatClientError::Response(_)),
        )) => Ok(response(
            SunatStatus::NotDelivered,
            None,
            Some(format!("{error}: {error:?}")),
        )),
        Err(error) => Err(error.into()),
    }
}

fn from_cdr(cdr_base64: &str, cdr: CdrMetadata) -> anyhow::Result<SunatResponse> {
    Ok(SunatResponse {
        notes: cdr.notes.clone(),
        cdr_zip: Some(general_purpose::STANDARD.decode(cdr_base64)?),
        ..response(
            cdr.status().into(),
            Some(cdr.response_code),
            Some(cdr.description),
        )
    })
}

fn from_fault(fault: SunatFault) -> SunatResponse {
    let code = fault
        .sunat_code()
        .map_or_else(|| fault.code.clone(), |code| code.to_string());
    response(fault.status().into(), Some(code), Some(fault.message))
}

fn response(
    status: SunatStatus,
    code: Option<String>,
    description: Option<String>,
) -> SunatResponse {
    SunatResponse {
        status,
        code,
        description,
        notes: Vec::new(),
        cdr_zip: None,
        ticket: None,
    }
}

impl From<Status> for SunatStatus {
    fn from(status: Status) -> Self {
        match status {
            Status::Accepted => Self::Accepted,
            Status::Rejected => Self::Rejected,
            Status::Exception => Self::Exception,
            Status::InProgress => Self::InProgress,
            Status::Unknown => Self::Unknown,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::{send_document, SunatCredentials, SunatEnvironment, SunatStatus};
    use crate::api::document::tests::invoice;
    use crate::api::signer::sign_document;
    use crate::api::signer::tests::certificate;

    fn beta_credentials() -> SunatCredentials {
        SunatCredentials {
            username: "10467793549MODDATOS".into(),
            password: "MODDATOS".into(),
            client_id: None,
            client_secret: None,
        }
    }

    /// Calls SUNAT beta: `cargo test -- --ignored`
    #[tokio::test]
    #[ignore]
    async fn send_document_to_beta() {
        let signed = sign_document(invoice().xml, certificate(), "password".into()).unwrap();
        let response = send_document(signed.xml, SunatEnvironment::Beta, beta_credentials())
            .await
            .unwrap();

        assert!(matches!(response.status, SunatStatus::Accepted));
        assert!(response.cdr_zip.is_some());
    }

    #[tokio::test]
    async fn send_document_refuses_guias_in_beta() {
        let xml = r#"<DespatchAdvice xmlns="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"><cbc:ID>T001-1</cbc:ID></DespatchAdvice>"#;
        let result = send_document(xml.into(), SunatEnvironment::Beta, beta_credentials()).await;
        assert!(result.is_err());
    }
}
