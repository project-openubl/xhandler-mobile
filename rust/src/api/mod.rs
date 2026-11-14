//! Functions the Flutter app calls. Rust stays stateless: documents, numbering
//! and storage live in the app.

pub mod document;
pub mod error;
pub mod signer;
pub mod sunat;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
