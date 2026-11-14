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

  /// Banco de la Nación account for detracciones
  TextColumn get cuentaDetracciones => text().nullable()();
  BoolColumn get esAgentePercepcion =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get esAgenteRetencion =>
      boolean().withDefault(const Constant(false))();

  /// RUC/DNI lookup service, see [LookupProvider]
  TextColumn get lookupProvider => textEnum<LookupProvider>().withDefault(
    Constant(LookupProvider.none.name),
  )();

  /// URL of a self-hosted searchpe
  TextColumn get lookupUrl => text().nullable()();
}

enum LookupProvider { none, commercial, searchpe }

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
  TextColumn get direccion => text().nullable()();
  TextColumn get email => text().nullable()();

  /// With country code, e.g. "+51987654321"
  TextColumn get telefono => text().nullable()();
}

class Products extends Table with SyncColumns {
  TextColumn get companyId => text().references(Companies, #id)();
  TextColumn get codigo => text().nullable()();
  TextColumn get descripcion => text()();

  /// Catalog 3, e.g. "NIU" unit, "ZZ" service
  TextColumn get unidadMedida => text().withDefault(const Constant('NIU'))();

  /// Decimal as text, to keep it exact
  TextColumn get precio => text()();
  BoolColumn get precioIncluyeIgv =>
      boolean().withDefault(const Constant(true))();

  /// Catalog 7; null = the company's default
  TextColumn get igvTipo => text().nullable()();

  /// Catalog 8 and its rate
  TextColumn get iscTipo => text().nullable()();
  TextColumn get iscTasa => text().nullable()();

  /// Plastic bag, taxed with ICB
  BoolColumn get esBolsa => boolean().withDefault(const Constant(false))();

  /// Catalog 54, when the good or service is subject to detracción
  TextColumn get detraccionCodigo => text().nullable()();

  /// Shown in the quick sale grid
  BoolColumn get favorito => boolean().withDefault(const Constant(false))();
}

/// Settings of this device (not synced)
class DeviceSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
