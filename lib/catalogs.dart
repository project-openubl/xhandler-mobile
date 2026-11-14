/// Names of the SUNAT catalog codes the app shows
abstract final class Catalogs {
  /// Catalog 1, the document types the app issues
  static const tiposComprobante = {
    '01': 'Factura',
    '03': 'Boleta de venta',
    '07': 'Nota de crédito',
    '08': 'Nota de débito',
    '09': 'Guía de remisión',
    '20': 'Comprobante de retención',
    '40': 'Comprobante de percepción',
  };

  /// First letters a series may start with, by document type
  static const serieLetters = {
    '01': 'F',
    '03': 'B',
    '07': 'FB',
    '08': 'FB',
    '09': 'T',
    '20': 'R',
    '40': 'P',
  };
}
