/// User-visible texts. The app is in Spanish only; keeping them here makes
/// them easy to review and change.
abstract final class Strings {
  static const appTitle = 'XHandler';
  static const save = 'Guardar';
  static const cancel = 'Cancelar';
  static const delete = 'Eliminar';
  static const required = 'Obligatorio';
  static const requiredFieldsLegend = 'Campos obligatorios';
  static const requiredFieldsLegendSemantics =
      'Los campos marcados con asterisco son obligatorios';
  static const show = 'Mostrar';
  static const hide = 'Ocultar';
  static const saved = 'Guardado';
  static const retry = 'Reintentar';
  static const unexpectedError = 'Ocurrió un error inesperado';
  static const guiaWithoutQr =
      'Esta guía no tiene el código QR de SUNAT, así que no se puede '
      'imprimir.';
  static const discardChanges = '¿Salir sin guardar? Se perderá lo ingresado.';
  static const discard = 'Salir';

  // Home
  static const welcomeTitle = 'Bienvenido';
  static const welcomeText =
      'Crea, firma y envía tus comprobantes electrónicos a SUNAT. Empieza '
      'registrando tu empresa.';
  static const createCompany = 'Crear empresa';
  static const addCompany = 'Agregar empresa';
  static const testMode =
      'MODO PRUEBA: los comprobantes se envían a SUNAT beta';
  static const databaseErrorTitle = 'No se puede abrir la base de datos';
  static const databaseErrorText =
      'La clave que protege los datos de este dispositivo ya no está '
      'disponible, por lo que no se pueden leer.';
  static const startOver = 'Empezar de nuevo';
  static const startOverConfirm =
      'Se borrarán todos los datos de este dispositivo: empresas, '
      'comprobantes y configuración.';
  static const startupErrorTitle = 'No se pudo iniciar la aplicación';
  static const setupTitle = 'Para emitir comprobantes reales';
  static String setupProgress(int done, int total) =>
      '$done de $total pasos listos';
  static const setupCertificateHelp =
      'De una entidad acreditada ante Indecopi, y registrado en SUNAT '
      'Operaciones en Línea (SOL).';
  static const setupCredentialsHelp =
      'Un usuario secundario SOL con el perfil de emisor electrónico.';
  static const setupProduction = 'Desactivar el modo prueba';
  static const setupProductionHelp =
      'En Empresa, cuando el certificado y las credenciales estén listos.';

  // Company
  static const companySettings = 'Empresa';
  static const companyData = 'Datos de la empresa';
  static const newCompany = 'Nueva empresa';
  static const ruc = 'RUC';
  static const invalidRuc = 'RUC no válido';
  static const companyExists = 'Ya existe una empresa con este RUC';
  static const companyCreated =
      'Empresa creada. Revisa su certificado, credenciales y series.';
  static const invalidCodigoLocal = 'El código tiene 4 dígitos';
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
  static const detracciones = 'Detracciones';
  static const cuentaDetracciones =
      'Cuenta de detracciones (Banco de la Nación)';
  static const cuentaDetraccionesHelp =
      'Si vendes bienes o servicios sujetos a detracción';
  static const agenteSunat = 'Percepción y retención';
  static const agentePercepcion = 'Agente de percepción';
  static const agentePercepcionHelp =
      'Si SUNAT te designó, podrás emitir comprobantes de percepción.';
  static const agenteRetencion = 'Agente de retención';
  static const agenteRetencionHelp =
      'Si SUNAT te designó, podrás emitir comprobantes de retención.';
  static const testModeSwitch = 'Modo prueba';
  static const testModeHelp =
      'Los comprobantes son de prueba y no tienen validez tributaria.';
  static const productionConfirm =
      'Desde ahora los comprobantes serán reales y tendrán validez ante '
      'SUNAT.';
  static const productionAccept = 'Emitir comprobantes reales';
  static const productionMissing =
      'Para emitir comprobantes reales registra primero el certificado '
      'digital y las credenciales SOL.';
  static const deleteCompany = 'Eliminar empresa';
  static const deleteCompanyConfirm =
      'La empresa dejará de mostrarse y se borrarán su certificado y '
      'credenciales de este dispositivo.';

  // Certificate
  static const certificate = 'Certificado digital';
  static const certificateMissing = 'Sin certificado';
  static const certificateSelect = 'Seleccionar archivo (.pfx o .p12)';
  static const certificateUnreadable =
      'El certificado guardado no se puede abrir; vuelve a importarlo.';
  static const certificateNotYetValid = 'El certificado aún no es válido';
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
  static const viewCertificate = 'Ver certificado';
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
  static const invalidNextNumber = 'Un número del 1 al 99999999';
  static const setDefault = 'Usar por defecto';
  static const isDefault = 'Serie por defecto';
  static const serieExists = 'Esta serie ya existe';

