import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../src/rust/api/sunat.dart';

const _uuid = Uuid();

/// New row id: a UUIDv7, unique across devices and sortable by creation
String newId() => _uuid.v7();

/// Timestamps are stored in UTC (DESIGN §3.1)
DateTime nowUtc() => DateTime.now().toUtc();

/// Columns of every table a future sync backend would replicate
/// (docs/DESIGN.md §3.1): device-generated sortable ids, timestamps and soft
/// deletes.
mixin SyncColumns on Table {
  TextColumn get id => text().clientDefault(newId)();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A company is the namespace of everything else. Its secrets (certificate,
/// SOL credentials...) are in the secure storage, not here.
@TableIndex.sql(
  'CREATE UNIQUE INDEX companies_ruc ON companies (ruc) '
  'WHERE deleted_at IS NULL',
)
class Companies extends Table with SyncColumns {
  TextColumn get ruc => text().withLength(min: 11, max: 11)();
  TextColumn get razonSocial => text()();
  TextColumn get nombreComercial => text().nullable()();

  // Domicilio fiscal
  TextColumn get ubigeo => text().nullable()();
  TextColumn get departamento => text().nullable()();
  TextColumn get provincia => text().nullable()();
  TextColumn get distrito => text().nullable()();
  TextColumn get direccion => text().nullable()();
  TextColumn get urbanizacion => text().nullable()();
  TextColumn get codigoLocal => text().nullable()();

  TextColumn get telefono => text().nullable()();
  TextColumn get email => text().nullable()();

  TextColumn get sunatEnvironment => textEnum<SunatEnvironment>().withDefault(
    Constant(SunatEnvironment.beta.name),
  )();

  /// Currency of new documents (ISO 4217)
  TextColumn get moneda => text().withDefault(const Constant('PEN'))();

  /// IGV type of new products (Catalog 7), "10" = gravado
  TextColumn get igvTipo => text().withDefault(const Constant('10'))();

  /// Banco de la Nación account where customers deposit detracciones.
  /// Schema 2.
  TextColumn get cuentaDetracciones => text().nullable()();

  BoolColumn get esAgentePercepcion =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get esAgenteRetencion =>
      boolean().withDefault(const Constant(false))();

  /// RUC/DNI lookup service, see [LookupProvider]
  TextColumn get lookupProvider => textEnum<LookupProvider>().withDefault(
    Constant(LookupProvider.none.name),
  )();
}

enum LookupProvider { none, decolecta }

/// Document numbering: each series gives `serie-number` to one document type.
/// Series are never deleted, so their numbers are never reused; they are
/// deactivated instead.
@DataClassName('Serie')
class Series extends Table with SyncColumns {
  TextColumn get companyId => text().references(Companies, #id)();

  /// Catalog 1, e.g. "01" factura
  TextColumn get tipoComprobante => text()();
  TextColumn get serie => text().withLength(min: 4, max: 4)();

  /// Number the next emitted document takes
  IntColumn get nextNumber => integer().withDefault(const Constant(1))();

  /// Suggested series for its document type
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();

  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [
    {companyId, tipoComprobante, serie},
  ];
}

@TableIndex.sql(
  'CREATE UNIQUE INDEX customers_document ON customers '
  '(company_id, tipo_documento_identidad, numero_documento_identidad) '
  'WHERE deleted_at IS NULL',
)
class Customers extends Table with SyncColumns {
  TextColumn get companyId => text().references(Companies, #id)();

  /// Catalog 6, e.g. "6" RUC, "1" DNI
  TextColumn get tipoDocumentoIdentidad => text()();
  TextColumn get numeroDocumentoIdentidad => text()();
  TextColumn get nombre => text()();

  // Address, as SUNAT's padrón and the lookup services give it
  TextColumn get direccion => text().nullable()();
  TextColumn get distrito => text().nullable()();
  TextColumn get provincia => text().nullable()();
  TextColumn get departamento => text().nullable()();
  TextColumn get ubigeo => text().nullable()();
  TextColumn get email => text().nullable()();

  /// With country code, e.g. "+51987654321"
  TextColumn get telefono => text().nullable()();
}

class Products extends Table with SyncColumns {
  TextColumn get companyId => text().references(Companies, #id)();
  TextColumn get codigo => text().nullable()();

  /// SUNAT product code (UNSPSC)
  TextColumn get codigoSunat => text().nullable()();
  TextColumn get descripcion => text()();

  /// Catalog 3, e.g. "NIU" unit, "ZZ" service
  TextColumn get unidadMedida => text().withDefault(const Constant('NIU'))();

  /// Decimal as text, to keep it exact
  TextColumn get precio => text()();
  BoolColumn get precioIncluyeIgv =>
      boolean().withDefault(const Constant(true))();

  /// Catalog 7; null = the company's default
  TextColumn get igvTipo => text().nullable()();

  /// Catalog 8 and its rate, as a percentage (e.g. "17")
  TextColumn get iscTipo => text().nullable()();
  TextColumn get iscTasa => text().nullable()();

  /// Plastic bag, taxed with ICB
  BoolColumn get esBolsa => boolean().withDefault(const Constant(false))();

  /// Catalog 54, when the good or service is subject to detracción
  TextColumn get detraccionCodigo => text().nullable()();

  /// Detracción rate of [detraccionCodigo] as a percentage, e.g. "12" (from
  /// SUNAT's annex; rates change, so the user enters it). Schema 2.
  TextColumn get detraccionPorcentaje => text().nullable()();

  /// Shown in the quick sale grid
  BoolColumn get favorito => boolean().withDefault(const Constant(false))();
}

/// Where a document is in its life (docs/DESIGN.md §5)
enum DocumentStatus {
  /// Signed and stored; SUNAT hasn't answered yet (no connection, server
  /// error...). Retried automatically.
  pendingSend,

  /// SUNAT gave a ticket; it's checked automatically
  inProgress,
  accepted,
  acceptedWithObservations,
  rejected,

  /// Not processed by SUNAT; the user must fix something and resend
  exception,
  unknown,

  /// Its comunicación de baja or resumen is waiting for SUNAT's answer
  voiding,

  /// SUNAT accepted its comunicación de baja or resumen
  voided,
}

/// An issued document: signed with its number taken, whatever SUNAT says
@TableIndex.sql(
  'CREATE UNIQUE INDEX documents_number ON documents '
  '(company_id, environment, tipo_comprobante, serie, numero)',
)
@TableIndex.sql(
  'CREATE INDEX documents_list ON documents '
  '(company_id, environment, created_at)',
)
@TableIndex.sql(
  'CREATE INDEX documents_outbox ON documents (status, next_attempt_at)',
)
class Documents extends Table with SyncColumns {
  TextColumn get companyId => text().references(Companies, #id)();

  /// Beta documents are kept apart from production ones
  TextColumn get environment => textEnum<SunatEnvironment>()();

  /// Catalog 1
  TextColumn get tipoComprobante => text()();
  TextColumn get serie => text()();
  IntColumn get numero => integer()();

  /// "YYYY-MM-DD", Peru's date
  TextColumn get fechaEmision => text()();
  TextColumn get clienteTipoDocumento => text()();
  TextColumn get clienteNumeroDocumento => text()();
  TextColumn get clienteNombre => text()();
  TextColumn get moneda => text()();

  /// Decimal as text
  TextColumn get total => text()();
  TextColumn get status => textEnum<DocumentStatus>()();

  /// SUNAT's answer: CDR ResponseCode, fault code, "HTTP 401"...
  TextColumn get sunatCode => text().nullable()();
  TextColumn get sunatDescription => text().nullable()();

  /// CDR observations, JSON list
  TextColumn get sunatNotes => text().nullable()();
  TextColumn get ticket => text().nullable()();

  /// Signature hash, printed in the QR code
  TextColumn get digestValue => text()();

  /// Sends that got no answer, for the retry back-off
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();

  /// What the user entered (xbuilder JSON), to fix and resend it or to
  /// issue a copy
  TextColumn get inputJson => text()();

  /// The document as built (xbuilder JSON, enriched), for the PDF
  TextColumn get enrichedJson => text()();

  /// The document a nota de crédito/débito modifies
  TextColumn get affectedDocumentId =>
      text().nullable().references(Documents, #id)();

  /// The comunicación de baja or resumen that voids this document
  TextColumn get voidedByDocumentId =>
      text().nullable().references(Documents, #id)();

  /// Device that issued it (DESIGN §3.1)
  TextColumn get deviceId => text()();
}

enum DocumentFileKind { signedXml, cdrZip }

class DocumentFiles extends Table with SyncColumns {
  TextColumn get documentId => text().references(Documents, #id)();
  TextColumn get kind => textEnum<DocumentFileKind>()();
  BlobColumn get bytes => blob()();

  /// Hex SHA-256 of [bytes], to upload a file once (DESIGN §3.1)
  TextColumn get sha256 => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {documentId, kind},
  ];
}

/// Timeline of a document: every status change and SUNAT answer
@TableIndex.sql(
  'CREATE INDEX document_events_timeline ON document_events '
  '(document_id, created_at)',
)
class DocumentEvents extends Table with SyncColumns {
  TextColumn get documentId => text().references(Documents, #id)();
  TextColumn get status => textEnum<DocumentStatus>()();
  TextColumn get code => text().nullable()();
  TextColumn get message => text().nullable()();
  TextColumn get deviceId => text()();
}

/// Vehicles of guías de remisión moved by the company (transporte privado)
class Vehicles extends Table with SyncColumns {
  TextColumn get companyId => text().references(Companies, #id)();

  /// Uppercase, without dashes or spaces, e.g. "ABC123"
  TextColumn get placa => text()();

  /// Tarjeta única de circulación or certificado de habilitación
  TextColumn get numeroCirculacion => text().nullable()();
}

/// Drivers of guías de remisión moved by the company (transporte privado)
class Drivers extends Table with SyncColumns {
  TextColumn get companyId => text().references(Companies, #id)();

  /// Catalog 6, usually "1" DNI
  TextColumn get tipoDocumentoIdentidad => text()();
  TextColumn get numeroDocumentoIdentidad => text()();
  TextColumn get nombres => text()();
  TextColumn get apellidos => text()();
  TextColumn get licencia => text()();
}

/// Starting points and destinations of guías de remisión
@DataClassName('Address')
class Addresses extends Table with SyncColumns {
  TextColumn get companyId => text().references(Companies, #id)();

  /// What the user calls it, e.g. "Almacén Ate"
  TextColumn get nombre => text().nullable()();
  TextColumn get ubigeo => text()();
  TextColumn get direccion => text()();

  /// SUNAT's code of the establishment, for transfers between the
  /// company's own (motivo 04)
  TextColumn get codigoLocal => text().nullable()();
}

enum DeliveryChannel { email, share }

/// A document sent to a customer (docs/DESIGN.md §8)
class Deliveries extends Table with SyncColumns {
  TextColumn get documentId => text().references(Documents, #id)();
  TextColumn get channel => textEnum<DeliveryChannel>()();

  /// Email address or phone; `null` when shared with another app
  TextColumn get recipient => text().nullable()();
  TextColumn get deviceId => text()();
}

/// Settings of this device (not synced)
class DeviceSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
