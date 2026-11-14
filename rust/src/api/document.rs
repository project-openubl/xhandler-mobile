use anyhow::Context;
use xhandler::prelude::{Defaults, Document, Enrich, Renderer};

use crate::api::error::BridgeError;

/// Values the enrichment uses when the document doesn't set them
pub struct DocumentDefaults {
    /// e.g. "0.18"
    pub igv_tasa: String,
    /// Bag tax per unit, e.g. "0.50"
    pub icb_tasa: String,
    /// e.g. "0.04"
    pub ivap_tasa: String,
    /// "YYYY-MM-DD"
    pub fecha_emision: String,
}

pub struct BuiltDocument {
    /// UBL XML, not signed yet
    pub xml: String,
    /// The document after enrichment (taxes, totals, legends), in the same
    /// JSON shape as the input
    pub enriched_json: String,
}

/// Enriches and renders a document given as JSON:
/// `{"kind": "Invoice", "spec": {...}}` (xbuilder models)
pub fn build_document(
    document_json: String,
    defaults: DocumentDefaults,
) -> Result<BuiltDocument, BridgeError> {
    build(&document_json, defaults).map_err(BridgeError::invalid_document)
}

fn build(document_json: &str, defaults: DocumentDefaults) -> anyhow::Result<BuiltDocument> {
    let mut document: Document = serde_json::from_str(document_json)?;
    document.enrich(&Defaults {
        igv_tasa: defaults.igv_tasa.parse().context("igv_tasa")?,
        icb_tasa: defaults.icb_tasa.parse().context("icb_tasa")?,
        ivap_tasa: defaults.ivap_tasa.parse().context("ivap_tasa")?,
        fecha_emision: defaults.fecha_emision.parse().context("fecha_emision")?,
    })?;
    Ok(BuiltDocument {
        xml: document.render()?,
        enriched_json: serde_json::to_string(&document)?,
    })
}

#[cfg(test)]
pub(crate) mod tests {
    use super::{build_document, BuiltDocument, DocumentDefaults};
    use crate::api::error::BridgeErrorKind;

    pub(crate) fn defaults() -> DocumentDefaults {
        DocumentDefaults {
            igv_tasa: "0.18".into(),
            icb_tasa: "0.50".into(),
            ivap_tasa: "0.04".into(),
            fecha_emision: "2026-11-13".into(),
        }
    }

    pub(crate) fn invoice() -> BuiltDocument {
        let json = r#"{
            "kind": "Invoice",
            "spec": {
                "serie_numero": "F001-1",
                "proveedor": {"ruc": "10467793549", "razon_social": "Llama S.A.C."},
                "cliente": {
                    "nombre": "Cliente S.A.C.",
                    "numero_documento_identidad": "20123456789",
                    "tipo_documento_identidad": "6"
                },
                "detalles": [{"descripcion": "Item", "cantidad": 2, "precio": 100}]
            }
        }"#;
        build_document(json.into(), defaults()).unwrap()
    }

    #[test]
    fn build_document_enriches_and_renders() {
        let built = invoice();

        assert!(built.xml.contains("<cbc:ID>F001-1</cbc:ID>"));
        assert!(built.xml.contains("2026-11-13"));
        let enriched: serde_json::Value = serde_json::from_str(&built.enriched_json).unwrap();
        assert_eq!(enriched["kind"], "Invoice");
        assert_eq!(
            enriched["spec"]["total_impuestos"]["gravado_importe"],
            "36.00"
        );
    }

    /// The JSON the Flutter app produces (test/features/invoice_draft_test.dart
    /// writes these files) must build and sign
    #[test]
    fn build_document_accepts_the_app_drafts() {
        let mut built = 0;
        for entry in std::fs::read_dir("tests/resources/drafts").unwrap() {
            let path = entry.unwrap().path();
            let json = std::fs::read_to_string(&path).unwrap();
            let document = build_document(json, defaults())
                .unwrap_or_else(|error| panic!("{path:?}: {}", error.message));
            crate::api::signer::sign_document(
                document.xml,
                crate::api::signer::tests::certificate(),
                "password".into(),
            )
            .unwrap_or_else(|error| panic!("{path:?}: {}", error.message));
            built += 1;
        }
        assert!(built >= 3);
    }

    #[test]
    fn build_document_rejects_unknown_kinds() {
        let json = r#"{"kind": "Unknown", "spec": {}}"#;
        let error = build_document(json.into(), defaults()).err().unwrap();
        assert!(matches!(error.kind, BridgeErrorKind::InvalidDocument));
    }
}
