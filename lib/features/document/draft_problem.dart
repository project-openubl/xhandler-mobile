/// Why a draft can't be issued; checked before using a number, since SUNAT
/// would reject the document and the number would be lost
enum DraftProblem {
  noLines,

  /// Facturas are for customers with a RUC
  facturaWithoutRuc,

  /// Percepciones and retenciones are for customers or suppliers with a RUC
  customerWithoutRuc,

  /// A percepción or retención is of some amount, up to the factura's total
  operacionOverTotal,

  /// Guías need where the goods leave from and arrive at
  missingAddresses,

  /// Guías need the vehicle and driver (privado) or the carrier (público)
  missingTransport,

  /// Motivo "otros" needs a description
  missingMotivo,

  /// Guías go to an identified destinatario
  anonymousDestinatario,

  /// Transfers between the company's establishments need their SUNAT codes
  missingCodigoLocal,

  /// Documents in other currencies need their exchange rate
  missingTipoCambio,

  /// Boletas over S/ 700 need an identified customer
  anonymousOver700,

  /// Installments must add up to what's owed (the total less any
  /// detracción), after the issue date
  cuotasMismatch,

  /// A factura with detracción needs the company's Banco de la Nación
  /// account
  missingDetraccionAccount,

  /// Notas of facturas use F series, notas of boletas B series
  noteSerieMismatch,

  /// Notas modify facturas and boletas accepted by SUNAT, in the same
  /// environment
  invalidAffectedDocument,

  /// Notas de crédito can't credit more than the invoice's total
  noteExceedsInvoice,

  /// Only documents SUNAT accepted can be voided
  notVoidable,

  /// Facturas and boletas are voided after their notas
  voidNotesFirst,

  /// Voiding is allowed only within the voiding period (voiding.dart)
  voidingTooLate,
}

class InvalidDraftError implements Exception {
  const InvalidDraftError(this.problem);

  final DraftProblem problem;
}
