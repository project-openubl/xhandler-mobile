use xhandler::prelude::SignError;

/// Error returned to the app: [`BridgeErrorKind`] says what the user can do
/// about it, `message` gives the details (in English, for support and logs)
#[derive(Debug)]
pub struct BridgeError {
    pub kind: BridgeErrorKind,
    pub message: String,
}

#[derive(Debug)]
pub enum BridgeErrorKind {
    /// The certificate's password is wrong
    WrongPassword,
    /// The file is not a usable PKCS#12 certificate
    InvalidCertificate,
    /// The document can't be created, signed or read
    InvalidDocument,
    Other,
}

impl BridgeError {
    pub(crate) fn new(kind: BridgeErrorKind, error: impl Into<anyhow::Error>) -> Self {
        Self {
            kind,
            message: format!("{:#}", error.into()),
        }
    }

    pub(crate) fn invalid_document(error: impl Into<anyhow::Error>) -> Self {
        Self::new(BridgeErrorKind::InvalidDocument, error)
    }

    pub(crate) fn other(error: impl Into<anyhow::Error>) -> Self {
        Self::new(BridgeErrorKind::Other, error)
    }
}

impl From<SignError> for BridgeError {
    fn from(error: SignError) -> Self {
        let kind = match error {
            SignError::WrongPassword => BridgeErrorKind::WrongPassword,
            SignError::Key(_) => BridgeErrorKind::InvalidCertificate,
            _ => BridgeErrorKind::InvalidDocument,
        };
        Self::new(kind, error)
    }
}
