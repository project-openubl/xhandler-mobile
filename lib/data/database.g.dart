// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CompaniesTable extends Companies
    with TableInfo<$CompaniesTable, Company> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompaniesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rucMeta = const VerificationMeta('ruc');
  @override
  late final GeneratedColumn<String> ruc = GeneratedColumn<String>(
    'ruc',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 11,
      maxTextLength: 11,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _razonSocialMeta = const VerificationMeta(
    'razonSocial',
  );
  @override
  late final GeneratedColumn<String> razonSocial = GeneratedColumn<String>(
    'razon_social',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nombreComercialMeta = const VerificationMeta(
    'nombreComercial',
  );
  @override
  late final GeneratedColumn<String> nombreComercial = GeneratedColumn<String>(
    'nombre_comercial',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ubigeoMeta = const VerificationMeta('ubigeo');
  @override
  late final GeneratedColumn<String> ubigeo = GeneratedColumn<String>(
    'ubigeo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departamentoMeta = const VerificationMeta(
    'departamento',
  );
  @override
  late final GeneratedColumn<String> departamento = GeneratedColumn<String>(
    'departamento',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _provinciaMeta = const VerificationMeta(
    'provincia',
  );
  @override
  late final GeneratedColumn<String> provincia = GeneratedColumn<String>(
    'provincia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distritoMeta = const VerificationMeta(
    'distrito',
  );
  @override
  late final GeneratedColumn<String> distrito = GeneratedColumn<String>(
    'distrito',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urbanizacionMeta = const VerificationMeta(
    'urbanizacion',
  );
  @override
  late final GeneratedColumn<String> urbanizacion = GeneratedColumn<String>(
    'urbanizacion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codigoLocalMeta = const VerificationMeta(
    'codigoLocal',
  );
  @override
  late final GeneratedColumn<String> codigoLocal = GeneratedColumn<String>(
    'codigo_local',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SunatEnvironment, String>
  sunatEnvironment = GeneratedColumn<String>(
    'sunat_environment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(SunatEnvironment.beta.name),
  ).withConverter<SunatEnvironment>($CompaniesTable.$convertersunatEnvironment);
  static const VerificationMeta _monedaMeta = const VerificationMeta('moneda');
  @override
  late final GeneratedColumn<String> moneda = GeneratedColumn<String>(
    'moneda',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PEN'),
  );
  static const VerificationMeta _igvTipoMeta = const VerificationMeta(
    'igvTipo',
  );
  @override
  late final GeneratedColumn<String> igvTipo = GeneratedColumn<String>(
    'igv_tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('10'),
  );
  static const VerificationMeta _cuentaDetraccionesMeta =
      const VerificationMeta('cuentaDetracciones');
  @override
  late final GeneratedColumn<String> cuentaDetracciones =
      GeneratedColumn<String>(
        'cuenta_detracciones',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _esAgentePercepcionMeta =
      const VerificationMeta('esAgentePercepcion');
  @override
  late final GeneratedColumn<bool> esAgentePercepcion = GeneratedColumn<bool>(
    'es_agente_percepcion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_agente_percepcion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _esAgenteRetencionMeta = const VerificationMeta(
    'esAgenteRetencion',
  );
  @override
  late final GeneratedColumn<bool> esAgenteRetencion = GeneratedColumn<bool>(
    'es_agente_retencion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_agente_retencion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LookupProvider, String>
  lookupProvider = GeneratedColumn<String>(
    'lookup_provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(LookupProvider.none.name),
  ).withConverter<LookupProvider>($CompaniesTable.$converterlookupProvider);
  static const VerificationMeta _lookupUrlMeta = const VerificationMeta(
    'lookupUrl',
  );
  @override
  late final GeneratedColumn<String> lookupUrl = GeneratedColumn<String>(
    'lookup_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    ruc,
    razonSocial,
    nombreComercial,
    ubigeo,
    departamento,
    provincia,
    distrito,
    direccion,
    urbanizacion,
    codigoLocal,
    telefono,
    email,
    sunatEnvironment,
    moneda,
    igvTipo,
    cuentaDetracciones,
    esAgentePercepcion,
    esAgenteRetencion,
    lookupProvider,
    lookupUrl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'companies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Company> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('ruc')) {
      context.handle(
        _rucMeta,
        ruc.isAcceptableOrUnknown(data['ruc']!, _rucMeta),
      );
    } else if (isInserting) {
      context.missing(_rucMeta);
    }
    if (data.containsKey('razon_social')) {
      context.handle(
        _razonSocialMeta,
        razonSocial.isAcceptableOrUnknown(
          data['razon_social']!,
          _razonSocialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_razonSocialMeta);
    }
    if (data.containsKey('nombre_comercial')) {
      context.handle(
        _nombreComercialMeta,
        nombreComercial.isAcceptableOrUnknown(
          data['nombre_comercial']!,
          _nombreComercialMeta,
        ),
      );
    }
    if (data.containsKey('ubigeo')) {
      context.handle(
        _ubigeoMeta,
        ubigeo.isAcceptableOrUnknown(data['ubigeo']!, _ubigeoMeta),
      );
    }
    if (data.containsKey('departamento')) {
      context.handle(
        _departamentoMeta,
        departamento.isAcceptableOrUnknown(
          data['departamento']!,
          _departamentoMeta,
        ),
      );
    }
    if (data.containsKey('provincia')) {
      context.handle(
        _provinciaMeta,
        provincia.isAcceptableOrUnknown(data['provincia']!, _provinciaMeta),
      );
    }
    if (data.containsKey('distrito')) {
      context.handle(
        _distritoMeta,
        distrito.isAcceptableOrUnknown(data['distrito']!, _distritoMeta),
      );
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('urbanizacion')) {
      context.handle(
        _urbanizacionMeta,
        urbanizacion.isAcceptableOrUnknown(
          data['urbanizacion']!,
          _urbanizacionMeta,
        ),
      );
    }
    if (data.containsKey('codigo_local')) {
      context.handle(
        _codigoLocalMeta,
        codigoLocal.isAcceptableOrUnknown(
          data['codigo_local']!,
          _codigoLocalMeta,
        ),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('moneda')) {
      context.handle(
        _monedaMeta,
        moneda.isAcceptableOrUnknown(data['moneda']!, _monedaMeta),
      );
    }
    if (data.containsKey('igv_tipo')) {
      context.handle(
        _igvTipoMeta,
        igvTipo.isAcceptableOrUnknown(data['igv_tipo']!, _igvTipoMeta),
      );
    }
    if (data.containsKey('cuenta_detracciones')) {
      context.handle(
        _cuentaDetraccionesMeta,
        cuentaDetracciones.isAcceptableOrUnknown(
          data['cuenta_detracciones']!,
          _cuentaDetraccionesMeta,
        ),
      );
    }
    if (data.containsKey('es_agente_percepcion')) {
      context.handle(
        _esAgentePercepcionMeta,
        esAgentePercepcion.isAcceptableOrUnknown(
          data['es_agente_percepcion']!,
          _esAgentePercepcionMeta,
        ),
      );
    }
    if (data.containsKey('es_agente_retencion')) {
      context.handle(
        _esAgenteRetencionMeta,
        esAgenteRetencion.isAcceptableOrUnknown(
          data['es_agente_retencion']!,
          _esAgenteRetencionMeta,
        ),
      );
    }
    if (data.containsKey('lookup_url')) {
      context.handle(
        _lookupUrlMeta,
        lookupUrl.isAcceptableOrUnknown(data['lookup_url']!, _lookupUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Company map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Company(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      ruc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ruc'],
      )!,
      razonSocial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}razon_social'],
      )!,
      nombreComercial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre_comercial'],
      ),
      ubigeo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ubigeo'],
      ),
      departamento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departamento'],
      ),
      provincia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provincia'],
      ),
      distrito: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distrito'],
      ),
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      ),
      urbanizacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}urbanizacion'],
      ),
      codigoLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_local'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      sunatEnvironment: $CompaniesTable.$convertersunatEnvironment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sunat_environment'],
        )!,
      ),
      moneda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moneda'],
      )!,
      igvTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}igv_tipo'],
      )!,
      cuentaDetracciones: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuenta_detracciones'],
      ),
      esAgentePercepcion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_agente_percepcion'],
      )!,
      esAgenteRetencion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_agente_retencion'],
      )!,
      lookupProvider: $CompaniesTable.$converterlookupProvider.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}lookup_provider'],
        )!,
      ),
      lookupUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lookup_url'],
      ),
    );
  }

  @override
  $CompaniesTable createAlias(String alias) {
    return $CompaniesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SunatEnvironment, String, String>
  $convertersunatEnvironment = const EnumNameConverter<SunatEnvironment>(
    SunatEnvironment.values,
  );
  static JsonTypeConverter2<LookupProvider, String, String>
  $converterlookupProvider = const EnumNameConverter<LookupProvider>(
    LookupProvider.values,
  );
}

