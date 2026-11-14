use chrono::{DateTime, Utc};
use x509_cert::der::Decode;
use x509_cert::Certificate;
use xhandler::prelude::{RsaKeyPair, UblFile, XSigner};

use crate::api::error::{BridgeError, BridgeErrorKind};
use crate::api::ruc::find_ruc;

pub struct SignedDocument {
    pub xml: String,
    /// `ds:DigestValue` of the signature, the "hash" of the printed QR code
    pub digest_value: String,
}

/// What the app shows about a certificate before using it
pub struct CertificateInfo {
    pub subject: String,
    pub issuer: String,
    /// RUC found in the subject's attributes, if any
    pub ruc: Option<String>,
    pub valid_from: DateTime<Utc>,
    pub valid_until: DateTime<Utc>,
}

/// Signs the XML with the certificate of a PKCS#12 keystore (`.pfx`)
pub fn sign_document(
    xml: String,
    certificate: Vec<u8>,
    password: String,
) -> Result<SignedDocument, BridgeError> {
    let key_pair = RsaKeyPair::from_pkcs12(&certificate, &password)?;
    let xml = XSigner::from_bytes(xml.into_bytes())
        .map_err(BridgeError::invalid_document)?
        .sign(&key_pair)?;
    let xml = String::from_utf8(xml).map_err(BridgeError::invalid_document)?;
    let digest_value = UblFile::from(xml.as_str())
        .metadata()
        .map_err(BridgeError::invalid_document)?
        .digest_value
        .ok_or_else(|| BridgeError::invalid_document(anyhow::anyhow!("No DigestValue")))?;
    Ok(SignedDocument { xml, digest_value })
}

/// Opens a PKCS#12 keystore (`.pfx`), which checks its password, and reads
/// its certificate
pub fn inspect_certificate(
    certificate: Vec<u8>,
    password: String,
) -> Result<CertificateInfo, BridgeError> {
    let key_pair = RsaKeyPair::from_pkcs12(&certificate, &password)?;
    let certificate = Certificate::from_der(key_pair.certificate_der())
        .map_err(|error| BridgeError::new(BridgeErrorKind::InvalidCertificate, error))?;
    let tbs = certificate.tbs_certificate();
    let date_time = |time: x509_cert::time::Time| {
        DateTime::from_timestamp(time.to_unix_duration().as_secs() as i64, 0).unwrap_or_default()
    };
    let ruc = tbs.subject().iter().find_map(|attribute| {
        // e.g. "SERIALNUMBER=RUC:20123456789"; undecodable values are "#<hex>"
        let text = attribute.to_string();
        let (_, value) = text.split_once('=')?;
        if value.starts_with('#') {
            return None;
        }
        find_ruc(value)
    });
    Ok(CertificateInfo {
        ruc,
        subject: tbs.subject().to_string(),
        issuer: tbs.issuer().to_string(),
        valid_from: date_time(tbs.validity().not_before),
        valid_until: date_time(tbs.validity().not_after),
    })
}

#[cfg(test)]
pub(crate) mod tests {
    use super::{inspect_certificate, sign_document};
    use crate::api::document::tests::invoice;
    use crate::api::error::BridgeErrorKind;

    /// SUNAT's demo certificate, also used by the app in MODO PRUEBA
    pub(crate) fn certificate() -> Vec<u8> {
        include_bytes!("../../../assets/demo/certificado_demo.pfx").to_vec()
    }

    #[test]
    fn sign_document_returns_the_digest_value() {
        let signed = sign_document(invoice().xml, certificate(), "password".into()).unwrap();

        assert!(signed.xml.contains("<ds:Signature "));
        assert!(signed.xml.contains(&format!(
            "<ds:DigestValue>{}</ds:DigestValue>",
            signed.digest_value
        )));
    }

    #[test]
    fn inspect_certificate_reads_ruc_and_validity() {
        let info = inspect_certificate(certificate(), "password".into()).unwrap();

        assert_eq!(info.ruc.as_deref(), Some("10467793549"));
        assert!(info.valid_from < info.valid_until);
    }

    #[test]
    fn inspect_certificate_tells_wrong_passwords_and_invalid_files_apart() {
        let wrong_password = inspect_certificate(certificate(), "wrong".into())
            .err()
            .unwrap();
        assert!(matches!(
            wrong_password.kind,
            BridgeErrorKind::WrongPassword
        ));

        let invalid = inspect_certificate(b"not a pfx".to_vec(), "password".into())
            .err()
            .unwrap();
        assert!(matches!(invalid.kind, BridgeErrorKind::InvalidCertificate));
    }
}