  // Customers
  static const customers = 'Clientes';
  static const newCustomer = 'Nuevo cliente';
  static const customer = 'Cliente';
  static const search = 'Buscar';
  static const noResults = 'Sin resultados';
  static const tipoDocumentoIdentidad = 'Tipo de documento';
  static const numeroDocumento = 'Número de documento';
  static const invalidDni = 'El DNI tiene 8 dígitos';
  static const nombre = 'Nombre o razón social';
  static const telefonoHelp = 'Con código de país, ej. +51987654321';
  static const lookup = 'Consultar';
  static const lookupNotFound = 'No se encontró el número';
  static const lookupFailed = 'No se pudo consultar; revisa la conexión';
  static const lookupAuthentication =
      'El servicio de consulta rechazó el token o la contraseña';
  static const lookupQuota = 'Se agotaron las consultas de tu plan';
  static String invalidNumeroDocumento(int length) =>
      'Hasta $length letras o números';
  static const invalidEmail = 'Correo no válido';
  static const customerExists = 'Ya existe un cliente con este documento';
  static const deleteCustomerConfirm = '¿Eliminar este cliente?';

  // Products
  static const products = 'Productos';
  static const newProduct = 'Nuevo producto';
  static const product = 'Producto';
  static const descripcion = 'Descripción';
  static const codigo = 'Código';
  static const unidadMedida = 'Unidad de medida';
  static const precio = 'Precio';
  static const invalidPrecio = 'Un monto mayor que 0, ej. 12.50';
  static const precioIncluyeIgv = 'El precio incluye IGV';
  static const igvTipo = 'Afectación del IGV';
  static const esBolsa = 'Bolsa de plástico (paga ICBPER)';
  static const favorito = 'Favorito (venta rápida)';
  static const moreOptions = 'Más opciones';
  static const iscTipo = 'Tipo de ISC';
  static const iscTasa = 'Tasa de ISC (%)';
  static const invalidIscTasa = 'Un porcentaje mayor que 0, ej. 17';
  static const igvTipoDefault = 'El de la empresa';
  static const codigoSunat = 'Código SUNAT del producto';
  static const invalidDetraccionCodigo = 'El código tiene 3 dígitos';
  static const detraccionCodigo = 'Código de detracción';
  static const detraccionPorcentaje = 'Porcentaje de detracción (%)';
  static const detraccionPorcentajeHelp =
      'El que SUNAT fija para este código, ej. 12';
  static const invalidDetraccionPorcentaje = 'Entre 0 y 100, ej. 12';
  static const detraccion = 'Detracción';
  static const deleteProductConfirm = '¿Eliminar este producto?';

  // Lookup settings
  static const lookupSettings = 'Consulta RUC/DNI';
  static const lookupNone = 'Sin consulta (ingreso manual)';
  static const lookupDecolecta = 'Decolecta';
  static const lookupDecolectaHelp =
      'Servicio con plan gratuito: regístrate en decolecta.com y copia tu token.';
  static const lookupToken = 'Token';