class Company extends DataClass implements Insertable<Company> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String ruc;
  final String razonSocial;
  final String? nombreComercial;
  final String? ubigeo;
  final String? departamento;
  final String? provincia;
  final String? distrito;
  final String? direccion;
  final String? urbanizacion;
  final String? codigoLocal;
  final String? telefono;
  final String? email;
  final SunatEnvironment sunatEnvironment;

  /// Currency of new documents (ISO 4217)
  final String moneda;

  /// IGV type of new products (Catalog 7), "10" = gravado
  final String igvTipo;

  /// Banco de la Nación account for detracciones
  final String? cuentaDetracciones;
  final bool esAgentePercepcion;
  final bool esAgenteRetencion;

  /// RUC/DNI lookup service, see [LookupProvider]
  final LookupProvider lookupProvider;

  /// URL of a self-hosted searchpe
  final String? lookupUrl;
  const Company({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.ruc,
    required this.razonSocial,
    this.nombreComercial,
    this.ubigeo,
    this.departamento,
    this.provincia,
    this.distrito,
    this.direccion,
    this.urbanizacion,
    this.codigoLocal,
    this.telefono,
    this.email,
    required this.sunatEnvironment,
    required this.moneda,
    required this.igvTipo,
    this.cuentaDetracciones,
    required this.esAgentePercepcion,
    required this.esAgenteRetencion,
    required this.lookupProvider,
    this.lookupUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['ruc'] = Variable<String>(ruc);
    map['razon_social'] = Variable<String>(razonSocial);
    if (!nullToAbsent || nombreComercial != null) {
      map['nombre_comercial'] = Variable<String>(nombreComercial);
    }
    if (!nullToAbsent || ubigeo != null) {
      map['ubigeo'] = Variable<String>(ubigeo);
    }
    if (!nullToAbsent || departamento != null) {
      map['departamento'] = Variable<String>(departamento);
    }
    if (!nullToAbsent || provincia != null) {
      map['provincia'] = Variable<String>(provincia);
    }
    if (!nullToAbsent || distrito != null) {
      map['distrito'] = Variable<String>(distrito);
    }
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    if (!nullToAbsent || urbanizacion != null) {
      map['urbanizacion'] = Variable<String>(urbanizacion);
    }
    if (!nullToAbsent || codigoLocal != null) {
      map['codigo_local'] = Variable<String>(codigoLocal);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    {
      map['sunat_environment'] = Variable<String>(
        $CompaniesTable.$convertersunatEnvironment.toSql(sunatEnvironment),
      );
    }
    map['moneda'] = Variable<String>(moneda);
    map['igv_tipo'] = Variable<String>(igvTipo);
    if (!nullToAbsent || cuentaDetracciones != null) {
      map['cuenta_detracciones'] = Variable<String>(cuentaDetracciones);
    }
    map['es_agente_percepcion'] = Variable<bool>(esAgentePercepcion);
    map['es_agente_retencion'] = Variable<bool>(esAgenteRetencion);
    {
      map['lookup_provider'] = Variable<String>(
        $CompaniesTable.$converterlookupProvider.toSql(lookupProvider),
      );
    }
    if (!nullToAbsent || lookupUrl != null) {
      map['lookup_url'] = Variable<String>(lookupUrl);
    }
    return map;
  }

  CompaniesCompanion toCompanion(bool nullToAbsent) {
    return CompaniesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      ruc: Value(ruc),
      razonSocial: Value(razonSocial),
      nombreComercial: nombreComercial == null && nullToAbsent
          ? const Value.absent()
          : Value(nombreComercial),
      ubigeo: ubigeo == null && nullToAbsent
          ? const Value.absent()
          : Value(ubigeo),
      departamento: departamento == null && nullToAbsent
          ? const Value.absent()
          : Value(departamento),
      provincia: provincia == null && nullToAbsent
          ? const Value.absent()
          : Value(provincia),
      distrito: distrito == null && nullToAbsent
          ? const Value.absent()
          : Value(distrito),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      urbanizacion: urbanizacion == null && nullToAbsent
          ? const Value.absent()
          : Value(urbanizacion),
      codigoLocal: codigoLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoLocal),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      sunatEnvironment: Value(sunatEnvironment),
      moneda: Value(moneda),
      igvTipo: Value(igvTipo),
      cuentaDetracciones: cuentaDetracciones == null && nullToAbsent
          ? const Value.absent()
          : Value(cuentaDetracciones),
      esAgentePercepcion: Value(esAgentePercepcion),
      esAgenteRetencion: Value(esAgenteRetencion),
      lookupProvider: Value(lookupProvider),
      lookupUrl: lookupUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(lookupUrl),
    );
  }

  factory Company.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Company(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      ruc: serializer.fromJson<String>(json['ruc']),
      razonSocial: serializer.fromJson<String>(json['razonSocial']),
      nombreComercial: serializer.fromJson<String?>(json['nombreComercial']),
      ubigeo: serializer.fromJson<String?>(json['ubigeo']),
      departamento: serializer.fromJson<String?>(json['departamento']),
      provincia: serializer.fromJson<String?>(json['provincia']),
      distrito: serializer.fromJson<String?>(json['distrito']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      urbanizacion: serializer.fromJson<String?>(json['urbanizacion']),
      codigoLocal: serializer.fromJson<String?>(json['codigoLocal']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      sunatEnvironment: $CompaniesTable.$convertersunatEnvironment.fromJson(
        serializer.fromJson<String>(json['sunatEnvironment']),
      ),
      moneda: serializer.fromJson<String>(json['moneda']),
      igvTipo: serializer.fromJson<String>(json['igvTipo']),
      cuentaDetracciones: serializer.fromJson<String?>(
        json['cuentaDetracciones'],
      ),
      esAgentePercepcion: serializer.fromJson<bool>(json['esAgentePercepcion']),
      esAgenteRetencion: serializer.fromJson<bool>(json['esAgenteRetencion']),
      lookupProvider: $CompaniesTable.$converterlookupProvider.fromJson(
        serializer.fromJson<String>(json['lookupProvider']),
      ),
      lookupUrl: serializer.fromJson<String?>(json['lookupUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'ruc': serializer.toJson<String>(ruc),
      'razonSocial': serializer.toJson<String>(razonSocial),
      'nombreComercial': serializer.toJson<String?>(nombreComercial),
      'ubigeo': serializer.toJson<String?>(ubigeo),
      'departamento': serializer.toJson<String?>(departamento),
      'provincia': serializer.toJson<String?>(provincia),
      'distrito': serializer.toJson<String?>(distrito),
      'direccion': serializer.toJson<String?>(direccion),
      'urbanizacion': serializer.toJson<String?>(urbanizacion),
      'codigoLocal': serializer.toJson<String?>(codigoLocal),
      'telefono': serializer.toJson<String?>(telefono),
      'email': serializer.toJson<String?>(email),
      'sunatEnvironment': serializer.toJson<String>(
        $CompaniesTable.$convertersunatEnvironment.toJson(sunatEnvironment),
      ),
      'moneda': serializer.toJson<String>(moneda),
      'igvTipo': serializer.toJson<String>(igvTipo),
      'cuentaDetracciones': serializer.toJson<String?>(cuentaDetracciones),
      'esAgentePercepcion': serializer.toJson<bool>(esAgentePercepcion),
      'esAgenteRetencion': serializer.toJson<bool>(esAgenteRetencion),
      'lookupProvider': serializer.toJson<String>(
        $CompaniesTable.$converterlookupProvider.toJson(lookupProvider),
      ),
      'lookupUrl': serializer.toJson<String?>(lookupUrl),
    };
  }

  Company copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? ruc,
    String? razonSocial,
    Value<String?> nombreComercial = const Value.absent(),
    Value<String?> ubigeo = const Value.absent(),
    Value<String?> departamento = const Value.absent(),
    Value<String?> provincia = const Value.absent(),
    Value<String?> distrito = const Value.absent(),
    Value<String?> direccion = const Value.absent(),
    Value<String?> urbanizacion = const Value.absent(),
    Value<String?> codigoLocal = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
    Value<String?> email = const Value.absent(),
    SunatEnvironment? sunatEnvironment,
    String? moneda,
    String? igvTipo,
    Value<String?> cuentaDetracciones = const Value.absent(),
    bool? esAgentePercepcion,
    bool? esAgenteRetencion,
    LookupProvider? lookupProvider,
    Value<String?> lookupUrl = const Value.absent(),
  }) => Company(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    ruc: ruc ?? this.ruc,
    razonSocial: razonSocial ?? this.razonSocial,
    nombreComercial: nombreComercial.present
        ? nombreComercial.value
        : this.nombreComercial,
    ubigeo: ubigeo.present ? ubigeo.value : this.ubigeo,
    departamento: departamento.present ? departamento.value : this.departamento,
    provincia: provincia.present ? provincia.value : this.provincia,
    distrito: distrito.present ? distrito.value : this.distrito,
    direccion: direccion.present ? direccion.value : this.direccion,
    urbanizacion: urbanizacion.present ? urbanizacion.value : this.urbanizacion,
    codigoLocal: codigoLocal.present ? codigoLocal.value : this.codigoLocal,
    telefono: telefono.present ? telefono.value : this.telefono,
    email: email.present ? email.value : this.email,
    sunatEnvironment: sunatEnvironment ?? this.sunatEnvironment,
    moneda: moneda ?? this.moneda,
    igvTipo: igvTipo ?? this.igvTipo,
    cuentaDetracciones: cuentaDetracciones.present
        ? cuentaDetracciones.value
        : this.cuentaDetracciones,
    esAgentePercepcion: esAgentePercepcion ?? this.esAgentePercepcion,
    esAgenteRetencion: esAgenteRetencion ?? this.esAgenteRetencion,
    lookupProvider: lookupProvider ?? this.lookupProvider,
    lookupUrl: lookupUrl.present ? lookupUrl.value : this.lookupUrl,
  );
  Company copyWithCompanion(CompaniesCompanion data) {
    return Company(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      ruc: data.ruc.present ? data.ruc.value : this.ruc,
      razonSocial: data.razonSocial.present
          ? data.razonSocial.value
          : this.razonSocial,
      nombreComercial: data.nombreComercial.present
          ? data.nombreComercial.value
          : this.nombreComercial,
      ubigeo: data.ubigeo.present ? data.ubigeo.value : this.ubigeo,
      departamento: data.departamento.present
          ? data.departamento.value
          : this.departamento,
      provincia: data.provincia.present ? data.provincia.value : this.provincia,
      distrito: data.distrito.present ? data.distrito.value : this.distrito,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      urbanizacion: data.urbanizacion.present
          ? data.urbanizacion.value
          : this.urbanizacion,
      codigoLocal: data.codigoLocal.present
          ? data.codigoLocal.value
          : this.codigoLocal,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      sunatEnvironment: data.sunatEnvironment.present
          ? data.sunatEnvironment.value
          : this.sunatEnvironment,
      moneda: data.moneda.present ? data.moneda.value : this.moneda,
      igvTipo: data.igvTipo.present ? data.igvTipo.value : this.igvTipo,
      cuentaDetracciones: data.cuentaDetracciones.present
          ? data.cuentaDetracciones.value
          : this.cuentaDetracciones,
      esAgentePercepcion: data.esAgentePercepcion.present
          ? data.esAgentePercepcion.value
          : this.esAgentePercepcion,
      esAgenteRetencion: data.esAgenteRetencion.present
          ? data.esAgenteRetencion.value
          : this.esAgenteRetencion,
      lookupProvider: data.lookupProvider.present
          ? data.lookupProvider.value
          : this.lookupProvider,
      lookupUrl: data.lookupUrl.present ? data.lookupUrl.value : this.lookupUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Company(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('ruc: $ruc, ')
          ..write('razonSocial: $razonSocial, ')
          ..write('nombreComercial: $nombreComercial, ')
          ..write('ubigeo: $ubigeo, ')
          ..write('departamento: $departamento, ')
          ..write('provincia: $provincia, ')
          ..write('distrito: $distrito, ')
          ..write('direccion: $direccion, ')
          ..write('urbanizacion: $urbanizacion, ')
          ..write('codigoLocal: $codigoLocal, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('sunatEnvironment: $sunatEnvironment, ')
          ..write('moneda: $moneda, ')
          ..write('igvTipo: $igvTipo, ')
          ..write('cuentaDetracciones: $cuentaDetracciones, ')
          ..write('esAgentePercepcion: $esAgentePercepcion, ')
          ..write('esAgenteRetencion: $esAgenteRetencion, ')
          ..write('lookupProvider: $lookupProvider, ')
          ..write('lookupUrl: $lookupUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    deletedAt,
    ruc,
    razonSocial,
    nombreComercial,
    ubigeo,
    departamento,
    provincia,
    distrito,
    direccion,
    urbanizacion,
    codigoLocal,
    telefono,
    email,
    sunatEnvironment,
    moneda,
    igvTipo,
    cuentaDetracciones,
    esAgentePercepcion,
    esAgenteRetencion,
    lookupProvider,
    lookupUrl,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Company &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.ruc == this.ruc &&
          other.razonSocial == this.razonSocial &&
          other.nombreComercial == this.nombreComercial &&
          other.ubigeo == this.ubigeo &&
          other.departamento == this.departamento &&
          other.provincia == this.provincia &&
          other.distrito == this.distrito &&
          other.direccion == this.direccion &&
          other.urbanizacion == this.urbanizacion &&
          other.codigoLocal == this.codigoLocal &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.sunatEnvironment == this.sunatEnvironment &&
          other.moneda == this.moneda &&
          other.igvTipo == this.igvTipo &&
          other.cuentaDetracciones == this.cuentaDetracciones &&
          other.esAgentePercepcion == this.esAgentePercepcion &&
          other.esAgenteRetencion == this.esAgenteRetencion &&
          other.lookupProvider == this.lookupProvider &&
          other.lookupUrl == this.lookupUrl);
}

class CompaniesCompanion extends UpdateCompanion<Company> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> ruc;
  final Value<String> razonSocial;
  final Value<String?> nombreComercial;
  final Value<String?> ubigeo;
  final Value<String?> departamento;
  final Value<String?> provincia;
  final Value<String?> distrito;
  final Value<String?> direccion;
  final Value<String?> urbanizacion;
  final Value<String?> codigoLocal;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<SunatEnvironment> sunatEnvironment;
  final Value<String> moneda;
  final Value<String> igvTipo;
  final Value<String?> cuentaDetracciones;
  final Value<bool> esAgentePercepcion;
  final Value<bool> esAgenteRetencion;
  final Value<LookupProvider> lookupProvider;
  final Value<String?> lookupUrl;
  final Value<int> rowid;
  const CompaniesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.ruc = const Value.absent(),
    this.razonSocial = const Value.absent(),
    this.nombreComercial = const Value.absent(),
    this.ubigeo = const Value.absent(),
    this.departamento = const Value.absent(),
    this.provincia = const Value.absent(),
    this.distrito = const Value.absent(),
    this.direccion = const Value.absent(),
    this.urbanizacion = const Value.absent(),
    this.codigoLocal = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.sunatEnvironment = const Value.absent(),
    this.moneda = const Value.absent(),
    this.igvTipo = const Value.absent(),
    this.cuentaDetracciones = const Value.absent(),
    this.esAgentePercepcion = const Value.absent(),
    this.esAgenteRetencion = const Value.absent(),
    this.lookupProvider = const Value.absent(),
    this.lookupUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompaniesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String ruc,
    required String razonSocial,
    this.nombreComercial = const Value.absent(),
    this.ubigeo = const Value.absent(),
    this.departamento = const Value.absent(),
    this.provincia = const Value.absent(),
    this.distrito = const Value.absent(),
    this.direccion = const Value.absent(),
    this.urbanizacion = const Value.absent(),
    this.codigoLocal = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.sunatEnvironment = const Value.absent(),
    this.moneda = const Value.absent(),
    this.igvTipo = const Value.absent(),
    this.cuentaDetracciones = const Value.absent(),
    this.esAgentePercepcion = const Value.absent(),
    this.esAgenteRetencion = const Value.absent(),
    this.lookupProvider = const Value.absent(),
    this.lookupUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ruc = Value(ruc),
       razonSocial = Value(razonSocial);
  static Insertable<Company> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? ruc,
    Expression<String>? razonSocial,
    Expression<String>? nombreComercial,
    Expression<String>? ubigeo,
    Expression<String>? departamento,
    Expression<String>? provincia,
    Expression<String>? distrito,
    Expression<String>? direccion,
    Expression<String>? urbanizacion,
    Expression<String>? codigoLocal,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? sunatEnvironment,
    Expression<String>? moneda,
    Expression<String>? igvTipo,
    Expression<String>? cuentaDetracciones,
    Expression<bool>? esAgentePercepcion,
    Expression<bool>? esAgenteRetencion,
    Expression<String>? lookupProvider,
    Expression<String>? lookupUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (ruc != null) 'ruc': ruc,
      if (razonSocial != null) 'razon_social': razonSocial,
      if (nombreComercial != null) 'nombre_comercial': nombreComercial,
      if (ubigeo != null) 'ubigeo': ubigeo,
      if (departamento != null) 'departamento': departamento,
      if (provincia != null) 'provincia': provincia,
      if (distrito != null) 'distrito': distrito,
      if (direccion != null) 'direccion': direccion,
      if (urbanizacion != null) 'urbanizacion': urbanizacion,
      if (codigoLocal != null) 'codigo_local': codigoLocal,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (sunatEnvironment != null) 'sunat_environment': sunatEnvironment,
      if (moneda != null) 'moneda': moneda,
      if (igvTipo != null) 'igv_tipo': igvTipo,
      if (cuentaDetracciones != null) 'cuenta_detracciones': cuentaDetracciones,
      if (esAgentePercepcion != null)
        'es_agente_percepcion': esAgentePercepcion,
      if (esAgenteRetencion != null) 'es_agente_retencion': esAgenteRetencion,
      if (lookupProvider != null) 'lookup_provider': lookupProvider,
      if (lookupUrl != null) 'lookup_url': lookupUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompaniesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? ruc,
    Value<String>? razonSocial,
    Value<String?>? nombreComercial,
    Value<String?>? ubigeo,
    Value<String?>? departamento,
    Value<String?>? provincia,
    Value<String?>? distrito,
    Value<String?>? direccion,
    Value<String?>? urbanizacion,
    Value<String?>? codigoLocal,
    Value<String?>? telefono,
    Value<String?>? email,
    Value<SunatEnvironment>? sunatEnvironment,
    Value<String>? moneda,
    Value<String>? igvTipo,
    Value<String?>? cuentaDetracciones,
    Value<bool>? esAgentePercepcion,
    Value<bool>? esAgenteRetencion,
    Value<LookupProvider>? lookupProvider,
    Value<String?>? lookupUrl,
    Value<int>? rowid,
  }) {
    return CompaniesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      ruc: ruc ?? this.ruc,
      razonSocial: razonSocial ?? this.razonSocial,
      nombreComercial: nombreComercial ?? this.nombreComercial,
      ubigeo: ubigeo ?? this.ubigeo,
      departamento: departamento ?? this.departamento,
      provincia: provincia ?? this.provincia,
      distrito: distrito ?? this.distrito,
      direccion: direccion ?? this.direccion,
      urbanizacion: urbanizacion ?? this.urbanizacion,
      codigoLocal: codigoLocal ?? this.codigoLocal,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      sunatEnvironment: sunatEnvironment ?? this.sunatEnvironment,
      moneda: moneda ?? this.moneda,
      igvTipo: igvTipo ?? this.igvTipo,
      cuentaDetracciones: cuentaDetracciones ?? this.cuentaDetracciones,
      esAgentePercepcion: esAgentePercepcion ?? this.esAgentePercepcion,
      esAgenteRetencion: esAgenteRetencion ?? this.esAgenteRetencion,
      lookupProvider: lookupProvider ?? this.lookupProvider,
      lookupUrl: lookupUrl ?? this.lookupUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (ruc.present) {
      map['ruc'] = Variable<String>(ruc.value);
    }
    if (razonSocial.present) {
      map['razon_social'] = Variable<String>(razonSocial.value);
    }
    if (nombreComercial.present) {
      map['nombre_comercial'] = Variable<String>(nombreComercial.value);
    }
    if (ubigeo.present) {
      map['ubigeo'] = Variable<String>(ubigeo.value);
    }
    if (departamento.present) {
      map['departamento'] = Variable<String>(departamento.value);
    }
    if (provincia.present) {
      map['provincia'] = Variable<String>(provincia.value);
    }
    if (distrito.present) {
      map['distrito'] = Variable<String>(distrito.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (urbanizacion.present) {
      map['urbanizacion'] = Variable<String>(urbanizacion.value);
    }
    if (codigoLocal.present) {
      map['codigo_local'] = Variable<String>(codigoLocal.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (sunatEnvironment.present) {
      map['sunat_environment'] = Variable<String>(
        $CompaniesTable.$convertersunatEnvironment.toSql(
          sunatEnvironment.value,
        ),
      );
    }
    if (moneda.present) {
      map['moneda'] = Variable<String>(moneda.value);
    }
    if (igvTipo.present) {
      map['igv_tipo'] = Variable<String>(igvTipo.value);
    }
    if (cuentaDetracciones.present) {
      map['cuenta_detracciones'] = Variable<String>(cuentaDetracciones.value);
    }
    if (esAgentePercepcion.present) {
      map['es_agente_percepcion'] = Variable<bool>(esAgentePercepcion.value);
    }
    if (esAgenteRetencion.present) {
      map['es_agente_retencion'] = Variable<bool>(esAgenteRetencion.value);
    }
    if (lookupProvider.present) {
      map['lookup_provider'] = Variable<String>(
        $CompaniesTable.$converterlookupProvider.toSql(lookupProvider.value),
      );
    }
    if (lookupUrl.present) {
      map['lookup_url'] = Variable<String>(lookupUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompaniesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('ruc: $ruc, ')
          ..write('razonSocial: $razonSocial, ')
          ..write('nombreComercial: $nombreComercial, ')
          ..write('ubigeo: $ubigeo, ')
          ..write('departamento: $departamento, ')
          ..write('provincia: $provincia, ')
          ..write('distrito: $distrito, ')
          ..write('direccion: $direccion, ')
          ..write('urbanizacion: $urbanizacion, ')
          ..write('codigoLocal: $codigoLocal, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('sunatEnvironment: $sunatEnvironment, ')
          ..write('moneda: $moneda, ')
          ..write('igvTipo: $igvTipo, ')
          ..write('cuentaDetracciones: $cuentaDetracciones, ')
          ..write('esAgentePercepcion: $esAgentePercepcion, ')
          ..write('esAgenteRetencion: $esAgenteRetencion, ')
          ..write('lookupProvider: $lookupProvider, ')
          ..write('lookupUrl: $lookupUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SeriesTable extends Series with TableInfo<$SeriesTable, Serie> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _tipoComprobanteMeta = const VerificationMeta(
    'tipoComprobante',
  );
  @override
  late final GeneratedColumn<String> tipoComprobante = GeneratedColumn<String>(
    'tipo_comprobante',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serieMeta = const VerificationMeta('serie');
  @override
  late final GeneratedColumn<String> serie = GeneratedColumn<String>(
    'serie',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 4,
      maxTextLength: 4,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextNumberMeta = const VerificationMeta(
    'nextNumber',
  );
  @override
  late final GeneratedColumn<int> nextNumber = GeneratedColumn<int>(
    'next_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    tipoComprobante,
    serie,
    nextNumber,
    isDefault,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'series';
  @override
  VerificationContext validateIntegrity(
    Insertable<Serie> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('tipo_comprobante')) {
      context.handle(
        _tipoComprobanteMeta,
        tipoComprobante.isAcceptableOrUnknown(
          data['tipo_comprobante']!,
          _tipoComprobanteMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoComprobanteMeta);
    }
    if (data.containsKey('serie')) {
      context.handle(
        _serieMeta,
        serie.isAcceptableOrUnknown(data['serie']!, _serieMeta),
      );
    } else if (isInserting) {
      context.missing(_serieMeta);
    }
    if (data.containsKey('next_number')) {
      context.handle(
        _nextNumberMeta,
        nextNumber.isAcceptableOrUnknown(data['next_number']!, _nextNumberMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {companyId, tipoComprobante, serie},
  ];
  @override
  Serie map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Serie(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      )!,
      tipoComprobante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_comprobante'],
      )!,
      serie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serie'],
      )!,
      nextNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_number'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $SeriesTable createAlias(String alias) {
    return $SeriesTable(attachedDatabase, alias);
  }
}

class Serie extends DataClass implements Insertable<Serie> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String companyId;

  /// Catalog 1, e.g. "01" factura
  final String tipoComprobante;
  final String serie;

  /// Number the next emitted document takes
  final int nextNumber;

  /// Suggested series for its document type
  final bool isDefault;
  final bool active;
  const Serie({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    required this.tipoComprobante,
    required this.serie,
    required this.nextNumber,
    required this.isDefault,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['company_id'] = Variable<String>(companyId);
    map['tipo_comprobante'] = Variable<String>(tipoComprobante);
    map['serie'] = Variable<String>(serie);
    map['next_number'] = Variable<int>(nextNumber);
    map['is_default'] = Variable<bool>(isDefault);
    map['active'] = Variable<bool>(active);
    return map;
  }

  SeriesCompanion toCompanion(bool nullToAbsent) {
    return SeriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      companyId: Value(companyId),
      tipoComprobante: Value(tipoComprobante),
      serie: Value(serie),
      nextNumber: Value(nextNumber),
      isDefault: Value(isDefault),
      active: Value(active),
    );
  }

  factory Serie.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Serie(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      companyId: serializer.fromJson<String>(json['companyId']),
      tipoComprobante: serializer.fromJson<String>(json['tipoComprobante']),
      serie: serializer.fromJson<String>(json['serie']),
      nextNumber: serializer.fromJson<int>(json['nextNumber']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'companyId': serializer.toJson<String>(companyId),
      'tipoComprobante': serializer.toJson<String>(tipoComprobante),
      'serie': serializer.toJson<String>(serie),
      'nextNumber': serializer.toJson<int>(nextNumber),
      'isDefault': serializer.toJson<bool>(isDefault),
      'active': serializer.toJson<bool>(active),
    };
  }

  Serie copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? companyId,
    String? tipoComprobante,
    String? serie,
    int? nextNumber,
    bool? isDefault,
    bool? active,
  }) => Serie(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    companyId: companyId ?? this.companyId,
    tipoComprobante: tipoComprobante ?? this.tipoComprobante,
    serie: serie ?? this.serie,
    nextNumber: nextNumber ?? this.nextNumber,
    isDefault: isDefault ?? this.isDefault,
    active: active ?? this.active,
  );
  Serie copyWithCompanion(SeriesCompanion data) {
    return Serie(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      tipoComprobante: data.tipoComprobante.present
          ? data.tipoComprobante.value
          : this.tipoComprobante,
      serie: data.serie.present ? data.serie.value : this.serie,
      nextNumber: data.nextNumber.present
          ? data.nextNumber.value
          : this.nextNumber,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Serie(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('tipoComprobante: $tipoComprobante, ')
          ..write('serie: $serie, ')
          ..write('nextNumber: $nextNumber, ')
          ..write('isDefault: $isDefault, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    tipoComprobante,
    serie,
    nextNumber,
    isDefault,
    active,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Serie &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.companyId == this.companyId &&
          other.tipoComprobante == this.tipoComprobante &&
          other.serie == this.serie &&
          other.nextNumber == this.nextNumber &&
          other.isDefault == this.isDefault &&
          other.active == this.active);
}

class SeriesCompanion extends UpdateCompanion<Serie> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> companyId;
  final Value<String> tipoComprobante;
  final Value<String> serie;
  final Value<int> nextNumber;
  final Value<bool> isDefault;
  final Value<bool> active;
  final Value<int> rowid;
  const SeriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.companyId = const Value.absent(),
    this.tipoComprobante = const Value.absent(),
    this.serie = const Value.absent(),
    this.nextNumber = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SeriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String companyId,
    required String tipoComprobante,
    required String serie,
    this.nextNumber = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId),
       tipoComprobante = Value(tipoComprobante),
       serie = Value(serie);
  static Insertable<Serie> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? companyId,
    Expression<String>? tipoComprobante,
    Expression<String>? serie,
    Expression<int>? nextNumber,
    Expression<bool>? isDefault,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (companyId != null) 'company_id': companyId,
      if (tipoComprobante != null) 'tipo_comprobante': tipoComprobante,
      if (serie != null) 'serie': serie,
      if (nextNumber != null) 'next_number': nextNumber,
      if (isDefault != null) 'is_default': isDefault,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SeriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? companyId,
    Value<String>? tipoComprobante,
    Value<String>? serie,
    Value<int>? nextNumber,
    Value<bool>? isDefault,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return SeriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      companyId: companyId ?? this.companyId,
      tipoComprobante: tipoComprobante ?? this.tipoComprobante,
      serie: serie ?? this.serie,
      nextNumber: nextNumber ?? this.nextNumber,
      isDefault: isDefault ?? this.isDefault,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (tipoComprobante.present) {
      map['tipo_comprobante'] = Variable<String>(tipoComprobante.value);
    }
    if (serie.present) {
      map['serie'] = Variable<String>(serie.value);
    }
    if (nextNumber.present) {
      map['next_number'] = Variable<int>(nextNumber.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('tipoComprobante: $tipoComprobante, ')
          ..write('serie: $serie, ')
          ..write('nextNumber: $nextNumber, ')
          ..write('isDefault: $isDefault, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _tipoDocumentoIdentidadMeta =
      const VerificationMeta('tipoDocumentoIdentidad');
  @override
  late final GeneratedColumn<String> tipoDocumentoIdentidad =
      GeneratedColumn<String>(
        'tipo_documento_identidad',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _numeroDocumentoIdentidadMeta =
      const VerificationMeta('numeroDocumentoIdentidad');
  @override
  late final GeneratedColumn<String> numeroDocumentoIdentidad =
      GeneratedColumn<String>(
        'numero_documento_identidad',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _direccionMeta = const VerificationMeta(
    'direccion',
  );
  @override
  late final GeneratedColumn<String> direccion = GeneratedColumn<String>(
    'direccion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    tipoDocumentoIdentidad,
    numeroDocumentoIdentidad,
    nombre,
    direccion,
    email,
    telefono,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('tipo_documento_identidad')) {
      context.handle(
        _tipoDocumentoIdentidadMeta,
        tipoDocumentoIdentidad.isAcceptableOrUnknown(
          data['tipo_documento_identidad']!,
          _tipoDocumentoIdentidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoDocumentoIdentidadMeta);
    }
    if (data.containsKey('numero_documento_identidad')) {
      context.handle(
        _numeroDocumentoIdentidadMeta,
        numeroDocumentoIdentidad.isAcceptableOrUnknown(
          data['numero_documento_identidad']!,
          _numeroDocumentoIdentidadMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_numeroDocumentoIdentidadMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      )!,
      tipoDocumentoIdentidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_documento_identidad'],
      )!,
      numeroDocumentoIdentidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_documento_identidad'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String companyId;

  /// Catalog 6, e.g. "6" RUC, "1" DNI
  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String nombre;
  final String? direccion;
  final String? email;

  /// With country code, e.g. "+51987654321"
  final String? telefono;
  const Customer({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    required this.tipoDocumentoIdentidad,
    required this.numeroDocumentoIdentidad,
    required this.nombre,
    this.direccion,
    this.email,
    this.telefono,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['company_id'] = Variable<String>(companyId);
    map['tipo_documento_identidad'] = Variable<String>(tipoDocumentoIdentidad);
    map['numero_documento_identidad'] = Variable<String>(
      numeroDocumentoIdentidad,
    );
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || direccion != null) {
      map['direccion'] = Variable<String>(direccion);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      companyId: Value(companyId),
      tipoDocumentoIdentidad: Value(tipoDocumentoIdentidad),
      numeroDocumentoIdentidad: Value(numeroDocumentoIdentidad),
      nombre: Value(nombre),
      direccion: direccion == null && nullToAbsent
          ? const Value.absent()
          : Value(direccion),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      companyId: serializer.fromJson<String>(json['companyId']),
      tipoDocumentoIdentidad: serializer.fromJson<String>(
        json['tipoDocumentoIdentidad'],
      ),
      numeroDocumentoIdentidad: serializer.fromJson<String>(
        json['numeroDocumentoIdentidad'],
      ),
      nombre: serializer.fromJson<String>(json['nombre']),
      direccion: serializer.fromJson<String?>(json['direccion']),
      email: serializer.fromJson<String?>(json['email']),
      telefono: serializer.fromJson<String?>(json['telefono']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'companyId': serializer.toJson<String>(companyId),
      'tipoDocumentoIdentidad': serializer.toJson<String>(
        tipoDocumentoIdentidad,
      ),
      'numeroDocumentoIdentidad': serializer.toJson<String>(
        numeroDocumentoIdentidad,
      ),
      'nombre': serializer.toJson<String>(nombre),
      'direccion': serializer.toJson<String?>(direccion),
      'email': serializer.toJson<String?>(email),
      'telefono': serializer.toJson<String?>(telefono),
    };
  }

  Customer copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? companyId,
    String? tipoDocumentoIdentidad,
    String? numeroDocumentoIdentidad,
    String? nombre,
    Value<String?> direccion = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
  }) => Customer(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    companyId: companyId ?? this.companyId,
    tipoDocumentoIdentidad:
        tipoDocumentoIdentidad ?? this.tipoDocumentoIdentidad,
    numeroDocumentoIdentidad:
        numeroDocumentoIdentidad ?? this.numeroDocumentoIdentidad,
    nombre: nombre ?? this.nombre,
    direccion: direccion.present ? direccion.value : this.direccion,
    email: email.present ? email.value : this.email,
    telefono: telefono.present ? telefono.value : this.telefono,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      tipoDocumentoIdentidad: data.tipoDocumentoIdentidad.present
          ? data.tipoDocumentoIdentidad.value
          : this.tipoDocumentoIdentidad,
      numeroDocumentoIdentidad: data.numeroDocumentoIdentidad.present
          ? data.numeroDocumentoIdentidad.value
          : this.numeroDocumentoIdentidad,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      email: data.email.present ? data.email.value : this.email,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('tipoDocumentoIdentidad: $tipoDocumentoIdentidad, ')
          ..write('numeroDocumentoIdentidad: $numeroDocumentoIdentidad, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('email: $email, ')
          ..write('telefono: $telefono')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    tipoDocumentoIdentidad,
    numeroDocumentoIdentidad,
    nombre,
    direccion,
    email,
    telefono,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.companyId == this.companyId &&
          other.tipoDocumentoIdentidad == this.tipoDocumentoIdentidad &&
          other.numeroDocumentoIdentidad == this.numeroDocumentoIdentidad &&
          other.nombre == this.nombre &&
          other.direccion == this.direccion &&
          other.email == this.email &&
          other.telefono == this.telefono);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> companyId;
  final Value<String> tipoDocumentoIdentidad;
  final Value<String> numeroDocumentoIdentidad;
  final Value<String> nombre;
  final Value<String?> direccion;
  final Value<String?> email;
  final Value<String?> telefono;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.companyId = const Value.absent(),
    this.tipoDocumentoIdentidad = const Value.absent(),
    this.numeroDocumentoIdentidad = const Value.absent(),
    this.nombre = const Value.absent(),
    this.direccion = const Value.absent(),
    this.email = const Value.absent(),
    this.telefono = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String companyId,
    required String tipoDocumentoIdentidad,
    required String numeroDocumentoIdentidad,
    required String nombre,
    this.direccion = const Value.absent(),
    this.email = const Value.absent(),
    this.telefono = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId),
       tipoDocumentoIdentidad = Value(tipoDocumentoIdentidad),
       numeroDocumentoIdentidad = Value(numeroDocumentoIdentidad),
       nombre = Value(nombre);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? companyId,
    Expression<String>? tipoDocumentoIdentidad,
    Expression<String>? numeroDocumentoIdentidad,
    Expression<String>? nombre,
    Expression<String>? direccion,
    Expression<String>? email,
    Expression<String>? telefono,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (companyId != null) 'company_id': companyId,
      if (tipoDocumentoIdentidad != null)
        'tipo_documento_identidad': tipoDocumentoIdentidad,
      if (numeroDocumentoIdentidad != null)
        'numero_documento_identidad': numeroDocumentoIdentidad,
      if (nombre != null) 'nombre': nombre,
      if (direccion != null) 'direccion': direccion,
      if (email != null) 'email': email,
      if (telefono != null) 'telefono': telefono,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? companyId,
    Value<String>? tipoDocumentoIdentidad,
    Value<String>? numeroDocumentoIdentidad,
    Value<String>? nombre,
    Value<String?>? direccion,
    Value<String?>? email,
    Value<String?>? telefono,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      companyId: companyId ?? this.companyId,
      tipoDocumentoIdentidad:
          tipoDocumentoIdentidad ?? this.tipoDocumentoIdentidad,
      numeroDocumentoIdentidad:
          numeroDocumentoIdentidad ?? this.numeroDocumentoIdentidad,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (tipoDocumentoIdentidad.present) {
      map['tipo_documento_identidad'] = Variable<String>(
        tipoDocumentoIdentidad.value,
      );
    }
    if (numeroDocumentoIdentidad.present) {
      map['numero_documento_identidad'] = Variable<String>(
        numeroDocumentoIdentidad.value,
      );
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('tipoDocumentoIdentidad: $tipoDocumentoIdentidad, ')
          ..write('numeroDocumentoIdentidad: $numeroDocumentoIdentidad, ')
          ..write('nombre: $nombre, ')
          ..write('direccion: $direccion, ')
          ..write('email: $email, ')
          ..write('telefono: $telefono, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: newId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: nowUtc,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyIdMeta = const VerificationMeta(
    'companyId',
  );
  @override
  late final GeneratedColumn<String> companyId = GeneratedColumn<String>(
    'company_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES companies (id)',
    ),
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unidadMedidaMeta = const VerificationMeta(
    'unidadMedida',
  );
  @override
  late final GeneratedColumn<String> unidadMedida = GeneratedColumn<String>(
    'unidad_medida',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('NIU'),
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<String> precio = GeneratedColumn<String>(
    'precio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioIncluyeIgvMeta = const VerificationMeta(
    'precioIncluyeIgv',
  );
  @override
  late final GeneratedColumn<bool> precioIncluyeIgv = GeneratedColumn<bool>(
    'precio_incluye_igv',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("precio_incluye_igv" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _igvTipoMeta = const VerificationMeta(
    'igvTipo',
  );
  @override
  late final GeneratedColumn<String> igvTipo = GeneratedColumn<String>(
    'igv_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iscTipoMeta = const VerificationMeta(
    'iscTipo',
  );
  @override
  late final GeneratedColumn<String> iscTipo = GeneratedColumn<String>(
    'isc_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iscTasaMeta = const VerificationMeta(
    'iscTasa',
  );
  @override
  late final GeneratedColumn<String> iscTasa = GeneratedColumn<String>(
    'isc_tasa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _esBolsaMeta = const VerificationMeta(
    'esBolsa',
  );
  @override
  late final GeneratedColumn<bool> esBolsa = GeneratedColumn<bool>(
    'es_bolsa',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("es_bolsa" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _detraccionCodigoMeta = const VerificationMeta(
    'detraccionCodigo',
  );
  @override
  late final GeneratedColumn<String> detraccionCodigo = GeneratedColumn<String>(
    'detraccion_codigo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _favoritoMeta = const VerificationMeta(
    'favorito',
  );
  @override
  late final GeneratedColumn<bool> favorito = GeneratedColumn<bool>(
    'favorito',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorito" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    codigo,
    descripcion,
    unidadMedida,
    precio,
    precioIncluyeIgv,
    igvTipo,
    iscTipo,
    iscTasa,
    esBolsa,
    detraccionCodigo,
    favorito,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('company_id')) {
      context.handle(
        _companyIdMeta,
        companyId.isAcceptableOrUnknown(data['company_id']!, _companyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_companyIdMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('unidad_medida')) {
      context.handle(
        _unidadMedidaMeta,
        unidadMedida.isAcceptableOrUnknown(
          data['unidad_medida']!,
          _unidadMedidaMeta,
        ),
      );
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    } else if (isInserting) {
      context.missing(_precioMeta);
    }
    if (data.containsKey('precio_incluye_igv')) {
      context.handle(
        _precioIncluyeIgvMeta,
        precioIncluyeIgv.isAcceptableOrUnknown(
          data['precio_incluye_igv']!,
          _precioIncluyeIgvMeta,
        ),
      );
    }
    if (data.containsKey('igv_tipo')) {
      context.handle(
        _igvTipoMeta,
        igvTipo.isAcceptableOrUnknown(data['igv_tipo']!, _igvTipoMeta),
      );
    }
    if (data.containsKey('isc_tipo')) {
      context.handle(
        _iscTipoMeta,
        iscTipo.isAcceptableOrUnknown(data['isc_tipo']!, _iscTipoMeta),
      );
    }
    if (data.containsKey('isc_tasa')) {
      context.handle(
        _iscTasaMeta,
        iscTasa.isAcceptableOrUnknown(data['isc_tasa']!, _iscTasaMeta),
      );
    }
    if (data.containsKey('es_bolsa')) {
      context.handle(
        _esBolsaMeta,
        esBolsa.isAcceptableOrUnknown(data['es_bolsa']!, _esBolsaMeta),
      );
    }
    if (data.containsKey('detraccion_codigo')) {
      context.handle(
        _detraccionCodigoMeta,
        detraccionCodigo.isAcceptableOrUnknown(
          data['detraccion_codigo']!,
          _detraccionCodigoMeta,
        ),
      );
    }
    if (data.containsKey('favorito')) {
      context.handle(
        _favoritoMeta,
        favorito.isAcceptableOrUnknown(data['favorito']!, _favoritoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      companyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      ),
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      unidadMedida: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad_medida'],
      )!,
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}precio'],
      )!,
      precioIncluyeIgv: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}precio_incluye_igv'],
      )!,
      igvTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}igv_tipo'],
      ),
      iscTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isc_tipo'],
      ),
      iscTasa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}isc_tasa'],
      ),
      esBolsa: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}es_bolsa'],
      )!,
      detraccionCodigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detraccion_codigo'],
      ),
      favorito: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorito'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String companyId;
  final String? codigo;
  final String descripcion;

  /// Catalog 3, e.g. "NIU" unit, "ZZ" service
  final String unidadMedida;

  /// Decimal as text, to keep it exact
  final String precio;
  final bool precioIncluyeIgv;

  /// Catalog 7; null = the company's default
  final String? igvTipo;

  /// Catalog 8 and its rate
  final String? iscTipo;
  final String? iscTasa;

  /// Plastic bag, taxed with ICB
  final bool esBolsa;

  /// Catalog 54, when the good or service is subject to detracción
  final String? detraccionCodigo;

  /// Shown in the quick sale grid
  final bool favorito;
  const Product({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    this.codigo,
    required this.descripcion,
    required this.unidadMedida,
    required this.precio,
    required this.precioIncluyeIgv,
    this.igvTipo,
    this.iscTipo,
    this.iscTasa,
    required this.esBolsa,
    this.detraccionCodigo,
    required this.favorito,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['company_id'] = Variable<String>(companyId);
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    map['descripcion'] = Variable<String>(descripcion);
    map['unidad_medida'] = Variable<String>(unidadMedida);
    map['precio'] = Variable<String>(precio);
    map['precio_incluye_igv'] = Variable<bool>(precioIncluyeIgv);
    if (!nullToAbsent || igvTipo != null) {
      map['igv_tipo'] = Variable<String>(igvTipo);
    }
    if (!nullToAbsent || iscTipo != null) {
      map['isc_tipo'] = Variable<String>(iscTipo);
    }
    if (!nullToAbsent || iscTasa != null) {
      map['isc_tasa'] = Variable<String>(iscTasa);
    }
    map['es_bolsa'] = Variable<bool>(esBolsa);
    if (!nullToAbsent || detraccionCodigo != null) {
      map['detraccion_codigo'] = Variable<String>(detraccionCodigo);
    }
    map['favorito'] = Variable<bool>(favorito);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      companyId: Value(companyId),
      codigo: codigo == null && nullToAbsent
          ? const Value.absent()
          : Value(codigo),
      descripcion: Value(descripcion),
      unidadMedida: Value(unidadMedida),
      precio: Value(precio),
      precioIncluyeIgv: Value(precioIncluyeIgv),
      igvTipo: igvTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(igvTipo),
      iscTipo: iscTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(iscTipo),
      iscTasa: iscTasa == null && nullToAbsent
          ? const Value.absent()
          : Value(iscTasa),
      esBolsa: Value(esBolsa),
      detraccionCodigo: detraccionCodigo == null && nullToAbsent
          ? const Value.absent()
          : Value(detraccionCodigo),
      favorito: Value(favorito),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      companyId: serializer.fromJson<String>(json['companyId']),
      codigo: serializer.fromJson<String?>(json['codigo']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      unidadMedida: serializer.fromJson<String>(json['unidadMedida']),
      precio: serializer.fromJson<String>(json['precio']),
      precioIncluyeIgv: serializer.fromJson<bool>(json['precioIncluyeIgv']),
      igvTipo: serializer.fromJson<String?>(json['igvTipo']),
      iscTipo: serializer.fromJson<String?>(json['iscTipo']),
      iscTasa: serializer.fromJson<String?>(json['iscTasa']),
      esBolsa: serializer.fromJson<bool>(json['esBolsa']),
      detraccionCodigo: serializer.fromJson<String?>(json['detraccionCodigo']),
      favorito: serializer.fromJson<bool>(json['favorito']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'companyId': serializer.toJson<String>(companyId),
      'codigo': serializer.toJson<String?>(codigo),
      'descripcion': serializer.toJson<String>(descripcion),
      'unidadMedida': serializer.toJson<String>(unidadMedida),
      'precio': serializer.toJson<String>(precio),
      'precioIncluyeIgv': serializer.toJson<bool>(precioIncluyeIgv),
      'igvTipo': serializer.toJson<String?>(igvTipo),
      'iscTipo': serializer.toJson<String?>(iscTipo),
      'iscTasa': serializer.toJson<String?>(iscTasa),
      'esBolsa': serializer.toJson<bool>(esBolsa),
      'detraccionCodigo': serializer.toJson<String?>(detraccionCodigo),
      'favorito': serializer.toJson<bool>(favorito),
    };
  }

  Product copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? companyId,
    Value<String?> codigo = const Value.absent(),
    String? descripcion,
    String? unidadMedida,
    String? precio,
    bool? precioIncluyeIgv,
    Value<String?> igvTipo = const Value.absent(),
    Value<String?> iscTipo = const Value.absent(),
    Value<String?> iscTasa = const Value.absent(),
    bool? esBolsa,
    Value<String?> detraccionCodigo = const Value.absent(),
    bool? favorito,
  }) => Product(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    companyId: companyId ?? this.companyId,
    codigo: codigo.present ? codigo.value : this.codigo,
    descripcion: descripcion ?? this.descripcion,
    unidadMedida: unidadMedida ?? this.unidadMedida,
    precio: precio ?? this.precio,
    precioIncluyeIgv: precioIncluyeIgv ?? this.precioIncluyeIgv,
    igvTipo: igvTipo.present ? igvTipo.value : this.igvTipo,
    iscTipo: iscTipo.present ? iscTipo.value : this.iscTipo,
    iscTasa: iscTasa.present ? iscTasa.value : this.iscTasa,
    esBolsa: esBolsa ?? this.esBolsa,
    detraccionCodigo: detraccionCodigo.present
        ? detraccionCodigo.value
        : this.detraccionCodigo,
    favorito: favorito ?? this.favorito,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      unidadMedida: data.unidadMedida.present
          ? data.unidadMedida.value
          : this.unidadMedida,
      precio: data.precio.present ? data.precio.value : this.precio,
      precioIncluyeIgv: data.precioIncluyeIgv.present
          ? data.precioIncluyeIgv.value
          : this.precioIncluyeIgv,
      igvTipo: data.igvTipo.present ? data.igvTipo.value : this.igvTipo,
      iscTipo: data.iscTipo.present ? data.iscTipo.value : this.iscTipo,
      iscTasa: data.iscTasa.present ? data.iscTasa.value : this.iscTasa,
      esBolsa: data.esBolsa.present ? data.esBolsa.value : this.esBolsa,
      detraccionCodigo: data.detraccionCodigo.present
          ? data.detraccionCodigo.value
          : this.detraccionCodigo,
      favorito: data.favorito.present ? data.favorito.value : this.favorito,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('unidadMedida: $unidadMedida, ')
          ..write('precio: $precio, ')
          ..write('precioIncluyeIgv: $precioIncluyeIgv, ')
          ..write('igvTipo: $igvTipo, ')
          ..write('iscTipo: $iscTipo, ')
          ..write('iscTasa: $iscTasa, ')
          ..write('esBolsa: $esBolsa, ')
          ..write('detraccionCodigo: $detraccionCodigo, ')
          ..write('favorito: $favorito')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    codigo,
    descripcion,
    unidadMedida,
    precio,
    precioIncluyeIgv,
    igvTipo,
    iscTipo,
    iscTasa,
    esBolsa,
    detraccionCodigo,
    favorito,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.companyId == this.companyId &&
          other.codigo == this.codigo &&
          other.descripcion == this.descripcion &&
          other.unidadMedida == this.unidadMedida &&
          other.precio == this.precio &&
          other.precioIncluyeIgv == this.precioIncluyeIgv &&
          other.igvTipo == this.igvTipo &&
          other.iscTipo == this.iscTipo &&
          other.iscTasa == this.iscTasa &&
          other.esBolsa == this.esBolsa &&
          other.detraccionCodigo == this.detraccionCodigo &&
          other.favorito == this.favorito);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> companyId;
  final Value<String?> codigo;
  final Value<String> descripcion;
  final Value<String> unidadMedida;
  final Value<String> precio;
  final Value<bool> precioIncluyeIgv;
  final Value<String?> igvTipo;
  final Value<String?> iscTipo;
  final Value<String?> iscTasa;
  final Value<bool> esBolsa;
  final Value<String?> detraccionCodigo;
  final Value<bool> favorito;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.companyId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.unidadMedida = const Value.absent(),
    this.precio = const Value.absent(),
    this.precioIncluyeIgv = const Value.absent(),
    this.igvTipo = const Value.absent(),
    this.iscTipo = const Value.absent(),
    this.iscTasa = const Value.absent(),
    this.esBolsa = const Value.absent(),
    this.detraccionCodigo = const Value.absent(),
    this.favorito = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String companyId,
    this.codigo = const Value.absent(),
    required String descripcion,
    this.unidadMedida = const Value.absent(),
    required String precio,
    this.precioIncluyeIgv = const Value.absent(),
    this.igvTipo = const Value.absent(),
    this.iscTipo = const Value.absent(),
    this.iscTasa = const Value.absent(),
    this.esBolsa = const Value.absent(),
    this.detraccionCodigo = const Value.absent(),
    this.favorito = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId),
       descripcion = Value(descripcion),
       precio = Value(precio);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? companyId,
    Expression<String>? codigo,
    Expression<String>? descripcion,
    Expression<String>? unidadMedida,
    Expression<String>? precio,
    Expression<bool>? precioIncluyeIgv,
    Expression<String>? igvTipo,
    Expression<String>? iscTipo,
    Expression<String>? iscTasa,
    Expression<bool>? esBolsa,
    Expression<String>? detraccionCodigo,
    Expression<bool>? favorito,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (companyId != null) 'company_id': companyId,
      if (codigo != null) 'codigo': codigo,
      if (descripcion != null) 'descripcion': descripcion,
      if (unidadMedida != null) 'unidad_medida': unidadMedida,
      if (precio != null) 'precio': precio,
      if (precioIncluyeIgv != null) 'precio_incluye_igv': precioIncluyeIgv,
      if (igvTipo != null) 'igv_tipo': igvTipo,
      if (iscTipo != null) 'isc_tipo': iscTipo,
      if (iscTasa != null) 'isc_tasa': iscTasa,
      if (esBolsa != null) 'es_bolsa': esBolsa,
      if (detraccionCodigo != null) 'detraccion_codigo': detraccionCodigo,
      if (favorito != null) 'favorito': favorito,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? companyId,
    Value<String?>? codigo,
    Value<String>? descripcion,
    Value<String>? unidadMedida,
    Value<String>? precio,
    Value<bool>? precioIncluyeIgv,
    Value<String?>? igvTipo,
    Value<String?>? iscTipo,
    Value<String?>? iscTasa,
    Value<bool>? esBolsa,
    Value<String?>? detraccionCodigo,
    Value<bool>? favorito,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      companyId: companyId ?? this.companyId,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      precio: precio ?? this.precio,
      precioIncluyeIgv: precioIncluyeIgv ?? this.precioIncluyeIgv,
      igvTipo: igvTipo ?? this.igvTipo,
      iscTipo: iscTipo ?? this.iscTipo,
      iscTasa: iscTasa ?? this.iscTasa,
      esBolsa: esBolsa ?? this.esBolsa,
      detraccionCodigo: detraccionCodigo ?? this.detraccionCodigo,
      favorito: favorito ?? this.favorito,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (companyId.present) {
      map['company_id'] = Variable<String>(companyId.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (unidadMedida.present) {
      map['unidad_medida'] = Variable<String>(unidadMedida.value);
    }
    if (precio.present) {
      map['precio'] = Variable<String>(precio.value);
    }
    if (precioIncluyeIgv.present) {
      map['precio_incluye_igv'] = Variable<bool>(precioIncluyeIgv.value);
    }
    if (igvTipo.present) {
      map['igv_tipo'] = Variable<String>(igvTipo.value);
    }
    if (iscTipo.present) {
      map['isc_tipo'] = Variable<String>(iscTipo.value);
    }
    if (iscTasa.present) {
      map['isc_tasa'] = Variable<String>(iscTasa.value);
    }
    if (esBolsa.present) {
      map['es_bolsa'] = Variable<bool>(esBolsa.value);
    }
    if (detraccionCodigo.present) {
      map['detraccion_codigo'] = Variable<String>(detraccionCodigo.value);
    }
    if (favorito.present) {
      map['favorito'] = Variable<bool>(favorito.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('codigo: $codigo, ')
          ..write('descripcion: $descripcion, ')
          ..write('unidadMedida: $unidadMedida, ')
          ..write('precio: $precio, ')
          ..write('precioIncluyeIgv: $precioIncluyeIgv, ')
          ..write('igvTipo: $igvTipo, ')
          ..write('iscTipo: $iscTipo, ')
          ..write('iscTasa: $iscTasa, ')
          ..write('esBolsa: $esBolsa, ')
          ..write('detraccionCodigo: $detraccionCodigo, ')
          ..write('favorito: $favorito, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeviceSettingsTable extends DeviceSettings
    with TableInfo<$DeviceSettingsTable, DeviceSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  DeviceSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $DeviceSettingsTable createAlias(String alias) {
    return $DeviceSettingsTable(attachedDatabase, alias);
  }
}

class DeviceSetting extends DataClass implements Insertable<DeviceSetting> {
  final String key;
  final String value;
  const DeviceSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  DeviceSettingsCompanion toCompanion(bool nullToAbsent) {
    return DeviceSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory DeviceSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  DeviceSetting copyWith({String? key, String? value}) =>
      DeviceSetting(key: key ?? this.key, value: value ?? this.value);
  DeviceSetting copyWithCompanion(DeviceSettingsCompanion data) {
    return DeviceSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class DeviceSettingsCompanion extends UpdateCompanion<DeviceSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const DeviceSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<DeviceSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return DeviceSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CompaniesTable companies = $CompaniesTable(this);
  late final $SeriesTable series = $SeriesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $DeviceSettingsTable deviceSettings = $DeviceSettingsTable(this);
  late final Index companiesRuc = Index(
    'companies_ruc',
    'CREATE UNIQUE INDEX companies_ruc ON companies (ruc) WHERE deleted_at IS NULL',
  );
  late final Index customersDocument = Index(
    'customers_document',
    'CREATE UNIQUE INDEX customers_document ON customers (company_id, tipo_documento_identidad, numero_documento_identidad) WHERE deleted_at IS NULL',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    companies,
    series,
    customers,
    products,
    deviceSettings,
    companiesRuc,
    customersDocument,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$CompaniesTableCreateCompanionBuilder = CompaniesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String ruc,
  required String razonSocial,
  Value<String?> nombreComercial,
  Value<String?> ubigeo,
  Value<String?> departamento,
  Value<String?> provincia,
  Value<String?> distrito,
  Value<String?> direccion,
  Value<String?> urbanizacion,
  Value<String?> codigoLocal,
  Value<String?> telefono,
  Value<String?> email,
  Value<SunatEnvironment> sunatEnvironment,
  Value<String> moneda,
  Value<String> igvTipo,
  Value<String?> cuentaDetracciones,
  Value<bool> esAgentePercepcion,
  Value<bool> esAgenteRetencion,
  Value<LookupProvider> lookupProvider,
  Value<String?> lookupUrl,
  Value<int> rowid,
});
typedef $$CompaniesTableUpdateCompanionBuilder = CompaniesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> ruc,
  Value<String> razonSocial,
  Value<String?> nombreComercial,
  Value<String?> ubigeo,
  Value<String?> departamento,
  Value<String?> provincia,
  Value<String?> distrito,
  Value<String?> direccion,
  Value<String?> urbanizacion,
  Value<String?> codigoLocal,
  Value<String?> telefono,
  Value<String?> email,
  Value<SunatEnvironment> sunatEnvironment,
  Value<String> moneda,
  Value<String> igvTipo,
  Value<String?> cuentaDetracciones,
  Value<bool> esAgentePercepcion,
  Value<bool> esAgenteRetencion,
  Value<LookupProvider> lookupProvider,
  Value<String?> lookupUrl,
  Value<int> rowid,
});

final class $$CompaniesTableReferences
    extends BaseReferences<_$AppDatabase, $CompaniesTable, Company> {
  $$CompaniesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SeriesTable, List<Serie>> _seriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.series,
    aliasName: 'companies__id__series__company_id',
  );

  $$SeriesTableProcessedTableManager get seriesRefs {
    final manager = $$SeriesTableTableManager(
      $_db,
      $_db.series,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_seriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustomersTable, List<Customer>>
  _customersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customers,
    aliasName: 'companies__id__customers__company_id',
  );

  $$CustomersTableProcessedTableManager get customersRefs {
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_customersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'companies__id__products__company_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CompaniesTableFilterComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruc => $composableBuilder(
    column: $table.ruc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombreComercial => $composableBuilder(
    column: $table.nombreComercial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ubigeo => $composableBuilder(
    column: $table.ubigeo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distrito => $composableBuilder(
    column: $table.distrito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get urbanizacion => $composableBuilder(
    column: $table.urbanizacion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoLocal => $composableBuilder(
    column: $table.codigoLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SunatEnvironment, SunatEnvironment, String>
  get sunatEnvironment => $composableBuilder(
    column: $table.sunatEnvironment,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get igvTipo => $composableBuilder(
    column: $table.igvTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuentaDetracciones => $composableBuilder(
    column: $table.cuentaDetracciones,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esAgentePercepcion => $composableBuilder(
    column: $table.esAgentePercepcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esAgenteRetencion => $composableBuilder(
    column: $table.esAgenteRetencion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LookupProvider, LookupProvider, String>
  get lookupProvider => $composableBuilder(
    column: $table.lookupProvider,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get lookupUrl => $composableBuilder(
    column: $table.lookupUrl,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> seriesRefs(
    Expression<bool> Function($$SeriesTableFilterComposer f) f,
  ) {
    final $$SeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableFilterComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> customersRefs(
    Expression<bool> Function($$CustomersTableFilterComposer f) f,
  ) {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompaniesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruc => $composableBuilder(
    column: $table.ruc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombreComercial => $composableBuilder(
    column: $table.nombreComercial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ubigeo => $composableBuilder(
    column: $table.ubigeo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distrito => $composableBuilder(
    column: $table.distrito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urbanizacion => $composableBuilder(
    column: $table.urbanizacion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoLocal => $composableBuilder(
    column: $table.codigoLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sunatEnvironment => $composableBuilder(
    column: $table.sunatEnvironment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get igvTipo => $composableBuilder(
    column: $table.igvTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuentaDetracciones => $composableBuilder(
    column: $table.cuentaDetracciones,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esAgentePercepcion => $composableBuilder(
    column: $table.esAgentePercepcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esAgenteRetencion => $composableBuilder(
    column: $table.esAgenteRetencion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lookupProvider => $composableBuilder(
    column: $table.lookupProvider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lookupUrl => $composableBuilder(
    column: $table.lookupUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompaniesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompaniesTable> {
  $$CompaniesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get ruc =>
      $composableBuilder(column: $table.ruc, builder: (column) => column);

  GeneratedColumn<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombreComercial => $composableBuilder(
    column: $table.nombreComercial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ubigeo =>
      $composableBuilder(column: $table.ubigeo, builder: (column) => column);

  GeneratedColumn<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get provincia =>
      $composableBuilder(column: $table.provincia, builder: (column) => column);

  GeneratedColumn<String> get distrito =>
      $composableBuilder(column: $table.distrito, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get urbanizacion => $composableBuilder(
    column: $table.urbanizacion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codigoLocal => $composableBuilder(
    column: $table.codigoLocal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SunatEnvironment, String>
  get sunatEnvironment => $composableBuilder(
    column: $table.sunatEnvironment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moneda =>
      $composableBuilder(column: $table.moneda, builder: (column) => column);

  GeneratedColumn<String> get igvTipo =>
      $composableBuilder(column: $table.igvTipo, builder: (column) => column);

  GeneratedColumn<String> get cuentaDetracciones => $composableBuilder(
    column: $table.cuentaDetracciones,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esAgentePercepcion => $composableBuilder(
    column: $table.esAgentePercepcion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get esAgenteRetencion => $composableBuilder(
    column: $table.esAgenteRetencion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LookupProvider, String> get lookupProvider =>
      $composableBuilder(
        column: $table.lookupProvider,
        builder: (column) => column,
      );

  GeneratedColumn<String> get lookupUrl =>
      $composableBuilder(column: $table.lookupUrl, builder: (column) => column);

  Expression<T> seriesRefs<T extends Object>(
    Expression<T> Function($$SeriesTableAnnotationComposer a) f,
  ) {
    final $$SeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> customersRefs<T extends Object>(
    Expression<T> Function($$CustomersTableAnnotationComposer a) f,
  ) {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CompaniesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompaniesTable,
          Company,
          $$CompaniesTableFilterComposer,
          $$CompaniesTableOrderingComposer,
          $$CompaniesTableAnnotationComposer,
          $$CompaniesTableCreateCompanionBuilder,
          $$CompaniesTableUpdateCompanionBuilder,
          (Company, $$CompaniesTableReferences),
          Company,
          PrefetchHooks Function({
            bool seriesRefs,
            bool customersRefs,
            bool productsRefs,
          })
        > {
  $$CompaniesTableTableManager(_$AppDatabase db, $CompaniesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompaniesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompaniesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompaniesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> ruc = const Value.absent(),
                Value<String> razonSocial = const Value.absent(),
                Value<String?> nombreComercial = const Value.absent(),
                Value<String?> ubigeo = const Value.absent(),
                Value<String?> departamento = const Value.absent(),
                Value<String?> provincia = const Value.absent(),
                Value<String?> distrito = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<String?> urbanizacion = const Value.absent(),
                Value<String?> codigoLocal = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<SunatEnvironment> sunatEnvironment = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String> igvTipo = const Value.absent(),
                Value<String?> cuentaDetracciones = const Value.absent(),
                Value<bool> esAgentePercepcion = const Value.absent(),
                Value<bool> esAgenteRetencion = const Value.absent(),
                Value<LookupProvider> lookupProvider = const Value.absent(),
                Value<String?> lookupUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompaniesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                ruc: ruc,
                razonSocial: razonSocial,
                nombreComercial: nombreComercial,
                ubigeo: ubigeo,
                departamento: departamento,
                provincia: provincia,
                distrito: distrito,
                direccion: direccion,
                urbanizacion: urbanizacion,
                codigoLocal: codigoLocal,
                telefono: telefono,
                email: email,
                sunatEnvironment: sunatEnvironment,
                moneda: moneda,
                igvTipo: igvTipo,
                cuentaDetracciones: cuentaDetracciones,
                esAgentePercepcion: esAgentePercepcion,
                esAgenteRetencion: esAgenteRetencion,
                lookupProvider: lookupProvider,
                lookupUrl: lookupUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String ruc,
                required String razonSocial,
                Value<String?> nombreComercial = const Value.absent(),
                Value<String?> ubigeo = const Value.absent(),
                Value<String?> departamento = const Value.absent(),
                Value<String?> provincia = const Value.absent(),
                Value<String?> distrito = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<String?> urbanizacion = const Value.absent(),
                Value<String?> codigoLocal = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<SunatEnvironment> sunatEnvironment = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String> igvTipo = const Value.absent(),
                Value<String?> cuentaDetracciones = const Value.absent(),
                Value<bool> esAgentePercepcion = const Value.absent(),
                Value<bool> esAgenteRetencion = const Value.absent(),
                Value<LookupProvider> lookupProvider = const Value.absent(),
                Value<String?> lookupUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompaniesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                ruc: ruc,
                razonSocial: razonSocial,
                nombreComercial: nombreComercial,
                ubigeo: ubigeo,
                departamento: departamento,
                provincia: provincia,
                distrito: distrito,
                direccion: direccion,
                urbanizacion: urbanizacion,
                codigoLocal: codigoLocal,
                telefono: telefono,
                email: email,
                sunatEnvironment: sunatEnvironment,
                moneda: moneda,
                igvTipo: igvTipo,
                cuentaDetracciones: cuentaDetracciones,
                esAgentePercepcion: esAgentePercepcion,
                esAgenteRetencion: esAgenteRetencion,
                lookupProvider: lookupProvider,
                lookupUrl: lookupUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CompaniesTable, Company>(table),
                  $$CompaniesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                seriesRefs = false,
                customersRefs = false,
                productsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (seriesRefs) db.series,
                    if (customersRefs) db.customers,
                    if (productsRefs) db.products,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (seriesRefs)
                        await $_getPrefetchedDataByColumns<
                          Company,
                          $CompaniesTable,
                          Serie,
                          $SeriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._seriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).seriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'company_id',
                          typedResults: items,
                        ),
                      if (customersRefs)
                        await $_getPrefetchedDataByColumns<
                          Company,
                          $CompaniesTable,
                          Customer,
                          $CustomersTable
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._customersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).customersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'company_id',
                          typedResults: items,
                        ),
                      if (productsRefs)
                        await $_getPrefetchedDataByColumns<
                          Company,
                          $CompaniesTable,
                          Product,
                          $ProductsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._productsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).productsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'company_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CompaniesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompaniesTable,
      Company,
      $$CompaniesTableFilterComposer,
      $$CompaniesTableOrderingComposer,
      $$CompaniesTableAnnotationComposer,
      $$CompaniesTableCreateCompanionBuilder,
      $$CompaniesTableUpdateCompanionBuilder,
      (Company, $$CompaniesTableReferences),
      Company,
      PrefetchHooks Function({
        bool seriesRefs,
        bool customersRefs,
        bool productsRefs,
      })
    >;
typedef $$SeriesTableCreateCompanionBuilder = SeriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String companyId,
  required String tipoComprobante,
  required String serie,
  Value<int> nextNumber,
  Value<bool> isDefault,
  Value<bool> active,
  Value<int> rowid,
});
typedef $$SeriesTableUpdateCompanionBuilder = SeriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> companyId,
  Value<String> tipoComprobante,
  Value<String> serie,
  Value<int> nextNumber,
  Value<bool> isDefault,
  Value<bool> active,
  Value<int> rowid,
});

final class $$SeriesTableReferences
    extends BaseReferences<_$AppDatabase, $SeriesTable, Serie> {
  $$SeriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('series__company_id__companies__id');

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SeriesTableFilterComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoComprobante => $composableBuilder(
    column: $table.tipoComprobante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serie => $composableBuilder(
    column: $table.serie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextNumber => $composableBuilder(
    column: $table.nextNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoComprobante => $composableBuilder(
    column: $table.tipoComprobante,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serie => $composableBuilder(
    column: $table.serie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextNumber => $composableBuilder(
    column: $table.nextNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get tipoComprobante => $composableBuilder(
    column: $table.tipoComprobante,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serie =>
      $composableBuilder(column: $table.serie, builder: (column) => column);

  GeneratedColumn<int> get nextNumber => $composableBuilder(
    column: $table.nextNumber,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeriesTable,
          Serie,
          $$SeriesTableFilterComposer,
          $$SeriesTableOrderingComposer,
          $$SeriesTableAnnotationComposer,
          $$SeriesTableCreateCompanionBuilder,
          $$SeriesTableUpdateCompanionBuilder,
          (Serie, $$SeriesTableReferences),
          Serie,
          PrefetchHooks Function({bool companyId})
        > {
  $$SeriesTableTableManager(_$AppDatabase db, $SeriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String> tipoComprobante = const Value.absent(),
                Value<String> serie = const Value.absent(),
                Value<int> nextNumber = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                tipoComprobante: tipoComprobante,
                serie: serie,
                nextNumber: nextNumber,
                isDefault: isDefault,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String companyId,
                required String tipoComprobante,
                required String serie,
                Value<int> nextNumber = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SeriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                tipoComprobante: tipoComprobante,
                serie: serie,
                nextNumber: nextNumber,
                isDefault: isDefault,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SeriesTable, Serie>(table),
                  $$SeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({companyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (companyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.companyId,
                        referencedTable: $$SeriesTableReferences
                            ._companyIdTable(db),
                        referencedColumn: $$SeriesTableReferences
                            ._companyIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeriesTable,
      Serie,
      $$SeriesTableFilterComposer,
      $$SeriesTableOrderingComposer,
      $$SeriesTableAnnotationComposer,
      $$SeriesTableCreateCompanionBuilder,
      $$SeriesTableUpdateCompanionBuilder,
      (Serie, $$SeriesTableReferences),
      Serie,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String companyId,
  required String tipoDocumentoIdentidad,
  required String numeroDocumentoIdentidad,
  required String nombre,
  Value<String?> direccion,
  Value<String?> email,
  Value<String?> telefono,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> companyId,
  Value<String> tipoDocumentoIdentidad,
  Value<String> numeroDocumentoIdentidad,
  Value<String> nombre,
  Value<String?> direccion,
  Value<String?> email,
  Value<String?> telefono,
  Value<int> rowid,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('customers__company_id__companies__id');

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipoDocumentoIdentidad => $composableBuilder(
    column: $table.tipoDocumentoIdentidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroDocumentoIdentidad => $composableBuilder(
    column: $table.numeroDocumentoIdentidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipoDocumentoIdentidad => $composableBuilder(
    column: $table.tipoDocumentoIdentidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroDocumentoIdentidad => $composableBuilder(
    column: $table.numeroDocumentoIdentidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get tipoDocumentoIdentidad => $composableBuilder(
    column: $table.tipoDocumentoIdentidad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get numeroDocumentoIdentidad => $composableBuilder(
    column: $table.numeroDocumentoIdentidad,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({bool companyId})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String> tipoDocumentoIdentidad = const Value.absent(),
                Value<String> numeroDocumentoIdentidad = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> direccion = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                nombre: nombre,
                direccion: direccion,
                email: email,
                telefono: telefono,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String companyId,
                required String tipoDocumentoIdentidad,
                required String numeroDocumentoIdentidad,
                required String nombre,
                Value<String?> direccion = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                nombre: nombre,
                direccion: direccion,
                email: email,
                telefono: telefono,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CustomersTable, Customer>(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({companyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (companyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.companyId,
                        referencedTable: $$CustomersTableReferences
                            ._companyIdTable(db),
                        referencedColumn: $$CustomersTableReferences
                            ._companyIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String companyId,
  Value<String?> codigo,
  required String descripcion,
  Value<String> unidadMedida,
  required String precio,
  Value<bool> precioIncluyeIgv,
  Value<String?> igvTipo,
  Value<String?> iscTipo,
  Value<String?> iscTasa,
  Value<bool> esBolsa,
  Value<String?> detraccionCodigo,
  Value<bool> favorito,
  Value<int> rowid,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> companyId,
  Value<String?> codigo,
  Value<String> descripcion,
  Value<String> unidadMedida,
  Value<String> precio,
  Value<bool> precioIncluyeIgv,
  Value<String?> igvTipo,
  Value<String?> iscTipo,
  Value<String?> iscTasa,
  Value<bool> esBolsa,
  Value<String?> detraccionCodigo,
  Value<bool> favorito,
  Value<int> rowid,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('products__company_id__companies__id');

  $$CompaniesTableProcessedTableManager get companyId {
    final $_column = $_itemColumn<String>('company_id')!;

    final manager = $$CompaniesTableTableManager(
      $_db,
      $_db.companies,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_companyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidadMedida => $composableBuilder(
    column: $table.unidadMedida,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get precioIncluyeIgv => $composableBuilder(
    column: $table.precioIncluyeIgv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get igvTipo => $composableBuilder(
    column: $table.igvTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iscTipo => $composableBuilder(
    column: $table.iscTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iscTasa => $composableBuilder(
    column: $table.iscTasa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get esBolsa => $composableBuilder(
    column: $table.esBolsa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detraccionCodigo => $composableBuilder(
    column: $table.detraccionCodigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorito => $composableBuilder(
    column: $table.favorito,
    builder: (column) => ColumnFilters(column),
  );

  $$CompaniesTableFilterComposer get companyId {
    final $$CompaniesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableFilterComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidadMedida => $composableBuilder(
    column: $table.unidadMedida,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get precioIncluyeIgv => $composableBuilder(
    column: $table.precioIncluyeIgv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get igvTipo => $composableBuilder(
    column: $table.igvTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iscTipo => $composableBuilder(
    column: $table.iscTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iscTasa => $composableBuilder(
    column: $table.iscTasa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get esBolsa => $composableBuilder(
    column: $table.esBolsa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detraccionCodigo => $composableBuilder(
    column: $table.detraccionCodigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorito => $composableBuilder(
    column: $table.favorito,
    builder: (column) => ColumnOrderings(column),
  );

  $$CompaniesTableOrderingComposer get companyId {
    final $$CompaniesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableOrderingComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unidadMedida => $composableBuilder(
    column: $table.unidadMedida,
    builder: (column) => column,
  );

  GeneratedColumn<String> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<bool> get precioIncluyeIgv => $composableBuilder(
    column: $table.precioIncluyeIgv,
    builder: (column) => column,
  );

  GeneratedColumn<String> get igvTipo =>
      $composableBuilder(column: $table.igvTipo, builder: (column) => column);

  GeneratedColumn<String> get iscTipo =>
      $composableBuilder(column: $table.iscTipo, builder: (column) => column);

  GeneratedColumn<String> get iscTasa =>
      $composableBuilder(column: $table.iscTasa, builder: (column) => column);

  GeneratedColumn<bool> get esBolsa =>
      $composableBuilder(column: $table.esBolsa, builder: (column) => column);

  GeneratedColumn<String> get detraccionCodigo => $composableBuilder(
    column: $table.detraccionCodigo,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get favorito =>
      $composableBuilder(column: $table.favorito, builder: (column) => column);

  $$CompaniesTableAnnotationComposer get companyId {
    final $$CompaniesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.companyId,
      referencedTable: $db.companies,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompaniesTableAnnotationComposer(
            $db: $db,
            $table: $db.companies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool companyId})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> unidadMedida = const Value.absent(),
                Value<String> precio = const Value.absent(),
                Value<bool> precioIncluyeIgv = const Value.absent(),
                Value<String?> igvTipo = const Value.absent(),
                Value<String?> iscTipo = const Value.absent(),
                Value<String?> iscTasa = const Value.absent(),
                Value<bool> esBolsa = const Value.absent(),
                Value<String?> detraccionCodigo = const Value.absent(),
                Value<bool> favorito = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                codigo: codigo,
                descripcion: descripcion,
                unidadMedida: unidadMedida,
                precio: precio,
                precioIncluyeIgv: precioIncluyeIgv,
                igvTipo: igvTipo,
                iscTipo: iscTipo,
                iscTasa: iscTasa,
                esBolsa: esBolsa,
                detraccionCodigo: detraccionCodigo,
                favorito: favorito,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String companyId,
                Value<String?> codigo = const Value.absent(),
                required String descripcion,
                Value<String> unidadMedida = const Value.absent(),
                required String precio,
                Value<bool> precioIncluyeIgv = const Value.absent(),
                Value<String?> igvTipo = const Value.absent(),
                Value<String?> iscTipo = const Value.absent(),
                Value<String?> iscTasa = const Value.absent(),
                Value<bool> esBolsa = const Value.absent(),
                Value<String?> detraccionCodigo = const Value.absent(),
                Value<bool> favorito = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                codigo: codigo,
                descripcion: descripcion,
                unidadMedida: unidadMedida,
                precio: precio,
                precioIncluyeIgv: precioIncluyeIgv,
                igvTipo: igvTipo,
                iscTipo: iscTipo,
                iscTasa: iscTasa,
                esBolsa: esBolsa,
                detraccionCodigo: detraccionCodigo,
                favorito: favorito,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductsTable, Product>(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({companyId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (companyId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.companyId,
                        referencedTable: $$ProductsTableReferences
                            ._companyIdTable(db),
                        referencedColumn: $$ProductsTableReferences
                            ._companyIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$DeviceSettingsTableCreateCompanionBuilder =
    DeviceSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$DeviceSettingsTableUpdateCompanionBuilder =
    DeviceSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$DeviceSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceSettingsTable> {
  $$DeviceSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceSettingsTable> {
  $$DeviceSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceSettingsTable> {
  $$DeviceSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$DeviceSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceSettingsTable,
          DeviceSetting,
          $$DeviceSettingsTableFilterComposer,
          $$DeviceSettingsTableOrderingComposer,
          $$DeviceSettingsTableAnnotationComposer,
          $$DeviceSettingsTableCreateCompanionBuilder,
          $$DeviceSettingsTableUpdateCompanionBuilder,
          (
            DeviceSetting,
            BaseReferences<_$AppDatabase, $DeviceSettingsTable, DeviceSetting>,
          ),
          DeviceSetting,
          PrefetchHooks Function()
        > {
  $$DeviceSettingsTableTableManager(
    _$AppDatabase db,
    $DeviceSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => DeviceSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => DeviceSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceSettingsTable, DeviceSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DeviceSettingsTable,
                    DeviceSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceSettingsTable,
      DeviceSetting,
      $$DeviceSettingsTableFilterComposer,
      $$DeviceSettingsTableOrderingComposer,
      $$DeviceSettingsTableAnnotationComposer,
      $$DeviceSettingsTableCreateCompanionBuilder,
      $$DeviceSettingsTableUpdateCompanionBuilder,
      (
        DeviceSetting,
        BaseReferences<_$AppDatabase, $DeviceSettingsTable, DeviceSetting>,
      ),
      DeviceSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CompaniesTableTableManager get companies =>
      $$CompaniesTableTableManager(_db, _db.companies);
  $$SeriesTableTableManager get series =>
      $$SeriesTableTableManager(_db, _db.series);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$DeviceSettingsTableTableManager get deviceSettings =>
      $$DeviceSettingsTableTableManager(_db, _db.deviceSettings);
}
