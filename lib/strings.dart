/// User-visible texts. The app is in Spanish only; keeping them here makes
/// them easy to review and change.
abstract final class Strings {
  static const appTitle = 'XHandler';
  static const save = 'Guardar';
  static const cancel = 'Cancelar';
  static const delete = 'Eliminar';
  static const required = 'Obligatorio';

  // Home
  static const welcomeTitle = 'Bienvenido';
  static const welcomeText =
      'Crea, firma y envía tus comprobantes electrónicos a SUNAT. Empieza '
      'registrando tu empresa.';
  static const createCompany = 'Crear empresa';
  static const addCompany = 'Agregar empresa';
  static const testMode =
      'MODO PRUEBA: los comprobantes se envían a SUNAT beta';
  static const documentsComingSoon = 'Aquí verás tus comprobantes.';
  static const databaseErrorTitle = 'No se puede abrir la base de datos';
  static const databaseErrorText =
      'La clave que protege los datos de este dispositivo ya no está '
      'disponible. Puedes empezar de nuevo (se borran los datos de este '
      'dispositivo) o restaurar una copia de seguridad.';
  static const startOver = 'Empezar de nuevo';

  // Company
  static const companySettings = 'Empresa';
  static const companyData = 'Datos de la empresa';
  static const newCompany = 'Nueva empresa';
  static const ruc = 'RUC';
  static const invalidRuc = 'RUC no válido';
  static const companyExists = 'Ya existe una empresa con este RUC';
  static const razonSocial = 'Razón social';
  static const nombreComercial = 'Nombre comercial';
  static const domicilioFiscal = 'Domicilio fiscal';
  static const direccion = 'Dirección';
  static const urbanizacion = 'Urbanización';
  static const distrito = 'Distrito';
  static const provincia = 'Provincia';
  static const departamento = 'Departamento';
  static const ubigeo = 'Ubigeo';
  static const invalidUbigeo = 'El ubigeo tiene 6 dígitos';
  static const codigoLocal = 'Código de establecimiento';
  static const contacto = 'Contacto';
  static const telefono = 'Teléfono';
  static const email = 'Correo electrónico';
  static const testModeSwitch = 'Modo prueba';
  static const testModeHelp =
      'Envía a SUNAT beta. Desactívalo para emitir comprobantes reales.';
  static const deleteCompany = 'Eliminar empresa';
  static const deleteCompanyConfirm =
      'Se ocultará la empresa y se borrarán su certificado y credenciales de '
      'este dispositivo.';

  // Certificate
  static const certificate = 'Certificado digital';
  static const certificateMissing = 'Sin certificado';
  static const certificateSelect = 'Seleccionar archivo .pfx';
  static const certificatePassword = 'Contraseña del certificado';
  static const certificateWrongPassword = 'Contraseña incorrecta';
  static const certificateInvalid =
      'El archivo no es un certificado digital válido (.pfx o .p12)';
  static String certificateOtherRuc(String? ruc) =>
      'El certificado ${ruc == null ? 'no indica un RUC' : 'es del RUC $ruc'}, '
      'no de esta empresa. ¿Guardarlo de todos modos?';
  static String certificateValidUntil(String date) => 'Válido hasta $date';
  static const certificateExpired = 'El certificado está vencido';
  static const certificateExpiresSoon =
      'El certificado vence en menos de 30 días';
  static const certificateTestModeHelp =
      'En modo prueba, sin certificado propio se usa el certificado de '
      'demostración de SUNAT.';

  // Credentials
  static const credentials = 'Credenciales SUNAT';
  static const solUsername = 'Usuario SOL';
  static const solUsernameHelp =
      'RUC seguido del usuario, ej. 20123456789USUARIO';
  static const solPassword = 'Clave SOL';
  static const greClientId = 'Client ID (guías de remisión)';
  static const greClientSecret = 'Client secret (guías de remisión)';
  static const credentialsTestModeHelp =
      'En modo prueba se usan las credenciales de SUNAT beta (MODDATOS).';

  // Series
  static const series = 'Series';
  static const addSerie = 'Agregar serie';
  static const tipoComprobante = 'Tipo de comprobante';
  static const serie = 'Serie';
  static String invalidSerie(String letters) =>
      '4 letras o números, empezando con ${letters.split('').join(' o ')}';
  static const nextNumber = 'Siguiente número';
  static String nextNumberOf(int number) => 'Siguiente número: $number';
  static const invalidNextNumber = 'Un número mayor que 0';
  static const setDefault = 'Usar por defecto';

  // Diagnostics
  static const sunatBetaCheckTitle = 'Diagnóstico SUNAT beta';
  static const sunatBetaCheckHelp =
      'Crea, firma y envía una factura de prueba a SUNAT beta con el '
      'certificado de demostración.';
  static const sunatBetaCheckRun = 'Probar';
  static const sunatBetaCheckBuilding = 'Creando y firmando…';
  static const sunatBetaCheckSending = 'Enviando a SUNAT beta…';
}