  // Documents
  static const newDocument = 'Nuevo comprobante';
  static const noDocuments = 'Aún no hay comprobantes';
  static const searchDocuments = 'Buscar por número o cliente';
  static const filterAll = 'Todos';
  static const filterProblems = 'Con problemas';
  static const filterType = 'Tipo';
  static const voidingDocuments = 'Bajas y resúmenes';
  static const clearFilter = 'Limpiar';
  static const factura = 'Factura';
  static const facturaHelp = 'Para clientes con RUC';
  static const boletaHelp = 'Para personas, con o sin DNI';
  static const boleta = 'Boleta';
  static const selectCustomer = 'Elegir cliente';
  static const anonymousCustomer = 'Clientes varios (sin documento)';
  static const lines = 'Productos';
  static const addProduct = 'Agregar producto';
  static const freeLine = 'Línea libre';
  static const cantidad = 'Cantidad';
  static const invalidCantidad = 'Una cantidad mayor que 0';
  static const add = 'Agregar';
  static const credito = 'Al crédito (en cuotas)';
  static const cuotas = 'Cuotas';
  static const addCuota = 'Agregar cuota';
  static const importe = 'Importe';
  static const fechaPago = 'Fecha de pago';
  static const totals = 'Totales';
  static const opGravada = 'Op. gravada';
  static const opExonerada = 'Op. exonerada';
  static const opInafecta = 'Op. inafecta';
  static const opExportacion = 'Op. exportación';
  static const igv = 'IGV';
  static const plusIgv = ' + IGV';
  static const isc = 'ISC';
  static const icbper = 'ICBPER';
  static const total = 'Total';
  static const emit = 'Emitir';
  static const creditoWithoutCuotas =
      'Agrega las cuotas de la venta al crédito.';
  static const cuotasCorregidas = 'Cuotas corregidas';
  static const ajusteWithoutCuotas =
      'Agrega las cuotas que quedan por pagar, con sus nuevas fechas.';
  static String noSerie(String tipo) =>
      'No tienes una serie activa de $tipo. Créala en Empresa → Series.';
  static const pendingDocuments = 'Por enviar';
  static const acceptedDocuments = 'Aceptados';
  static const missingCertificate =
      'Registra el certificado digital de la empresa para emitir comprobantes reales.';
  static const expiredCertificate =
      'El certificado digital venció. Importa el renovado en Empresa → '
      'Certificado digital para seguir emitiendo.';
  static const viewDocument = 'Ver comprobante';
  static const documentNotFound = 'El comprobante no está en este teléfono';
  static const done = 'Listo';
  static const timeline = 'Historial';
  static const sunatAnswer = 'Respuesta de SUNAT';
  static const fechaEmision = 'Fecha de emisión';
  static const moneda = 'Moneda';
  static const tipoCambio = 'Tipo de cambio';
  static const linesNotConverted =
      'Los precios de las líneas ya agregadas no se recalculan: revísalos.';
  static const tipoCambioHelp =
      'Venta SBS del día, en soles. Los productos del catálogo se convierten '
      'al agregarlos.';
  static String sendingDeadline(String date) =>
      'SUNAT debe recibirlo hasta el $date';

  // Notes
  static const notaCredito = 'Nota de crédito';
  static const notaDebito = 'Nota de débito';
  static const tipoNota = 'Motivo';
  static const sustento = 'Sustento';
  static String affectedDocument(String serieNumero) => 'Modifica $serieNumero';
  static const notes = 'Documentos relacionados';
  static String noNoteSerie(String tipo, String prefix) =>
      'No tienes una serie activa $prefix.. de $tipo. Créala en Empresa → Series.';

  // Voiding
  static const voidDocument = 'Anular';
  static const voidTitle = 'Anular comprobante';
  static const voidHelp =
      'Solo anula comprobantes que el cliente aún no recibió. Si ya lo '
      'recibió, emite una nota de crédito.';
  static const voidDelivered =
      'Ya compartiste este comprobante con el cliente. Si lo recibió, SUNAT '
      'no permite anularlo: emite una nota de crédito.';
  static const motivo = 'Motivo';
  static const motivoHelp = 'Para tu historial y para SUNAT';
  static const voidingRejected = 'SUNAT rechazó la anulación';
  static const comunicacionBaja = 'Comunicación de baja';
  static const resumenDiario = 'Resumen diario';
  static const reversion = 'Reversión';
  static String voids(String serieNumero) => 'Anula $serieNumero';
  static String voidedBy(String serieNumero) => 'Anulado por $serieNumero';

  // Percepción and retención
  static const percepcion = 'Percepción';
  static const percepcionHelp = 'Cobro de una factura a un cliente';
  static const retencion = 'Retención';
  static const retencionHelp = 'Pago de una factura a un proveedor';
  static const selectSupplier = 'Elegir proveedor';
  static const regimen = 'Régimen';
  static const facturaSerieNumero = 'Serie y número';
  static const invalidSerieNumero = 'Escribe la serie y el número: F001-123';
  static const facturaTotal = 'Total de la factura';
  static const cobro = 'Cobro';
  static const pago = 'Pago';
  static const importeHelp = 'Vacío: el total de la factura';
  static const fechaCobro = 'Fecha de cobro';
  static const observaciones = 'Observaciones';
  static const percibido = 'Percibido';
  static const retenido = 'Retenido';
  static const totalCobrado = 'Total cobrado';
  static const totalPagado = 'Total pagado';

