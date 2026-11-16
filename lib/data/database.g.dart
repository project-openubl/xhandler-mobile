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

  /// Banco de la Nación account where customers deposit detracciones.
  /// Schema 2.
  final String? cuentaDetracciones;
  final bool esAgentePercepcion;
  final bool esAgenteRetencion;

  /// RUC/DNI lookup service, see [LookupProvider]
  final LookupProvider lookupProvider;
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
          ..write('lookupProvider: $lookupProvider')
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
          other.lookupProvider == this.lookupProvider);
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
  static const VerificationMeta _ubigeoMeta = const VerificationMeta('ubigeo');
  @override
  late final GeneratedColumn<String> ubigeo = GeneratedColumn<String>(
    'ubigeo',
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
    distrito,
    provincia,
    departamento,
    ubigeo,
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
    if (data.containsKey('distrito')) {
      context.handle(
        _distritoMeta,
        distrito.isAcceptableOrUnknown(data['distrito']!, _distritoMeta),
      );
    }
    if (data.containsKey('provincia')) {
      context.handle(
        _provinciaMeta,
        provincia.isAcceptableOrUnknown(data['provincia']!, _provinciaMeta),
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
    if (data.containsKey('ubigeo')) {
      context.handle(
        _ubigeoMeta,
        ubigeo.isAcceptableOrUnknown(data['ubigeo']!, _ubigeoMeta),
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
      distrito: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distrito'],
      ),
      provincia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provincia'],
      ),
      departamento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}departamento'],
      ),
      ubigeo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ubigeo'],
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
  final String? distrito;
  final String? provincia;
  final String? departamento;
  final String? ubigeo;
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
    this.distrito,
    this.provincia,
    this.departamento,
    this.ubigeo,
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
    if (!nullToAbsent || distrito != null) {
      map['distrito'] = Variable<String>(distrito);
    }
    if (!nullToAbsent || provincia != null) {
      map['provincia'] = Variable<String>(provincia);
    }
    if (!nullToAbsent || departamento != null) {
      map['departamento'] = Variable<String>(departamento);
    }
    if (!nullToAbsent || ubigeo != null) {
      map['ubigeo'] = Variable<String>(ubigeo);
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
      distrito: distrito == null && nullToAbsent
          ? const Value.absent()
          : Value(distrito),
      provincia: provincia == null && nullToAbsent
          ? const Value.absent()
          : Value(provincia),
      departamento: departamento == null && nullToAbsent
          ? const Value.absent()
          : Value(departamento),
      ubigeo: ubigeo == null && nullToAbsent
          ? const Value.absent()
          : Value(ubigeo),
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
      distrito: serializer.fromJson<String?>(json['distrito']),
      provincia: serializer.fromJson<String?>(json['provincia']),
      departamento: serializer.fromJson<String?>(json['departamento']),
      ubigeo: serializer.fromJson<String?>(json['ubigeo']),
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
      'distrito': serializer.toJson<String?>(distrito),
      'provincia': serializer.toJson<String?>(provincia),
      'departamento': serializer.toJson<String?>(departamento),
      'ubigeo': serializer.toJson<String?>(ubigeo),
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
    Value<String?> distrito = const Value.absent(),
    Value<String?> provincia = const Value.absent(),
    Value<String?> departamento = const Value.absent(),
    Value<String?> ubigeo = const Value.absent(),
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
    distrito: distrito.present ? distrito.value : this.distrito,
    provincia: provincia.present ? provincia.value : this.provincia,
    departamento: departamento.present ? departamento.value : this.departamento,
    ubigeo: ubigeo.present ? ubigeo.value : this.ubigeo,
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
      distrito: data.distrito.present ? data.distrito.value : this.distrito,
      provincia: data.provincia.present ? data.provincia.value : this.provincia,
      departamento: data.departamento.present
          ? data.departamento.value
          : this.departamento,
      ubigeo: data.ubigeo.present ? data.ubigeo.value : this.ubigeo,
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
          ..write('distrito: $distrito, ')
          ..write('provincia: $provincia, ')
          ..write('departamento: $departamento, ')
          ..write('ubigeo: $ubigeo, ')
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
    distrito,
    provincia,
    departamento,
    ubigeo,
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
          other.distrito == this.distrito &&
          other.provincia == this.provincia &&
          other.departamento == this.departamento &&
          other.ubigeo == this.ubigeo &&
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
  final Value<String?> distrito;
  final Value<String?> provincia;
  final Value<String?> departamento;
  final Value<String?> ubigeo;
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
    this.distrito = const Value.absent(),
    this.provincia = const Value.absent(),
    this.departamento = const Value.absent(),
    this.ubigeo = const Value.absent(),
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
    this.distrito = const Value.absent(),
    this.provincia = const Value.absent(),
    this.departamento = const Value.absent(),
    this.ubigeo = const Value.absent(),
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
    Expression<String>? distrito,
    Expression<String>? provincia,
    Expression<String>? departamento,
    Expression<String>? ubigeo,
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
      if (distrito != null) 'distrito': distrito,
      if (provincia != null) 'provincia': provincia,
      if (departamento != null) 'departamento': departamento,
      if (ubigeo != null) 'ubigeo': ubigeo,
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
    Value<String?>? distrito,
    Value<String?>? provincia,
    Value<String?>? departamento,
    Value<String?>? ubigeo,
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
      distrito: distrito ?? this.distrito,
      provincia: provincia ?? this.provincia,
      departamento: departamento ?? this.departamento,
      ubigeo: ubigeo ?? this.ubigeo,
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
    if (distrito.present) {
      map['distrito'] = Variable<String>(distrito.value);
    }
    if (provincia.present) {
      map['provincia'] = Variable<String>(provincia.value);
    }
    if (departamento.present) {
      map['departamento'] = Variable<String>(departamento.value);
    }
    if (ubigeo.present) {
      map['ubigeo'] = Variable<String>(ubigeo.value);
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
          ..write('distrito: $distrito, ')
          ..write('provincia: $provincia, ')
          ..write('departamento: $departamento, ')
          ..write('ubigeo: $ubigeo, ')
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
  static const VerificationMeta _codigoSunatMeta = const VerificationMeta(
    'codigoSunat',
  );
  @override
  late final GeneratedColumn<String> codigoSunat = GeneratedColumn<String>(
    'codigo_sunat',
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
  static const VerificationMeta _detraccionPorcentajeMeta =
      const VerificationMeta('detraccionPorcentaje');
  @override
  late final GeneratedColumn<String> detraccionPorcentaje =
      GeneratedColumn<String>(
        'detraccion_porcentaje',
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
    codigoSunat,
    descripcion,
    unidadMedida,
    precio,
    precioIncluyeIgv,
    igvTipo,
    iscTipo,
    iscTasa,
    esBolsa,
    detraccionCodigo,
    detraccionPorcentaje,
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
    if (data.containsKey('codigo_sunat')) {
      context.handle(
        _codigoSunatMeta,
        codigoSunat.isAcceptableOrUnknown(
          data['codigo_sunat']!,
          _codigoSunatMeta,
        ),
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
    if (data.containsKey('detraccion_porcentaje')) {
      context.handle(
        _detraccionPorcentajeMeta,
        detraccionPorcentaje.isAcceptableOrUnknown(
          data['detraccion_porcentaje']!,
          _detraccionPorcentajeMeta,
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
      codigoSunat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_sunat'],
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
      detraccionPorcentaje: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detraccion_porcentaje'],
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

  /// SUNAT product code (UNSPSC)
  final String? codigoSunat;
  final String descripcion;

  /// Catalog 3, e.g. "NIU" unit, "ZZ" service
  final String unidadMedida;

  /// Decimal as text, to keep it exact
  final String precio;
  final bool precioIncluyeIgv;

  /// Catalog 7; null = the company's default
  final String? igvTipo;

  /// Catalog 8 and its rate, as a percentage (e.g. "17")
  final String? iscTipo;
  final String? iscTasa;

  /// Plastic bag, taxed with ICB
  final bool esBolsa;

  /// Catalog 54, when the good or service is subject to detracción
  final String? detraccionCodigo;

  /// Detracción rate of [detraccionCodigo] as a percentage, e.g. "12" (from
  /// SUNAT's annex; rates change, so the user enters it). Schema 2.
  final String? detraccionPorcentaje;

  /// Shown in the quick sale grid
  final bool favorito;
  const Product({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    this.codigo,
    this.codigoSunat,
    required this.descripcion,
    required this.unidadMedida,
    required this.precio,
    required this.precioIncluyeIgv,
    this.igvTipo,
    this.iscTipo,
    this.iscTasa,
    required this.esBolsa,
    this.detraccionCodigo,
    this.detraccionPorcentaje,
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
    if (!nullToAbsent || codigoSunat != null) {
      map['codigo_sunat'] = Variable<String>(codigoSunat);
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
    if (!nullToAbsent || detraccionPorcentaje != null) {
      map['detraccion_porcentaje'] = Variable<String>(detraccionPorcentaje);
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
      codigoSunat: codigoSunat == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoSunat),
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
      detraccionPorcentaje: detraccionPorcentaje == null && nullToAbsent
          ? const Value.absent()
          : Value(detraccionPorcentaje),
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
      codigoSunat: serializer.fromJson<String?>(json['codigoSunat']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      unidadMedida: serializer.fromJson<String>(json['unidadMedida']),
      precio: serializer.fromJson<String>(json['precio']),
      precioIncluyeIgv: serializer.fromJson<bool>(json['precioIncluyeIgv']),
      igvTipo: serializer.fromJson<String?>(json['igvTipo']),
      iscTipo: serializer.fromJson<String?>(json['iscTipo']),
      iscTasa: serializer.fromJson<String?>(json['iscTasa']),
      esBolsa: serializer.fromJson<bool>(json['esBolsa']),
      detraccionCodigo: serializer.fromJson<String?>(json['detraccionCodigo']),
      detraccionPorcentaje: serializer.fromJson<String?>(
        json['detraccionPorcentaje'],
      ),
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
      'codigoSunat': serializer.toJson<String?>(codigoSunat),
      'descripcion': serializer.toJson<String>(descripcion),
      'unidadMedida': serializer.toJson<String>(unidadMedida),
      'precio': serializer.toJson<String>(precio),
      'precioIncluyeIgv': serializer.toJson<bool>(precioIncluyeIgv),
      'igvTipo': serializer.toJson<String?>(igvTipo),
      'iscTipo': serializer.toJson<String?>(iscTipo),
      'iscTasa': serializer.toJson<String?>(iscTasa),
      'esBolsa': serializer.toJson<bool>(esBolsa),
      'detraccionCodigo': serializer.toJson<String?>(detraccionCodigo),
      'detraccionPorcentaje': serializer.toJson<String?>(detraccionPorcentaje),
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
    Value<String?> codigoSunat = const Value.absent(),
    String? descripcion,
    String? unidadMedida,
    String? precio,
    bool? precioIncluyeIgv,
    Value<String?> igvTipo = const Value.absent(),
    Value<String?> iscTipo = const Value.absent(),
    Value<String?> iscTasa = const Value.absent(),
    bool? esBolsa,
    Value<String?> detraccionCodigo = const Value.absent(),
    Value<String?> detraccionPorcentaje = const Value.absent(),
    bool? favorito,
  }) => Product(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    companyId: companyId ?? this.companyId,
    codigo: codigo.present ? codigo.value : this.codigo,
    codigoSunat: codigoSunat.present ? codigoSunat.value : this.codigoSunat,
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
    detraccionPorcentaje: detraccionPorcentaje.present
        ? detraccionPorcentaje.value
        : this.detraccionPorcentaje,
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
      codigoSunat: data.codigoSunat.present
          ? data.codigoSunat.value
          : this.codigoSunat,
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
      detraccionPorcentaje: data.detraccionPorcentaje.present
          ? data.detraccionPorcentaje.value
          : this.detraccionPorcentaje,
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
          ..write('codigoSunat: $codigoSunat, ')
          ..write('descripcion: $descripcion, ')
          ..write('unidadMedida: $unidadMedida, ')
          ..write('precio: $precio, ')
          ..write('precioIncluyeIgv: $precioIncluyeIgv, ')
          ..write('igvTipo: $igvTipo, ')
          ..write('iscTipo: $iscTipo, ')
          ..write('iscTasa: $iscTasa, ')
          ..write('esBolsa: $esBolsa, ')
          ..write('detraccionCodigo: $detraccionCodigo, ')
          ..write('detraccionPorcentaje: $detraccionPorcentaje, ')
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
    codigoSunat,
    descripcion,
    unidadMedida,
    precio,
    precioIncluyeIgv,
    igvTipo,
    iscTipo,
    iscTasa,
    esBolsa,
    detraccionCodigo,
    detraccionPorcentaje,
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
          other.codigoSunat == this.codigoSunat &&
          other.descripcion == this.descripcion &&
          other.unidadMedida == this.unidadMedida &&
          other.precio == this.precio &&
          other.precioIncluyeIgv == this.precioIncluyeIgv &&
          other.igvTipo == this.igvTipo &&
          other.iscTipo == this.iscTipo &&
          other.iscTasa == this.iscTasa &&
          other.esBolsa == this.esBolsa &&
          other.detraccionCodigo == this.detraccionCodigo &&
          other.detraccionPorcentaje == this.detraccionPorcentaje &&
          other.favorito == this.favorito);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> companyId;
  final Value<String?> codigo;
  final Value<String?> codigoSunat;
  final Value<String> descripcion;
  final Value<String> unidadMedida;
  final Value<String> precio;
  final Value<bool> precioIncluyeIgv;
  final Value<String?> igvTipo;
  final Value<String?> iscTipo;
  final Value<String?> iscTasa;
  final Value<bool> esBolsa;
  final Value<String?> detraccionCodigo;
  final Value<String?> detraccionPorcentaje;
  final Value<bool> favorito;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.companyId = const Value.absent(),
    this.codigo = const Value.absent(),
    this.codigoSunat = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.unidadMedida = const Value.absent(),
    this.precio = const Value.absent(),
    this.precioIncluyeIgv = const Value.absent(),
    this.igvTipo = const Value.absent(),
    this.iscTipo = const Value.absent(),
    this.iscTasa = const Value.absent(),
    this.esBolsa = const Value.absent(),
    this.detraccionCodigo = const Value.absent(),
    this.detraccionPorcentaje = const Value.absent(),
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
    this.codigoSunat = const Value.absent(),
    required String descripcion,
    this.unidadMedida = const Value.absent(),
    required String precio,
    this.precioIncluyeIgv = const Value.absent(),
    this.igvTipo = const Value.absent(),
    this.iscTipo = const Value.absent(),
    this.iscTasa = const Value.absent(),
    this.esBolsa = const Value.absent(),
    this.detraccionCodigo = const Value.absent(),
    this.detraccionPorcentaje = const Value.absent(),
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
    Expression<String>? codigoSunat,
    Expression<String>? descripcion,
    Expression<String>? unidadMedida,
    Expression<String>? precio,
    Expression<bool>? precioIncluyeIgv,
    Expression<String>? igvTipo,
    Expression<String>? iscTipo,
    Expression<String>? iscTasa,
    Expression<bool>? esBolsa,
    Expression<String>? detraccionCodigo,
    Expression<String>? detraccionPorcentaje,
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
      if (codigoSunat != null) 'codigo_sunat': codigoSunat,
      if (descripcion != null) 'descripcion': descripcion,
      if (unidadMedida != null) 'unidad_medida': unidadMedida,
      if (precio != null) 'precio': precio,
      if (precioIncluyeIgv != null) 'precio_incluye_igv': precioIncluyeIgv,
      if (igvTipo != null) 'igv_tipo': igvTipo,
      if (iscTipo != null) 'isc_tipo': iscTipo,
      if (iscTasa != null) 'isc_tasa': iscTasa,
      if (esBolsa != null) 'es_bolsa': esBolsa,
      if (detraccionCodigo != null) 'detraccion_codigo': detraccionCodigo,
      if (detraccionPorcentaje != null)
        'detraccion_porcentaje': detraccionPorcentaje,
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
    Value<String?>? codigoSunat,
    Value<String>? descripcion,
    Value<String>? unidadMedida,
    Value<String>? precio,
    Value<bool>? precioIncluyeIgv,
    Value<String?>? igvTipo,
    Value<String?>? iscTipo,
    Value<String?>? iscTasa,
    Value<bool>? esBolsa,
    Value<String?>? detraccionCodigo,
    Value<String?>? detraccionPorcentaje,
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
      codigoSunat: codigoSunat ?? this.codigoSunat,
      descripcion: descripcion ?? this.descripcion,
      unidadMedida: unidadMedida ?? this.unidadMedida,
      precio: precio ?? this.precio,
      precioIncluyeIgv: precioIncluyeIgv ?? this.precioIncluyeIgv,
      igvTipo: igvTipo ?? this.igvTipo,
      iscTipo: iscTipo ?? this.iscTipo,
      iscTasa: iscTasa ?? this.iscTasa,
      esBolsa: esBolsa ?? this.esBolsa,
      detraccionCodigo: detraccionCodigo ?? this.detraccionCodigo,
      detraccionPorcentaje: detraccionPorcentaje ?? this.detraccionPorcentaje,
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
    if (codigoSunat.present) {
      map['codigo_sunat'] = Variable<String>(codigoSunat.value);
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
    if (detraccionPorcentaje.present) {
      map['detraccion_porcentaje'] = Variable<String>(
        detraccionPorcentaje.value,
      );
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
          ..write('codigoSunat: $codigoSunat, ')
          ..write('descripcion: $descripcion, ')
          ..write('unidadMedida: $unidadMedida, ')
          ..write('precio: $precio, ')
          ..write('precioIncluyeIgv: $precioIncluyeIgv, ')
          ..write('igvTipo: $igvTipo, ')
          ..write('iscTipo: $iscTipo, ')
          ..write('iscTasa: $iscTasa, ')
          ..write('esBolsa: $esBolsa, ')
          ..write('detraccionCodigo: $detraccionCodigo, ')
          ..write('detraccionPorcentaje: $detraccionPorcentaje, ')
          ..write('favorito: $favorito, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<SunatEnvironment, String>
  environment = GeneratedColumn<String>(
    'environment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<SunatEnvironment>($DocumentsTable.$converterenvironment);
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroMeta = const VerificationMeta('numero');
  @override
  late final GeneratedColumn<int> numero = GeneratedColumn<int>(
    'numero',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaEmisionMeta = const VerificationMeta(
    'fechaEmision',
  );
  @override
  late final GeneratedColumn<String> fechaEmision = GeneratedColumn<String>(
    'fecha_emision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clienteTipoDocumentoMeta =
      const VerificationMeta('clienteTipoDocumento');
  @override
  late final GeneratedColumn<String> clienteTipoDocumento =
      GeneratedColumn<String>(
        'cliente_tipo_documento',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _clienteNumeroDocumentoMeta =
      const VerificationMeta('clienteNumeroDocumento');
  @override
  late final GeneratedColumn<String> clienteNumeroDocumento =
      GeneratedColumn<String>(
        'cliente_numero_documento',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _clienteNombreMeta = const VerificationMeta(
    'clienteNombre',
  );
  @override
  late final GeneratedColumn<String> clienteNombre = GeneratedColumn<String>(
    'cliente_nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monedaMeta = const VerificationMeta('moneda');
  @override
  late final GeneratedColumn<String> moneda = GeneratedColumn<String>(
    'moneda',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<String> total = GeneratedColumn<String>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DocumentStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DocumentStatus>($DocumentsTable.$converterstatus);
  static const VerificationMeta _sunatCodeMeta = const VerificationMeta(
    'sunatCode',
  );
  @override
  late final GeneratedColumn<String> sunatCode = GeneratedColumn<String>(
    'sunat_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sunatDescriptionMeta = const VerificationMeta(
    'sunatDescription',
  );
  @override
  late final GeneratedColumn<String> sunatDescription = GeneratedColumn<String>(
    'sunat_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sunatNotesMeta = const VerificationMeta(
    'sunatNotes',
  );
  @override
  late final GeneratedColumn<String> sunatNotes = GeneratedColumn<String>(
    'sunat_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ticketMeta = const VerificationMeta('ticket');
  @override
  late final GeneratedColumn<String> ticket = GeneratedColumn<String>(
    'ticket',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _digestValueMeta = const VerificationMeta(
    'digestValue',
  );
  @override
  late final GeneratedColumn<String> digestValue = GeneratedColumn<String>(
    'digest_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _inputJsonMeta = const VerificationMeta(
    'inputJson',
  );
  @override
  late final GeneratedColumn<String> inputJson = GeneratedColumn<String>(
    'input_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enrichedJsonMeta = const VerificationMeta(
    'enrichedJson',
  );
  @override
  late final GeneratedColumn<String> enrichedJson = GeneratedColumn<String>(
    'enriched_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _affectedDocumentIdMeta =
      const VerificationMeta('affectedDocumentId');
  @override
  late final GeneratedColumn<String> affectedDocumentId =
      GeneratedColumn<String>(
        'affected_document_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES documents (id)',
        ),
      );
  static const VerificationMeta _voidedByDocumentIdMeta =
      const VerificationMeta('voidedByDocumentId');
  @override
  late final GeneratedColumn<String> voidedByDocumentId =
      GeneratedColumn<String>(
        'voided_by_document_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES documents (id)',
        ),
      );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    environment,
    tipoComprobante,
    serie,
    numero,
    fechaEmision,
    clienteTipoDocumento,
    clienteNumeroDocumento,
    clienteNombre,
    moneda,
    total,
    status,
    sunatCode,
    sunatDescription,
    sunatNotes,
    ticket,
    digestValue,
    attempts,
    nextAttemptAt,
    inputJson,
    enrichedJson,
    affectedDocumentId,
    voidedByDocumentId,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<Document> instance, {
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
    if (data.containsKey('numero')) {
      context.handle(
        _numeroMeta,
        numero.isAcceptableOrUnknown(data['numero']!, _numeroMeta),
      );
    } else if (isInserting) {
      context.missing(_numeroMeta);
    }
    if (data.containsKey('fecha_emision')) {
      context.handle(
        _fechaEmisionMeta,
        fechaEmision.isAcceptableOrUnknown(
          data['fecha_emision']!,
          _fechaEmisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaEmisionMeta);
    }
    if (data.containsKey('cliente_tipo_documento')) {
      context.handle(
        _clienteTipoDocumentoMeta,
        clienteTipoDocumento.isAcceptableOrUnknown(
          data['cliente_tipo_documento']!,
          _clienteTipoDocumentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clienteTipoDocumentoMeta);
    }
    if (data.containsKey('cliente_numero_documento')) {
      context.handle(
        _clienteNumeroDocumentoMeta,
        clienteNumeroDocumento.isAcceptableOrUnknown(
          data['cliente_numero_documento']!,
          _clienteNumeroDocumentoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clienteNumeroDocumentoMeta);
    }
    if (data.containsKey('cliente_nombre')) {
      context.handle(
        _clienteNombreMeta,
        clienteNombre.isAcceptableOrUnknown(
          data['cliente_nombre']!,
          _clienteNombreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clienteNombreMeta);
    }
    if (data.containsKey('moneda')) {
      context.handle(
        _monedaMeta,
        moneda.isAcceptableOrUnknown(data['moneda']!, _monedaMeta),
      );
    } else if (isInserting) {
      context.missing(_monedaMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('sunat_code')) {
      context.handle(
        _sunatCodeMeta,
        sunatCode.isAcceptableOrUnknown(data['sunat_code']!, _sunatCodeMeta),
      );
    }
    if (data.containsKey('sunat_description')) {
      context.handle(
        _sunatDescriptionMeta,
        sunatDescription.isAcceptableOrUnknown(
          data['sunat_description']!,
          _sunatDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('sunat_notes')) {
      context.handle(
        _sunatNotesMeta,
        sunatNotes.isAcceptableOrUnknown(data['sunat_notes']!, _sunatNotesMeta),
      );
    }
    if (data.containsKey('ticket')) {
      context.handle(
        _ticketMeta,
        ticket.isAcceptableOrUnknown(data['ticket']!, _ticketMeta),
      );
    }
    if (data.containsKey('digest_value')) {
      context.handle(
        _digestValueMeta,
        digestValue.isAcceptableOrUnknown(
          data['digest_value']!,
          _digestValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_digestValueMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('input_json')) {
      context.handle(
        _inputJsonMeta,
        inputJson.isAcceptableOrUnknown(data['input_json']!, _inputJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_inputJsonMeta);
    }
    if (data.containsKey('enriched_json')) {
      context.handle(
        _enrichedJsonMeta,
        enrichedJson.isAcceptableOrUnknown(
          data['enriched_json']!,
          _enrichedJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_enrichedJsonMeta);
    }
    if (data.containsKey('affected_document_id')) {
      context.handle(
        _affectedDocumentIdMeta,
        affectedDocumentId.isAcceptableOrUnknown(
          data['affected_document_id']!,
          _affectedDocumentIdMeta,
        ),
      );
    }
    if (data.containsKey('voided_by_document_id')) {
      context.handle(
        _voidedByDocumentIdMeta,
        voidedByDocumentId.isAcceptableOrUnknown(
          data['voided_by_document_id']!,
          _voidedByDocumentIdMeta,
        ),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
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
      environment: $DocumentsTable.$converterenvironment.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}environment'],
        )!,
      ),
      tipoComprobante: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo_comprobante'],
      )!,
      serie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serie'],
      )!,
      numero: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}numero'],
      )!,
      fechaEmision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_emision'],
      )!,
      clienteTipoDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_tipo_documento'],
      )!,
      clienteNumeroDocumento: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_numero_documento'],
      )!,
      clienteNombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cliente_nombre'],
      )!,
      moneda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moneda'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}total'],
      )!,
      status: $DocumentsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      sunatCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sunat_code'],
      ),
      sunatDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sunat_description'],
      ),
      sunatNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sunat_notes'],
      ),
      ticket: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ticket'],
      ),
      digestValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}digest_value'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      inputJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_json'],
      )!,
      enrichedJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enriched_json'],
      )!,
      affectedDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}affected_document_id'],
      ),
      voidedByDocumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voided_by_document_id'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SunatEnvironment, String, String>
  $converterenvironment = const EnumNameConverter<SunatEnvironment>(
    SunatEnvironment.values,
  );
  static JsonTypeConverter2<DocumentStatus, String, String> $converterstatus =
      const EnumNameConverter<DocumentStatus>(DocumentStatus.values);
}

class Document extends DataClass implements Insertable<Document> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String companyId;

  /// Beta documents are kept apart from production ones
  final SunatEnvironment environment;

  /// Catalog 1
  final String tipoComprobante;
  final String serie;
  final int numero;

  /// "YYYY-MM-DD", Peru's date
  final String fechaEmision;
  final String clienteTipoDocumento;
  final String clienteNumeroDocumento;
  final String clienteNombre;
  final String moneda;

  /// Decimal as text
  final String total;
  final DocumentStatus status;

  /// SUNAT's answer: CDR ResponseCode, fault code, "HTTP 401"...
  final String? sunatCode;
  final String? sunatDescription;

  /// CDR observations, JSON list
  final String? sunatNotes;
  final String? ticket;

  /// Signature hash, printed in the QR code
  final String digestValue;

  /// Sends that got no answer, for the retry back-off
  final int attempts;
  final DateTime? nextAttemptAt;

  /// What the user entered (xbuilder JSON), to fix and resend it or to
  /// issue a copy
  final String inputJson;

  /// The document as built (xbuilder JSON, enriched), for the PDF
  final String enrichedJson;

  /// The document a nota de crédito/débito modifies
  final String? affectedDocumentId;

  /// The comunicación de baja or resumen that voids this document
  final String? voidedByDocumentId;

  /// Device that issued it (DESIGN §3.1)
  final String deviceId;
  const Document({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    required this.environment,
    required this.tipoComprobante,
    required this.serie,
    required this.numero,
    required this.fechaEmision,
    required this.clienteTipoDocumento,
    required this.clienteNumeroDocumento,
    required this.clienteNombre,
    required this.moneda,
    required this.total,
    required this.status,
    this.sunatCode,
    this.sunatDescription,
    this.sunatNotes,
    this.ticket,
    required this.digestValue,
    required this.attempts,
    this.nextAttemptAt,
    required this.inputJson,
    required this.enrichedJson,
    this.affectedDocumentId,
    this.voidedByDocumentId,
    required this.deviceId,
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
    {
      map['environment'] = Variable<String>(
        $DocumentsTable.$converterenvironment.toSql(environment),
      );
    }
    map['tipo_comprobante'] = Variable<String>(tipoComprobante);
    map['serie'] = Variable<String>(serie);
    map['numero'] = Variable<int>(numero);
    map['fecha_emision'] = Variable<String>(fechaEmision);
    map['cliente_tipo_documento'] = Variable<String>(clienteTipoDocumento);
    map['cliente_numero_documento'] = Variable<String>(clienteNumeroDocumento);
    map['cliente_nombre'] = Variable<String>(clienteNombre);
    map['moneda'] = Variable<String>(moneda);
    map['total'] = Variable<String>(total);
    {
      map['status'] = Variable<String>(
        $DocumentsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || sunatCode != null) {
      map['sunat_code'] = Variable<String>(sunatCode);
    }
    if (!nullToAbsent || sunatDescription != null) {
      map['sunat_description'] = Variable<String>(sunatDescription);
    }
    if (!nullToAbsent || sunatNotes != null) {
      map['sunat_notes'] = Variable<String>(sunatNotes);
    }
    if (!nullToAbsent || ticket != null) {
      map['ticket'] = Variable<String>(ticket);
    }
    map['digest_value'] = Variable<String>(digestValue);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    map['input_json'] = Variable<String>(inputJson);
    map['enriched_json'] = Variable<String>(enrichedJson);
    if (!nullToAbsent || affectedDocumentId != null) {
      map['affected_document_id'] = Variable<String>(affectedDocumentId);
    }
    if (!nullToAbsent || voidedByDocumentId != null) {
      map['voided_by_document_id'] = Variable<String>(voidedByDocumentId);
    }
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      companyId: Value(companyId),
      environment: Value(environment),
      tipoComprobante: Value(tipoComprobante),
      serie: Value(serie),
      numero: Value(numero),
      fechaEmision: Value(fechaEmision),
      clienteTipoDocumento: Value(clienteTipoDocumento),
      clienteNumeroDocumento: Value(clienteNumeroDocumento),
      clienteNombre: Value(clienteNombre),
      moneda: Value(moneda),
      total: Value(total),
      status: Value(status),
      sunatCode: sunatCode == null && nullToAbsent
          ? const Value.absent()
          : Value(sunatCode),
      sunatDescription: sunatDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(sunatDescription),
      sunatNotes: sunatNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(sunatNotes),
      ticket: ticket == null && nullToAbsent
          ? const Value.absent()
          : Value(ticket),
      digestValue: Value(digestValue),
      attempts: Value(attempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      inputJson: Value(inputJson),
      enrichedJson: Value(enrichedJson),
      affectedDocumentId: affectedDocumentId == null && nullToAbsent
          ? const Value.absent()
          : Value(affectedDocumentId),
      voidedByDocumentId: voidedByDocumentId == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedByDocumentId),
      deviceId: Value(deviceId),
    );
  }

  factory Document.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      companyId: serializer.fromJson<String>(json['companyId']),
      environment: $DocumentsTable.$converterenvironment.fromJson(
        serializer.fromJson<String>(json['environment']),
      ),
      tipoComprobante: serializer.fromJson<String>(json['tipoComprobante']),
      serie: serializer.fromJson<String>(json['serie']),
      numero: serializer.fromJson<int>(json['numero']),
      fechaEmision: serializer.fromJson<String>(json['fechaEmision']),
      clienteTipoDocumento: serializer.fromJson<String>(
        json['clienteTipoDocumento'],
      ),
      clienteNumeroDocumento: serializer.fromJson<String>(
        json['clienteNumeroDocumento'],
      ),
      clienteNombre: serializer.fromJson<String>(json['clienteNombre']),
      moneda: serializer.fromJson<String>(json['moneda']),
      total: serializer.fromJson<String>(json['total']),
      status: $DocumentsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      sunatCode: serializer.fromJson<String?>(json['sunatCode']),
      sunatDescription: serializer.fromJson<String?>(json['sunatDescription']),
      sunatNotes: serializer.fromJson<String?>(json['sunatNotes']),
      ticket: serializer.fromJson<String?>(json['ticket']),
      digestValue: serializer.fromJson<String>(json['digestValue']),
      attempts: serializer.fromJson<int>(json['attempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      inputJson: serializer.fromJson<String>(json['inputJson']),
      enrichedJson: serializer.fromJson<String>(json['enrichedJson']),
      affectedDocumentId: serializer.fromJson<String?>(
        json['affectedDocumentId'],
      ),
      voidedByDocumentId: serializer.fromJson<String?>(
        json['voidedByDocumentId'],
      ),
      deviceId: serializer.fromJson<String>(json['deviceId']),
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
      'environment': serializer.toJson<String>(
        $DocumentsTable.$converterenvironment.toJson(environment),
      ),
      'tipoComprobante': serializer.toJson<String>(tipoComprobante),
      'serie': serializer.toJson<String>(serie),
      'numero': serializer.toJson<int>(numero),
      'fechaEmision': serializer.toJson<String>(fechaEmision),
      'clienteTipoDocumento': serializer.toJson<String>(clienteTipoDocumento),
      'clienteNumeroDocumento': serializer.toJson<String>(
        clienteNumeroDocumento,
      ),
      'clienteNombre': serializer.toJson<String>(clienteNombre),
      'moneda': serializer.toJson<String>(moneda),
      'total': serializer.toJson<String>(total),
      'status': serializer.toJson<String>(
        $DocumentsTable.$converterstatus.toJson(status),
      ),
      'sunatCode': serializer.toJson<String?>(sunatCode),
      'sunatDescription': serializer.toJson<String?>(sunatDescription),
      'sunatNotes': serializer.toJson<String?>(sunatNotes),
      'ticket': serializer.toJson<String?>(ticket),
      'digestValue': serializer.toJson<String>(digestValue),
      'attempts': serializer.toJson<int>(attempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'inputJson': serializer.toJson<String>(inputJson),
      'enrichedJson': serializer.toJson<String>(enrichedJson),
      'affectedDocumentId': serializer.toJson<String?>(affectedDocumentId),
      'voidedByDocumentId': serializer.toJson<String?>(voidedByDocumentId),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Document copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? companyId,
    SunatEnvironment? environment,
    String? tipoComprobante,
    String? serie,
    int? numero,
    String? fechaEmision,
    String? clienteTipoDocumento,
    String? clienteNumeroDocumento,
    String? clienteNombre,
    String? moneda,
    String? total,
    DocumentStatus? status,
    Value<String?> sunatCode = const Value.absent(),
    Value<String?> sunatDescription = const Value.absent(),
    Value<String?> sunatNotes = const Value.absent(),
    Value<String?> ticket = const Value.absent(),
    String? digestValue,
    int? attempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    String? inputJson,
    String? enrichedJson,
    Value<String?> affectedDocumentId = const Value.absent(),
    Value<String?> voidedByDocumentId = const Value.absent(),
    String? deviceId,
  }) => Document(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    companyId: companyId ?? this.companyId,
    environment: environment ?? this.environment,
    tipoComprobante: tipoComprobante ?? this.tipoComprobante,
    serie: serie ?? this.serie,
    numero: numero ?? this.numero,
    fechaEmision: fechaEmision ?? this.fechaEmision,
    clienteTipoDocumento: clienteTipoDocumento ?? this.clienteTipoDocumento,
    clienteNumeroDocumento:
        clienteNumeroDocumento ?? this.clienteNumeroDocumento,
    clienteNombre: clienteNombre ?? this.clienteNombre,
    moneda: moneda ?? this.moneda,
    total: total ?? this.total,
    status: status ?? this.status,
    sunatCode: sunatCode.present ? sunatCode.value : this.sunatCode,
    sunatDescription: sunatDescription.present
        ? sunatDescription.value
        : this.sunatDescription,
    sunatNotes: sunatNotes.present ? sunatNotes.value : this.sunatNotes,
    ticket: ticket.present ? ticket.value : this.ticket,
    digestValue: digestValue ?? this.digestValue,
    attempts: attempts ?? this.attempts,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    inputJson: inputJson ?? this.inputJson,
    enrichedJson: enrichedJson ?? this.enrichedJson,
    affectedDocumentId: affectedDocumentId.present
        ? affectedDocumentId.value
        : this.affectedDocumentId,
    voidedByDocumentId: voidedByDocumentId.present
        ? voidedByDocumentId.value
        : this.voidedByDocumentId,
    deviceId: deviceId ?? this.deviceId,
  );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      environment: data.environment.present
          ? data.environment.value
          : this.environment,
      tipoComprobante: data.tipoComprobante.present
          ? data.tipoComprobante.value
          : this.tipoComprobante,
      serie: data.serie.present ? data.serie.value : this.serie,
      numero: data.numero.present ? data.numero.value : this.numero,
      fechaEmision: data.fechaEmision.present
          ? data.fechaEmision.value
          : this.fechaEmision,
      clienteTipoDocumento: data.clienteTipoDocumento.present
          ? data.clienteTipoDocumento.value
          : this.clienteTipoDocumento,
      clienteNumeroDocumento: data.clienteNumeroDocumento.present
          ? data.clienteNumeroDocumento.value
          : this.clienteNumeroDocumento,
      clienteNombre: data.clienteNombre.present
          ? data.clienteNombre.value
          : this.clienteNombre,
      moneda: data.moneda.present ? data.moneda.value : this.moneda,
      total: data.total.present ? data.total.value : this.total,
      status: data.status.present ? data.status.value : this.status,
      sunatCode: data.sunatCode.present ? data.sunatCode.value : this.sunatCode,
      sunatDescription: data.sunatDescription.present
          ? data.sunatDescription.value
          : this.sunatDescription,
      sunatNotes: data.sunatNotes.present
          ? data.sunatNotes.value
          : this.sunatNotes,
      ticket: data.ticket.present ? data.ticket.value : this.ticket,
      digestValue: data.digestValue.present
          ? data.digestValue.value
          : this.digestValue,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      inputJson: data.inputJson.present ? data.inputJson.value : this.inputJson,
      enrichedJson: data.enrichedJson.present
          ? data.enrichedJson.value
          : this.enrichedJson,
      affectedDocumentId: data.affectedDocumentId.present
          ? data.affectedDocumentId.value
          : this.affectedDocumentId,
      voidedByDocumentId: data.voidedByDocumentId.present
          ? data.voidedByDocumentId.value
          : this.voidedByDocumentId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('environment: $environment, ')
          ..write('tipoComprobante: $tipoComprobante, ')
          ..write('serie: $serie, ')
          ..write('numero: $numero, ')
          ..write('fechaEmision: $fechaEmision, ')
          ..write('clienteTipoDocumento: $clienteTipoDocumento, ')
          ..write('clienteNumeroDocumento: $clienteNumeroDocumento, ')
          ..write('clienteNombre: $clienteNombre, ')
          ..write('moneda: $moneda, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('sunatCode: $sunatCode, ')
          ..write('sunatDescription: $sunatDescription, ')
          ..write('sunatNotes: $sunatNotes, ')
          ..write('ticket: $ticket, ')
          ..write('digestValue: $digestValue, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('inputJson: $inputJson, ')
          ..write('enrichedJson: $enrichedJson, ')
          ..write('affectedDocumentId: $affectedDocumentId, ')
          ..write('voidedByDocumentId: $voidedByDocumentId, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    environment,
    tipoComprobante,
    serie,
    numero,
    fechaEmision,
    clienteTipoDocumento,
    clienteNumeroDocumento,
    clienteNombre,
    moneda,
    total,
    status,
    sunatCode,
    sunatDescription,
    sunatNotes,
    ticket,
    digestValue,
    attempts,
    nextAttemptAt,
    inputJson,
    enrichedJson,
    affectedDocumentId,
    voidedByDocumentId,
    deviceId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.companyId == this.companyId &&
          other.environment == this.environment &&
          other.tipoComprobante == this.tipoComprobante &&
          other.serie == this.serie &&
          other.numero == this.numero &&
          other.fechaEmision == this.fechaEmision &&
          other.clienteTipoDocumento == this.clienteTipoDocumento &&
          other.clienteNumeroDocumento == this.clienteNumeroDocumento &&
          other.clienteNombre == this.clienteNombre &&
          other.moneda == this.moneda &&
          other.total == this.total &&
          other.status == this.status &&
          other.sunatCode == this.sunatCode &&
          other.sunatDescription == this.sunatDescription &&
          other.sunatNotes == this.sunatNotes &&
          other.ticket == this.ticket &&
          other.digestValue == this.digestValue &&
          other.attempts == this.attempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.inputJson == this.inputJson &&
          other.enrichedJson == this.enrichedJson &&
          other.affectedDocumentId == this.affectedDocumentId &&
          other.voidedByDocumentId == this.voidedByDocumentId &&
          other.deviceId == this.deviceId);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> companyId;
  final Value<SunatEnvironment> environment;
  final Value<String> tipoComprobante;
  final Value<String> serie;
  final Value<int> numero;
  final Value<String> fechaEmision;
  final Value<String> clienteTipoDocumento;
  final Value<String> clienteNumeroDocumento;
  final Value<String> clienteNombre;
  final Value<String> moneda;
  final Value<String> total;
  final Value<DocumentStatus> status;
  final Value<String?> sunatCode;
  final Value<String?> sunatDescription;
  final Value<String?> sunatNotes;
  final Value<String?> ticket;
  final Value<String> digestValue;
  final Value<int> attempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String> inputJson;
  final Value<String> enrichedJson;
  final Value<String?> affectedDocumentId;
  final Value<String?> voidedByDocumentId;
  final Value<String> deviceId;
  final Value<int> rowid;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.companyId = const Value.absent(),
    this.environment = const Value.absent(),
    this.tipoComprobante = const Value.absent(),
    this.serie = const Value.absent(),
    this.numero = const Value.absent(),
    this.fechaEmision = const Value.absent(),
    this.clienteTipoDocumento = const Value.absent(),
    this.clienteNumeroDocumento = const Value.absent(),
    this.clienteNombre = const Value.absent(),
    this.moneda = const Value.absent(),
    this.total = const Value.absent(),
    this.status = const Value.absent(),
    this.sunatCode = const Value.absent(),
    this.sunatDescription = const Value.absent(),
    this.sunatNotes = const Value.absent(),
    this.ticket = const Value.absent(),
    this.digestValue = const Value.absent(),
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.inputJson = const Value.absent(),
    this.enrichedJson = const Value.absent(),
    this.affectedDocumentId = const Value.absent(),
    this.voidedByDocumentId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String companyId,
    required SunatEnvironment environment,
    required String tipoComprobante,
    required String serie,
    required int numero,
    required String fechaEmision,
    required String clienteTipoDocumento,
    required String clienteNumeroDocumento,
    required String clienteNombre,
    required String moneda,
    required String total,
    required DocumentStatus status,
    this.sunatCode = const Value.absent(),
    this.sunatDescription = const Value.absent(),
    this.sunatNotes = const Value.absent(),
    this.ticket = const Value.absent(),
    required String digestValue,
    this.attempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    required String inputJson,
    required String enrichedJson,
    this.affectedDocumentId = const Value.absent(),
    this.voidedByDocumentId = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId),
       environment = Value(environment),
       tipoComprobante = Value(tipoComprobante),
       serie = Value(serie),
       numero = Value(numero),
       fechaEmision = Value(fechaEmision),
       clienteTipoDocumento = Value(clienteTipoDocumento),
       clienteNumeroDocumento = Value(clienteNumeroDocumento),
       clienteNombre = Value(clienteNombre),
       moneda = Value(moneda),
       total = Value(total),
       status = Value(status),
       digestValue = Value(digestValue),
       inputJson = Value(inputJson),
       enrichedJson = Value(enrichedJson),
       deviceId = Value(deviceId);
  static Insertable<Document> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? companyId,
    Expression<String>? environment,
    Expression<String>? tipoComprobante,
    Expression<String>? serie,
    Expression<int>? numero,
    Expression<String>? fechaEmision,
    Expression<String>? clienteTipoDocumento,
    Expression<String>? clienteNumeroDocumento,
    Expression<String>? clienteNombre,
    Expression<String>? moneda,
    Expression<String>? total,
    Expression<String>? status,
    Expression<String>? sunatCode,
    Expression<String>? sunatDescription,
    Expression<String>? sunatNotes,
    Expression<String>? ticket,
    Expression<String>? digestValue,
    Expression<int>? attempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? inputJson,
    Expression<String>? enrichedJson,
    Expression<String>? affectedDocumentId,
    Expression<String>? voidedByDocumentId,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (companyId != null) 'company_id': companyId,
      if (environment != null) 'environment': environment,
      if (tipoComprobante != null) 'tipo_comprobante': tipoComprobante,
      if (serie != null) 'serie': serie,
      if (numero != null) 'numero': numero,
      if (fechaEmision != null) 'fecha_emision': fechaEmision,
      if (clienteTipoDocumento != null)
        'cliente_tipo_documento': clienteTipoDocumento,
      if (clienteNumeroDocumento != null)
        'cliente_numero_documento': clienteNumeroDocumento,
      if (clienteNombre != null) 'cliente_nombre': clienteNombre,
      if (moneda != null) 'moneda': moneda,
      if (total != null) 'total': total,
      if (status != null) 'status': status,
      if (sunatCode != null) 'sunat_code': sunatCode,
      if (sunatDescription != null) 'sunat_description': sunatDescription,
      if (sunatNotes != null) 'sunat_notes': sunatNotes,
      if (ticket != null) 'ticket': ticket,
      if (digestValue != null) 'digest_value': digestValue,
      if (attempts != null) 'attempts': attempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (inputJson != null) 'input_json': inputJson,
      if (enrichedJson != null) 'enriched_json': enrichedJson,
      if (affectedDocumentId != null)
        'affected_document_id': affectedDocumentId,
      if (voidedByDocumentId != null)
        'voided_by_document_id': voidedByDocumentId,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? companyId,
    Value<SunatEnvironment>? environment,
    Value<String>? tipoComprobante,
    Value<String>? serie,
    Value<int>? numero,
    Value<String>? fechaEmision,
    Value<String>? clienteTipoDocumento,
    Value<String>? clienteNumeroDocumento,
    Value<String>? clienteNombre,
    Value<String>? moneda,
    Value<String>? total,
    Value<DocumentStatus>? status,
    Value<String?>? sunatCode,
    Value<String?>? sunatDescription,
    Value<String?>? sunatNotes,
    Value<String?>? ticket,
    Value<String>? digestValue,
    Value<int>? attempts,
    Value<DateTime?>? nextAttemptAt,
    Value<String>? inputJson,
    Value<String>? enrichedJson,
    Value<String?>? affectedDocumentId,
    Value<String?>? voidedByDocumentId,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return DocumentsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      companyId: companyId ?? this.companyId,
      environment: environment ?? this.environment,
      tipoComprobante: tipoComprobante ?? this.tipoComprobante,
      serie: serie ?? this.serie,
      numero: numero ?? this.numero,
      fechaEmision: fechaEmision ?? this.fechaEmision,
      clienteTipoDocumento: clienteTipoDocumento ?? this.clienteTipoDocumento,
      clienteNumeroDocumento:
          clienteNumeroDocumento ?? this.clienteNumeroDocumento,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      moneda: moneda ?? this.moneda,
      total: total ?? this.total,
      status: status ?? this.status,
      sunatCode: sunatCode ?? this.sunatCode,
      sunatDescription: sunatDescription ?? this.sunatDescription,
      sunatNotes: sunatNotes ?? this.sunatNotes,
      ticket: ticket ?? this.ticket,
      digestValue: digestValue ?? this.digestValue,
      attempts: attempts ?? this.attempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      inputJson: inputJson ?? this.inputJson,
      enrichedJson: enrichedJson ?? this.enrichedJson,
      affectedDocumentId: affectedDocumentId ?? this.affectedDocumentId,
      voidedByDocumentId: voidedByDocumentId ?? this.voidedByDocumentId,
      deviceId: deviceId ?? this.deviceId,
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
    if (environment.present) {
      map['environment'] = Variable<String>(
        $DocumentsTable.$converterenvironment.toSql(environment.value),
      );
    }
    if (tipoComprobante.present) {
      map['tipo_comprobante'] = Variable<String>(tipoComprobante.value);
    }
    if (serie.present) {
      map['serie'] = Variable<String>(serie.value);
    }
    if (numero.present) {
      map['numero'] = Variable<int>(numero.value);
    }
    if (fechaEmision.present) {
      map['fecha_emision'] = Variable<String>(fechaEmision.value);
    }
    if (clienteTipoDocumento.present) {
      map['cliente_tipo_documento'] = Variable<String>(
        clienteTipoDocumento.value,
      );
    }
    if (clienteNumeroDocumento.present) {
      map['cliente_numero_documento'] = Variable<String>(
        clienteNumeroDocumento.value,
      );
    }
    if (clienteNombre.present) {
      map['cliente_nombre'] = Variable<String>(clienteNombre.value);
    }
    if (moneda.present) {
      map['moneda'] = Variable<String>(moneda.value);
    }
    if (total.present) {
      map['total'] = Variable<String>(total.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DocumentsTable.$converterstatus.toSql(status.value),
      );
    }
    if (sunatCode.present) {
      map['sunat_code'] = Variable<String>(sunatCode.value);
    }
    if (sunatDescription.present) {
      map['sunat_description'] = Variable<String>(sunatDescription.value);
    }
    if (sunatNotes.present) {
      map['sunat_notes'] = Variable<String>(sunatNotes.value);
    }
    if (ticket.present) {
      map['ticket'] = Variable<String>(ticket.value);
    }
    if (digestValue.present) {
      map['digest_value'] = Variable<String>(digestValue.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (inputJson.present) {
      map['input_json'] = Variable<String>(inputJson.value);
    }
    if (enrichedJson.present) {
      map['enriched_json'] = Variable<String>(enrichedJson.value);
    }
    if (affectedDocumentId.present) {
      map['affected_document_id'] = Variable<String>(affectedDocumentId.value);
    }
    if (voidedByDocumentId.present) {
      map['voided_by_document_id'] = Variable<String>(voidedByDocumentId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('environment: $environment, ')
          ..write('tipoComprobante: $tipoComprobante, ')
          ..write('serie: $serie, ')
          ..write('numero: $numero, ')
          ..write('fechaEmision: $fechaEmision, ')
          ..write('clienteTipoDocumento: $clienteTipoDocumento, ')
          ..write('clienteNumeroDocumento: $clienteNumeroDocumento, ')
          ..write('clienteNombre: $clienteNombre, ')
          ..write('moneda: $moneda, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('sunatCode: $sunatCode, ')
          ..write('sunatDescription: $sunatDescription, ')
          ..write('sunatNotes: $sunatNotes, ')
          ..write('ticket: $ticket, ')
          ..write('digestValue: $digestValue, ')
          ..write('attempts: $attempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('inputJson: $inputJson, ')
          ..write('enrichedJson: $enrichedJson, ')
          ..write('affectedDocumentId: $affectedDocumentId, ')
          ..write('voidedByDocumentId: $voidedByDocumentId, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentFilesTable extends DocumentFiles
    with TableInfo<$DocumentFilesTable, DocumentFile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentFilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DocumentFileKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DocumentFileKind>($DocumentFilesTable.$converterkind);
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<Uint8List> bytes = GeneratedColumn<Uint8List>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sha256Meta = const VerificationMeta('sha256');
  @override
  late final GeneratedColumn<String> sha256 = GeneratedColumn<String>(
    'sha256',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    documentId,
    kind,
    bytes,
    sha256,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_files';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentFile> instance, {
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
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    if (data.containsKey('sha256')) {
      context.handle(
        _sha256Meta,
        sha256.isAcceptableOrUnknown(data['sha256']!, _sha256Meta),
      );
    } else if (isInserting) {
      context.missing(_sha256Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {documentId, kind},
  ];
  @override
  DocumentFile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentFile(
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
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      kind: $DocumentFilesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bytes'],
      )!,
      sha256: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sha256'],
      )!,
    );
  }

  @override
  $DocumentFilesTable createAlias(String alias) {
    return $DocumentFilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DocumentFileKind, String, String> $converterkind =
      const EnumNameConverter<DocumentFileKind>(DocumentFileKind.values);
}

class DocumentFile extends DataClass implements Insertable<DocumentFile> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String documentId;
  final DocumentFileKind kind;
  final Uint8List bytes;

  /// Hex SHA-256 of [bytes], to upload a file once (DESIGN §3.1)
  final String sha256;
  const DocumentFile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.documentId,
    required this.kind,
    required this.bytes,
    required this.sha256,
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
    map['document_id'] = Variable<String>(documentId);
    {
      map['kind'] = Variable<String>(
        $DocumentFilesTable.$converterkind.toSql(kind),
      );
    }
    map['bytes'] = Variable<Uint8List>(bytes);
    map['sha256'] = Variable<String>(sha256);
    return map;
  }

  DocumentFilesCompanion toCompanion(bool nullToAbsent) {
    return DocumentFilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      documentId: Value(documentId),
      kind: Value(kind),
      bytes: Value(bytes),
      sha256: Value(sha256),
    );
  }

  factory DocumentFile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentFile(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      documentId: serializer.fromJson<String>(json['documentId']),
      kind: $DocumentFilesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      bytes: serializer.fromJson<Uint8List>(json['bytes']),
      sha256: serializer.fromJson<String>(json['sha256']),
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
      'documentId': serializer.toJson<String>(documentId),
      'kind': serializer.toJson<String>(
        $DocumentFilesTable.$converterkind.toJson(kind),
      ),
      'bytes': serializer.toJson<Uint8List>(bytes),
      'sha256': serializer.toJson<String>(sha256),
    };
  }

  DocumentFile copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? documentId,
    DocumentFileKind? kind,
    Uint8List? bytes,
    String? sha256,
  }) => DocumentFile(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    documentId: documentId ?? this.documentId,
    kind: kind ?? this.kind,
    bytes: bytes ?? this.bytes,
    sha256: sha256 ?? this.sha256,
  );
  DocumentFile copyWithCompanion(DocumentFilesCompanion data) {
    return DocumentFile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      kind: data.kind.present ? data.kind.value : this.kind,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
      sha256: data.sha256.present ? data.sha256.value : this.sha256,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentFile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('documentId: $documentId, ')
          ..write('kind: $kind, ')
          ..write('bytes: $bytes, ')
          ..write('sha256: $sha256')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    documentId,
    kind,
    $driftBlobEquality.hash(bytes),
    sha256,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentFile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.documentId == this.documentId &&
          other.kind == this.kind &&
          $driftBlobEquality.equals(other.bytes, this.bytes) &&
          other.sha256 == this.sha256);
}

class DocumentFilesCompanion extends UpdateCompanion<DocumentFile> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> documentId;
  final Value<DocumentFileKind> kind;
  final Value<Uint8List> bytes;
  final Value<String> sha256;
  final Value<int> rowid;
  const DocumentFilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.documentId = const Value.absent(),
    this.kind = const Value.absent(),
    this.bytes = const Value.absent(),
    this.sha256 = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentFilesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String documentId,
    required DocumentFileKind kind,
    required Uint8List bytes,
    required String sha256,
    this.rowid = const Value.absent(),
  }) : documentId = Value(documentId),
       kind = Value(kind),
       bytes = Value(bytes),
       sha256 = Value(sha256);
  static Insertable<DocumentFile> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? documentId,
    Expression<String>? kind,
    Expression<Uint8List>? bytes,
    Expression<String>? sha256,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (documentId != null) 'document_id': documentId,
      if (kind != null) 'kind': kind,
      if (bytes != null) 'bytes': bytes,
      if (sha256 != null) 'sha256': sha256,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentFilesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? documentId,
    Value<DocumentFileKind>? kind,
    Value<Uint8List>? bytes,
    Value<String>? sha256,
    Value<int>? rowid,
  }) {
    return DocumentFilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      documentId: documentId ?? this.documentId,
      kind: kind ?? this.kind,
      bytes: bytes ?? this.bytes,
      sha256: sha256 ?? this.sha256,
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
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $DocumentFilesTable.$converterkind.toSql(kind.value),
      );
    }
    if (bytes.present) {
      map['bytes'] = Variable<Uint8List>(bytes.value);
    }
    if (sha256.present) {
      map['sha256'] = Variable<String>(sha256.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentFilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('documentId: $documentId, ')
          ..write('kind: $kind, ')
          ..write('bytes: $bytes, ')
          ..write('sha256: $sha256, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentEventsTable extends DocumentEvents
    with TableInfo<$DocumentEventsTable, DocumentEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DocumentStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DocumentStatus>($DocumentEventsTable.$converterstatus);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    documentId,
    status,
    code,
    message,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentEvent> instance, {
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
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentEvent(
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
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      status: $DocumentEventsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $DocumentEventsTable createAlias(String alias) {
    return $DocumentEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DocumentStatus, String, String> $converterstatus =
      const EnumNameConverter<DocumentStatus>(DocumentStatus.values);
}

class DocumentEvent extends DataClass implements Insertable<DocumentEvent> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String documentId;
  final DocumentStatus status;
  final String? code;
  final String? message;
  final String deviceId;
  const DocumentEvent({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.documentId,
    required this.status,
    this.code,
    this.message,
    required this.deviceId,
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
    map['document_id'] = Variable<String>(documentId);
    {
      map['status'] = Variable<String>(
        $DocumentEventsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  DocumentEventsCompanion toCompanion(bool nullToAbsent) {
    return DocumentEventsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      documentId: Value(documentId),
      status: Value(status),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      deviceId: Value(deviceId),
    );
  }

  factory DocumentEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentEvent(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      documentId: serializer.fromJson<String>(json['documentId']),
      status: $DocumentEventsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      code: serializer.fromJson<String?>(json['code']),
      message: serializer.fromJson<String?>(json['message']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
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
      'documentId': serializer.toJson<String>(documentId),
      'status': serializer.toJson<String>(
        $DocumentEventsTable.$converterstatus.toJson(status),
      ),
      'code': serializer.toJson<String?>(code),
      'message': serializer.toJson<String?>(message),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  DocumentEvent copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? documentId,
    DocumentStatus? status,
    Value<String?> code = const Value.absent(),
    Value<String?> message = const Value.absent(),
    String? deviceId,
  }) => DocumentEvent(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    documentId: documentId ?? this.documentId,
    status: status ?? this.status,
    code: code.present ? code.value : this.code,
    message: message.present ? message.value : this.message,
    deviceId: deviceId ?? this.deviceId,
  );
  DocumentEvent copyWithCompanion(DocumentEventsCompanion data) {
    return DocumentEvent(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      status: data.status.present ? data.status.value : this.status,
      code: data.code.present ? data.code.value : this.code,
      message: data.message.present ? data.message.value : this.message,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentEvent(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('documentId: $documentId, ')
          ..write('status: $status, ')
          ..write('code: $code, ')
          ..write('message: $message, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    documentId,
    status,
    code,
    message,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentEvent &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.documentId == this.documentId &&
          other.status == this.status &&
          other.code == this.code &&
          other.message == this.message &&
          other.deviceId == this.deviceId);
}

class DocumentEventsCompanion extends UpdateCompanion<DocumentEvent> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> documentId;
  final Value<DocumentStatus> status;
  final Value<String?> code;
  final Value<String?> message;
  final Value<String> deviceId;
  final Value<int> rowid;
  const DocumentEventsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.documentId = const Value.absent(),
    this.status = const Value.absent(),
    this.code = const Value.absent(),
    this.message = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentEventsCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String documentId,
    required DocumentStatus status,
    this.code = const Value.absent(),
    this.message = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : documentId = Value(documentId),
       status = Value(status),
       deviceId = Value(deviceId);
  static Insertable<DocumentEvent> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? documentId,
    Expression<String>? status,
    Expression<String>? code,
    Expression<String>? message,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (documentId != null) 'document_id': documentId,
      if (status != null) 'status': status,
      if (code != null) 'code': code,
      if (message != null) 'message': message,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentEventsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? documentId,
    Value<DocumentStatus>? status,
    Value<String?>? code,
    Value<String?>? message,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return DocumentEventsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      documentId: documentId ?? this.documentId,
      status: status ?? this.status,
      code: code ?? this.code,
      message: message ?? this.message,
      deviceId: deviceId ?? this.deviceId,
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
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DocumentEventsTable.$converterstatus.toSql(status.value),
      );
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentEventsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('documentId: $documentId, ')
          ..write('status: $status, ')
          ..write('code: $code, ')
          ..write('message: $message, ')
          ..write('deviceId: $deviceId, ')
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

class $VehiclesTable extends Vehicles with TableInfo<$VehiclesTable, Vehicle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VehiclesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _placaMeta = const VerificationMeta('placa');
  @override
  late final GeneratedColumn<String> placa = GeneratedColumn<String>(
    'placa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numeroCirculacionMeta = const VerificationMeta(
    'numeroCirculacion',
  );
  @override
  late final GeneratedColumn<String> numeroCirculacion =
      GeneratedColumn<String>(
        'numero_circulacion',
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
    placa,
    numeroCirculacion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vehicles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Vehicle> instance, {
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
    if (data.containsKey('placa')) {
      context.handle(
        _placaMeta,
        placa.isAcceptableOrUnknown(data['placa']!, _placaMeta),
      );
    } else if (isInserting) {
      context.missing(_placaMeta);
    }
    if (data.containsKey('numero_circulacion')) {
      context.handle(
        _numeroCirculacionMeta,
        numeroCirculacion.isAcceptableOrUnknown(
          data['numero_circulacion']!,
          _numeroCirculacionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vehicle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vehicle(
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
      placa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placa'],
      )!,
      numeroCirculacion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}numero_circulacion'],
      ),
    );
  }

  @override
  $VehiclesTable createAlias(String alias) {
    return $VehiclesTable(attachedDatabase, alias);
  }
}

class Vehicle extends DataClass implements Insertable<Vehicle> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String companyId;

  /// Uppercase, without dashes or spaces, e.g. "ABC123"
  final String placa;

  /// Tarjeta única de circulación or certificado de habilitación
  final String? numeroCirculacion;
  const Vehicle({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    required this.placa,
    this.numeroCirculacion,
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
    map['placa'] = Variable<String>(placa);
    if (!nullToAbsent || numeroCirculacion != null) {
      map['numero_circulacion'] = Variable<String>(numeroCirculacion);
    }
    return map;
  }

  VehiclesCompanion toCompanion(bool nullToAbsent) {
    return VehiclesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      companyId: Value(companyId),
      placa: Value(placa),
      numeroCirculacion: numeroCirculacion == null && nullToAbsent
          ? const Value.absent()
          : Value(numeroCirculacion),
    );
  }

  factory Vehicle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vehicle(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      companyId: serializer.fromJson<String>(json['companyId']),
      placa: serializer.fromJson<String>(json['placa']),
      numeroCirculacion: serializer.fromJson<String?>(
        json['numeroCirculacion'],
      ),
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
      'placa': serializer.toJson<String>(placa),
      'numeroCirculacion': serializer.toJson<String?>(numeroCirculacion),
    };
  }

  Vehicle copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? companyId,
    String? placa,
    Value<String?> numeroCirculacion = const Value.absent(),
  }) => Vehicle(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    companyId: companyId ?? this.companyId,
    placa: placa ?? this.placa,
    numeroCirculacion: numeroCirculacion.present
        ? numeroCirculacion.value
        : this.numeroCirculacion,
  );
  Vehicle copyWithCompanion(VehiclesCompanion data) {
    return Vehicle(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      placa: data.placa.present ? data.placa.value : this.placa,
      numeroCirculacion: data.numeroCirculacion.present
          ? data.numeroCirculacion.value
          : this.numeroCirculacion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vehicle(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('placa: $placa, ')
          ..write('numeroCirculacion: $numeroCirculacion')
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
    placa,
    numeroCirculacion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vehicle &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.companyId == this.companyId &&
          other.placa == this.placa &&
          other.numeroCirculacion == this.numeroCirculacion);
}

class VehiclesCompanion extends UpdateCompanion<Vehicle> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> companyId;
  final Value<String> placa;
  final Value<String?> numeroCirculacion;
  final Value<int> rowid;
  const VehiclesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.companyId = const Value.absent(),
    this.placa = const Value.absent(),
    this.numeroCirculacion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VehiclesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String companyId,
    required String placa,
    this.numeroCirculacion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId),
       placa = Value(placa);
  static Insertable<Vehicle> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? companyId,
    Expression<String>? placa,
    Expression<String>? numeroCirculacion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (companyId != null) 'company_id': companyId,
      if (placa != null) 'placa': placa,
      if (numeroCirculacion != null) 'numero_circulacion': numeroCirculacion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VehiclesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? companyId,
    Value<String>? placa,
    Value<String?>? numeroCirculacion,
    Value<int>? rowid,
  }) {
    return VehiclesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      companyId: companyId ?? this.companyId,
      placa: placa ?? this.placa,
      numeroCirculacion: numeroCirculacion ?? this.numeroCirculacion,
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
    if (placa.present) {
      map['placa'] = Variable<String>(placa.value);
    }
    if (numeroCirculacion.present) {
      map['numero_circulacion'] = Variable<String>(numeroCirculacion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VehiclesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('placa: $placa, ')
          ..write('numeroCirculacion: $numeroCirculacion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DriversTable extends Drivers with TableInfo<$DriversTable, Driver> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DriversTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nombresMeta = const VerificationMeta(
    'nombres',
  );
  @override
  late final GeneratedColumn<String> nombres = GeneratedColumn<String>(
    'nombres',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _apellidosMeta = const VerificationMeta(
    'apellidos',
  );
  @override
  late final GeneratedColumn<String> apellidos = GeneratedColumn<String>(
    'apellidos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenciaMeta = const VerificationMeta(
    'licencia',
  );
  @override
  late final GeneratedColumn<String> licencia = GeneratedColumn<String>(
    'licencia',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    nombres,
    apellidos,
    licencia,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drivers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Driver> instance, {
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
    if (data.containsKey('nombres')) {
      context.handle(
        _nombresMeta,
        nombres.isAcceptableOrUnknown(data['nombres']!, _nombresMeta),
      );
    } else if (isInserting) {
      context.missing(_nombresMeta);
    }
    if (data.containsKey('apellidos')) {
      context.handle(
        _apellidosMeta,
        apellidos.isAcceptableOrUnknown(data['apellidos']!, _apellidosMeta),
      );
    } else if (isInserting) {
      context.missing(_apellidosMeta);
    }
    if (data.containsKey('licencia')) {
      context.handle(
        _licenciaMeta,
        licencia.isAcceptableOrUnknown(data['licencia']!, _licenciaMeta),
      );
    } else if (isInserting) {
      context.missing(_licenciaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Driver map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Driver(
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
      nombres: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombres'],
      )!,
      apellidos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}apellidos'],
      )!,
      licencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}licencia'],
      )!,
    );
  }

  @override
  $DriversTable createAlias(String alias) {
    return $DriversTable(attachedDatabase, alias);
  }
}

class Driver extends DataClass implements Insertable<Driver> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String companyId;

  /// Catalog 6, usually "1" DNI
  final String tipoDocumentoIdentidad;
  final String numeroDocumentoIdentidad;
  final String nombres;
  final String apellidos;
  final String licencia;
  const Driver({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    required this.tipoDocumentoIdentidad,
    required this.numeroDocumentoIdentidad,
    required this.nombres,
    required this.apellidos,
    required this.licencia,
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
    map['nombres'] = Variable<String>(nombres);
    map['apellidos'] = Variable<String>(apellidos);
    map['licencia'] = Variable<String>(licencia);
    return map;
  }

  DriversCompanion toCompanion(bool nullToAbsent) {
    return DriversCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      companyId: Value(companyId),
      tipoDocumentoIdentidad: Value(tipoDocumentoIdentidad),
      numeroDocumentoIdentidad: Value(numeroDocumentoIdentidad),
      nombres: Value(nombres),
      apellidos: Value(apellidos),
      licencia: Value(licencia),
    );
  }

  factory Driver.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Driver(
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
      nombres: serializer.fromJson<String>(json['nombres']),
      apellidos: serializer.fromJson<String>(json['apellidos']),
      licencia: serializer.fromJson<String>(json['licencia']),
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
      'nombres': serializer.toJson<String>(nombres),
      'apellidos': serializer.toJson<String>(apellidos),
      'licencia': serializer.toJson<String>(licencia),
    };
  }

  Driver copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? companyId,
    String? tipoDocumentoIdentidad,
    String? numeroDocumentoIdentidad,
    String? nombres,
    String? apellidos,
    String? licencia,
  }) => Driver(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    companyId: companyId ?? this.companyId,
    tipoDocumentoIdentidad:
        tipoDocumentoIdentidad ?? this.tipoDocumentoIdentidad,
    numeroDocumentoIdentidad:
        numeroDocumentoIdentidad ?? this.numeroDocumentoIdentidad,
    nombres: nombres ?? this.nombres,
    apellidos: apellidos ?? this.apellidos,
    licencia: licencia ?? this.licencia,
  );
  Driver copyWithCompanion(DriversCompanion data) {
    return Driver(
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
      nombres: data.nombres.present ? data.nombres.value : this.nombres,
      apellidos: data.apellidos.present ? data.apellidos.value : this.apellidos,
      licencia: data.licencia.present ? data.licencia.value : this.licencia,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Driver(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('tipoDocumentoIdentidad: $tipoDocumentoIdentidad, ')
          ..write('numeroDocumentoIdentidad: $numeroDocumentoIdentidad, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('licencia: $licencia')
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
    nombres,
    apellidos,
    licencia,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Driver &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.companyId == this.companyId &&
          other.tipoDocumentoIdentidad == this.tipoDocumentoIdentidad &&
          other.numeroDocumentoIdentidad == this.numeroDocumentoIdentidad &&
          other.nombres == this.nombres &&
          other.apellidos == this.apellidos &&
          other.licencia == this.licencia);
}

class DriversCompanion extends UpdateCompanion<Driver> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> companyId;
  final Value<String> tipoDocumentoIdentidad;
  final Value<String> numeroDocumentoIdentidad;
  final Value<String> nombres;
  final Value<String> apellidos;
  final Value<String> licencia;
  final Value<int> rowid;
  const DriversCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.companyId = const Value.absent(),
    this.tipoDocumentoIdentidad = const Value.absent(),
    this.numeroDocumentoIdentidad = const Value.absent(),
    this.nombres = const Value.absent(),
    this.apellidos = const Value.absent(),
    this.licencia = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DriversCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String companyId,
    required String tipoDocumentoIdentidad,
    required String numeroDocumentoIdentidad,
    required String nombres,
    required String apellidos,
    required String licencia,
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId),
       tipoDocumentoIdentidad = Value(tipoDocumentoIdentidad),
       numeroDocumentoIdentidad = Value(numeroDocumentoIdentidad),
       nombres = Value(nombres),
       apellidos = Value(apellidos),
       licencia = Value(licencia);
  static Insertable<Driver> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? companyId,
    Expression<String>? tipoDocumentoIdentidad,
    Expression<String>? numeroDocumentoIdentidad,
    Expression<String>? nombres,
    Expression<String>? apellidos,
    Expression<String>? licencia,
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
      if (nombres != null) 'nombres': nombres,
      if (apellidos != null) 'apellidos': apellidos,
      if (licencia != null) 'licencia': licencia,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DriversCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? companyId,
    Value<String>? tipoDocumentoIdentidad,
    Value<String>? numeroDocumentoIdentidad,
    Value<String>? nombres,
    Value<String>? apellidos,
    Value<String>? licencia,
    Value<int>? rowid,
  }) {
    return DriversCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      companyId: companyId ?? this.companyId,
      tipoDocumentoIdentidad:
          tipoDocumentoIdentidad ?? this.tipoDocumentoIdentidad,
      numeroDocumentoIdentidad:
          numeroDocumentoIdentidad ?? this.numeroDocumentoIdentidad,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      licencia: licencia ?? this.licencia,
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
    if (nombres.present) {
      map['nombres'] = Variable<String>(nombres.value);
    }
    if (apellidos.present) {
      map['apellidos'] = Variable<String>(apellidos.value);
    }
    if (licencia.present) {
      map['licencia'] = Variable<String>(licencia.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriversCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('tipoDocumentoIdentidad: $tipoDocumentoIdentidad, ')
          ..write('numeroDocumentoIdentidad: $numeroDocumentoIdentidad, ')
          ..write('nombres: $nombres, ')
          ..write('apellidos: $apellidos, ')
          ..write('licencia: $licencia, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AddressesTable extends Addresses
    with TableInfo<$AddressesTable, Address> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AddressesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    companyId,
    nombre,
    ubigeo,
    direccion,
    codigoLocal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'addresses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Address> instance, {
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
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    }
    if (data.containsKey('ubigeo')) {
      context.handle(
        _ubigeoMeta,
        ubigeo.isAcceptableOrUnknown(data['ubigeo']!, _ubigeoMeta),
      );
    } else if (isInserting) {
      context.missing(_ubigeoMeta);
    }
    if (data.containsKey('direccion')) {
      context.handle(
        _direccionMeta,
        direccion.isAcceptableOrUnknown(data['direccion']!, _direccionMeta),
      );
    } else if (isInserting) {
      context.missing(_direccionMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Address map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Address(
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
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      ),
      ubigeo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ubigeo'],
      )!,
      direccion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direccion'],
      )!,
      codigoLocal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_local'],
      ),
    );
  }

  @override
  $AddressesTable createAlias(String alias) {
    return $AddressesTable(attachedDatabase, alias);
  }
}

class Address extends DataClass implements Insertable<Address> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String companyId;

  /// What the user calls it, e.g. "Almacén Ate"
  final String? nombre;
  final String ubigeo;
  final String direccion;

  /// SUNAT's code of the establishment, for transfers between the
  /// company's own (motivo 04)
  final String? codigoLocal;
  const Address({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.companyId,
    this.nombre,
    required this.ubigeo,
    required this.direccion,
    this.codigoLocal,
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
    if (!nullToAbsent || nombre != null) {
      map['nombre'] = Variable<String>(nombre);
    }
    map['ubigeo'] = Variable<String>(ubigeo);
    map['direccion'] = Variable<String>(direccion);
    if (!nullToAbsent || codigoLocal != null) {
      map['codigo_local'] = Variable<String>(codigoLocal);
    }
    return map;
  }

  AddressesCompanion toCompanion(bool nullToAbsent) {
    return AddressesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      companyId: Value(companyId),
      nombre: nombre == null && nullToAbsent
          ? const Value.absent()
          : Value(nombre),
      ubigeo: Value(ubigeo),
      direccion: Value(direccion),
      codigoLocal: codigoLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoLocal),
    );
  }

  factory Address.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Address(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      companyId: serializer.fromJson<String>(json['companyId']),
      nombre: serializer.fromJson<String?>(json['nombre']),
      ubigeo: serializer.fromJson<String>(json['ubigeo']),
      direccion: serializer.fromJson<String>(json['direccion']),
      codigoLocal: serializer.fromJson<String?>(json['codigoLocal']),
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
      'nombre': serializer.toJson<String?>(nombre),
      'ubigeo': serializer.toJson<String>(ubigeo),
      'direccion': serializer.toJson<String>(direccion),
      'codigoLocal': serializer.toJson<String?>(codigoLocal),
    };
  }

  Address copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? companyId,
    Value<String?> nombre = const Value.absent(),
    String? ubigeo,
    String? direccion,
    Value<String?> codigoLocal = const Value.absent(),
  }) => Address(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    companyId: companyId ?? this.companyId,
    nombre: nombre.present ? nombre.value : this.nombre,
    ubigeo: ubigeo ?? this.ubigeo,
    direccion: direccion ?? this.direccion,
    codigoLocal: codigoLocal.present ? codigoLocal.value : this.codigoLocal,
  );
  Address copyWithCompanion(AddressesCompanion data) {
    return Address(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      companyId: data.companyId.present ? data.companyId.value : this.companyId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      ubigeo: data.ubigeo.present ? data.ubigeo.value : this.ubigeo,
      direccion: data.direccion.present ? data.direccion.value : this.direccion,
      codigoLocal: data.codigoLocal.present
          ? data.codigoLocal.value
          : this.codigoLocal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Address(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('nombre: $nombre, ')
          ..write('ubigeo: $ubigeo, ')
          ..write('direccion: $direccion, ')
          ..write('codigoLocal: $codigoLocal')
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
    nombre,
    ubigeo,
    direccion,
    codigoLocal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Address &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.companyId == this.companyId &&
          other.nombre == this.nombre &&
          other.ubigeo == this.ubigeo &&
          other.direccion == this.direccion &&
          other.codigoLocal == this.codigoLocal);
}

class AddressesCompanion extends UpdateCompanion<Address> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> companyId;
  final Value<String?> nombre;
  final Value<String> ubigeo;
  final Value<String> direccion;
  final Value<String?> codigoLocal;
  final Value<int> rowid;
  const AddressesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.companyId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.ubigeo = const Value.absent(),
    this.direccion = const Value.absent(),
    this.codigoLocal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AddressesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String companyId,
    this.nombre = const Value.absent(),
    required String ubigeo,
    required String direccion,
    this.codigoLocal = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : companyId = Value(companyId),
       ubigeo = Value(ubigeo),
       direccion = Value(direccion);
  static Insertable<Address> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? companyId,
    Expression<String>? nombre,
    Expression<String>? ubigeo,
    Expression<String>? direccion,
    Expression<String>? codigoLocal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (companyId != null) 'company_id': companyId,
      if (nombre != null) 'nombre': nombre,
      if (ubigeo != null) 'ubigeo': ubigeo,
      if (direccion != null) 'direccion': direccion,
      if (codigoLocal != null) 'codigo_local': codigoLocal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AddressesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? companyId,
    Value<String?>? nombre,
    Value<String>? ubigeo,
    Value<String>? direccion,
    Value<String?>? codigoLocal,
    Value<int>? rowid,
  }) {
    return AddressesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      companyId: companyId ?? this.companyId,
      nombre: nombre ?? this.nombre,
      ubigeo: ubigeo ?? this.ubigeo,
      direccion: direccion ?? this.direccion,
      codigoLocal: codigoLocal ?? this.codigoLocal,
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
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (ubigeo.present) {
      map['ubigeo'] = Variable<String>(ubigeo.value);
    }
    if (direccion.present) {
      map['direccion'] = Variable<String>(direccion.value);
    }
    if (codigoLocal.present) {
      map['codigo_local'] = Variable<String>(codigoLocal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AddressesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('companyId: $companyId, ')
          ..write('nombre: $nombre, ')
          ..write('ubigeo: $ubigeo, ')
          ..write('direccion: $direccion, ')
          ..write('codigoLocal: $codigoLocal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeliveriesTable extends Deliveries
    with TableInfo<$DeliveriesTable, Delivery> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeliveriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES documents (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DeliveryChannel, String> channel =
      GeneratedColumn<String>(
        'channel',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DeliveryChannel>($DeliveriesTable.$converterchannel);
  static const VerificationMeta _recipientMeta = const VerificationMeta(
    'recipient',
  );
  @override
  late final GeneratedColumn<String> recipient = GeneratedColumn<String>(
    'recipient',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    documentId,
    channel,
    recipient,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deliveries';
  @override
  VerificationContext validateIntegrity(
    Insertable<Delivery> instance, {
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
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('recipient')) {
      context.handle(
        _recipientMeta,
        recipient.isAcceptableOrUnknown(data['recipient']!, _recipientMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Delivery map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Delivery(
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
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      channel: $DeliveriesTable.$converterchannel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}channel'],
        )!,
      ),
      recipient: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient'],
      ),
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $DeliveriesTable createAlias(String alias) {
    return $DeliveriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DeliveryChannel, String, String> $converterchannel =
      const EnumNameConverter<DeliveryChannel>(DeliveryChannel.values);
}

class Delivery extends DataClass implements Insertable<Delivery> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String documentId;
  final DeliveryChannel channel;

  /// Email address or phone; `null` when shared with another app
  final String? recipient;
  final String deviceId;
  const Delivery({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.documentId,
    required this.channel,
    this.recipient,
    required this.deviceId,
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
    map['document_id'] = Variable<String>(documentId);
    {
      map['channel'] = Variable<String>(
        $DeliveriesTable.$converterchannel.toSql(channel),
      );
    }
    if (!nullToAbsent || recipient != null) {
      map['recipient'] = Variable<String>(recipient);
    }
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  DeliveriesCompanion toCompanion(bool nullToAbsent) {
    return DeliveriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      documentId: Value(documentId),
      channel: Value(channel),
      recipient: recipient == null && nullToAbsent
          ? const Value.absent()
          : Value(recipient),
      deviceId: Value(deviceId),
    );
  }

  factory Delivery.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Delivery(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      documentId: serializer.fromJson<String>(json['documentId']),
      channel: $DeliveriesTable.$converterchannel.fromJson(
        serializer.fromJson<String>(json['channel']),
      ),
      recipient: serializer.fromJson<String?>(json['recipient']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
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
      'documentId': serializer.toJson<String>(documentId),
      'channel': serializer.toJson<String>(
        $DeliveriesTable.$converterchannel.toJson(channel),
      ),
      'recipient': serializer.toJson<String?>(recipient),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Delivery copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    String? documentId,
    DeliveryChannel? channel,
    Value<String?> recipient = const Value.absent(),
    String? deviceId,
  }) => Delivery(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    documentId: documentId ?? this.documentId,
    channel: channel ?? this.channel,
    recipient: recipient.present ? recipient.value : this.recipient,
    deviceId: deviceId ?? this.deviceId,
  );
  Delivery copyWithCompanion(DeliveriesCompanion data) {
    return Delivery(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      channel: data.channel.present ? data.channel.value : this.channel,
      recipient: data.recipient.present ? data.recipient.value : this.recipient,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Delivery(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('documentId: $documentId, ')
          ..write('channel: $channel, ')
          ..write('recipient: $recipient, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    documentId,
    channel,
    recipient,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Delivery &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.documentId == this.documentId &&
          other.channel == this.channel &&
          other.recipient == this.recipient &&
          other.deviceId == this.deviceId);
}

class DeliveriesCompanion extends UpdateCompanion<Delivery> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<String> documentId;
  final Value<DeliveryChannel> channel;
  final Value<String?> recipient;
  final Value<String> deviceId;
  final Value<int> rowid;
  const DeliveriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.documentId = const Value.absent(),
    this.channel = const Value.absent(),
    this.recipient = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeliveriesCompanion.insert({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required String documentId,
    required DeliveryChannel channel,
    this.recipient = const Value.absent(),
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : documentId = Value(documentId),
       channel = Value(channel),
       deviceId = Value(deviceId);
  static Insertable<Delivery> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? documentId,
    Expression<String>? channel,
    Expression<String>? recipient,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (documentId != null) 'document_id': documentId,
      if (channel != null) 'channel': channel,
      if (recipient != null) 'recipient': recipient,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeliveriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<String>? documentId,
    Value<DeliveryChannel>? channel,
    Value<String?>? recipient,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return DeliveriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      documentId: documentId ?? this.documentId,
      channel: channel ?? this.channel,
      recipient: recipient ?? this.recipient,
      deviceId: deviceId ?? this.deviceId,
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
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(
        $DeliveriesTable.$converterchannel.toSql(channel.value),
      );
    }
    if (recipient.present) {
      map['recipient'] = Variable<String>(recipient.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeliveriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('documentId: $documentId, ')
          ..write('channel: $channel, ')
          ..write('recipient: $recipient, ')
          ..write('deviceId: $deviceId, ')
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
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $DocumentFilesTable documentFiles = $DocumentFilesTable(this);
  late final $DocumentEventsTable documentEvents = $DocumentEventsTable(this);
  late final $DeviceSettingsTable deviceSettings = $DeviceSettingsTable(this);
  late final $VehiclesTable vehicles = $VehiclesTable(this);
  late final $DriversTable drivers = $DriversTable(this);
  late final $AddressesTable addresses = $AddressesTable(this);
  late final $DeliveriesTable deliveries = $DeliveriesTable(this);
  late final Index companiesRuc = Index(
    'companies_ruc',
    'CREATE UNIQUE INDEX companies_ruc ON companies (ruc) WHERE deleted_at IS NULL',
  );
  late final Index customersDocument = Index(
    'customers_document',
    'CREATE UNIQUE INDEX customers_document ON customers (company_id, tipo_documento_identidad, numero_documento_identidad) WHERE deleted_at IS NULL',
  );
  late final Index documentsNumber = Index(
    'documents_number',
    'CREATE UNIQUE INDEX documents_number ON documents (company_id, environment, tipo_comprobante, serie, numero)',
  );
  late final Index documentsList = Index(
    'documents_list',
    'CREATE INDEX documents_list ON documents (company_id, environment, created_at)',
  );
  late final Index documentsOutbox = Index(
    'documents_outbox',
    'CREATE INDEX documents_outbox ON documents (status, next_attempt_at)',
  );
  late final Index documentEventsTimeline = Index(
    'document_events_timeline',
    'CREATE INDEX document_events_timeline ON document_events (document_id, created_at)',
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
    documents,
    documentFiles,
    documentEvents,
    deviceSettings,
    vehicles,
    drivers,
    addresses,
    deliveries,
    companiesRuc,
    customersDocument,
    documentsNumber,
    documentsList,
    documentsOutbox,
    documentEventsTimeline,
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

  static MultiTypedResultKey<$DocumentsTable, List<Document>>
  _documentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documents,
    aliasName: 'companies__id__documents__company_id',
  );

  $$DocumentsTableProcessedTableManager get documentsRefs {
    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VehiclesTable, List<Vehicle>> _vehiclesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.vehicles,
    aliasName: 'companies__id__vehicles__company_id',
  );

  $$VehiclesTableProcessedTableManager get vehiclesRefs {
    final manager = $$VehiclesTableTableManager(
      $_db,
      $_db.vehicles,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_vehiclesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DriversTable, List<Driver>> _driversRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.drivers,
    aliasName: 'companies__id__drivers__company_id',
  );

  $$DriversTableProcessedTableManager get driversRefs {
    final manager = $$DriversTableTableManager(
      $_db,
      $_db.drivers,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_driversRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AddressesTable, List<Address>>
  _addressesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.addresses,
    aliasName: 'companies__id__addresses__company_id',
  );

  $$AddressesTableProcessedTableManager get addressesRefs {
    final manager = $$AddressesTableTableManager(
      $_db,
      $_db.addresses,
    ).filter((f) => f.companyId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_addressesRefsTable($_db));
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

  Expression<bool> documentsRefs(
    Expression<bool> Function($$DocumentsTableFilterComposer f) f,
  ) {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> vehiclesRefs(
    Expression<bool> Function($$VehiclesTableFilterComposer f) f,
  ) {
    final $$VehiclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableFilterComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> driversRefs(
    Expression<bool> Function($$DriversTableFilterComposer f) f,
  ) {
    final $$DriversTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.drivers,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DriversTableFilterComposer(
            $db: $db,
            $table: $db.drivers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> addressesRefs(
    Expression<bool> Function($$AddressesTableFilterComposer f) f,
  ) {
    final $$AddressesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableFilterComposer(
            $db: $db,
            $table: $db.addresses,
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

  Expression<T> documentsRefs<T extends Object>(
    Expression<T> Function($$DocumentsTableAnnotationComposer a) f,
  ) {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> vehiclesRefs<T extends Object>(
    Expression<T> Function($$VehiclesTableAnnotationComposer a) f,
  ) {
    final $$VehiclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.vehicles,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VehiclesTableAnnotationComposer(
            $db: $db,
            $table: $db.vehicles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> driversRefs<T extends Object>(
    Expression<T> Function($$DriversTableAnnotationComposer a) f,
  ) {
    final $$DriversTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.drivers,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DriversTableAnnotationComposer(
            $db: $db,
            $table: $db.drivers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> addressesRefs<T extends Object>(
    Expression<T> Function($$AddressesTableAnnotationComposer a) f,
  ) {
    final $$AddressesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.addresses,
      getReferencedColumn: (t) => t.companyId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AddressesTableAnnotationComposer(
            $db: $db,
            $table: $db.addresses,
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
            bool documentsRefs,
            bool vehiclesRefs,
            bool driversRefs,
            bool addressesRefs,
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
                documentsRefs = false,
                vehiclesRefs = false,
                driversRefs = false,
                addressesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (seriesRefs) db.series,
                    if (customersRefs) db.customers,
                    if (productsRefs) db.products,
                    if (documentsRefs) db.documents,
                    if (vehiclesRefs) db.vehicles,
                    if (driversRefs) db.drivers,
                    if (addressesRefs) db.addresses,
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
                      if (documentsRefs)
                        await $_getPrefetchedDataByColumns<
                          Company,
                          $CompaniesTable,
                          Document,
                          $DocumentsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._documentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).documentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'company_id',
                          typedResults: items,
                        ),
                      if (vehiclesRefs)
                        await $_getPrefetchedDataByColumns<
                          Company,
                          $CompaniesTable,
                          Vehicle,
                          $VehiclesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._vehiclesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).vehiclesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'company_id',
                          typedResults: items,
                        ),
                      if (driversRefs)
                        await $_getPrefetchedDataByColumns<
                          Company,
                          $CompaniesTable,
                          Driver,
                          $DriversTable
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._driversRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).driversRefs,
                          currentColumn: 'id',
                          referencedColumn: 'company_id',
                          typedResults: items,
                        ),
                      if (addressesRefs)
                        await $_getPrefetchedDataByColumns<
                          Company,
                          $CompaniesTable,
                          Address,
                          $AddressesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CompaniesTableReferences
                              ._addressesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CompaniesTableReferences(
                                db,
                                table,
                                p0,
                              ).addressesRefs,
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
        bool documentsRefs,
        bool vehiclesRefs,
        bool driversRefs,
        bool addressesRefs,
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
  Value<String?> distrito,
  Value<String?> provincia,
  Value<String?> departamento,
  Value<String?> ubigeo,
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
  Value<String?> distrito,
  Value<String?> provincia,
  Value<String?> departamento,
  Value<String?> ubigeo,
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

  ColumnFilters<String> get distrito => $composableBuilder(
    column: $table.distrito,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ubigeo => $composableBuilder(
    column: $table.ubigeo,
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

  ColumnOrderings<String> get distrito => $composableBuilder(
    column: $table.distrito,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provincia => $composableBuilder(
    column: $table.provincia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ubigeo => $composableBuilder(
    column: $table.ubigeo,
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

  GeneratedColumn<String> get distrito =>
      $composableBuilder(column: $table.distrito, builder: (column) => column);

  GeneratedColumn<String> get provincia =>
      $composableBuilder(column: $table.provincia, builder: (column) => column);

  GeneratedColumn<String> get departamento => $composableBuilder(
    column: $table.departamento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ubigeo =>
      $composableBuilder(column: $table.ubigeo, builder: (column) => column);

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
                Value<String?> distrito = const Value.absent(),
                Value<String?> provincia = const Value.absent(),
                Value<String?> departamento = const Value.absent(),
                Value<String?> ubigeo = const Value.absent(),
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
                distrito: distrito,
                provincia: provincia,
                departamento: departamento,
                ubigeo: ubigeo,
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
                Value<String?> distrito = const Value.absent(),
                Value<String?> provincia = const Value.absent(),
                Value<String?> departamento = const Value.absent(),
                Value<String?> ubigeo = const Value.absent(),
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
                distrito: distrito,
                provincia: provincia,
                departamento: departamento,
                ubigeo: ubigeo,
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
  Value<String?> codigoSunat,
  required String descripcion,
  Value<String> unidadMedida,
  required String precio,
  Value<bool> precioIncluyeIgv,
  Value<String?> igvTipo,
  Value<String?> iscTipo,
  Value<String?> iscTasa,
  Value<bool> esBolsa,
  Value<String?> detraccionCodigo,
  Value<String?> detraccionPorcentaje,
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
  Value<String?> codigoSunat,
  Value<String> descripcion,
  Value<String> unidadMedida,
  Value<String> precio,
  Value<bool> precioIncluyeIgv,
  Value<String?> igvTipo,
  Value<String?> iscTipo,
  Value<String?> iscTasa,
  Value<bool> esBolsa,
  Value<String?> detraccionCodigo,
  Value<String?> detraccionPorcentaje,
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

  ColumnFilters<String> get codigoSunat => $composableBuilder(
    column: $table.codigoSunat,
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

  ColumnFilters<String> get detraccionPorcentaje => $composableBuilder(
    column: $table.detraccionPorcentaje,
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

  ColumnOrderings<String> get codigoSunat => $composableBuilder(
    column: $table.codigoSunat,
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

  ColumnOrderings<String> get detraccionPorcentaje => $composableBuilder(
    column: $table.detraccionPorcentaje,
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

  GeneratedColumn<String> get codigoSunat => $composableBuilder(
    column: $table.codigoSunat,
    builder: (column) => column,
  );

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

  GeneratedColumn<String> get detraccionPorcentaje => $composableBuilder(
    column: $table.detraccionPorcentaje,
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
                Value<String?> codigoSunat = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<String> unidadMedida = const Value.absent(),
                Value<String> precio = const Value.absent(),
                Value<bool> precioIncluyeIgv = const Value.absent(),
                Value<String?> igvTipo = const Value.absent(),
                Value<String?> iscTipo = const Value.absent(),
                Value<String?> iscTasa = const Value.absent(),
                Value<bool> esBolsa = const Value.absent(),
                Value<String?> detraccionCodigo = const Value.absent(),
                Value<String?> detraccionPorcentaje = const Value.absent(),
                Value<bool> favorito = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                codigo: codigo,
                codigoSunat: codigoSunat,
                descripcion: descripcion,
                unidadMedida: unidadMedida,
                precio: precio,
                precioIncluyeIgv: precioIncluyeIgv,
                igvTipo: igvTipo,
                iscTipo: iscTipo,
                iscTasa: iscTasa,
                esBolsa: esBolsa,
                detraccionCodigo: detraccionCodigo,
                detraccionPorcentaje: detraccionPorcentaje,
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
                Value<String?> codigoSunat = const Value.absent(),
                required String descripcion,
                Value<String> unidadMedida = const Value.absent(),
                required String precio,
                Value<bool> precioIncluyeIgv = const Value.absent(),
                Value<String?> igvTipo = const Value.absent(),
                Value<String?> iscTipo = const Value.absent(),
                Value<String?> iscTasa = const Value.absent(),
                Value<bool> esBolsa = const Value.absent(),
                Value<String?> detraccionCodigo = const Value.absent(),
                Value<String?> detraccionPorcentaje = const Value.absent(),
                Value<bool> favorito = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                codigo: codigo,
                codigoSunat: codigoSunat,
                descripcion: descripcion,
                unidadMedida: unidadMedida,
                precio: precio,
                precioIncluyeIgv: precioIncluyeIgv,
                igvTipo: igvTipo,
                iscTipo: iscTipo,
                iscTasa: iscTasa,
                esBolsa: esBolsa,
                detraccionCodigo: detraccionCodigo,
                detraccionPorcentaje: detraccionPorcentaje,
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
typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String companyId,
  required SunatEnvironment environment,
  required String tipoComprobante,
  required String serie,
  required int numero,
  required String fechaEmision,
  required String clienteTipoDocumento,
  required String clienteNumeroDocumento,
  required String clienteNombre,
  required String moneda,
  required String total,
  required DocumentStatus status,
  Value<String?> sunatCode,
  Value<String?> sunatDescription,
  Value<String?> sunatNotes,
  Value<String?> ticket,
  required String digestValue,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  required String inputJson,
  required String enrichedJson,
  Value<String?> affectedDocumentId,
  Value<String?> voidedByDocumentId,
  required String deviceId,
  Value<int> rowid,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> companyId,
  Value<SunatEnvironment> environment,
  Value<String> tipoComprobante,
  Value<String> serie,
  Value<int> numero,
  Value<String> fechaEmision,
  Value<String> clienteTipoDocumento,
  Value<String> clienteNumeroDocumento,
  Value<String> clienteNombre,
  Value<String> moneda,
  Value<String> total,
  Value<DocumentStatus> status,
  Value<String?> sunatCode,
  Value<String?> sunatDescription,
  Value<String?> sunatNotes,
  Value<String?> ticket,
  Value<String> digestValue,
  Value<int> attempts,
  Value<DateTime?> nextAttemptAt,
  Value<String> inputJson,
  Value<String> enrichedJson,
  Value<String?> affectedDocumentId,
  Value<String?> voidedByDocumentId,
  Value<String> deviceId,
  Value<int> rowid,
});

final class $$DocumentsTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentsTable, Document> {
  $$DocumentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('documents__company_id__companies__id');

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

  static $DocumentsTable _affectedDocumentIdTable(_$AppDatabase db) => db
      .documents
      .createAlias('documents__affected_document_id__documents__id');

  $$DocumentsTableProcessedTableManager? get affectedDocumentId {
    final $_column = $_itemColumn<String>('affected_document_id');
    if ($_column == null) return null;
    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_affectedDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DocumentsTable _voidedByDocumentIdTable(_$AppDatabase db) => db
      .documents
      .createAlias('documents__voided_by_document_id__documents__id');

  $$DocumentsTableProcessedTableManager? get voidedByDocumentId {
    final $_column = $_itemColumn<String>('voided_by_document_id');
    if ($_column == null) return null;
    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_voidedByDocumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DocumentFilesTable, List<DocumentFile>>
  _documentFilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentFiles,
    aliasName: 'documents__id__document_files__document_id',
  );

  $$DocumentFilesTableProcessedTableManager get documentFilesRefs {
    final manager = $$DocumentFilesTableTableManager(
      $_db,
      $_db.documentFiles,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentFilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DocumentEventsTable, List<DocumentEvent>>
  _documentEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentEvents,
    aliasName: 'documents__id__document_events__document_id',
  );

  $$DocumentEventsTableProcessedTableManager get documentEventsRefs {
    final manager = $$DocumentEventsTableTableManager(
      $_db,
      $_db.documentEvents,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DeliveriesTable, List<Delivery>>
  _deliveriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.deliveries,
    aliasName: 'documents__id__deliveries__document_id',
  );

  $$DeliveriesTableProcessedTableManager get deliveriesRefs {
    final manager = $$DeliveriesTableTableManager(
      $_db,
      $_db.deliveries,
    ).filter((f) => f.documentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_deliveriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<SunatEnvironment, SunatEnvironment, String>
  get environment => $composableBuilder(
    column: $table.environment,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get tipoComprobante => $composableBuilder(
    column: $table.tipoComprobante,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serie => $composableBuilder(
    column: $table.serie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaEmision => $composableBuilder(
    column: $table.fechaEmision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteTipoDocumento => $composableBuilder(
    column: $table.clienteTipoDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteNumeroDocumento => $composableBuilder(
    column: $table.clienteNumeroDocumento,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clienteNombre => $composableBuilder(
    column: $table.clienteNombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DocumentStatus, DocumentStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get sunatCode => $composableBuilder(
    column: $table.sunatCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sunatDescription => $composableBuilder(
    column: $table.sunatDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sunatNotes => $composableBuilder(
    column: $table.sunatNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ticket => $composableBuilder(
    column: $table.ticket,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get digestValue => $composableBuilder(
    column: $table.digestValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputJson => $composableBuilder(
    column: $table.inputJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enrichedJson => $composableBuilder(
    column: $table.enrichedJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
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

  $$DocumentsTableFilterComposer get affectedDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.affectedDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableFilterComposer get voidedByDocumentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidedByDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> documentFilesRefs(
    Expression<bool> Function($$DocumentFilesTableFilterComposer f) f,
  ) {
    final $$DocumentFilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentFiles,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFilesTableFilterComposer(
            $db: $db,
            $table: $db.documentFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> documentEventsRefs(
    Expression<bool> Function($$DocumentEventsTableFilterComposer f) f,
  ) {
    final $$DocumentEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentEvents,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentEventsTableFilterComposer(
            $db: $db,
            $table: $db.documentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> deliveriesRefs(
    Expression<bool> Function($$DeliveriesTableFilterComposer f) f,
  ) {
    final $$DeliveriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deliveries,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeliveriesTableFilterComposer(
            $db: $db,
            $table: $db.deliveries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
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

  ColumnOrderings<String> get environment => $composableBuilder(
    column: $table.environment,
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

  ColumnOrderings<int> get numero => $composableBuilder(
    column: $table.numero,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaEmision => $composableBuilder(
    column: $table.fechaEmision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteTipoDocumento => $composableBuilder(
    column: $table.clienteTipoDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteNumeroDocumento => $composableBuilder(
    column: $table.clienteNumeroDocumento,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clienteNombre => $composableBuilder(
    column: $table.clienteNombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sunatCode => $composableBuilder(
    column: $table.sunatCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sunatDescription => $composableBuilder(
    column: $table.sunatDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sunatNotes => $composableBuilder(
    column: $table.sunatNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ticket => $composableBuilder(
    column: $table.ticket,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get digestValue => $composableBuilder(
    column: $table.digestValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputJson => $composableBuilder(
    column: $table.inputJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enrichedJson => $composableBuilder(
    column: $table.enrichedJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
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

  $$DocumentsTableOrderingComposer get affectedDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.affectedDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableOrderingComposer get voidedByDocumentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidedByDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<SunatEnvironment, String> get environment =>
      $composableBuilder(
        column: $table.environment,
        builder: (column) => column,
      );

  GeneratedColumn<String> get tipoComprobante => $composableBuilder(
    column: $table.tipoComprobante,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serie =>
      $composableBuilder(column: $table.serie, builder: (column) => column);

  GeneratedColumn<int> get numero =>
      $composableBuilder(column: $table.numero, builder: (column) => column);

  GeneratedColumn<String> get fechaEmision => $composableBuilder(
    column: $table.fechaEmision,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteTipoDocumento => $composableBuilder(
    column: $table.clienteTipoDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteNumeroDocumento => $composableBuilder(
    column: $table.clienteNumeroDocumento,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clienteNombre => $composableBuilder(
    column: $table.clienteNombre,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moneda =>
      $composableBuilder(column: $table.moneda, builder: (column) => column);

  GeneratedColumn<String> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DocumentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get sunatCode =>
      $composableBuilder(column: $table.sunatCode, builder: (column) => column);

  GeneratedColumn<String> get sunatDescription => $composableBuilder(
    column: $table.sunatDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sunatNotes => $composableBuilder(
    column: $table.sunatNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ticket =>
      $composableBuilder(column: $table.ticket, builder: (column) => column);

  GeneratedColumn<String> get digestValue => $composableBuilder(
    column: $table.digestValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inputJson =>
      $composableBuilder(column: $table.inputJson, builder: (column) => column);

  GeneratedColumn<String> get enrichedJson => $composableBuilder(
    column: $table.enrichedJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

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

  $$DocumentsTableAnnotationComposer get affectedDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.affectedDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DocumentsTableAnnotationComposer get voidedByDocumentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.voidedByDocumentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> documentFilesRefs<T extends Object>(
    Expression<T> Function($$DocumentFilesTableAnnotationComposer a) f,
  ) {
    final $$DocumentFilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentFiles,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFilesTableAnnotationComposer(
            $db: $db,
            $table: $db.documentFiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> documentEventsRefs<T extends Object>(
    Expression<T> Function($$DocumentEventsTableAnnotationComposer a) f,
  ) {
    final $$DocumentEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentEvents,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.documentEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> deliveriesRefs<T extends Object>(
    Expression<T> Function($$DeliveriesTableAnnotationComposer a) f,
  ) {
    final $$DeliveriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.deliveries,
      getReferencedColumn: (t) => t.documentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeliveriesTableAnnotationComposer(
            $db: $db,
            $table: $db.deliveries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentsTable,
          Document,
          $$DocumentsTableFilterComposer,
          $$DocumentsTableOrderingComposer,
          $$DocumentsTableAnnotationComposer,
          $$DocumentsTableCreateCompanionBuilder,
          $$DocumentsTableUpdateCompanionBuilder,
          (Document, $$DocumentsTableReferences),
          Document,
          PrefetchHooks Function({
            bool companyId,
            bool affectedDocumentId,
            bool voidedByDocumentId,
            bool documentFilesRefs,
            bool documentEventsRefs,
            bool deliveriesRefs,
          })
        > {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<SunatEnvironment> environment = const Value.absent(),
                Value<String> tipoComprobante = const Value.absent(),
                Value<String> serie = const Value.absent(),
                Value<int> numero = const Value.absent(),
                Value<String> fechaEmision = const Value.absent(),
                Value<String> clienteTipoDocumento = const Value.absent(),
                Value<String> clienteNumeroDocumento = const Value.absent(),
                Value<String> clienteNombre = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String> total = const Value.absent(),
                Value<DocumentStatus> status = const Value.absent(),
                Value<String?> sunatCode = const Value.absent(),
                Value<String?> sunatDescription = const Value.absent(),
                Value<String?> sunatNotes = const Value.absent(),
                Value<String?> ticket = const Value.absent(),
                Value<String> digestValue = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String> inputJson = const Value.absent(),
                Value<String> enrichedJson = const Value.absent(),
                Value<String?> affectedDocumentId = const Value.absent(),
                Value<String?> voidedByDocumentId = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                environment: environment,
                tipoComprobante: tipoComprobante,
                serie: serie,
                numero: numero,
                fechaEmision: fechaEmision,
                clienteTipoDocumento: clienteTipoDocumento,
                clienteNumeroDocumento: clienteNumeroDocumento,
                clienteNombre: clienteNombre,
                moneda: moneda,
                total: total,
                status: status,
                sunatCode: sunatCode,
                sunatDescription: sunatDescription,
                sunatNotes: sunatNotes,
                ticket: ticket,
                digestValue: digestValue,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                inputJson: inputJson,
                enrichedJson: enrichedJson,
                affectedDocumentId: affectedDocumentId,
                voidedByDocumentId: voidedByDocumentId,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String companyId,
                required SunatEnvironment environment,
                required String tipoComprobante,
                required String serie,
                required int numero,
                required String fechaEmision,
                required String clienteTipoDocumento,
                required String clienteNumeroDocumento,
                required String clienteNombre,
                required String moneda,
                required String total,
                required DocumentStatus status,
                Value<String?> sunatCode = const Value.absent(),
                Value<String?> sunatDescription = const Value.absent(),
                Value<String?> sunatNotes = const Value.absent(),
                Value<String?> ticket = const Value.absent(),
                required String digestValue,
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                required String inputJson,
                required String enrichedJson,
                Value<String?> affectedDocumentId = const Value.absent(),
                Value<String?> voidedByDocumentId = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => DocumentsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                environment: environment,
                tipoComprobante: tipoComprobante,
                serie: serie,
                numero: numero,
                fechaEmision: fechaEmision,
                clienteTipoDocumento: clienteTipoDocumento,
                clienteNumeroDocumento: clienteNumeroDocumento,
                clienteNombre: clienteNombre,
                moneda: moneda,
                total: total,
                status: status,
                sunatCode: sunatCode,
                sunatDescription: sunatDescription,
                sunatNotes: sunatNotes,
                ticket: ticket,
                digestValue: digestValue,
                attempts: attempts,
                nextAttemptAt: nextAttemptAt,
                inputJson: inputJson,
                enrichedJson: enrichedJson,
                affectedDocumentId: affectedDocumentId,
                voidedByDocumentId: voidedByDocumentId,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentsTable, Document>(table),
                  $$DocumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                companyId = false,
                affectedDocumentId = false,
                voidedByDocumentId = false,
                documentFilesRefs = false,
                documentEventsRefs = false,
                deliveriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (documentFilesRefs) db.documentFiles,
                    if (documentEventsRefs) db.documentEvents,
                    if (deliveriesRefs) db.deliveries,
                  ],
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
                            referencedTable: $$DocumentsTableReferences
                                ._companyIdTable(db),
                            referencedColumn: $$DocumentsTableReferences
                                ._companyIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (affectedDocumentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.affectedDocumentId,
                            referencedTable: $$DocumentsTableReferences
                                ._affectedDocumentIdTable(db),
                            referencedColumn: $$DocumentsTableReferences
                                ._affectedDocumentIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (voidedByDocumentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.voidedByDocumentId,
                            referencedTable: $$DocumentsTableReferences
                                ._voidedByDocumentIdTable(db),
                            referencedColumn: $$DocumentsTableReferences
                                ._voidedByDocumentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (documentFilesRefs)
                        await $_getPrefetchedDataByColumns<
                          Document,
                          $DocumentsTable,
                          DocumentFile,
                          $DocumentFilesTable
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._documentFilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).documentFilesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'document_id',
                          typedResults: items,
                        ),
                      if (documentEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          Document,
                          $DocumentsTable,
                          DocumentEvent,
                          $DocumentEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._documentEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).documentEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'document_id',
                          typedResults: items,
                        ),
                      if (deliveriesRefs)
                        await $_getPrefetchedDataByColumns<
                          Document,
                          $DocumentsTable,
                          Delivery,
                          $DeliveriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentsTableReferences
                              ._deliveriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentsTableReferences(
                                db,
                                table,
                                p0,
                              ).deliveriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'document_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentsTable,
      Document,
      $$DocumentsTableFilterComposer,
      $$DocumentsTableOrderingComposer,
      $$DocumentsTableAnnotationComposer,
      $$DocumentsTableCreateCompanionBuilder,
      $$DocumentsTableUpdateCompanionBuilder,
      (Document, $$DocumentsTableReferences),
      Document,
      PrefetchHooks Function({
        bool companyId,
        bool affectedDocumentId,
        bool voidedByDocumentId,
        bool documentFilesRefs,
        bool documentEventsRefs,
        bool deliveriesRefs,
      })
    >;
typedef $$DocumentFilesTableCreateCompanionBuilder =
    DocumentFilesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String documentId,
      required DocumentFileKind kind,
      required Uint8List bytes,
      required String sha256,
      Value<int> rowid,
    });
typedef $$DocumentFilesTableUpdateCompanionBuilder =
    DocumentFilesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> documentId,
      Value<DocumentFileKind> kind,
      Value<Uint8List> bytes,
      Value<String> sha256,
      Value<int> rowid,
    });

final class $$DocumentFilesTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentFilesTable, DocumentFile> {
  $$DocumentFilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DocumentsTable _documentIdTable(_$AppDatabase db) =>
      db.documents.createAlias('document_files__document_id__documents__id');

  $$DocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DocumentFilesTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentFilesTable> {
  $$DocumentFilesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DocumentFileKind, DocumentFileKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get documentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentFilesTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentFilesTable> {
  $$DocumentFilesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sha256 => $composableBuilder(
    column: $table.sha256,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get documentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentFilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentFilesTable> {
  $$DocumentFilesTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<DocumentFileKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<Uint8List> get bytes =>
      $composableBuilder(column: $table.bytes, builder: (column) => column);

  GeneratedColumn<String> get sha256 =>
      $composableBuilder(column: $table.sha256, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get documentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentFilesTable,
          DocumentFile,
          $$DocumentFilesTableFilterComposer,
          $$DocumentFilesTableOrderingComposer,
          $$DocumentFilesTableAnnotationComposer,
          $$DocumentFilesTableCreateCompanionBuilder,
          $$DocumentFilesTableUpdateCompanionBuilder,
          (DocumentFile, $$DocumentFilesTableReferences),
          DocumentFile,
          PrefetchHooks Function({bool documentId})
        > {
  $$DocumentFilesTableTableManager(_$AppDatabase db, $DocumentFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<DocumentFileKind> kind = const Value.absent(),
                Value<Uint8List> bytes = const Value.absent(),
                Value<String> sha256 = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentFilesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                documentId: documentId,
                kind: kind,
                bytes: bytes,
                sha256: sha256,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String documentId,
                required DocumentFileKind kind,
                required Uint8List bytes,
                required String sha256,
                Value<int> rowid = const Value.absent(),
              }) => DocumentFilesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                documentId: documentId,
                kind: kind,
                bytes: bytes,
                sha256: sha256,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentFilesTable, DocumentFile>(table),
                  $$DocumentFilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentId = false}) {
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
                    if (documentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.documentId,
                        referencedTable: $$DocumentFilesTableReferences
                            ._documentIdTable(db),
                        referencedColumn: $$DocumentFilesTableReferences
                            ._documentIdTable(db)
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

typedef $$DocumentFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentFilesTable,
      DocumentFile,
      $$DocumentFilesTableFilterComposer,
      $$DocumentFilesTableOrderingComposer,
      $$DocumentFilesTableAnnotationComposer,
      $$DocumentFilesTableCreateCompanionBuilder,
      $$DocumentFilesTableUpdateCompanionBuilder,
      (DocumentFile, $$DocumentFilesTableReferences),
      DocumentFile,
      PrefetchHooks Function({bool documentId})
    >;
typedef $$DocumentEventsTableCreateCompanionBuilder =
    DocumentEventsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      required String documentId,
      required DocumentStatus status,
      Value<String?> code,
      Value<String?> message,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$DocumentEventsTableUpdateCompanionBuilder =
    DocumentEventsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<String> documentId,
      Value<DocumentStatus> status,
      Value<String?> code,
      Value<String?> message,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$DocumentEventsTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentEventsTable, DocumentEvent> {
  $$DocumentEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DocumentsTable _documentIdTable(_$AppDatabase db) =>
      db.documents.createAlias('document_events__document_id__documents__id');

  $$DocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DocumentEventsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentEventsTable> {
  $$DocumentEventsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DocumentStatus, DocumentStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get documentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentEventsTable> {
  $$DocumentEventsTableOrderingComposer({
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get documentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentEventsTable> {
  $$DocumentEventsTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<DocumentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get documentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentEventsTable,
          DocumentEvent,
          $$DocumentEventsTableFilterComposer,
          $$DocumentEventsTableOrderingComposer,
          $$DocumentEventsTableAnnotationComposer,
          $$DocumentEventsTableCreateCompanionBuilder,
          $$DocumentEventsTableUpdateCompanionBuilder,
          (DocumentEvent, $$DocumentEventsTableReferences),
          DocumentEvent,
          PrefetchHooks Function({bool documentId})
        > {
  $$DocumentEventsTableTableManager(
    _$AppDatabase db,
    $DocumentEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<DocumentStatus> status = const Value.absent(),
                Value<String?> code = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DocumentEventsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                documentId: documentId,
                status: status,
                code: code,
                message: message,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String documentId,
                required DocumentStatus status,
                Value<String?> code = const Value.absent(),
                Value<String?> message = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => DocumentEventsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                documentId: documentId,
                status: status,
                code: code,
                message: message,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentEventsTable, DocumentEvent>(table),
                  $$DocumentEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentId = false}) {
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
                    if (documentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.documentId,
                        referencedTable: $$DocumentEventsTableReferences
                            ._documentIdTable(db),
                        referencedColumn: $$DocumentEventsTableReferences
                            ._documentIdTable(db)
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

typedef $$DocumentEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentEventsTable,
      DocumentEvent,
      $$DocumentEventsTableFilterComposer,
      $$DocumentEventsTableOrderingComposer,
      $$DocumentEventsTableAnnotationComposer,
      $$DocumentEventsTableCreateCompanionBuilder,
      $$DocumentEventsTableUpdateCompanionBuilder,
      (DocumentEvent, $$DocumentEventsTableReferences),
      DocumentEvent,
      PrefetchHooks Function({bool documentId})
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
typedef $$VehiclesTableCreateCompanionBuilder = VehiclesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String companyId,
  required String placa,
  Value<String?> numeroCirculacion,
  Value<int> rowid,
});
typedef $$VehiclesTableUpdateCompanionBuilder = VehiclesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> companyId,
  Value<String> placa,
  Value<String?> numeroCirculacion,
  Value<int> rowid,
});

final class $$VehiclesTableReferences
    extends BaseReferences<_$AppDatabase, $VehiclesTable, Vehicle> {
  $$VehiclesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('vehicles__company_id__companies__id');

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

class $$VehiclesTableFilterComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableFilterComposer({
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

  ColumnFilters<String> get placa => $composableBuilder(
    column: $table.placa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get numeroCirculacion => $composableBuilder(
    column: $table.numeroCirculacion,
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

class $$VehiclesTableOrderingComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableOrderingComposer({
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

  ColumnOrderings<String> get placa => $composableBuilder(
    column: $table.placa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get numeroCirculacion => $composableBuilder(
    column: $table.numeroCirculacion,
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

class $$VehiclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $VehiclesTable> {
  $$VehiclesTableAnnotationComposer({
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

  GeneratedColumn<String> get placa =>
      $composableBuilder(column: $table.placa, builder: (column) => column);

  GeneratedColumn<String> get numeroCirculacion => $composableBuilder(
    column: $table.numeroCirculacion,
    builder: (column) => column,
  );

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

class $$VehiclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VehiclesTable,
          Vehicle,
          $$VehiclesTableFilterComposer,
          $$VehiclesTableOrderingComposer,
          $$VehiclesTableAnnotationComposer,
          $$VehiclesTableCreateCompanionBuilder,
          $$VehiclesTableUpdateCompanionBuilder,
          (Vehicle, $$VehiclesTableReferences),
          Vehicle,
          PrefetchHooks Function({bool companyId})
        > {
  $$VehiclesTableTableManager(_$AppDatabase db, $VehiclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VehiclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VehiclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VehiclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String> placa = const Value.absent(),
                Value<String?> numeroCirculacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                placa: placa,
                numeroCirculacion: numeroCirculacion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String companyId,
                required String placa,
                Value<String?> numeroCirculacion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VehiclesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                placa: placa,
                numeroCirculacion: numeroCirculacion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VehiclesTable, Vehicle>(table),
                  $$VehiclesTableReferences(db, table, e),
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
                        referencedTable: $$VehiclesTableReferences
                            ._companyIdTable(db),
                        referencedColumn: $$VehiclesTableReferences
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

typedef $$VehiclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VehiclesTable,
      Vehicle,
      $$VehiclesTableFilterComposer,
      $$VehiclesTableOrderingComposer,
      $$VehiclesTableAnnotationComposer,
      $$VehiclesTableCreateCompanionBuilder,
      $$VehiclesTableUpdateCompanionBuilder,
      (Vehicle, $$VehiclesTableReferences),
      Vehicle,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$DriversTableCreateCompanionBuilder = DriversCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String companyId,
  required String tipoDocumentoIdentidad,
  required String numeroDocumentoIdentidad,
  required String nombres,
  required String apellidos,
  required String licencia,
  Value<int> rowid,
});
typedef $$DriversTableUpdateCompanionBuilder = DriversCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> companyId,
  Value<String> tipoDocumentoIdentidad,
  Value<String> numeroDocumentoIdentidad,
  Value<String> nombres,
  Value<String> apellidos,
  Value<String> licencia,
  Value<int> rowid,
});

final class $$DriversTableReferences
    extends BaseReferences<_$AppDatabase, $DriversTable, Driver> {
  $$DriversTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('drivers__company_id__companies__id');

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

class $$DriversTableFilterComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableFilterComposer({
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

  ColumnFilters<String> get nombres => $composableBuilder(
    column: $table.nombres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get apellidos => $composableBuilder(
    column: $table.apellidos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licencia => $composableBuilder(
    column: $table.licencia,
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

class $$DriversTableOrderingComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableOrderingComposer({
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

  ColumnOrderings<String> get nombres => $composableBuilder(
    column: $table.nombres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get apellidos => $composableBuilder(
    column: $table.apellidos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licencia => $composableBuilder(
    column: $table.licencia,
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

class $$DriversTableAnnotationComposer
    extends Composer<_$AppDatabase, $DriversTable> {
  $$DriversTableAnnotationComposer({
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

  GeneratedColumn<String> get nombres =>
      $composableBuilder(column: $table.nombres, builder: (column) => column);

  GeneratedColumn<String> get apellidos =>
      $composableBuilder(column: $table.apellidos, builder: (column) => column);

  GeneratedColumn<String> get licencia =>
      $composableBuilder(column: $table.licencia, builder: (column) => column);

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

class $$DriversTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DriversTable,
          Driver,
          $$DriversTableFilterComposer,
          $$DriversTableOrderingComposer,
          $$DriversTableAnnotationComposer,
          $$DriversTableCreateCompanionBuilder,
          $$DriversTableUpdateCompanionBuilder,
          (Driver, $$DriversTableReferences),
          Driver,
          PrefetchHooks Function({bool companyId})
        > {
  $$DriversTableTableManager(_$AppDatabase db, $DriversTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DriversTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DriversTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DriversTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String> tipoDocumentoIdentidad = const Value.absent(),
                Value<String> numeroDocumentoIdentidad = const Value.absent(),
                Value<String> nombres = const Value.absent(),
                Value<String> apellidos = const Value.absent(),
                Value<String> licencia = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DriversCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                nombres: nombres,
                apellidos: apellidos,
                licencia: licencia,
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
                required String nombres,
                required String apellidos,
                required String licencia,
                Value<int> rowid = const Value.absent(),
              }) => DriversCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                tipoDocumentoIdentidad: tipoDocumentoIdentidad,
                numeroDocumentoIdentidad: numeroDocumentoIdentidad,
                nombres: nombres,
                apellidos: apellidos,
                licencia: licencia,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DriversTable, Driver>(table),
                  $$DriversTableReferences(db, table, e),
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
                        referencedTable: $$DriversTableReferences
                            ._companyIdTable(db),
                        referencedColumn: $$DriversTableReferences
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

typedef $$DriversTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DriversTable,
      Driver,
      $$DriversTableFilterComposer,
      $$DriversTableOrderingComposer,
      $$DriversTableAnnotationComposer,
      $$DriversTableCreateCompanionBuilder,
      $$DriversTableUpdateCompanionBuilder,
      (Driver, $$DriversTableReferences),
      Driver,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$AddressesTableCreateCompanionBuilder = AddressesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String companyId,
  Value<String?> nombre,
  required String ubigeo,
  required String direccion,
  Value<String?> codigoLocal,
  Value<int> rowid,
});
typedef $$AddressesTableUpdateCompanionBuilder = AddressesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> companyId,
  Value<String?> nombre,
  Value<String> ubigeo,
  Value<String> direccion,
  Value<String?> codigoLocal,
  Value<int> rowid,
});

final class $$AddressesTableReferences
    extends BaseReferences<_$AppDatabase, $AddressesTable, Address> {
  $$AddressesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CompaniesTable _companyIdTable(_$AppDatabase db) =>
      db.companies.createAlias('addresses__company_id__companies__id');

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

class $$AddressesTableFilterComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableFilterComposer({
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

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ubigeo => $composableBuilder(
    column: $table.ubigeo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoLocal => $composableBuilder(
    column: $table.codigoLocal,
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

class $$AddressesTableOrderingComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableOrderingComposer({
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

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ubigeo => $composableBuilder(
    column: $table.ubigeo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direccion => $composableBuilder(
    column: $table.direccion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoLocal => $composableBuilder(
    column: $table.codigoLocal,
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

class $$AddressesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AddressesTable> {
  $$AddressesTableAnnotationComposer({
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

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get ubigeo =>
      $composableBuilder(column: $table.ubigeo, builder: (column) => column);

  GeneratedColumn<String> get direccion =>
      $composableBuilder(column: $table.direccion, builder: (column) => column);

  GeneratedColumn<String> get codigoLocal => $composableBuilder(
    column: $table.codigoLocal,
    builder: (column) => column,
  );

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

class $$AddressesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AddressesTable,
          Address,
          $$AddressesTableFilterComposer,
          $$AddressesTableOrderingComposer,
          $$AddressesTableAnnotationComposer,
          $$AddressesTableCreateCompanionBuilder,
          $$AddressesTableUpdateCompanionBuilder,
          (Address, $$AddressesTableReferences),
          Address,
          PrefetchHooks Function({bool companyId})
        > {
  $$AddressesTableTableManager(_$AppDatabase db, $AddressesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AddressesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AddressesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AddressesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> companyId = const Value.absent(),
                Value<String?> nombre = const Value.absent(),
                Value<String> ubigeo = const Value.absent(),
                Value<String> direccion = const Value.absent(),
                Value<String?> codigoLocal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AddressesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                nombre: nombre,
                ubigeo: ubigeo,
                direccion: direccion,
                codigoLocal: codigoLocal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String companyId,
                Value<String?> nombre = const Value.absent(),
                required String ubigeo,
                required String direccion,
                Value<String?> codigoLocal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AddressesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                companyId: companyId,
                nombre: nombre,
                ubigeo: ubigeo,
                direccion: direccion,
                codigoLocal: codigoLocal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AddressesTable, Address>(table),
                  $$AddressesTableReferences(db, table, e),
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
                        referencedTable: $$AddressesTableReferences
                            ._companyIdTable(db),
                        referencedColumn: $$AddressesTableReferences
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

typedef $$AddressesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AddressesTable,
      Address,
      $$AddressesTableFilterComposer,
      $$AddressesTableOrderingComposer,
      $$AddressesTableAnnotationComposer,
      $$AddressesTableCreateCompanionBuilder,
      $$AddressesTableUpdateCompanionBuilder,
      (Address, $$AddressesTableReferences),
      Address,
      PrefetchHooks Function({bool companyId})
    >;
typedef $$DeliveriesTableCreateCompanionBuilder = DeliveriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  required String documentId,
  required DeliveryChannel channel,
  Value<String?> recipient,
  required String deviceId,
  Value<int> rowid,
});
typedef $$DeliveriesTableUpdateCompanionBuilder = DeliveriesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<String> documentId,
  Value<DeliveryChannel> channel,
  Value<String?> recipient,
  Value<String> deviceId,
  Value<int> rowid,
});

final class $$DeliveriesTableReferences
    extends BaseReferences<_$AppDatabase, $DeliveriesTable, Delivery> {
  $$DeliveriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _documentIdTable(_$AppDatabase db) =>
      db.documents.createAlias('deliveries__document_id__documents__id');

  $$DocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<String>('document_id')!;

    final manager = $$DocumentsTableTableManager(
      $_db,
      $_db.documents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DeliveriesTableFilterComposer
    extends Composer<_$AppDatabase, $DeliveriesTable> {
  $$DeliveriesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DeliveryChannel, DeliveryChannel, String>
  get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get recipient => $composableBuilder(
    column: $table.recipient,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentsTableFilterComposer get documentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableFilterComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeliveriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DeliveriesTable> {
  $$DeliveriesTableOrderingComposer({
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

  ColumnOrderings<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipient => $composableBuilder(
    column: $table.recipient,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentsTableOrderingComposer get documentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableOrderingComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeliveriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeliveriesTable> {
  $$DeliveriesTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<DeliveryChannel, String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<String> get recipient =>
      $composableBuilder(column: $table.recipient, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get documentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.documentId,
      referencedTable: $db.documents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentsTableAnnotationComposer(
            $db: $db,
            $table: $db.documents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DeliveriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeliveriesTable,
          Delivery,
          $$DeliveriesTableFilterComposer,
          $$DeliveriesTableOrderingComposer,
          $$DeliveriesTableAnnotationComposer,
          $$DeliveriesTableCreateCompanionBuilder,
          $$DeliveriesTableUpdateCompanionBuilder,
          (Delivery, $$DeliveriesTableReferences),
          Delivery,
          PrefetchHooks Function({bool documentId})
        > {
  $$DeliveriesTableTableManager(_$AppDatabase db, $DeliveriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeliveriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeliveriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeliveriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<String> documentId = const Value.absent(),
                Value<DeliveryChannel> channel = const Value.absent(),
                Value<String?> recipient = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeliveriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                documentId: documentId,
                channel: channel,
                recipient: recipient,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required String documentId,
                required DeliveryChannel channel,
                Value<String?> recipient = const Value.absent(),
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => DeliveriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                documentId: documentId,
                channel: channel,
                recipient: recipient,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeliveriesTable, Delivery>(table),
                  $$DeliveriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({documentId = false}) {
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
                    if (documentId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.documentId,
                        referencedTable: $$DeliveriesTableReferences
                            ._documentIdTable(db),
                        referencedColumn: $$DeliveriesTableReferences
                            ._documentIdTable(db)
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

typedef $$DeliveriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeliveriesTable,
      Delivery,
      $$DeliveriesTableFilterComposer,
      $$DeliveriesTableOrderingComposer,
      $$DeliveriesTableAnnotationComposer,
      $$DeliveriesTableCreateCompanionBuilder,
      $$DeliveriesTableUpdateCompanionBuilder,
      (Delivery, $$DeliveriesTableReferences),
      Delivery,
      PrefetchHooks Function({bool documentId})
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
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$DocumentFilesTableTableManager get documentFiles =>
      $$DocumentFilesTableTableManager(_db, _db.documentFiles);
  $$DocumentEventsTableTableManager get documentEvents =>
      $$DocumentEventsTableTableManager(_db, _db.documentEvents);
  $$DeviceSettingsTableTableManager get deviceSettings =>
      $$DeviceSettingsTableTableManager(_db, _db.deviceSettings);
  $$VehiclesTableTableManager get vehicles =>
      $$VehiclesTableTableManager(_db, _db.vehicles);
  $$DriversTableTableManager get drivers =>
      $$DriversTableTableManager(_db, _db.drivers);
  $$AddressesTableTableManager get addresses =>
      $$AddressesTableTableManager(_db, _db.addresses);
  $$DeliveriesTableTableManager get deliveries =>
      $$DeliveriesTableTableManager(_db, _db.deliveries);
}
