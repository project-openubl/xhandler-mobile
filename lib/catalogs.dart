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
}