  // Guía de remisión
  static const guia = 'Guía de remisión';
  static const guiaHelp = 'Para trasladar bienes';
  static String guiaOf(String serieNumero) => 'Bienes de $serieNumero';
  static const motivoTraslado = 'Motivo del traslado';
  static const motivoDescripcion = 'Descripción del motivo';
  static const selectDestinatario = 'Elegir destinatario';
  static const traslado = 'Traslado';
  static const fechaTraslado = 'Fecha de inicio del traslado';
  static const pesoTotal = 'Peso bruto total';
  static const numeroBultos = 'Bultos';
  static const partida = 'Punto de partida';
  static const llegada = 'Punto de llegada';
  static const selectAddress = 'Elegir dirección';
  static const companyAddress = 'Dirección de la empresa';
  static const customerAddress = 'Dirección del destinatario';
  static const transportePrivado = 'Transporte propio';
  static const transportePublico = 'Transportista';
  static const vehiculoM1L = 'Auto o moto (M1 o L)';
  static const vehiculoM1LHelp = 'No requiere placa ni conductor';
  static const selectVehicle = 'Elegir vehículo';
  static const selectDriver = 'Elegir conductor';
  static const selectCarrier = 'Elegir transportista';
  static const registroMtc = 'Registro MTC del transportista';
  static const optional = 'Opcional';
  static const bienes = 'Bienes';
  static const bien = 'Bien';
  static const addBien = 'Agregar bien';
  static const newVehicle = 'Nuevo vehículo';
  static const placa = 'Placa';
  static const invalidPlaca = 'Escribe la placa: ABC123';
  static const numeroCirculacion = 'Tarjeta de circulación (TUCE)';
  static const newDriver = 'Nuevo conductor';
  static const dni = 'DNI';
  static const nombres = 'Nombres';
  static const apellidos = 'Apellidos';
  static const licencia = 'Licencia';
  static const invalidLicencia = 'La licencia tiene de 9 a 10 letras o números';
  static const newAddress = 'Nueva dirección';
  static const addressName = 'Nombre (ej. Almacén Ate)';
  static const invalidCirculacion = 'De 10 a 15 letras o números';
  static const onlySoles = 'Solo facturas en soles';
  static const codigoLocalHelp =
      'Solo en traslados entre establecimientos de la empresa';

  // PDF and delivery
  static const pdfFormat = 'Formato del PDF';
  static const preparingFiles = 'Preparando los archivos…';
  static const deliver = 'Enviar al cliente';
  static const deliveries = 'Envíos al cliente';
  static const sendByEmail = 'Correo';
  static const otherApps = 'Otras aplicaciones';
  static const send = 'Enviar';
  static const sending = 'Enviando…';
  static String emailSent(String to) => 'Enviado a $to';
  static const invalidValue = 'Revisa este dato';
  static const emailNotConfigured =
      'Configura el correo de la empresa para enviar comprobantes.';
  static const emailSettings = 'Correo de la empresa';
  static const emailSettingsHelp =
      'Los comprobantes se envían desde tu correo. En Gmail usa una '
      'contraseña de aplicación (activa la verificación en dos pasos). '
      'Outlook aún no está disponible.';
  static const testDocumentNote =
      'Es un comprobante de prueba (modo prueba), sin validez tributaria.';
  static const smtpHost = 'Servidor SMTP';
  static const smtpPort = 'Puerto';
  static const appPassword = 'Contraseña de aplicación';
  static const appPasswordHelp =
      'No es la contraseña con la que entras al correo';
  static const sendTestEmail = 'Enviarme una prueba';
  static String testEmailSent(String to) => 'Prueba enviada a $to';
  static const emailAuthenticationError =
      'El correo no aceptó el usuario o la contraseña de aplicación.';
  static const emailConnectionError =
      'No se pudo conectar con el servidor de correo.';
  static const emailRejectedError = 'El servidor de correo rechazó el mensaje.';

  // Backup
  static const backupTitle = 'Copia de seguridad';
  static const backupHelp =
      'Guarda todo (empresas, comprobantes, certificados y credenciales) en '
      'un archivo protegido con una contraseña. Guárdalo en un lugar seguro, '
      'como Google Drive o tu correo, para restaurarlo en otro teléfono. '
      'Los comprobantes (XML y CDR) se deben conservar por varios años: '
      'haz copias seguido.';
  static const noBackupYet = 'Aún no has hecho una copia de seguridad.';
  static String lastBackup(String date) => 'Última copia: $date';
  static const backupPassword = 'Contraseña de la copia';
  static const backupPasswordHelp =
      'Si la olvidas, no podrás restaurar la copia. Nadie puede recuperarla.';
  static const backupPasswordTooShort = 'Al menos 8 caracteres';
  static const backupPasswordConfirmation = 'Repite la contraseña';
  static const passwordsDiffer = 'Las contraseñas no coinciden';
  static const createBackup = 'Crear copia de seguridad';
  static const backupCreated = 'Copia de seguridad guardada';
  static const restoreBackup = 'Restaurar copia de seguridad';
  static const restoreWarning =
      'Se reemplazará todo lo que hay en este teléfono por el contenido de '
      'la copia.';
  static const restore = 'Restaurar';
  static String exportCompany(String name) => 'Exportar solo $name';
  static const importCompanies = 'Importar empresas de una copia';
  static const importHelp =
      'Se agregan las empresas de la copia que no están en este teléfono, '
      'con sus comprobantes, certificado y credenciales; lo demás no cambia. '
      'Si una empresa sigue emitiendo en otro teléfono, usa series '
      'distintas en cada uno.';
  static const import = 'Importar';
  static const importing = 'Importando…';
  static String imported(String names) => 'Se agregó: $names';
  static const nothingToImport =
      'Las empresas de la copia ya están en este teléfono.';
  static const restoring = 'Restaurando…';
  static const wrongBackupPassword =
      'La contraseña no es correcta o el archivo está dañado.';
  static const notABackup =
      'El archivo no es una copia de seguridad de XHandler.';
  static const backupNeedsUpdate =
      'La copia es de una versión más nueva de XHandler. Actualiza la app.';

