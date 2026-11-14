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

  /// Catalog 6, identity documents of customers
  static const tiposDocumentoIdentidad = {
    '6': 'RUC',
    '1': 'DNI',
    '4': 'Carnet de extranjería',
    '7': 'Pasaporte',
    '0': 'Doc. tributario no domiciliado',
    'A': 'Cédula diplomática',
  };

  /// Catalog 3, the most used units of measure
  static const unidadesMedida = {
    'NIU': 'Unidad',
    'ZZ': 'Servicio',
    'KGM': 'Kilogramo',
    'LTR': 'Litro',
    'MTR': 'Metro',
    'BX': 'Caja',
    'GLL': 'Galón',
  };

  /// Catalog 7, how IGV applies to a sale
  static const igvTipos = {
    '10': 'Gravado',
    '20': 'Exonerado',
    '30': 'Inafecto',
    '40': 'Exportación',
  };

  /// Catalog 8, how ISC is calculated (fixed amounts, "02", aren't
  /// supported by xbuilder yet)
  static const iscTipos = {
    '01': 'Sistema al valor',
    '03': 'Precios de venta al público',
  };

  /// Catalog 6 maximum length of each document number
  static const numeroDocumentoLength = {
    '6': 11,
    '1': 8,
    '4': 12,
    '7': 12,
    '0': 15,
    'A': 15,
  };

  /// Catalog 9, why a nota de crédito is issued
  static const tiposNotaCredito = {
    '01': 'Anulación de la operación',
    '02': 'Anulación por error en el RUC',
    '03': 'Corrección por error en la descripción',
    '04': 'Descuento global',
    '05': 'Descuento por ítem',
    '06': 'Devolución total',
    '07': 'Devolución por ítem',
    '08': 'Bonificación',
    '09': 'Disminución en el valor',
    '10': 'Otros conceptos',
  };

  /// Catalog 10, why a nota de débito is issued
  static const tiposNotaDebito = {
    '01': 'Intereses por mora',
    '02': 'Aumento en el valor',
    '03': 'Penalidades / otros conceptos',
  };
}
