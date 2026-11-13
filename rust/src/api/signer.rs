use anyhow::anyhow;
use x509_cert::der::Decode;
use x509_cert::Certificate;
use xhandler::prelude::{RsaKeyPair, UblFile, XSigner};

pub struct SignedDocument {
    pub xml: String,
    /// `ds:DigestValue` of the signature, the "hash" of the printed QR code
    pub digest_value: String,
}

/// What the app shows about a certificate before using it
pub struct CertificateInfo {
    pub subject: String,
    pub issuer: String,
    /// First 11-digit number of the subject, where Peruvian certificates
    /// carry the RUC
    pub ruc: Option<String>,
    /// Unix time in seconds
    pub valid_from: i64,
    /// Unix time in seconds
    pub valid_until: i64,
}

/// Signs the XML with the certificate of a PKCS#12 keystore (`.pfx`)
pub fn sign_document(
    xml: String,
    certificate: Vec<u8>,
    password: String,
) -> anyhow::Result<SignedDocument> {
    let key_pair = RsaKeyPair::from_pkcs12(&certificate, &password)?;
    let signed = XSigner::from_bytes(xml.into_bytes())?.sign(&key_pair)?;
    let xml = String::from_utf8(signed)?;
    let digest_value = UblFile::from(xml.as_str())
        .metadata()?
        .digest_value
        .ok_or_else(|| anyhow!("The signed XML has no DigestValue"))?;
    Ok(SignedDocument { xml, digest_value })
}

/// Opens a PKCS#12 keystore (`.pfx`), which checks its password, and reads
/// its certificate
pub fn inspect_certificate(
    certificate: Vec<u8>,
    password: String,
) -> anyhow::Result<CertificateInfo> {
    let key_pair = RsaKeyPair::from_pkcs12(&certificate, &password)?;
    let certificate = Certificate::from_der(key_pair.certificate_der())?;
    let tbs = certificate.tbs_certificate();
    let subject = tbs.subject().to_string();
    let unix_seconds = |time: x509_cert::time::Time| time.to_unix_duration().as_secs() as i64;
    Ok(CertificateInfo {
        ruc: subject
            .split(|character: char| !character.is_ascii_digit())
            .find(|digits| digits.len() == 11)
            .map(String::from),
        subject,
        issuer: tbs.issuer().to_string(),
        valid_from: unix_seconds(tbs.validity().not_before),
        valid_until: unix_seconds(tbs.validity().not_after),
    })
}

#[cfg(test)]
pub(crate) mod tests {
    use super::{inspect_certificate, sign_document};
    use crate::api::document::tests::invoice;

    pub(crate) fn certificate() -> Vec<u8> {
        std::fs::read("tests/resources/LLAMA-PE-CERTIFICADO-DEMO-10467793549.pfx").unwrap()
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
        assert!(inspect_certificate(certificate(), "wrong".into()).is_err());
    }
}