  // Reports
  static const reports = 'Reportes';
  static const salesRegister = 'Registro de ventas';
  static const previousMonth = 'Mes anterior';
  static const nextMonth = 'Mes siguiente';
  static const noSales = 'No hay ventas en este mes.';
  static String unconfirmedCount(int count) =>
      '$count aún sin respuesta de SUNAT: el mes puede cambiar.';
  static String documentsCount(int count, int voided) =>
      '$count comprobantes${voided == 0 ? '' : ' ($voided anulados)'}';
  static const export = 'Exportar';
  static const salesRegisterHelp =
      'Facturas, boletas y notas emitidas (salvo las rechazadas), con su '
      'estado; las notas de crédito restan y las anuladas figuran sin '
      'importes. Los totales son por moneda; los archivos traen además el '
      'tipo de cambio y el total en soles. Para abrir en Excel usa el '
      'archivo Excel.';

  // Quick sale
  static const quickSale = 'Venta rápida';
  static const quickSaleHelp = 'Boleta en segundos, para ventas de mostrador';
  static const cartEmpty = 'Toca un producto para agregarlo';
  static const charge = 'Cobrar';
  static const received = 'Recibido';
  static const change = 'Vuelto';
  static const missing = 'Falta';
  static const removeOne = 'Quitar uno';
  static const newSale = 'Nueva venta';
  static const identifyCustomer = 'Identificar cliente';
  static const noFavorites =
      'Marca productos como favoritos para verlos aquí, o búscalos.';

  // Appearance
  static const appearance = 'Apariencia';
  static const themeMode = 'Tema';
  static const themeSystem = 'Según el teléfono';
  static const themeSystemHelp =
      'Claro u oscuro, como esté configurado el teléfono';
  static const themeLight = 'Claro';
  static const themeDark = 'Oscuro';

  // Security
  static const security = 'Seguridad';
  static const appLock = 'Bloqueo de la app';
  static const appLockHelp =
      'Pide la huella, el rostro o el PIN del teléfono para abrir la app. '
      'Mientras está activo, la app no se ve en las apps recientes ni en '
      'capturas de pantalla.';
  static const lockOff = 'Desactivado';
  static const lockImmediately = 'Al salir de la app';
  static String lockAfter(int minutes) => minutes == 1
      ? 'Tras 1 minuto fuera de la app'
      : 'Tras $minutes minutos fuera de la app';
  static const lockNeedsScreenLock =
      'Configura primero un bloqueo de pantalla en el teléfono.';
  static const locked = 'XHandler está bloqueado';
  static const unlock = 'Desbloquear';
  static const unlockReason = 'Desbloquea XHandler';

  // Notifications
  static const notificationChannel = 'Respuestas de SUNAT';
  static const notificationChannelHelp = 'Cuando SUNAT responde un comprobante';

  // Diagnostics
  static const diagnostics = 'Diagnóstico';
  static const sunatBetaCheckTitle = 'Diagnóstico SUNAT beta';
  static const sunatBetaCheckHelp =
      'Crea, firma y envía una factura de prueba a SUNAT beta con el '
      'certificado de demostración.';
  static const sunatBetaCheckRun = 'Probar';
  static const sunatBetaCheckBuilding = 'Creando y firmando…';
  static const sunatBetaCheckSending = 'Enviando a SUNAT beta…';
  static const shareErrorLog = 'Compartir registro de errores';
  static const shareErrorLogHelp =
      'Errores que la app no pudo mostrar, para enviarlos a soporte. No '
      'incluye contraseñas ni certificados.';
  static const noErrorLog = 'No hay errores registrados';
}
