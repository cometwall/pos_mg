// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class Terminal extends Table with TableInfo<Terminal, TerminalData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Terminal(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, codigo, activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'terminal';
  @override
  VerificationContext validateIntegrity(
    Insertable<TerminalData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    } else if (isInserting) {
      context.missing(_codigoMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TerminalData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TerminalData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  Terminal createAlias(String alias) {
    return Terminal(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TerminalData extends DataClass implements Insertable<TerminalData> {
  final int id;
  final String nombre;
  final String codigo;
  final int activo;
  const TerminalData({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['codigo'] = Variable<String>(codigo);
    map['activo'] = Variable<int>(activo);
    return map;
  }

  TerminalCompanion toCompanion(bool nullToAbsent) {
    return TerminalCompanion(
      id: Value(id),
      nombre: Value(nombre),
      codigo: Value(codigo),
      activo: Value(activo),
    );
  }

  factory TerminalData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TerminalData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigo: serializer.fromJson<String>(json['codigo']),
      activo: serializer.fromJson<int>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'codigo': serializer.toJson<String>(codigo),
      'activo': serializer.toJson<int>(activo),
    };
  }

  TerminalData copyWith({
    int? id,
    String? nombre,
    String? codigo,
    int? activo,
  }) => TerminalData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    activo: activo ?? this.activo,
  );
  TerminalData copyWithCompanion(TerminalCompanion data) {
    return TerminalData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TerminalData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, codigo, activo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TerminalData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.codigo == this.codigo &&
          other.activo == this.activo);
}

class TerminalCompanion extends UpdateCompanion<TerminalData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> codigo;
  final Value<int> activo;
  const TerminalCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigo = const Value.absent(),
    this.activo = const Value.absent(),
  });
  TerminalCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String codigo,
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre),
       codigo = Value(codigo);
  static Insertable<TerminalData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? codigo,
    Expression<int>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (codigo != null) 'codigo': codigo,
      if (activo != null) 'activo': activo,
    });
  }

  TerminalCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? codigo,
    Value<int>? activo,
  }) {
    return TerminalCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TerminalCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('codigo: $codigo, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class Usuario extends Table with TableInfo<Usuario, UsuarioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Usuario(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _rolMeta = const VerificationMeta('rol');
  late final GeneratedColumn<String> rol = GeneratedColumn<String>(
    'rol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (rol IN (\'DUEÑO\', \'CAJERO\'))',
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  late final GeneratedColumn<String> creadoEn = GeneratedColumn<String>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre, rol, activo, creadoEn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuario';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsuarioData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('rol')) {
      context.handle(
        _rolMeta,
        rol.isAcceptableOrUnknown(data['rol']!, _rolMeta),
      );
    } else if (isInserting) {
      context.missing(_rolMeta);
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsuarioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsuarioData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      rol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rol'],
      )!,
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  Usuario createAlias(String alias) {
    return Usuario(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class UsuarioData extends DataClass implements Insertable<UsuarioData> {
  final int id;
  final String nombre;
  final String rol;
  final int activo;
  final String creadoEn;
  const UsuarioData({
    required this.id,
    required this.nombre,
    required this.rol,
    required this.activo,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['rol'] = Variable<String>(rol);
    map['activo'] = Variable<int>(activo);
    map['creado_en'] = Variable<String>(creadoEn);
    return map;
  }

  UsuarioCompanion toCompanion(bool nullToAbsent) {
    return UsuarioCompanion(
      id: Value(id),
      nombre: Value(nombre),
      rol: Value(rol),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
    );
  }

  factory UsuarioData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsuarioData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      rol: serializer.fromJson<String>(json['rol']),
      activo: serializer.fromJson<int>(json['activo']),
      creadoEn: serializer.fromJson<String>(json['creado_en']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'rol': serializer.toJson<String>(rol),
      'activo': serializer.toJson<int>(activo),
      'creado_en': serializer.toJson<String>(creadoEn),
    };
  }

  UsuarioData copyWith({
    int? id,
    String? nombre,
    String? rol,
    int? activo,
    String? creadoEn,
  }) => UsuarioData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    rol: rol ?? this.rol,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  UsuarioData copyWithCompanion(UsuarioCompanion data) {
    return UsuarioData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      rol: data.rol.present ? data.rol.value : this.rol,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsuarioData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('rol: $rol, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, rol, activo, creadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsuarioData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.rol == this.rol &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn);
}

class UsuarioCompanion extends UpdateCompanion<UsuarioData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> rol;
  final Value<int> activo;
  final Value<String> creadoEn;
  const UsuarioCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.rol = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  UsuarioCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String rol,
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       rol = Value(rol);
  static Insertable<UsuarioData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? rol,
    Expression<int>? activo,
    Expression<String>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (rol != null) 'rol': rol,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  UsuarioCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? rol,
    Value<int>? activo,
    Value<String>? creadoEn,
  }) {
    return UsuarioCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      rol: rol ?? this.rol,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (rol.present) {
      map['rol'] = Variable<String>(rol.value);
    }
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<String>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuarioCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('rol: $rol, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class CajaSesion extends Table with TableInfo<CajaSesion, CajaSesionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CajaSesion(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _terminalIdMeta = const VerificationMeta(
    'terminalId',
  );
  late final GeneratedColumn<int> terminalId = GeneratedColumn<int>(
    'terminal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES terminal(id)',
  );
  static const VerificationMeta _usuarioAperturaIdMeta = const VerificationMeta(
    'usuarioAperturaId',
  );
  late final GeneratedColumn<int> usuarioAperturaId = GeneratedColumn<int>(
    'usuario_apertura_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _usuarioCierreIdMeta = const VerificationMeta(
    'usuarioCierreId',
  );
  late final GeneratedColumn<int> usuarioCierreId = GeneratedColumn<int>(
    'usuario_cierre_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaAperturaMeta = const VerificationMeta(
    'fechaApertura',
  );
  late final GeneratedColumn<String> fechaApertura = GeneratedColumn<String>(
    'fecha_apertura',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  static const VerificationMeta _efectivoInicialCentavosMeta =
      const VerificationMeta('efectivoInicialCentavos');
  late final GeneratedColumn<int> efectivoInicialCentavos =
      GeneratedColumn<int>(
        'efectivo_inicial_centavos',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
        $customConstraints: 'NOT NULL CHECK (efectivo_inicial_centavos >= 0)',
      );
  static const VerificationMeta _fechaCierreMeta = const VerificationMeta(
    'fechaCierre',
  );
  late final GeneratedColumn<String> fechaCierre = GeneratedColumn<String>(
    'fecha_cierre',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _efectivoEsperadoCentavosMeta =
      const VerificationMeta('efectivoEsperadoCentavos');
  late final GeneratedColumn<int> efectivoEsperadoCentavos =
      GeneratedColumn<int>(
        'efectivo_esperado_centavos',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  static const VerificationMeta _efectivoContadoCentavosMeta =
      const VerificationMeta('efectivoContadoCentavos');
  late final GeneratedColumn<int> efectivoContadoCentavos =
      GeneratedColumn<int>(
        'efectivo_contado_centavos',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  static const VerificationMeta _diferenciaCentavosMeta =
      const VerificationMeta('diferenciaCentavos');
  late final GeneratedColumn<int> diferenciaCentavos = GeneratedColumn<int>(
    'diferencia_centavos',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'ABIERTA\' CHECK (estado IN (\'ABIERTA\', \'CERRADA\'))',
    defaultValue: const CustomExpression('\'ABIERTA\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    terminalId,
    usuarioAperturaId,
    usuarioCierreId,
    fechaApertura,
    efectivoInicialCentavos,
    fechaCierre,
    efectivoEsperadoCentavos,
    efectivoContadoCentavos,
    diferenciaCentavos,
    estado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'caja_sesion';
  @override
  VerificationContext validateIntegrity(
    Insertable<CajaSesionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
        _terminalIdMeta,
        terminalId.isAcceptableOrUnknown(data['terminal_id']!, _terminalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_terminalIdMeta);
    }
    if (data.containsKey('usuario_apertura_id')) {
      context.handle(
        _usuarioAperturaIdMeta,
        usuarioAperturaId.isAcceptableOrUnknown(
          data['usuario_apertura_id']!,
          _usuarioAperturaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_usuarioAperturaIdMeta);
    }
    if (data.containsKey('usuario_cierre_id')) {
      context.handle(
        _usuarioCierreIdMeta,
        usuarioCierreId.isAcceptableOrUnknown(
          data['usuario_cierre_id']!,
          _usuarioCierreIdMeta,
        ),
      );
    }
    if (data.containsKey('fecha_apertura')) {
      context.handle(
        _fechaAperturaMeta,
        fechaApertura.isAcceptableOrUnknown(
          data['fecha_apertura']!,
          _fechaAperturaMeta,
        ),
      );
    }
    if (data.containsKey('efectivo_inicial_centavos')) {
      context.handle(
        _efectivoInicialCentavosMeta,
        efectivoInicialCentavos.isAcceptableOrUnknown(
          data['efectivo_inicial_centavos']!,
          _efectivoInicialCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_efectivoInicialCentavosMeta);
    }
    if (data.containsKey('fecha_cierre')) {
      context.handle(
        _fechaCierreMeta,
        fechaCierre.isAcceptableOrUnknown(
          data['fecha_cierre']!,
          _fechaCierreMeta,
        ),
      );
    }
    if (data.containsKey('efectivo_esperado_centavos')) {
      context.handle(
        _efectivoEsperadoCentavosMeta,
        efectivoEsperadoCentavos.isAcceptableOrUnknown(
          data['efectivo_esperado_centavos']!,
          _efectivoEsperadoCentavosMeta,
        ),
      );
    }
    if (data.containsKey('efectivo_contado_centavos')) {
      context.handle(
        _efectivoContadoCentavosMeta,
        efectivoContadoCentavos.isAcceptableOrUnknown(
          data['efectivo_contado_centavos']!,
          _efectivoContadoCentavosMeta,
        ),
      );
    }
    if (data.containsKey('diferencia_centavos')) {
      context.handle(
        _diferenciaCentavosMeta,
        diferenciaCentavos.isAcceptableOrUnknown(
          data['diferencia_centavos']!,
          _diferenciaCentavosMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CajaSesionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CajaSesionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      terminalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}terminal_id'],
      )!,
      usuarioAperturaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_apertura_id'],
      )!,
      usuarioCierreId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_cierre_id'],
      ),
      fechaApertura: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_apertura'],
      )!,
      efectivoInicialCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}efectivo_inicial_centavos'],
      )!,
      fechaCierre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha_cierre'],
      ),
      efectivoEsperadoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}efectivo_esperado_centavos'],
      ),
      efectivoContadoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}efectivo_contado_centavos'],
      ),
      diferenciaCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diferencia_centavos'],
      ),
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
    );
  }

  @override
  CajaSesion createAlias(String alias) {
    return CajaSesion(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK((estado = \'ABIERTA\' AND fecha_cierre IS NULL AND usuario_cierre_id IS NULL AND efectivo_esperado_centavos IS NULL AND efectivo_contado_centavos IS NULL AND diferencia_centavos IS NULL)OR(estado = \'CERRADA\' AND fecha_cierre IS NOT NULL AND usuario_cierre_id IS NOT NULL AND efectivo_esperado_centavos IS NOT NULL AND efectivo_contado_centavos IS NOT NULL AND diferencia_centavos IS NOT NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class CajaSesionData extends DataClass implements Insertable<CajaSesionData> {
  final int id;
  final int terminalId;
  final int usuarioAperturaId;
  final int? usuarioCierreId;
  final String fechaApertura;
  final int efectivoInicialCentavos;
  final String? fechaCierre;
  final int? efectivoEsperadoCentavos;
  final int? efectivoContadoCentavos;
  final int? diferenciaCentavos;
  final String estado;
  const CajaSesionData({
    required this.id,
    required this.terminalId,
    required this.usuarioAperturaId,
    this.usuarioCierreId,
    required this.fechaApertura,
    required this.efectivoInicialCentavos,
    this.fechaCierre,
    this.efectivoEsperadoCentavos,
    this.efectivoContadoCentavos,
    this.diferenciaCentavos,
    required this.estado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['terminal_id'] = Variable<int>(terminalId);
    map['usuario_apertura_id'] = Variable<int>(usuarioAperturaId);
    if (!nullToAbsent || usuarioCierreId != null) {
      map['usuario_cierre_id'] = Variable<int>(usuarioCierreId);
    }
    map['fecha_apertura'] = Variable<String>(fechaApertura);
    map['efectivo_inicial_centavos'] = Variable<int>(efectivoInicialCentavos);
    if (!nullToAbsent || fechaCierre != null) {
      map['fecha_cierre'] = Variable<String>(fechaCierre);
    }
    if (!nullToAbsent || efectivoEsperadoCentavos != null) {
      map['efectivo_esperado_centavos'] = Variable<int>(
        efectivoEsperadoCentavos,
      );
    }
    if (!nullToAbsent || efectivoContadoCentavos != null) {
      map['efectivo_contado_centavos'] = Variable<int>(efectivoContadoCentavos);
    }
    if (!nullToAbsent || diferenciaCentavos != null) {
      map['diferencia_centavos'] = Variable<int>(diferenciaCentavos);
    }
    map['estado'] = Variable<String>(estado);
    return map;
  }

  CajaSesionCompanion toCompanion(bool nullToAbsent) {
    return CajaSesionCompanion(
      id: Value(id),
      terminalId: Value(terminalId),
      usuarioAperturaId: Value(usuarioAperturaId),
      usuarioCierreId: usuarioCierreId == null && nullToAbsent
          ? const Value.absent()
          : Value(usuarioCierreId),
      fechaApertura: Value(fechaApertura),
      efectivoInicialCentavos: Value(efectivoInicialCentavos),
      fechaCierre: fechaCierre == null && nullToAbsent
          ? const Value.absent()
          : Value(fechaCierre),
      efectivoEsperadoCentavos: efectivoEsperadoCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(efectivoEsperadoCentavos),
      efectivoContadoCentavos: efectivoContadoCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(efectivoContadoCentavos),
      diferenciaCentavos: diferenciaCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(diferenciaCentavos),
      estado: Value(estado),
    );
  }

  factory CajaSesionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CajaSesionData(
      id: serializer.fromJson<int>(json['id']),
      terminalId: serializer.fromJson<int>(json['terminal_id']),
      usuarioAperturaId: serializer.fromJson<int>(json['usuario_apertura_id']),
      usuarioCierreId: serializer.fromJson<int?>(json['usuario_cierre_id']),
      fechaApertura: serializer.fromJson<String>(json['fecha_apertura']),
      efectivoInicialCentavos: serializer.fromJson<int>(
        json['efectivo_inicial_centavos'],
      ),
      fechaCierre: serializer.fromJson<String?>(json['fecha_cierre']),
      efectivoEsperadoCentavos: serializer.fromJson<int?>(
        json['efectivo_esperado_centavos'],
      ),
      efectivoContadoCentavos: serializer.fromJson<int?>(
        json['efectivo_contado_centavos'],
      ),
      diferenciaCentavos: serializer.fromJson<int?>(
        json['diferencia_centavos'],
      ),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'terminal_id': serializer.toJson<int>(terminalId),
      'usuario_apertura_id': serializer.toJson<int>(usuarioAperturaId),
      'usuario_cierre_id': serializer.toJson<int?>(usuarioCierreId),
      'fecha_apertura': serializer.toJson<String>(fechaApertura),
      'efectivo_inicial_centavos': serializer.toJson<int>(
        efectivoInicialCentavos,
      ),
      'fecha_cierre': serializer.toJson<String?>(fechaCierre),
      'efectivo_esperado_centavos': serializer.toJson<int?>(
        efectivoEsperadoCentavos,
      ),
      'efectivo_contado_centavos': serializer.toJson<int?>(
        efectivoContadoCentavos,
      ),
      'diferencia_centavos': serializer.toJson<int?>(diferenciaCentavos),
      'estado': serializer.toJson<String>(estado),
    };
  }

  CajaSesionData copyWith({
    int? id,
    int? terminalId,
    int? usuarioAperturaId,
    Value<int?> usuarioCierreId = const Value.absent(),
    String? fechaApertura,
    int? efectivoInicialCentavos,
    Value<String?> fechaCierre = const Value.absent(),
    Value<int?> efectivoEsperadoCentavos = const Value.absent(),
    Value<int?> efectivoContadoCentavos = const Value.absent(),
    Value<int?> diferenciaCentavos = const Value.absent(),
    String? estado,
  }) => CajaSesionData(
    id: id ?? this.id,
    terminalId: terminalId ?? this.terminalId,
    usuarioAperturaId: usuarioAperturaId ?? this.usuarioAperturaId,
    usuarioCierreId: usuarioCierreId.present
        ? usuarioCierreId.value
        : this.usuarioCierreId,
    fechaApertura: fechaApertura ?? this.fechaApertura,
    efectivoInicialCentavos:
        efectivoInicialCentavos ?? this.efectivoInicialCentavos,
    fechaCierre: fechaCierre.present ? fechaCierre.value : this.fechaCierre,
    efectivoEsperadoCentavos: efectivoEsperadoCentavos.present
        ? efectivoEsperadoCentavos.value
        : this.efectivoEsperadoCentavos,
    efectivoContadoCentavos: efectivoContadoCentavos.present
        ? efectivoContadoCentavos.value
        : this.efectivoContadoCentavos,
    diferenciaCentavos: diferenciaCentavos.present
        ? diferenciaCentavos.value
        : this.diferenciaCentavos,
    estado: estado ?? this.estado,
  );
  CajaSesionData copyWithCompanion(CajaSesionCompanion data) {
    return CajaSesionData(
      id: data.id.present ? data.id.value : this.id,
      terminalId: data.terminalId.present
          ? data.terminalId.value
          : this.terminalId,
      usuarioAperturaId: data.usuarioAperturaId.present
          ? data.usuarioAperturaId.value
          : this.usuarioAperturaId,
      usuarioCierreId: data.usuarioCierreId.present
          ? data.usuarioCierreId.value
          : this.usuarioCierreId,
      fechaApertura: data.fechaApertura.present
          ? data.fechaApertura.value
          : this.fechaApertura,
      efectivoInicialCentavos: data.efectivoInicialCentavos.present
          ? data.efectivoInicialCentavos.value
          : this.efectivoInicialCentavos,
      fechaCierre: data.fechaCierre.present
          ? data.fechaCierre.value
          : this.fechaCierre,
      efectivoEsperadoCentavos: data.efectivoEsperadoCentavos.present
          ? data.efectivoEsperadoCentavos.value
          : this.efectivoEsperadoCentavos,
      efectivoContadoCentavos: data.efectivoContadoCentavos.present
          ? data.efectivoContadoCentavos.value
          : this.efectivoContadoCentavos,
      diferenciaCentavos: data.diferenciaCentavos.present
          ? data.diferenciaCentavos.value
          : this.diferenciaCentavos,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CajaSesionData(')
          ..write('id: $id, ')
          ..write('terminalId: $terminalId, ')
          ..write('usuarioAperturaId: $usuarioAperturaId, ')
          ..write('usuarioCierreId: $usuarioCierreId, ')
          ..write('fechaApertura: $fechaApertura, ')
          ..write('efectivoInicialCentavos: $efectivoInicialCentavos, ')
          ..write('fechaCierre: $fechaCierre, ')
          ..write('efectivoEsperadoCentavos: $efectivoEsperadoCentavos, ')
          ..write('efectivoContadoCentavos: $efectivoContadoCentavos, ')
          ..write('diferenciaCentavos: $diferenciaCentavos, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    terminalId,
    usuarioAperturaId,
    usuarioCierreId,
    fechaApertura,
    efectivoInicialCentavos,
    fechaCierre,
    efectivoEsperadoCentavos,
    efectivoContadoCentavos,
    diferenciaCentavos,
    estado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CajaSesionData &&
          other.id == this.id &&
          other.terminalId == this.terminalId &&
          other.usuarioAperturaId == this.usuarioAperturaId &&
          other.usuarioCierreId == this.usuarioCierreId &&
          other.fechaApertura == this.fechaApertura &&
          other.efectivoInicialCentavos == this.efectivoInicialCentavos &&
          other.fechaCierre == this.fechaCierre &&
          other.efectivoEsperadoCentavos == this.efectivoEsperadoCentavos &&
          other.efectivoContadoCentavos == this.efectivoContadoCentavos &&
          other.diferenciaCentavos == this.diferenciaCentavos &&
          other.estado == this.estado);
}

class CajaSesionCompanion extends UpdateCompanion<CajaSesionData> {
  final Value<int> id;
  final Value<int> terminalId;
  final Value<int> usuarioAperturaId;
  final Value<int?> usuarioCierreId;
  final Value<String> fechaApertura;
  final Value<int> efectivoInicialCentavos;
  final Value<String?> fechaCierre;
  final Value<int?> efectivoEsperadoCentavos;
  final Value<int?> efectivoContadoCentavos;
  final Value<int?> diferenciaCentavos;
  final Value<String> estado;
  const CajaSesionCompanion({
    this.id = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.usuarioAperturaId = const Value.absent(),
    this.usuarioCierreId = const Value.absent(),
    this.fechaApertura = const Value.absent(),
    this.efectivoInicialCentavos = const Value.absent(),
    this.fechaCierre = const Value.absent(),
    this.efectivoEsperadoCentavos = const Value.absent(),
    this.efectivoContadoCentavos = const Value.absent(),
    this.diferenciaCentavos = const Value.absent(),
    this.estado = const Value.absent(),
  });
  CajaSesionCompanion.insert({
    this.id = const Value.absent(),
    required int terminalId,
    required int usuarioAperturaId,
    this.usuarioCierreId = const Value.absent(),
    this.fechaApertura = const Value.absent(),
    required int efectivoInicialCentavos,
    this.fechaCierre = const Value.absent(),
    this.efectivoEsperadoCentavos = const Value.absent(),
    this.efectivoContadoCentavos = const Value.absent(),
    this.diferenciaCentavos = const Value.absent(),
    this.estado = const Value.absent(),
  }) : terminalId = Value(terminalId),
       usuarioAperturaId = Value(usuarioAperturaId),
       efectivoInicialCentavos = Value(efectivoInicialCentavos);
  static Insertable<CajaSesionData> custom({
    Expression<int>? id,
    Expression<int>? terminalId,
    Expression<int>? usuarioAperturaId,
    Expression<int>? usuarioCierreId,
    Expression<String>? fechaApertura,
    Expression<int>? efectivoInicialCentavos,
    Expression<String>? fechaCierre,
    Expression<int>? efectivoEsperadoCentavos,
    Expression<int>? efectivoContadoCentavos,
    Expression<int>? diferenciaCentavos,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (terminalId != null) 'terminal_id': terminalId,
      if (usuarioAperturaId != null) 'usuario_apertura_id': usuarioAperturaId,
      if (usuarioCierreId != null) 'usuario_cierre_id': usuarioCierreId,
      if (fechaApertura != null) 'fecha_apertura': fechaApertura,
      if (efectivoInicialCentavos != null)
        'efectivo_inicial_centavos': efectivoInicialCentavos,
      if (fechaCierre != null) 'fecha_cierre': fechaCierre,
      if (efectivoEsperadoCentavos != null)
        'efectivo_esperado_centavos': efectivoEsperadoCentavos,
      if (efectivoContadoCentavos != null)
        'efectivo_contado_centavos': efectivoContadoCentavos,
      if (diferenciaCentavos != null) 'diferencia_centavos': diferenciaCentavos,
      if (estado != null) 'estado': estado,
    });
  }

  CajaSesionCompanion copyWith({
    Value<int>? id,
    Value<int>? terminalId,
    Value<int>? usuarioAperturaId,
    Value<int?>? usuarioCierreId,
    Value<String>? fechaApertura,
    Value<int>? efectivoInicialCentavos,
    Value<String?>? fechaCierre,
    Value<int?>? efectivoEsperadoCentavos,
    Value<int?>? efectivoContadoCentavos,
    Value<int?>? diferenciaCentavos,
    Value<String>? estado,
  }) {
    return CajaSesionCompanion(
      id: id ?? this.id,
      terminalId: terminalId ?? this.terminalId,
      usuarioAperturaId: usuarioAperturaId ?? this.usuarioAperturaId,
      usuarioCierreId: usuarioCierreId ?? this.usuarioCierreId,
      fechaApertura: fechaApertura ?? this.fechaApertura,
      efectivoInicialCentavos:
          efectivoInicialCentavos ?? this.efectivoInicialCentavos,
      fechaCierre: fechaCierre ?? this.fechaCierre,
      efectivoEsperadoCentavos:
          efectivoEsperadoCentavos ?? this.efectivoEsperadoCentavos,
      efectivoContadoCentavos:
          efectivoContadoCentavos ?? this.efectivoContadoCentavos,
      diferenciaCentavos: diferenciaCentavos ?? this.diferenciaCentavos,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<int>(terminalId.value);
    }
    if (usuarioAperturaId.present) {
      map['usuario_apertura_id'] = Variable<int>(usuarioAperturaId.value);
    }
    if (usuarioCierreId.present) {
      map['usuario_cierre_id'] = Variable<int>(usuarioCierreId.value);
    }
    if (fechaApertura.present) {
      map['fecha_apertura'] = Variable<String>(fechaApertura.value);
    }
    if (efectivoInicialCentavos.present) {
      map['efectivo_inicial_centavos'] = Variable<int>(
        efectivoInicialCentavos.value,
      );
    }
    if (fechaCierre.present) {
      map['fecha_cierre'] = Variable<String>(fechaCierre.value);
    }
    if (efectivoEsperadoCentavos.present) {
      map['efectivo_esperado_centavos'] = Variable<int>(
        efectivoEsperadoCentavos.value,
      );
    }
    if (efectivoContadoCentavos.present) {
      map['efectivo_contado_centavos'] = Variable<int>(
        efectivoContadoCentavos.value,
      );
    }
    if (diferenciaCentavos.present) {
      map['diferencia_centavos'] = Variable<int>(diferenciaCentavos.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CajaSesionCompanion(')
          ..write('id: $id, ')
          ..write('terminalId: $terminalId, ')
          ..write('usuarioAperturaId: $usuarioAperturaId, ')
          ..write('usuarioCierreId: $usuarioCierreId, ')
          ..write('fechaApertura: $fechaApertura, ')
          ..write('efectivoInicialCentavos: $efectivoInicialCentavos, ')
          ..write('fechaCierre: $fechaCierre, ')
          ..write('efectivoEsperadoCentavos: $efectivoEsperadoCentavos, ')
          ..write('efectivoContadoCentavos: $efectivoContadoCentavos, ')
          ..write('diferenciaCentavos: $diferenciaCentavos, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class Categoria extends Table with TableInfo<Categoria, CategoriaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categoria(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categoria';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  Categoria createAlias(String alias) {
    return Categoria(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CategoriaData extends DataClass implements Insertable<CategoriaData> {
  final int id;
  final String nombre;
  const CategoriaData({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  CategoriaCompanion toCompanion(bool nullToAbsent) {
    return CategoriaCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory CategoriaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriaData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  CategoriaData copyWith({int? id, String? nombre}) =>
      CategoriaData(id: id ?? this.id, nombre: nombre ?? this.nombre);
  CategoriaData copyWithCompanion(CategoriaCompanion data) {
    return CategoriaData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriaData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriaData &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class CategoriaCompanion extends UpdateCompanion<CategoriaData> {
  final Value<int> id;
  final Value<String> nombre;
  const CategoriaCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  CategoriaCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<CategoriaData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  CategoriaCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return CategoriaCompanion(id: id ?? this.id, nombre: nombre ?? this.nombre);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriaCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class TipoEnvase extends Table with TableInfo<TipoEnvase, TipoEnvaseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TipoEnvase(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _valorDepositoCentavosMeta =
      const VerificationMeta('valorDepositoCentavos');
  late final GeneratedColumn<int> valorDepositoCentavos = GeneratedColumn<int>(
    'valor_deposito_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT 0 CHECK (valor_deposito_centavos >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _valorReposicionCentavosMeta =
      const VerificationMeta('valorReposicionCentavos');
  late final GeneratedColumn<int> valorReposicionCentavos =
      GeneratedColumn<int>(
        'valor_reposicion_centavos',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        $customConstraints: 'CHECK (valor_reposicion_centavos IS NULL OR valor_reposicion_centavos >= 0)',
      );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))',
    defaultValue: const CustomExpression('1'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    valorDepositoCentavos,
    valorReposicionCentavos,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tipo_envase';
  @override
  VerificationContext validateIntegrity(
    Insertable<TipoEnvaseData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('valor_deposito_centavos')) {
      context.handle(
        _valorDepositoCentavosMeta,
        valorDepositoCentavos.isAcceptableOrUnknown(
          data['valor_deposito_centavos']!,
          _valorDepositoCentavosMeta,
        ),
      );
    }
    if (data.containsKey('valor_reposicion_centavos')) {
      context.handle(
        _valorReposicionCentavosMeta,
        valorReposicionCentavos.isAcceptableOrUnknown(
          data['valor_reposicion_centavos']!,
          _valorReposicionCentavosMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TipoEnvaseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TipoEnvaseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      valorDepositoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_deposito_centavos'],
      )!,
      valorReposicionCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}valor_reposicion_centavos'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  TipoEnvase createAlias(String alias) {
    return TipoEnvase(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TipoEnvaseData extends DataClass implements Insertable<TipoEnvaseData> {
  final int id;
  final String nombre;
  final int valorDepositoCentavos;
  final int? valorReposicionCentavos;
  final int activo;
  const TipoEnvaseData({
    required this.id,
    required this.nombre,
    required this.valorDepositoCentavos,
    this.valorReposicionCentavos,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['valor_deposito_centavos'] = Variable<int>(valorDepositoCentavos);
    if (!nullToAbsent || valorReposicionCentavos != null) {
      map['valor_reposicion_centavos'] = Variable<int>(valorReposicionCentavos);
    }
    map['activo'] = Variable<int>(activo);
    return map;
  }

  TipoEnvaseCompanion toCompanion(bool nullToAbsent) {
    return TipoEnvaseCompanion(
      id: Value(id),
      nombre: Value(nombre),
      valorDepositoCentavos: Value(valorDepositoCentavos),
      valorReposicionCentavos: valorReposicionCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(valorReposicionCentavos),
      activo: Value(activo),
    );
  }

  factory TipoEnvaseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TipoEnvaseData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      valorDepositoCentavos: serializer.fromJson<int>(
        json['valor_deposito_centavos'],
      ),
      valorReposicionCentavos: serializer.fromJson<int?>(
        json['valor_reposicion_centavos'],
      ),
      activo: serializer.fromJson<int>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'valor_deposito_centavos': serializer.toJson<int>(valorDepositoCentavos),
      'valor_reposicion_centavos': serializer.toJson<int?>(
        valorReposicionCentavos,
      ),
      'activo': serializer.toJson<int>(activo),
    };
  }

  TipoEnvaseData copyWith({
    int? id,
    String? nombre,
    int? valorDepositoCentavos,
    Value<int?> valorReposicionCentavos = const Value.absent(),
    int? activo,
  }) => TipoEnvaseData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    valorDepositoCentavos: valorDepositoCentavos ?? this.valorDepositoCentavos,
    valorReposicionCentavos: valorReposicionCentavos.present
        ? valorReposicionCentavos.value
        : this.valorReposicionCentavos,
    activo: activo ?? this.activo,
  );
  TipoEnvaseData copyWithCompanion(TipoEnvaseCompanion data) {
    return TipoEnvaseData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      valorDepositoCentavos: data.valorDepositoCentavos.present
          ? data.valorDepositoCentavos.value
          : this.valorDepositoCentavos,
      valorReposicionCentavos: data.valorReposicionCentavos.present
          ? data.valorReposicionCentavos.value
          : this.valorReposicionCentavos,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TipoEnvaseData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('valorDepositoCentavos: $valorDepositoCentavos, ')
          ..write('valorReposicionCentavos: $valorReposicionCentavos, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    valorDepositoCentavos,
    valorReposicionCentavos,
    activo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TipoEnvaseData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.valorDepositoCentavos == this.valorDepositoCentavos &&
          other.valorReposicionCentavos == this.valorReposicionCentavos &&
          other.activo == this.activo);
}

class TipoEnvaseCompanion extends UpdateCompanion<TipoEnvaseData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<int> valorDepositoCentavos;
  final Value<int?> valorReposicionCentavos;
  final Value<int> activo;
  const TipoEnvaseCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.valorDepositoCentavos = const Value.absent(),
    this.valorReposicionCentavos = const Value.absent(),
    this.activo = const Value.absent(),
  });
  TipoEnvaseCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.valorDepositoCentavos = const Value.absent(),
    this.valorReposicionCentavos = const Value.absent(),
    this.activo = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<TipoEnvaseData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<int>? valorDepositoCentavos,
    Expression<int>? valorReposicionCentavos,
    Expression<int>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (valorDepositoCentavos != null)
        'valor_deposito_centavos': valorDepositoCentavos,
      if (valorReposicionCentavos != null)
        'valor_reposicion_centavos': valorReposicionCentavos,
      if (activo != null) 'activo': activo,
    });
  }

  TipoEnvaseCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<int>? valorDepositoCentavos,
    Value<int?>? valorReposicionCentavos,
    Value<int>? activo,
  }) {
    return TipoEnvaseCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      valorDepositoCentavos:
          valorDepositoCentavos ?? this.valorDepositoCentavos,
      valorReposicionCentavos:
          valorReposicionCentavos ?? this.valorReposicionCentavos,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (valorDepositoCentavos.present) {
      map['valor_deposito_centavos'] = Variable<int>(
        valorDepositoCentavos.value,
      );
    }
    if (valorReposicionCentavos.present) {
      map['valor_reposicion_centavos'] = Variable<int>(
        valorReposicionCentavos.value,
      );
    }
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TipoEnvaseCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('valorDepositoCentavos: $valorDepositoCentavos, ')
          ..write('valorReposicionCentavos: $valorReposicionCentavos, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class Producto extends Table with TableInfo<Producto, ProductoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Producto(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES categoria(id)',
  );
  static const VerificationMeta _tipoEnvaseIdMeta = const VerificationMeta(
    'tipoEnvaseId',
  );
  late final GeneratedColumn<int> tipoEnvaseId = GeneratedColumn<int>(
    'tipo_envase_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES tipo_envase(id)',
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _codigoBarrasMeta = const VerificationMeta(
    'codigoBarras',
  );
  late final GeneratedColumn<String> codigoBarras = GeneratedColumn<String>(
    'codigo_barras',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'UNIQUE',
  );
  static const VerificationMeta _codigoInternoMeta = const VerificationMeta(
    'codigoInterno',
  );
  late final GeneratedColumn<String> codigoInterno = GeneratedColumn<String>(
    'codigo_interno',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
    'unidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (unidad IN (\'pieza\', \'peso\'))',
  );
  static const VerificationMeta _precioVentaCentavosMeta =
      const VerificationMeta('precioVentaCentavos');
  late final GeneratedColumn<int> precioVentaCentavos = GeneratedColumn<int>(
    'precio_venta_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (precio_venta_centavos >= 0)',
  );
  static const VerificationMeta _costoReferenciaCentavosMeta =
      const VerificationMeta('costoReferenciaCentavos');
  late final GeneratedColumn<int> costoReferenciaCentavos =
      GeneratedColumn<int>(
        'costo_referencia_centavos',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        $customConstraints: 'CHECK (costo_referencia_centavos IS NULL OR costo_referencia_centavos >= 0)',
      );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  late final GeneratedColumn<String> creadoEn = GeneratedColumn<String>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoriaId,
    tipoEnvaseId,
    nombre,
    codigoBarras,
    codigoInterno,
    unidad,
    precioVentaCentavos,
    costoReferenciaCentavos,
    activo,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'producto';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('tipo_envase_id')) {
      context.handle(
        _tipoEnvaseIdMeta,
        tipoEnvaseId.isAcceptableOrUnknown(
          data['tipo_envase_id']!,
          _tipoEnvaseIdMeta,
        ),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('codigo_barras')) {
      context.handle(
        _codigoBarrasMeta,
        codigoBarras.isAcceptableOrUnknown(
          data['codigo_barras']!,
          _codigoBarrasMeta,
        ),
      );
    }
    if (data.containsKey('codigo_interno')) {
      context.handle(
        _codigoInternoMeta,
        codigoInterno.isAcceptableOrUnknown(
          data['codigo_interno']!,
          _codigoInternoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_codigoInternoMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    } else if (isInserting) {
      context.missing(_unidadMeta);
    }
    if (data.containsKey('precio_venta_centavos')) {
      context.handle(
        _precioVentaCentavosMeta,
        precioVentaCentavos.isAcceptableOrUnknown(
          data['precio_venta_centavos']!,
          _precioVentaCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioVentaCentavosMeta);
    }
    if (data.containsKey('costo_referencia_centavos')) {
      context.handle(
        _costoReferenciaCentavosMeta,
        costoReferenciaCentavos.isAcceptableOrUnknown(
          data['costo_referencia_centavos']!,
          _costoReferenciaCentavosMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      ),
      tipoEnvaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_envase_id'],
      ),
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      codigoBarras: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_barras'],
      ),
      codigoInterno: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo_interno'],
      )!,
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      )!,
      precioVentaCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}precio_venta_centavos'],
      )!,
      costoReferenciaCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_referencia_centavos'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  Producto createAlias(String alias) {
    return Producto(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ProductoData extends DataClass implements Insertable<ProductoData> {
  final int id;
  final int? categoriaId;
  final int? tipoEnvaseId;
  final String nombre;
  final String? codigoBarras;
  final String codigoInterno;
  final String unidad;
  final int precioVentaCentavos;
  final int? costoReferenciaCentavos;
  final int activo;
  final String creadoEn;
  const ProductoData({
    required this.id,
    this.categoriaId,
    this.tipoEnvaseId,
    required this.nombre,
    this.codigoBarras,
    required this.codigoInterno,
    required this.unidad,
    required this.precioVentaCentavos,
    this.costoReferenciaCentavos,
    required this.activo,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    if (!nullToAbsent || tipoEnvaseId != null) {
      map['tipo_envase_id'] = Variable<int>(tipoEnvaseId);
    }
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || codigoBarras != null) {
      map['codigo_barras'] = Variable<String>(codigoBarras);
    }
    map['codigo_interno'] = Variable<String>(codigoInterno);
    map['unidad'] = Variable<String>(unidad);
    map['precio_venta_centavos'] = Variable<int>(precioVentaCentavos);
    if (!nullToAbsent || costoReferenciaCentavos != null) {
      map['costo_referencia_centavos'] = Variable<int>(costoReferenciaCentavos);
    }
    map['activo'] = Variable<int>(activo);
    map['creado_en'] = Variable<String>(creadoEn);
    return map;
  }

  ProductoCompanion toCompanion(bool nullToAbsent) {
    return ProductoCompanion(
      id: Value(id),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      tipoEnvaseId: tipoEnvaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoEnvaseId),
      nombre: Value(nombre),
      codigoBarras: codigoBarras == null && nullToAbsent
          ? const Value.absent()
          : Value(codigoBarras),
      codigoInterno: Value(codigoInterno),
      unidad: Value(unidad),
      precioVentaCentavos: Value(precioVentaCentavos),
      costoReferenciaCentavos: costoReferenciaCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(costoReferenciaCentavos),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
    );
  }

  factory ProductoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductoData(
      id: serializer.fromJson<int>(json['id']),
      categoriaId: serializer.fromJson<int?>(json['categoria_id']),
      tipoEnvaseId: serializer.fromJson<int?>(json['tipo_envase_id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      codigoBarras: serializer.fromJson<String?>(json['codigo_barras']),
      codigoInterno: serializer.fromJson<String>(json['codigo_interno']),
      unidad: serializer.fromJson<String>(json['unidad']),
      precioVentaCentavos: serializer.fromJson<int>(
        json['precio_venta_centavos'],
      ),
      costoReferenciaCentavos: serializer.fromJson<int?>(
        json['costo_referencia_centavos'],
      ),
      activo: serializer.fromJson<int>(json['activo']),
      creadoEn: serializer.fromJson<String>(json['creado_en']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoria_id': serializer.toJson<int?>(categoriaId),
      'tipo_envase_id': serializer.toJson<int?>(tipoEnvaseId),
      'nombre': serializer.toJson<String>(nombre),
      'codigo_barras': serializer.toJson<String?>(codigoBarras),
      'codigo_interno': serializer.toJson<String>(codigoInterno),
      'unidad': serializer.toJson<String>(unidad),
      'precio_venta_centavos': serializer.toJson<int>(precioVentaCentavos),
      'costo_referencia_centavos': serializer.toJson<int?>(
        costoReferenciaCentavos,
      ),
      'activo': serializer.toJson<int>(activo),
      'creado_en': serializer.toJson<String>(creadoEn),
    };
  }

  ProductoData copyWith({
    int? id,
    Value<int?> categoriaId = const Value.absent(),
    Value<int?> tipoEnvaseId = const Value.absent(),
    String? nombre,
    Value<String?> codigoBarras = const Value.absent(),
    String? codigoInterno,
    String? unidad,
    int? precioVentaCentavos,
    Value<int?> costoReferenciaCentavos = const Value.absent(),
    int? activo,
    String? creadoEn,
  }) => ProductoData(
    id: id ?? this.id,
    categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
    tipoEnvaseId: tipoEnvaseId.present ? tipoEnvaseId.value : this.tipoEnvaseId,
    nombre: nombre ?? this.nombre,
    codigoBarras: codigoBarras.present ? codigoBarras.value : this.codigoBarras,
    codigoInterno: codigoInterno ?? this.codigoInterno,
    unidad: unidad ?? this.unidad,
    precioVentaCentavos: precioVentaCentavos ?? this.precioVentaCentavos,
    costoReferenciaCentavos: costoReferenciaCentavos.present
        ? costoReferenciaCentavos.value
        : this.costoReferenciaCentavos,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  ProductoData copyWithCompanion(ProductoCompanion data) {
    return ProductoData(
      id: data.id.present ? data.id.value : this.id,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      tipoEnvaseId: data.tipoEnvaseId.present
          ? data.tipoEnvaseId.value
          : this.tipoEnvaseId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      codigoBarras: data.codigoBarras.present
          ? data.codigoBarras.value
          : this.codigoBarras,
      codigoInterno: data.codigoInterno.present
          ? data.codigoInterno.value
          : this.codigoInterno,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      precioVentaCentavos: data.precioVentaCentavos.present
          ? data.precioVentaCentavos.value
          : this.precioVentaCentavos,
      costoReferenciaCentavos: data.costoReferenciaCentavos.present
          ? data.costoReferenciaCentavos.value
          : this.costoReferenciaCentavos,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductoData(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('nombre: $nombre, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('codigoInterno: $codigoInterno, ')
          ..write('unidad: $unidad, ')
          ..write('precioVentaCentavos: $precioVentaCentavos, ')
          ..write('costoReferenciaCentavos: $costoReferenciaCentavos, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoriaId,
    tipoEnvaseId,
    nombre,
    codigoBarras,
    codigoInterno,
    unidad,
    precioVentaCentavos,
    costoReferenciaCentavos,
    activo,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductoData &&
          other.id == this.id &&
          other.categoriaId == this.categoriaId &&
          other.tipoEnvaseId == this.tipoEnvaseId &&
          other.nombre == this.nombre &&
          other.codigoBarras == this.codigoBarras &&
          other.codigoInterno == this.codigoInterno &&
          other.unidad == this.unidad &&
          other.precioVentaCentavos == this.precioVentaCentavos &&
          other.costoReferenciaCentavos == this.costoReferenciaCentavos &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn);
}

class ProductoCompanion extends UpdateCompanion<ProductoData> {
  final Value<int> id;
  final Value<int?> categoriaId;
  final Value<int?> tipoEnvaseId;
  final Value<String> nombre;
  final Value<String?> codigoBarras;
  final Value<String> codigoInterno;
  final Value<String> unidad;
  final Value<int> precioVentaCentavos;
  final Value<int?> costoReferenciaCentavos;
  final Value<int> activo;
  final Value<String> creadoEn;
  const ProductoCompanion({
    this.id = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.tipoEnvaseId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.codigoBarras = const Value.absent(),
    this.codigoInterno = const Value.absent(),
    this.unidad = const Value.absent(),
    this.precioVentaCentavos = const Value.absent(),
    this.costoReferenciaCentavos = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  ProductoCompanion.insert({
    this.id = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.tipoEnvaseId = const Value.absent(),
    required String nombre,
    this.codigoBarras = const Value.absent(),
    required String codigoInterno,
    required String unidad,
    required int precioVentaCentavos,
    this.costoReferenciaCentavos = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : nombre = Value(nombre),
       codigoInterno = Value(codigoInterno),
       unidad = Value(unidad),
       precioVentaCentavos = Value(precioVentaCentavos);
  static Insertable<ProductoData> custom({
    Expression<int>? id,
    Expression<int>? categoriaId,
    Expression<int>? tipoEnvaseId,
    Expression<String>? nombre,
    Expression<String>? codigoBarras,
    Expression<String>? codigoInterno,
    Expression<String>? unidad,
    Expression<int>? precioVentaCentavos,
    Expression<int>? costoReferenciaCentavos,
    Expression<int>? activo,
    Expression<String>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (tipoEnvaseId != null) 'tipo_envase_id': tipoEnvaseId,
      if (nombre != null) 'nombre': nombre,
      if (codigoBarras != null) 'codigo_barras': codigoBarras,
      if (codigoInterno != null) 'codigo_interno': codigoInterno,
      if (unidad != null) 'unidad': unidad,
      if (precioVentaCentavos != null)
        'precio_venta_centavos': precioVentaCentavos,
      if (costoReferenciaCentavos != null)
        'costo_referencia_centavos': costoReferenciaCentavos,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  ProductoCompanion copyWith({
    Value<int>? id,
    Value<int?>? categoriaId,
    Value<int?>? tipoEnvaseId,
    Value<String>? nombre,
    Value<String?>? codigoBarras,
    Value<String>? codigoInterno,
    Value<String>? unidad,
    Value<int>? precioVentaCentavos,
    Value<int?>? costoReferenciaCentavos,
    Value<int>? activo,
    Value<String>? creadoEn,
  }) {
    return ProductoCompanion(
      id: id ?? this.id,
      categoriaId: categoriaId ?? this.categoriaId,
      tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
      nombre: nombre ?? this.nombre,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      codigoInterno: codigoInterno ?? this.codigoInterno,
      unidad: unidad ?? this.unidad,
      precioVentaCentavos: precioVentaCentavos ?? this.precioVentaCentavos,
      costoReferenciaCentavos:
          costoReferenciaCentavos ?? this.costoReferenciaCentavos,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (tipoEnvaseId.present) {
      map['tipo_envase_id'] = Variable<int>(tipoEnvaseId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (codigoBarras.present) {
      map['codigo_barras'] = Variable<String>(codigoBarras.value);
    }
    if (codigoInterno.present) {
      map['codigo_interno'] = Variable<String>(codigoInterno.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (precioVentaCentavos.present) {
      map['precio_venta_centavos'] = Variable<int>(precioVentaCentavos.value);
    }
    if (costoReferenciaCentavos.present) {
      map['costo_referencia_centavos'] = Variable<int>(
        costoReferenciaCentavos.value,
      );
    }
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<String>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductoCompanion(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('nombre: $nombre, ')
          ..write('codigoBarras: $codigoBarras, ')
          ..write('codigoInterno: $codigoInterno, ')
          ..write('unidad: $unidad, ')
          ..write('precioVentaCentavos: $precioVentaCentavos, ')
          ..write('costoReferenciaCentavos: $costoReferenciaCentavos, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class MovimientoInventario extends Table
    with TableInfo<MovimientoInventario, MovimientoInventarioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MovimientoInventario(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES producto(id)',
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (tipo IN (\'COMPRA\', \'VENTA\', \'DEVOLUCION\', \'CANCELACION\', \'AJUSTE\', \'MERMA\'))',
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad != 0)',
  );
  static const VerificationMeta _referenciaTipoMeta = const VerificationMeta(
    'referenciaTipo',
  );
  late final GeneratedColumn<String> referenciaTipo = GeneratedColumn<String>(
    'referencia_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (referencia_tipo IN (\'COMPRA\', \'VENTA\', \'DEVOLUCION\', \'CANCELACION_VENTA\', \'CANCELACION_COMPRA\', \'AJUSTE_MANUAL\'))',
  );
  static const VerificationMeta _referenciaIdMeta = const VerificationMeta(
    'referenciaId',
  );
  late final GeneratedColumn<int> referenciaId = GeneratedColumn<int>(
    'referencia_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _reversaDeIdMeta = const VerificationMeta(
    'reversaDeId',
  );
  late final GeneratedColumn<int> reversaDeId = GeneratedColumn<int>(
    'reversa_de_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES movimiento_inventario(id)',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productoId,
    tipo,
    cantidad,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimiento_inventario';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientoInventarioData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('referencia_tipo')) {
      context.handle(
        _referenciaTipoMeta,
        referenciaTipo.isAcceptableOrUnknown(
          data['referencia_tipo']!,
          _referenciaTipoMeta,
        ),
      );
    }
    if (data.containsKey('referencia_id')) {
      context.handle(
        _referenciaIdMeta,
        referenciaId.isAcceptableOrUnknown(
          data['referencia_id']!,
          _referenciaIdMeta,
        ),
      );
    }
    if (data.containsKey('reversa_de_id')) {
      context.handle(
        _reversaDeIdMeta,
        reversaDeId.isAcceptableOrUnknown(
          data['reversa_de_id']!,
          _reversaDeIdMeta,
        ),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientoInventarioData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientoInventarioData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      referenciaTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia_tipo'],
      ),
      referenciaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referencia_id'],
      ),
      reversaDeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reversa_de_id'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  MovimientoInventario createAlias(String alias) {
    return MovimientoInventario(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class MovimientoInventarioData extends DataClass
    implements Insertable<MovimientoInventarioData> {
  final int id;
  final int productoId;
  final String tipo;
  final int cantidad;
  final String? referenciaTipo;
  final int? referenciaId;
  final int? reversaDeId;
  final int usuarioId;
  final String fecha;
  const MovimientoInventarioData({
    required this.id,
    required this.productoId,
    required this.tipo,
    required this.cantidad,
    this.referenciaTipo,
    this.referenciaId,
    this.reversaDeId,
    required this.usuarioId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['producto_id'] = Variable<int>(productoId);
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<int>(cantidad);
    if (!nullToAbsent || referenciaTipo != null) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo);
    }
    if (!nullToAbsent || referenciaId != null) {
      map['referencia_id'] = Variable<int>(referenciaId);
    }
    if (!nullToAbsent || reversaDeId != null) {
      map['reversa_de_id'] = Variable<int>(reversaDeId);
    }
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    return map;
  }

  MovimientoInventarioCompanion toCompanion(bool nullToAbsent) {
    return MovimientoInventarioCompanion(
      id: Value(id),
      productoId: Value(productoId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      referenciaTipo: referenciaTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaTipo),
      referenciaId: referenciaId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaId),
      reversaDeId: reversaDeId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversaDeId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
    );
  }

  factory MovimientoInventarioData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientoInventarioData(
      id: serializer.fromJson<int>(json['id']),
      productoId: serializer.fromJson<int>(json['producto_id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      referenciaTipo: serializer.fromJson<String?>(json['referencia_tipo']),
      referenciaId: serializer.fromJson<int?>(json['referencia_id']),
      reversaDeId: serializer.fromJson<int?>(json['reversa_de_id']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'producto_id': serializer.toJson<int>(productoId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<int>(cantidad),
      'referencia_tipo': serializer.toJson<String?>(referenciaTipo),
      'referencia_id': serializer.toJson<int?>(referenciaId),
      'reversa_de_id': serializer.toJson<int?>(reversaDeId),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
    };
  }

  MovimientoInventarioData copyWith({
    int? id,
    int? productoId,
    String? tipo,
    int? cantidad,
    Value<String?> referenciaTipo = const Value.absent(),
    Value<int?> referenciaId = const Value.absent(),
    Value<int?> reversaDeId = const Value.absent(),
    int? usuarioId,
    String? fecha,
  }) => MovimientoInventarioData(
    id: id ?? this.id,
    productoId: productoId ?? this.productoId,
    tipo: tipo ?? this.tipo,
    cantidad: cantidad ?? this.cantidad,
    referenciaTipo: referenciaTipo.present
        ? referenciaTipo.value
        : this.referenciaTipo,
    referenciaId: referenciaId.present ? referenciaId.value : this.referenciaId,
    reversaDeId: reversaDeId.present ? reversaDeId.value : this.reversaDeId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
  );
  MovimientoInventarioData copyWithCompanion(
    MovimientoInventarioCompanion data,
  ) {
    return MovimientoInventarioData(
      id: data.id.present ? data.id.value : this.id,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      referenciaTipo: data.referenciaTipo.present
          ? data.referenciaTipo.value
          : this.referenciaTipo,
      referenciaId: data.referenciaId.present
          ? data.referenciaId.value
          : this.referenciaId,
      reversaDeId: data.reversaDeId.present
          ? data.reversaDeId.value
          : this.reversaDeId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoInventarioData(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    productoId,
    tipo,
    cantidad,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientoInventarioData &&
          other.id == this.id &&
          other.productoId == this.productoId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.referenciaTipo == this.referenciaTipo &&
          other.referenciaId == this.referenciaId &&
          other.reversaDeId == this.reversaDeId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha);
}

class MovimientoInventarioCompanion
    extends UpdateCompanion<MovimientoInventarioData> {
  final Value<int> id;
  final Value<int> productoId;
  final Value<String> tipo;
  final Value<int> cantidad;
  final Value<String?> referenciaTipo;
  final Value<int?> referenciaId;
  final Value<int?> reversaDeId;
  final Value<int> usuarioId;
  final Value<String> fecha;
  const MovimientoInventarioCompanion({
    this.id = const Value.absent(),
    this.productoId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  MovimientoInventarioCompanion.insert({
    this.id = const Value.absent(),
    required int productoId,
    required String tipo,
    required int cantidad,
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    required int usuarioId,
    this.fecha = const Value.absent(),
  }) : productoId = Value(productoId),
       tipo = Value(tipo),
       cantidad = Value(cantidad),
       usuarioId = Value(usuarioId);
  static Insertable<MovimientoInventarioData> custom({
    Expression<int>? id,
    Expression<int>? productoId,
    Expression<String>? tipo,
    Expression<int>? cantidad,
    Expression<String>? referenciaTipo,
    Expression<int>? referenciaId,
    Expression<int>? reversaDeId,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productoId != null) 'producto_id': productoId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (referenciaTipo != null) 'referencia_tipo': referenciaTipo,
      if (referenciaId != null) 'referencia_id': referenciaId,
      if (reversaDeId != null) 'reversa_de_id': reversaDeId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
    });
  }

  MovimientoInventarioCompanion copyWith({
    Value<int>? id,
    Value<int>? productoId,
    Value<String>? tipo,
    Value<int>? cantidad,
    Value<String?>? referenciaTipo,
    Value<int?>? referenciaId,
    Value<int?>? reversaDeId,
    Value<int>? usuarioId,
    Value<String>? fecha,
  }) {
    return MovimientoInventarioCompanion(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      referenciaTipo: referenciaTipo ?? this.referenciaTipo,
      referenciaId: referenciaId ?? this.referenciaId,
      reversaDeId: reversaDeId ?? this.reversaDeId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (referenciaTipo.present) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo.value);
    }
    if (referenciaId.present) {
      map['referencia_id'] = Variable<int>(referenciaId.value);
    }
    if (reversaDeId.present) {
      map['reversa_de_id'] = Variable<int>(reversaDeId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoInventarioCompanion(')
          ..write('id: $id, ')
          ..write('productoId: $productoId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class InventarioSaldo extends Table
    with TableInfo<InventarioSaldo, InventarioSaldoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  InventarioSaldo(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY REFERENCES producto(id)',
  );
  static const VerificationMeta _cantidadActualMeta = const VerificationMeta(
    'cantidadActual',
  );
  late final GeneratedColumn<int> cantidadActual = GeneratedColumn<int>(
    'cantidad_actual',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad_actual >= 0)',
  );
  static const VerificationMeta _actualizadoEnMeta = const VerificationMeta(
    'actualizadoEn',
  );
  late final GeneratedColumn<String> actualizadoEn = GeneratedColumn<String>(
    'actualizado_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    productoId,
    cantidadActual,
    actualizadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventario_saldo';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventarioSaldoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    }
    if (data.containsKey('cantidad_actual')) {
      context.handle(
        _cantidadActualMeta,
        cantidadActual.isAcceptableOrUnknown(
          data['cantidad_actual']!,
          _cantidadActualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cantidadActualMeta);
    }
    if (data.containsKey('actualizado_en')) {
      context.handle(
        _actualizadoEnMeta,
        actualizadoEn.isAcceptableOrUnknown(
          data['actualizado_en']!,
          _actualizadoEnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {productoId};
  @override
  InventarioSaldoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventarioSaldoData(
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      cantidadActual: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad_actual'],
      )!,
      actualizadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actualizado_en'],
      )!,
    );
  }

  @override
  InventarioSaldo createAlias(String alias) {
    return InventarioSaldo(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class InventarioSaldoData extends DataClass
    implements Insertable<InventarioSaldoData> {
  final int productoId;
  final int cantidadActual;
  final String actualizadoEn;
  const InventarioSaldoData({
    required this.productoId,
    required this.cantidadActual,
    required this.actualizadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad_actual'] = Variable<int>(cantidadActual);
    map['actualizado_en'] = Variable<String>(actualizadoEn);
    return map;
  }

  InventarioSaldoCompanion toCompanion(bool nullToAbsent) {
    return InventarioSaldoCompanion(
      productoId: Value(productoId),
      cantidadActual: Value(cantidadActual),
      actualizadoEn: Value(actualizadoEn),
    );
  }

  factory InventarioSaldoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventarioSaldoData(
      productoId: serializer.fromJson<int>(json['producto_id']),
      cantidadActual: serializer.fromJson<int>(json['cantidad_actual']),
      actualizadoEn: serializer.fromJson<String>(json['actualizado_en']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'producto_id': serializer.toJson<int>(productoId),
      'cantidad_actual': serializer.toJson<int>(cantidadActual),
      'actualizado_en': serializer.toJson<String>(actualizadoEn),
    };
  }

  InventarioSaldoData copyWith({
    int? productoId,
    int? cantidadActual,
    String? actualizadoEn,
  }) => InventarioSaldoData(
    productoId: productoId ?? this.productoId,
    cantidadActual: cantidadActual ?? this.cantidadActual,
    actualizadoEn: actualizadoEn ?? this.actualizadoEn,
  );
  InventarioSaldoData copyWithCompanion(InventarioSaldoCompanion data) {
    return InventarioSaldoData(
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidadActual: data.cantidadActual.present
          ? data.cantidadActual.value
          : this.cantidadActual,
      actualizadoEn: data.actualizadoEn.present
          ? data.actualizadoEn.value
          : this.actualizadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventarioSaldoData(')
          ..write('productoId: $productoId, ')
          ..write('cantidadActual: $cantidadActual, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(productoId, cantidadActual, actualizadoEn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventarioSaldoData &&
          other.productoId == this.productoId &&
          other.cantidadActual == this.cantidadActual &&
          other.actualizadoEn == this.actualizadoEn);
}

class InventarioSaldoCompanion extends UpdateCompanion<InventarioSaldoData> {
  final Value<int> productoId;
  final Value<int> cantidadActual;
  final Value<String> actualizadoEn;
  const InventarioSaldoCompanion({
    this.productoId = const Value.absent(),
    this.cantidadActual = const Value.absent(),
    this.actualizadoEn = const Value.absent(),
  });
  InventarioSaldoCompanion.insert({
    this.productoId = const Value.absent(),
    required int cantidadActual,
    this.actualizadoEn = const Value.absent(),
  }) : cantidadActual = Value(cantidadActual);
  static Insertable<InventarioSaldoData> custom({
    Expression<int>? productoId,
    Expression<int>? cantidadActual,
    Expression<String>? actualizadoEn,
  }) {
    return RawValuesInsertable({
      if (productoId != null) 'producto_id': productoId,
      if (cantidadActual != null) 'cantidad_actual': cantidadActual,
      if (actualizadoEn != null) 'actualizado_en': actualizadoEn,
    });
  }

  InventarioSaldoCompanion copyWith({
    Value<int>? productoId,
    Value<int>? cantidadActual,
    Value<String>? actualizadoEn,
  }) {
    return InventarioSaldoCompanion(
      productoId: productoId ?? this.productoId,
      cantidadActual: cantidadActual ?? this.cantidadActual,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidadActual.present) {
      map['cantidad_actual'] = Variable<int>(cantidadActual.value);
    }
    if (actualizadoEn.present) {
      map['actualizado_en'] = Variable<String>(actualizadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventarioSaldoCompanion(')
          ..write('productoId: $productoId, ')
          ..write('cantidadActual: $cantidadActual, ')
          ..write('actualizadoEn: $actualizadoEn')
          ..write(')'))
        .toString();
  }
}

class SaldoGuard extends Table with TableInfo<SaldoGuard, SaldoGuardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SaldoGuard(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [activo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saldo_guard';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaldoGuardData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    } else if (isInserting) {
      context.missing(_activoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SaldoGuardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaldoGuardData(
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  SaldoGuard createAlias(String alias) {
    return SaldoGuard(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class SaldoGuardData extends DataClass implements Insertable<SaldoGuardData> {
  final int activo;
  const SaldoGuardData({required this.activo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activo'] = Variable<int>(activo);
    return map;
  }

  SaldoGuardCompanion toCompanion(bool nullToAbsent) {
    return SaldoGuardCompanion(activo: Value(activo));
  }

  factory SaldoGuardData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaldoGuardData(activo: serializer.fromJson<int>(json['activo']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'activo': serializer.toJson<int>(activo)};
  }

  SaldoGuardData copyWith({int? activo}) =>
      SaldoGuardData(activo: activo ?? this.activo);
  SaldoGuardData copyWithCompanion(SaldoGuardCompanion data) {
    return SaldoGuardData(
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaldoGuardData(')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => activo.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaldoGuardData && other.activo == this.activo);
}

class SaldoGuardCompanion extends UpdateCompanion<SaldoGuardData> {
  final Value<int> activo;
  final Value<int> rowid;
  const SaldoGuardCompanion({
    this.activo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaldoGuardCompanion.insert({
    required int activo,
    this.rowid = const Value.absent(),
  }) : activo = Value(activo);
  static Insertable<SaldoGuardData> custom({
    Expression<int>? activo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (activo != null) 'activo': activo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaldoGuardCompanion copyWith({Value<int>? activo, Value<int>? rowid}) {
    return SaldoGuardCompanion(
      activo: activo ?? this.activo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaldoGuardCompanion(')
          ..write('activo: $activo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Proveedor extends Table with TableInfo<Proveedor, ProveedorData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Proveedor(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  @override
  List<GeneratedColumn> get $columns => [id, nombre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'proveedor';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProveedorData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProveedorData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProveedorData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
    );
  }

  @override
  Proveedor createAlias(String alias) {
    return Proveedor(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ProveedorData extends DataClass implements Insertable<ProveedorData> {
  final int id;
  final String nombre;
  const ProveedorData({required this.id, required this.nombre});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    return map;
  }

  ProveedorCompanion toCompanion(bool nullToAbsent) {
    return ProveedorCompanion(id: Value(id), nombre: Value(nombre));
  }

  factory ProveedorData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProveedorData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
    };
  }

  ProveedorData copyWith({int? id, String? nombre}) =>
      ProveedorData(id: id ?? this.id, nombre: nombre ?? this.nombre);
  ProveedorData copyWithCompanion(ProveedorCompanion data) {
    return ProveedorData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProveedorData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProveedorData &&
          other.id == this.id &&
          other.nombre == this.nombre);
}

class ProveedorCompanion extends UpdateCompanion<ProveedorData> {
  final Value<int> id;
  final Value<String> nombre;
  const ProveedorCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
  });
  ProveedorCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
  }) : nombre = Value(nombre);
  static Insertable<ProveedorData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
    });
  }

  ProveedorCompanion copyWith({Value<int>? id, Value<String>? nombre}) {
    return ProveedorCompanion(id: id ?? this.id, nombre: nombre ?? this.nombre);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProveedorCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre')
          ..write(')'))
        .toString();
  }
}

class Compra extends Table with TableInfo<Compra, CompraData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Compra(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _terminalIdMeta = const VerificationMeta(
    'terminalId',
  );
  late final GeneratedColumn<int> terminalId = GeneratedColumn<int>(
    'terminal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES terminal(id)',
  );
  static const VerificationMeta _cajaSesionIdMeta = const VerificationMeta(
    'cajaSesionId',
  );
  late final GeneratedColumn<int> cajaSesionId = GeneratedColumn<int>(
    'caja_sesion_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES caja_sesion(id)',
  );
  static const VerificationMeta _folioMeta = const VerificationMeta('folio');
  late final GeneratedColumn<String> folio = GeneratedColumn<String>(
    'folio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _proveedorIdMeta = const VerificationMeta(
    'proveedorId',
  );
  late final GeneratedColumn<int> proveedorId = GeneratedColumn<int>(
    'proveedor_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES proveedor(id)',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  static const VerificationMeta _totalCentavosMeta = const VerificationMeta(
    'totalCentavos',
  );
  late final GeneratedColumn<int> totalCentavos = GeneratedColumn<int>(
    'total_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (total_centavos >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'COMPLETADA\' CHECK (estado IN (\'COMPLETADA\', \'CANCELADA\'))',
    defaultValue: const CustomExpression('\'COMPLETADA\''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    terminalId,
    cajaSesionId,
    folio,
    proveedorId,
    usuarioId,
    fecha,
    totalCentavos,
    estado,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'compra';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompraData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
        _terminalIdMeta,
        terminalId.isAcceptableOrUnknown(data['terminal_id']!, _terminalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_terminalIdMeta);
    }
    if (data.containsKey('caja_sesion_id')) {
      context.handle(
        _cajaSesionIdMeta,
        cajaSesionId.isAcceptableOrUnknown(
          data['caja_sesion_id']!,
          _cajaSesionIdMeta,
        ),
      );
    }
    if (data.containsKey('folio')) {
      context.handle(
        _folioMeta,
        folio.isAcceptableOrUnknown(data['folio']!, _folioMeta),
      );
    } else if (isInserting) {
      context.missing(_folioMeta);
    }
    if (data.containsKey('proveedor_id')) {
      context.handle(
        _proveedorIdMeta,
        proveedorId.isAcceptableOrUnknown(
          data['proveedor_id']!,
          _proveedorIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proveedorIdMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('total_centavos')) {
      context.handle(
        _totalCentavosMeta,
        totalCentavos.isAcceptableOrUnknown(
          data['total_centavos']!,
          _totalCentavosMeta,
        ),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompraData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompraData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      terminalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}terminal_id'],
      )!,
      cajaSesionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caja_sesion_id'],
      ),
      folio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folio'],
      )!,
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proveedor_id'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
      totalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_centavos'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
    );
  }

  @override
  Compra createAlias(String alias) {
    return Compra(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CompraData extends DataClass implements Insertable<CompraData> {
  final int id;
  final int terminalId;
  final int? cajaSesionId;
  final String folio;
  final int proveedorId;
  final int usuarioId;
  final String fecha;
  final int totalCentavos;
  final String estado;
  const CompraData({
    required this.id,
    required this.terminalId,
    this.cajaSesionId,
    required this.folio,
    required this.proveedorId,
    required this.usuarioId,
    required this.fecha,
    required this.totalCentavos,
    required this.estado,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['terminal_id'] = Variable<int>(terminalId);
    if (!nullToAbsent || cajaSesionId != null) {
      map['caja_sesion_id'] = Variable<int>(cajaSesionId);
    }
    map['folio'] = Variable<String>(folio);
    map['proveedor_id'] = Variable<int>(proveedorId);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    map['total_centavos'] = Variable<int>(totalCentavos);
    map['estado'] = Variable<String>(estado);
    return map;
  }

  CompraCompanion toCompanion(bool nullToAbsent) {
    return CompraCompanion(
      id: Value(id),
      terminalId: Value(terminalId),
      cajaSesionId: cajaSesionId == null && nullToAbsent
          ? const Value.absent()
          : Value(cajaSesionId),
      folio: Value(folio),
      proveedorId: Value(proveedorId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
      totalCentavos: Value(totalCentavos),
      estado: Value(estado),
    );
  }

  factory CompraData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompraData(
      id: serializer.fromJson<int>(json['id']),
      terminalId: serializer.fromJson<int>(json['terminal_id']),
      cajaSesionId: serializer.fromJson<int?>(json['caja_sesion_id']),
      folio: serializer.fromJson<String>(json['folio']),
      proveedorId: serializer.fromJson<int>(json['proveedor_id']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
      totalCentavos: serializer.fromJson<int>(json['total_centavos']),
      estado: serializer.fromJson<String>(json['estado']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'terminal_id': serializer.toJson<int>(terminalId),
      'caja_sesion_id': serializer.toJson<int?>(cajaSesionId),
      'folio': serializer.toJson<String>(folio),
      'proveedor_id': serializer.toJson<int>(proveedorId),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
      'total_centavos': serializer.toJson<int>(totalCentavos),
      'estado': serializer.toJson<String>(estado),
    };
  }

  CompraData copyWith({
    int? id,
    int? terminalId,
    Value<int?> cajaSesionId = const Value.absent(),
    String? folio,
    int? proveedorId,
    int? usuarioId,
    String? fecha,
    int? totalCentavos,
    String? estado,
  }) => CompraData(
    id: id ?? this.id,
    terminalId: terminalId ?? this.terminalId,
    cajaSesionId: cajaSesionId.present ? cajaSesionId.value : this.cajaSesionId,
    folio: folio ?? this.folio,
    proveedorId: proveedorId ?? this.proveedorId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
    totalCentavos: totalCentavos ?? this.totalCentavos,
    estado: estado ?? this.estado,
  );
  CompraData copyWithCompanion(CompraCompanion data) {
    return CompraData(
      id: data.id.present ? data.id.value : this.id,
      terminalId: data.terminalId.present
          ? data.terminalId.value
          : this.terminalId,
      cajaSesionId: data.cajaSesionId.present
          ? data.cajaSesionId.value
          : this.cajaSesionId,
      folio: data.folio.present ? data.folio.value : this.folio,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      totalCentavos: data.totalCentavos.present
          ? data.totalCentavos.value
          : this.totalCentavos,
      estado: data.estado.present ? data.estado.value : this.estado,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompraData(')
          ..write('id: $id, ')
          ..write('terminalId: $terminalId, ')
          ..write('cajaSesionId: $cajaSesionId, ')
          ..write('folio: $folio, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha, ')
          ..write('totalCentavos: $totalCentavos, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    terminalId,
    cajaSesionId,
    folio,
    proveedorId,
    usuarioId,
    fecha,
    totalCentavos,
    estado,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompraData &&
          other.id == this.id &&
          other.terminalId == this.terminalId &&
          other.cajaSesionId == this.cajaSesionId &&
          other.folio == this.folio &&
          other.proveedorId == this.proveedorId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha &&
          other.totalCentavos == this.totalCentavos &&
          other.estado == this.estado);
}

class CompraCompanion extends UpdateCompanion<CompraData> {
  final Value<int> id;
  final Value<int> terminalId;
  final Value<int?> cajaSesionId;
  final Value<String> folio;
  final Value<int> proveedorId;
  final Value<int> usuarioId;
  final Value<String> fecha;
  final Value<int> totalCentavos;
  final Value<String> estado;
  const CompraCompanion({
    this.id = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.cajaSesionId = const Value.absent(),
    this.folio = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.totalCentavos = const Value.absent(),
    this.estado = const Value.absent(),
  });
  CompraCompanion.insert({
    this.id = const Value.absent(),
    required int terminalId,
    this.cajaSesionId = const Value.absent(),
    required String folio,
    required int proveedorId,
    required int usuarioId,
    this.fecha = const Value.absent(),
    this.totalCentavos = const Value.absent(),
    this.estado = const Value.absent(),
  }) : terminalId = Value(terminalId),
       folio = Value(folio),
       proveedorId = Value(proveedorId),
       usuarioId = Value(usuarioId);
  static Insertable<CompraData> custom({
    Expression<int>? id,
    Expression<int>? terminalId,
    Expression<int>? cajaSesionId,
    Expression<String>? folio,
    Expression<int>? proveedorId,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
    Expression<int>? totalCentavos,
    Expression<String>? estado,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (terminalId != null) 'terminal_id': terminalId,
      if (cajaSesionId != null) 'caja_sesion_id': cajaSesionId,
      if (folio != null) 'folio': folio,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
      if (totalCentavos != null) 'total_centavos': totalCentavos,
      if (estado != null) 'estado': estado,
    });
  }

  CompraCompanion copyWith({
    Value<int>? id,
    Value<int>? terminalId,
    Value<int?>? cajaSesionId,
    Value<String>? folio,
    Value<int>? proveedorId,
    Value<int>? usuarioId,
    Value<String>? fecha,
    Value<int>? totalCentavos,
    Value<String>? estado,
  }) {
    return CompraCompanion(
      id: id ?? this.id,
      terminalId: terminalId ?? this.terminalId,
      cajaSesionId: cajaSesionId ?? this.cajaSesionId,
      folio: folio ?? this.folio,
      proveedorId: proveedorId ?? this.proveedorId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
      totalCentavos: totalCentavos ?? this.totalCentavos,
      estado: estado ?? this.estado,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<int>(terminalId.value);
    }
    if (cajaSesionId.present) {
      map['caja_sesion_id'] = Variable<int>(cajaSesionId.value);
    }
    if (folio.present) {
      map['folio'] = Variable<String>(folio.value);
    }
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<int>(proveedorId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    if (totalCentavos.present) {
      map['total_centavos'] = Variable<int>(totalCentavos.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompraCompanion(')
          ..write('id: $id, ')
          ..write('terminalId: $terminalId, ')
          ..write('cajaSesionId: $cajaSesionId, ')
          ..write('folio: $folio, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha, ')
          ..write('totalCentavos: $totalCentavos, ')
          ..write('estado: $estado')
          ..write(')'))
        .toString();
  }
}

class DetalleCompra extends Table
    with TableInfo<DetalleCompra, DetalleCompraData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DetalleCompra(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _compraIdMeta = const VerificationMeta(
    'compraId',
  );
  late final GeneratedColumn<int> compraId = GeneratedColumn<int>(
    'compra_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES compra(id)',
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES producto(id)',
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad > 0)',
  );
  static const VerificationMeta _costoUnitarioCentavosMeta =
      const VerificationMeta('costoUnitarioCentavos');
  late final GeneratedColumn<int> costoUnitarioCentavos = GeneratedColumn<int>(
    'costo_unitario_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (costo_unitario_centavos >= 0)',
  );
  static const VerificationMeta _subtotalCentavosMeta = const VerificationMeta(
    'subtotalCentavos',
  );
  late final GeneratedColumn<int> subtotalCentavos = GeneratedColumn<int>(
    'subtotal_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (subtotal_centavos >= 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    compraId,
    productoId,
    cantidad,
    costoUnitarioCentavos,
    subtotalCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detalle_compra';
  @override
  VerificationContext validateIntegrity(
    Insertable<DetalleCompraData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('compra_id')) {
      context.handle(
        _compraIdMeta,
        compraId.isAcceptableOrUnknown(data['compra_id']!, _compraIdMeta),
      );
    } else if (isInserting) {
      context.missing(_compraIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('costo_unitario_centavos')) {
      context.handle(
        _costoUnitarioCentavosMeta,
        costoUnitarioCentavos.isAcceptableOrUnknown(
          data['costo_unitario_centavos']!,
          _costoUnitarioCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoUnitarioCentavosMeta);
    }
    if (data.containsKey('subtotal_centavos')) {
      context.handle(
        _subtotalCentavosMeta,
        subtotalCentavos.isAcceptableOrUnknown(
          data['subtotal_centavos']!,
          _subtotalCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DetalleCompraData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetalleCompraData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      compraId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}compra_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      costoUnitarioCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_unitario_centavos'],
      )!,
      subtotalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_centavos'],
      )!,
    );
  }

  @override
  DetalleCompra createAlias(String alias) {
    return DetalleCompra(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DetalleCompraData extends DataClass
    implements Insertable<DetalleCompraData> {
  final int id;
  final int compraId;
  final int productoId;
  final int cantidad;
  final int costoUnitarioCentavos;
  final int subtotalCentavos;
  const DetalleCompraData({
    required this.id,
    required this.compraId,
    required this.productoId,
    required this.cantidad,
    required this.costoUnitarioCentavos,
    required this.subtotalCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['compra_id'] = Variable<int>(compraId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['costo_unitario_centavos'] = Variable<int>(costoUnitarioCentavos);
    map['subtotal_centavos'] = Variable<int>(subtotalCentavos);
    return map;
  }

  DetalleCompraCompanion toCompanion(bool nullToAbsent) {
    return DetalleCompraCompanion(
      id: Value(id),
      compraId: Value(compraId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      costoUnitarioCentavos: Value(costoUnitarioCentavos),
      subtotalCentavos: Value(subtotalCentavos),
    );
  }

  factory DetalleCompraData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetalleCompraData(
      id: serializer.fromJson<int>(json['id']),
      compraId: serializer.fromJson<int>(json['compra_id']),
      productoId: serializer.fromJson<int>(json['producto_id']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      costoUnitarioCentavos: serializer.fromJson<int>(
        json['costo_unitario_centavos'],
      ),
      subtotalCentavos: serializer.fromJson<int>(json['subtotal_centavos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'compra_id': serializer.toJson<int>(compraId),
      'producto_id': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'costo_unitario_centavos': serializer.toJson<int>(costoUnitarioCentavos),
      'subtotal_centavos': serializer.toJson<int>(subtotalCentavos),
    };
  }

  DetalleCompraData copyWith({
    int? id,
    int? compraId,
    int? productoId,
    int? cantidad,
    int? costoUnitarioCentavos,
    int? subtotalCentavos,
  }) => DetalleCompraData(
    id: id ?? this.id,
    compraId: compraId ?? this.compraId,
    productoId: productoId ?? this.productoId,
    cantidad: cantidad ?? this.cantidad,
    costoUnitarioCentavos: costoUnitarioCentavos ?? this.costoUnitarioCentavos,
    subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
  );
  DetalleCompraData copyWithCompanion(DetalleCompraCompanion data) {
    return DetalleCompraData(
      id: data.id.present ? data.id.value : this.id,
      compraId: data.compraId.present ? data.compraId.value : this.compraId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      costoUnitarioCentavos: data.costoUnitarioCentavos.present
          ? data.costoUnitarioCentavos.value
          : this.costoUnitarioCentavos,
      subtotalCentavos: data.subtotalCentavos.present
          ? data.subtotalCentavos.value
          : this.subtotalCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetalleCompraData(')
          ..write('id: $id, ')
          ..write('compraId: $compraId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('costoUnitarioCentavos: $costoUnitarioCentavos, ')
          ..write('subtotalCentavos: $subtotalCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    compraId,
    productoId,
    cantidad,
    costoUnitarioCentavos,
    subtotalCentavos,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetalleCompraData &&
          other.id == this.id &&
          other.compraId == this.compraId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.costoUnitarioCentavos == this.costoUnitarioCentavos &&
          other.subtotalCentavos == this.subtotalCentavos);
}

class DetalleCompraCompanion extends UpdateCompanion<DetalleCompraData> {
  final Value<int> id;
  final Value<int> compraId;
  final Value<int> productoId;
  final Value<int> cantidad;
  final Value<int> costoUnitarioCentavos;
  final Value<int> subtotalCentavos;
  const DetalleCompraCompanion({
    this.id = const Value.absent(),
    this.compraId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.costoUnitarioCentavos = const Value.absent(),
    this.subtotalCentavos = const Value.absent(),
  });
  DetalleCompraCompanion.insert({
    this.id = const Value.absent(),
    required int compraId,
    required int productoId,
    required int cantidad,
    required int costoUnitarioCentavos,
    required int subtotalCentavos,
  }) : compraId = Value(compraId),
       productoId = Value(productoId),
       cantidad = Value(cantidad),
       costoUnitarioCentavos = Value(costoUnitarioCentavos),
       subtotalCentavos = Value(subtotalCentavos);
  static Insertable<DetalleCompraData> custom({
    Expression<int>? id,
    Expression<int>? compraId,
    Expression<int>? productoId,
    Expression<int>? cantidad,
    Expression<int>? costoUnitarioCentavos,
    Expression<int>? subtotalCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (compraId != null) 'compra_id': compraId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (costoUnitarioCentavos != null)
        'costo_unitario_centavos': costoUnitarioCentavos,
      if (subtotalCentavos != null) 'subtotal_centavos': subtotalCentavos,
    });
  }

  DetalleCompraCompanion copyWith({
    Value<int>? id,
    Value<int>? compraId,
    Value<int>? productoId,
    Value<int>? cantidad,
    Value<int>? costoUnitarioCentavos,
    Value<int>? subtotalCentavos,
  }) {
    return DetalleCompraCompanion(
      id: id ?? this.id,
      compraId: compraId ?? this.compraId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      costoUnitarioCentavos:
          costoUnitarioCentavos ?? this.costoUnitarioCentavos,
      subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (compraId.present) {
      map['compra_id'] = Variable<int>(compraId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (costoUnitarioCentavos.present) {
      map['costo_unitario_centavos'] = Variable<int>(
        costoUnitarioCentavos.value,
      );
    }
    if (subtotalCentavos.present) {
      map['subtotal_centavos'] = Variable<int>(subtotalCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetalleCompraCompanion(')
          ..write('id: $id, ')
          ..write('compraId: $compraId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('costoUnitarioCentavos: $costoUnitarioCentavos, ')
          ..write('subtotalCentavos: $subtotalCentavos')
          ..write(')'))
        .toString();
  }
}

class Cliente extends Table with TableInfo<Cliente, ClienteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Cliente(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _umbralAdvertenciaCentavosMeta =
      const VerificationMeta('umbralAdvertenciaCentavos');
  late final GeneratedColumn<int> umbralAdvertenciaCentavos =
      GeneratedColumn<int>(
        'umbral_advertencia_centavos',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        $customConstraints: '',
      );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  late final GeneratedColumn<int> activo = GeneratedColumn<int>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 1 CHECK (activo IN (0, 1))',
    defaultValue: const CustomExpression('1'),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  late final GeneratedColumn<String> creadoEn = GeneratedColumn<String>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    telefono,
    umbralAdvertenciaCentavos,
    activo,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cliente';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClienteData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('umbral_advertencia_centavos')) {
      context.handle(
        _umbralAdvertenciaCentavosMeta,
        umbralAdvertenciaCentavos.isAcceptableOrUnknown(
          data['umbral_advertencia_centavos']!,
          _umbralAdvertenciaCentavosMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClienteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClienteData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      umbralAdvertenciaCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}umbral_advertencia_centavos'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activo'],
      )!,
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  Cliente createAlias(String alias) {
    return Cliente(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class ClienteData extends DataClass implements Insertable<ClienteData> {
  final int id;
  final String nombre;
  final String? telefono;
  final int? umbralAdvertenciaCentavos;
  final int activo;
  final String creadoEn;
  const ClienteData({
    required this.id,
    required this.nombre,
    this.telefono,
    this.umbralAdvertenciaCentavos,
    required this.activo,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || umbralAdvertenciaCentavos != null) {
      map['umbral_advertencia_centavos'] = Variable<int>(
        umbralAdvertenciaCentavos,
      );
    }
    map['activo'] = Variable<int>(activo);
    map['creado_en'] = Variable<String>(creadoEn);
    return map;
  }

  ClienteCompanion toCompanion(bool nullToAbsent) {
    return ClienteCompanion(
      id: Value(id),
      nombre: Value(nombre),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      umbralAdvertenciaCentavos:
          umbralAdvertenciaCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(umbralAdvertenciaCentavos),
      activo: Value(activo),
      creadoEn: Value(creadoEn),
    );
  }

  factory ClienteData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClienteData(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      umbralAdvertenciaCentavos: serializer.fromJson<int?>(
        json['umbral_advertencia_centavos'],
      ),
      activo: serializer.fromJson<int>(json['activo']),
      creadoEn: serializer.fromJson<String>(json['creado_en']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'telefono': serializer.toJson<String?>(telefono),
      'umbral_advertencia_centavos': serializer.toJson<int?>(
        umbralAdvertenciaCentavos,
      ),
      'activo': serializer.toJson<int>(activo),
      'creado_en': serializer.toJson<String>(creadoEn),
    };
  }

  ClienteData copyWith({
    int? id,
    String? nombre,
    Value<String?> telefono = const Value.absent(),
    Value<int?> umbralAdvertenciaCentavos = const Value.absent(),
    int? activo,
    String? creadoEn,
  }) => ClienteData(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    telefono: telefono.present ? telefono.value : this.telefono,
    umbralAdvertenciaCentavos: umbralAdvertenciaCentavos.present
        ? umbralAdvertenciaCentavos.value
        : this.umbralAdvertenciaCentavos,
    activo: activo ?? this.activo,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  ClienteData copyWithCompanion(ClienteCompanion data) {
    return ClienteData(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      umbralAdvertenciaCentavos: data.umbralAdvertenciaCentavos.present
          ? data.umbralAdvertenciaCentavos.value
          : this.umbralAdvertenciaCentavos,
      activo: data.activo.present ? data.activo.value : this.activo,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClienteData(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('umbralAdvertenciaCentavos: $umbralAdvertenciaCentavos, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nombre,
    telefono,
    umbralAdvertenciaCentavos,
    activo,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClienteData &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.telefono == this.telefono &&
          other.umbralAdvertenciaCentavos == this.umbralAdvertenciaCentavos &&
          other.activo == this.activo &&
          other.creadoEn == this.creadoEn);
}

class ClienteCompanion extends UpdateCompanion<ClienteData> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String?> telefono;
  final Value<int?> umbralAdvertenciaCentavos;
  final Value<int> activo;
  final Value<String> creadoEn;
  const ClienteCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.telefono = const Value.absent(),
    this.umbralAdvertenciaCentavos = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  ClienteCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    this.telefono = const Value.absent(),
    this.umbralAdvertenciaCentavos = const Value.absent(),
    this.activo = const Value.absent(),
    this.creadoEn = const Value.absent(),
  }) : nombre = Value(nombre);
  static Insertable<ClienteData> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? telefono,
    Expression<int>? umbralAdvertenciaCentavos,
    Expression<int>? activo,
    Expression<String>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (telefono != null) 'telefono': telefono,
      if (umbralAdvertenciaCentavos != null)
        'umbral_advertencia_centavos': umbralAdvertenciaCentavos,
      if (activo != null) 'activo': activo,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  ClienteCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String?>? telefono,
    Value<int?>? umbralAdvertenciaCentavos,
    Value<int>? activo,
    Value<String>? creadoEn,
  }) {
    return ClienteCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      umbralAdvertenciaCentavos:
          umbralAdvertenciaCentavos ?? this.umbralAdvertenciaCentavos,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (umbralAdvertenciaCentavos.present) {
      map['umbral_advertencia_centavos'] = Variable<int>(
        umbralAdvertenciaCentavos.value,
      );
    }
    if (activo.present) {
      map['activo'] = Variable<int>(activo.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<String>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClienteCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('telefono: $telefono, ')
          ..write('umbralAdvertenciaCentavos: $umbralAdvertenciaCentavos, ')
          ..write('activo: $activo, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class Venta extends Table with TableInfo<Venta, VentaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Venta(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _terminalIdMeta = const VerificationMeta(
    'terminalId',
  );
  late final GeneratedColumn<int> terminalId = GeneratedColumn<int>(
    'terminal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES terminal(id)',
  );
  static const VerificationMeta _folioMeta = const VerificationMeta('folio');
  late final GeneratedColumn<String> folio = GeneratedColumn<String>(
    'folio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE',
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES cliente(id)',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  static const VerificationMeta _estadoMeta = const VerificationMeta('estado');
  late final GeneratedColumn<String> estado = GeneratedColumn<String>(
    'estado',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'COMPLETADA\' CHECK (estado IN (\'COMPLETADA\', \'CANCELADA\'))',
    defaultValue: const CustomExpression('\'COMPLETADA\''),
  );
  static const VerificationMeta _subtotalCentavosMeta = const VerificationMeta(
    'subtotalCentavos',
  );
  late final GeneratedColumn<int> subtotalCentavos = GeneratedColumn<int>(
    'subtotal_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (subtotal_centavos >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _totalCentavosMeta = const VerificationMeta(
    'totalCentavos',
  );
  late final GeneratedColumn<int> totalCentavos = GeneratedColumn<int>(
    'total_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK (total_centavos >= 0)',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    terminalId,
    folio,
    clienteId,
    usuarioId,
    fecha,
    estado,
    subtotalCentavos,
    totalCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'venta';
  @override
  VerificationContext validateIntegrity(
    Insertable<VentaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('terminal_id')) {
      context.handle(
        _terminalIdMeta,
        terminalId.isAcceptableOrUnknown(data['terminal_id']!, _terminalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_terminalIdMeta);
    }
    if (data.containsKey('folio')) {
      context.handle(
        _folioMeta,
        folio.isAcceptableOrUnknown(data['folio']!, _folioMeta),
      );
    } else if (isInserting) {
      context.missing(_folioMeta);
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('estado')) {
      context.handle(
        _estadoMeta,
        estado.isAcceptableOrUnknown(data['estado']!, _estadoMeta),
      );
    }
    if (data.containsKey('subtotal_centavos')) {
      context.handle(
        _subtotalCentavosMeta,
        subtotalCentavos.isAcceptableOrUnknown(
          data['subtotal_centavos']!,
          _subtotalCentavosMeta,
        ),
      );
    }
    if (data.containsKey('total_centavos')) {
      context.handle(
        _totalCentavosMeta,
        totalCentavos.isAcceptableOrUnknown(
          data['total_centavos']!,
          _totalCentavosMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VentaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VentaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      terminalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}terminal_id'],
      )!,
      folio: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}folio'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
      estado: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}estado'],
      )!,
      subtotalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_centavos'],
      )!,
      totalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_centavos'],
      )!,
    );
  }

  @override
  Venta createAlias(String alias) {
    return Venta(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class VentaData extends DataClass implements Insertable<VentaData> {
  final int id;
  final int terminalId;
  final String folio;
  final int? clienteId;
  final int usuarioId;
  final String fecha;
  final String estado;
  final int subtotalCentavos;
  final int totalCentavos;
  const VentaData({
    required this.id,
    required this.terminalId,
    required this.folio,
    this.clienteId,
    required this.usuarioId,
    required this.fecha,
    required this.estado,
    required this.subtotalCentavos,
    required this.totalCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['terminal_id'] = Variable<int>(terminalId);
    map['folio'] = Variable<String>(folio);
    if (!nullToAbsent || clienteId != null) {
      map['cliente_id'] = Variable<int>(clienteId);
    }
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    map['estado'] = Variable<String>(estado);
    map['subtotal_centavos'] = Variable<int>(subtotalCentavos);
    map['total_centavos'] = Variable<int>(totalCentavos);
    return map;
  }

  VentaCompanion toCompanion(bool nullToAbsent) {
    return VentaCompanion(
      id: Value(id),
      terminalId: Value(terminalId),
      folio: Value(folio),
      clienteId: clienteId == null && nullToAbsent
          ? const Value.absent()
          : Value(clienteId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
      estado: Value(estado),
      subtotalCentavos: Value(subtotalCentavos),
      totalCentavos: Value(totalCentavos),
    );
  }

  factory VentaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VentaData(
      id: serializer.fromJson<int>(json['id']),
      terminalId: serializer.fromJson<int>(json['terminal_id']),
      folio: serializer.fromJson<String>(json['folio']),
      clienteId: serializer.fromJson<int?>(json['cliente_id']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
      estado: serializer.fromJson<String>(json['estado']),
      subtotalCentavos: serializer.fromJson<int>(json['subtotal_centavos']),
      totalCentavos: serializer.fromJson<int>(json['total_centavos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'terminal_id': serializer.toJson<int>(terminalId),
      'folio': serializer.toJson<String>(folio),
      'cliente_id': serializer.toJson<int?>(clienteId),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
      'estado': serializer.toJson<String>(estado),
      'subtotal_centavos': serializer.toJson<int>(subtotalCentavos),
      'total_centavos': serializer.toJson<int>(totalCentavos),
    };
  }

  VentaData copyWith({
    int? id,
    int? terminalId,
    String? folio,
    Value<int?> clienteId = const Value.absent(),
    int? usuarioId,
    String? fecha,
    String? estado,
    int? subtotalCentavos,
    int? totalCentavos,
  }) => VentaData(
    id: id ?? this.id,
    terminalId: terminalId ?? this.terminalId,
    folio: folio ?? this.folio,
    clienteId: clienteId.present ? clienteId.value : this.clienteId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
    estado: estado ?? this.estado,
    subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
    totalCentavos: totalCentavos ?? this.totalCentavos,
  );
  VentaData copyWithCompanion(VentaCompanion data) {
    return VentaData(
      id: data.id.present ? data.id.value : this.id,
      terminalId: data.terminalId.present
          ? data.terminalId.value
          : this.terminalId,
      folio: data.folio.present ? data.folio.value : this.folio,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      estado: data.estado.present ? data.estado.value : this.estado,
      subtotalCentavos: data.subtotalCentavos.present
          ? data.subtotalCentavos.value
          : this.subtotalCentavos,
      totalCentavos: data.totalCentavos.present
          ? data.totalCentavos.value
          : this.totalCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VentaData(')
          ..write('id: $id, ')
          ..write('terminalId: $terminalId, ')
          ..write('folio: $folio, ')
          ..write('clienteId: $clienteId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha, ')
          ..write('estado: $estado, ')
          ..write('subtotalCentavos: $subtotalCentavos, ')
          ..write('totalCentavos: $totalCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    terminalId,
    folio,
    clienteId,
    usuarioId,
    fecha,
    estado,
    subtotalCentavos,
    totalCentavos,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VentaData &&
          other.id == this.id &&
          other.terminalId == this.terminalId &&
          other.folio == this.folio &&
          other.clienteId == this.clienteId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha &&
          other.estado == this.estado &&
          other.subtotalCentavos == this.subtotalCentavos &&
          other.totalCentavos == this.totalCentavos);
}

class VentaCompanion extends UpdateCompanion<VentaData> {
  final Value<int> id;
  final Value<int> terminalId;
  final Value<String> folio;
  final Value<int?> clienteId;
  final Value<int> usuarioId;
  final Value<String> fecha;
  final Value<String> estado;
  final Value<int> subtotalCentavos;
  final Value<int> totalCentavos;
  const VentaCompanion({
    this.id = const Value.absent(),
    this.terminalId = const Value.absent(),
    this.folio = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
    this.estado = const Value.absent(),
    this.subtotalCentavos = const Value.absent(),
    this.totalCentavos = const Value.absent(),
  });
  VentaCompanion.insert({
    this.id = const Value.absent(),
    required int terminalId,
    required String folio,
    this.clienteId = const Value.absent(),
    required int usuarioId,
    this.fecha = const Value.absent(),
    this.estado = const Value.absent(),
    this.subtotalCentavos = const Value.absent(),
    this.totalCentavos = const Value.absent(),
  }) : terminalId = Value(terminalId),
       folio = Value(folio),
       usuarioId = Value(usuarioId);
  static Insertable<VentaData> custom({
    Expression<int>? id,
    Expression<int>? terminalId,
    Expression<String>? folio,
    Expression<int>? clienteId,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
    Expression<String>? estado,
    Expression<int>? subtotalCentavos,
    Expression<int>? totalCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (terminalId != null) 'terminal_id': terminalId,
      if (folio != null) 'folio': folio,
      if (clienteId != null) 'cliente_id': clienteId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
      if (estado != null) 'estado': estado,
      if (subtotalCentavos != null) 'subtotal_centavos': subtotalCentavos,
      if (totalCentavos != null) 'total_centavos': totalCentavos,
    });
  }

  VentaCompanion copyWith({
    Value<int>? id,
    Value<int>? terminalId,
    Value<String>? folio,
    Value<int?>? clienteId,
    Value<int>? usuarioId,
    Value<String>? fecha,
    Value<String>? estado,
    Value<int>? subtotalCentavos,
    Value<int>? totalCentavos,
  }) {
    return VentaCompanion(
      id: id ?? this.id,
      terminalId: terminalId ?? this.terminalId,
      folio: folio ?? this.folio,
      clienteId: clienteId ?? this.clienteId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
      subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
      totalCentavos: totalCentavos ?? this.totalCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (terminalId.present) {
      map['terminal_id'] = Variable<int>(terminalId.value);
    }
    if (folio.present) {
      map['folio'] = Variable<String>(folio.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    if (estado.present) {
      map['estado'] = Variable<String>(estado.value);
    }
    if (subtotalCentavos.present) {
      map['subtotal_centavos'] = Variable<int>(subtotalCentavos.value);
    }
    if (totalCentavos.present) {
      map['total_centavos'] = Variable<int>(totalCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VentaCompanion(')
          ..write('id: $id, ')
          ..write('terminalId: $terminalId, ')
          ..write('folio: $folio, ')
          ..write('clienteId: $clienteId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha, ')
          ..write('estado: $estado, ')
          ..write('subtotalCentavos: $subtotalCentavos, ')
          ..write('totalCentavos: $totalCentavos')
          ..write(')'))
        .toString();
  }
}

class DetalleVenta extends Table
    with TableInfo<DetalleVenta, DetalleVentaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DetalleVenta(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES venta(id)',
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES producto(id)',
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad > 0)',
  );
  static const VerificationMeta _precioUnitarioCentavosMeta =
      const VerificationMeta('precioUnitarioCentavos');
  late final GeneratedColumn<int> precioUnitarioCentavos = GeneratedColumn<int>(
    'precio_unitario_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (precio_unitario_centavos >= 0)',
  );
  static const VerificationMeta _costoUnitarioCentavosMeta =
      const VerificationMeta('costoUnitarioCentavos');
  late final GeneratedColumn<int> costoUnitarioCentavos = GeneratedColumn<int>(
    'costo_unitario_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (costo_unitario_centavos >= 0)',
  );
  static const VerificationMeta _subtotalCentavosMeta = const VerificationMeta(
    'subtotalCentavos',
  );
  late final GeneratedColumn<int> subtotalCentavos = GeneratedColumn<int>(
    'subtotal_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (subtotal_centavos >= 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    productoId,
    cantidad,
    precioUnitarioCentavos,
    costoUnitarioCentavos,
    subtotalCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'detalle_venta';
  @override
  VerificationContext validateIntegrity(
    Insertable<DetalleVentaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario_centavos')) {
      context.handle(
        _precioUnitarioCentavosMeta,
        precioUnitarioCentavos.isAcceptableOrUnknown(
          data['precio_unitario_centavos']!,
          _precioUnitarioCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_precioUnitarioCentavosMeta);
    }
    if (data.containsKey('costo_unitario_centavos')) {
      context.handle(
        _costoUnitarioCentavosMeta,
        costoUnitarioCentavos.isAcceptableOrUnknown(
          data['costo_unitario_centavos']!,
          _costoUnitarioCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_costoUnitarioCentavosMeta);
    }
    if (data.containsKey('subtotal_centavos')) {
      context.handle(
        _subtotalCentavosMeta,
        subtotalCentavos.isAcceptableOrUnknown(
          data['subtotal_centavos']!,
          _subtotalCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalCentavosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DetalleVentaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DetalleVentaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitarioCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}precio_unitario_centavos'],
      )!,
      costoUnitarioCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}costo_unitario_centavos'],
      )!,
      subtotalCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_centavos'],
      )!,
    );
  }

  @override
  DetalleVenta createAlias(String alias) {
    return DetalleVenta(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DetalleVentaData extends DataClass
    implements Insertable<DetalleVentaData> {
  final int id;
  final int ventaId;
  final int productoId;
  final int cantidad;
  final int precioUnitarioCentavos;
  final int costoUnitarioCentavos;
  final int subtotalCentavos;
  const DetalleVentaData({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitarioCentavos,
    required this.costoUnitarioCentavos,
    required this.subtotalCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['precio_unitario_centavos'] = Variable<int>(precioUnitarioCentavos);
    map['costo_unitario_centavos'] = Variable<int>(costoUnitarioCentavos);
    map['subtotal_centavos'] = Variable<int>(subtotalCentavos);
    return map;
  }

  DetalleVentaCompanion toCompanion(bool nullToAbsent) {
    return DetalleVentaCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      precioUnitarioCentavos: Value(precioUnitarioCentavos),
      costoUnitarioCentavos: Value(costoUnitarioCentavos),
      subtotalCentavos: Value(subtotalCentavos),
    );
  }

  factory DetalleVentaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DetalleVentaData(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['venta_id']),
      productoId: serializer.fromJson<int>(json['producto_id']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      precioUnitarioCentavos: serializer.fromJson<int>(
        json['precio_unitario_centavos'],
      ),
      costoUnitarioCentavos: serializer.fromJson<int>(
        json['costo_unitario_centavos'],
      ),
      subtotalCentavos: serializer.fromJson<int>(json['subtotal_centavos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'venta_id': serializer.toJson<int>(ventaId),
      'producto_id': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'precio_unitario_centavos': serializer.toJson<int>(
        precioUnitarioCentavos,
      ),
      'costo_unitario_centavos': serializer.toJson<int>(costoUnitarioCentavos),
      'subtotal_centavos': serializer.toJson<int>(subtotalCentavos),
    };
  }

  DetalleVentaData copyWith({
    int? id,
    int? ventaId,
    int? productoId,
    int? cantidad,
    int? precioUnitarioCentavos,
    int? costoUnitarioCentavos,
    int? subtotalCentavos,
  }) => DetalleVentaData(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    productoId: productoId ?? this.productoId,
    cantidad: cantidad ?? this.cantidad,
    precioUnitarioCentavos:
        precioUnitarioCentavos ?? this.precioUnitarioCentavos,
    costoUnitarioCentavos: costoUnitarioCentavos ?? this.costoUnitarioCentavos,
    subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
  );
  DetalleVentaData copyWithCompanion(DetalleVentaCompanion data) {
    return DetalleVentaData(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitarioCentavos: data.precioUnitarioCentavos.present
          ? data.precioUnitarioCentavos.value
          : this.precioUnitarioCentavos,
      costoUnitarioCentavos: data.costoUnitarioCentavos.present
          ? data.costoUnitarioCentavos.value
          : this.costoUnitarioCentavos,
      subtotalCentavos: data.subtotalCentavos.present
          ? data.subtotalCentavos.value
          : this.subtotalCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DetalleVentaData(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitarioCentavos: $precioUnitarioCentavos, ')
          ..write('costoUnitarioCentavos: $costoUnitarioCentavos, ')
          ..write('subtotalCentavos: $subtotalCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ventaId,
    productoId,
    cantidad,
    precioUnitarioCentavos,
    costoUnitarioCentavos,
    subtotalCentavos,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DetalleVentaData &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.precioUnitarioCentavos == this.precioUnitarioCentavos &&
          other.costoUnitarioCentavos == this.costoUnitarioCentavos &&
          other.subtotalCentavos == this.subtotalCentavos);
}

class DetalleVentaCompanion extends UpdateCompanion<DetalleVentaData> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<int> productoId;
  final Value<int> cantidad;
  final Value<int> precioUnitarioCentavos;
  final Value<int> costoUnitarioCentavos;
  final Value<int> subtotalCentavos;
  const DetalleVentaCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitarioCentavos = const Value.absent(),
    this.costoUnitarioCentavos = const Value.absent(),
    this.subtotalCentavos = const Value.absent(),
  });
  DetalleVentaCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required int productoId,
    required int cantidad,
    required int precioUnitarioCentavos,
    required int costoUnitarioCentavos,
    required int subtotalCentavos,
  }) : ventaId = Value(ventaId),
       productoId = Value(productoId),
       cantidad = Value(cantidad),
       precioUnitarioCentavos = Value(precioUnitarioCentavos),
       costoUnitarioCentavos = Value(costoUnitarioCentavos),
       subtotalCentavos = Value(subtotalCentavos);
  static Insertable<DetalleVentaData> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<int>? productoId,
    Expression<int>? cantidad,
    Expression<int>? precioUnitarioCentavos,
    Expression<int>? costoUnitarioCentavos,
    Expression<int>? subtotalCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitarioCentavos != null)
        'precio_unitario_centavos': precioUnitarioCentavos,
      if (costoUnitarioCentavos != null)
        'costo_unitario_centavos': costoUnitarioCentavos,
      if (subtotalCentavos != null) 'subtotal_centavos': subtotalCentavos,
    });
  }

  DetalleVentaCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<int>? productoId,
    Value<int>? cantidad,
    Value<int>? precioUnitarioCentavos,
    Value<int>? costoUnitarioCentavos,
    Value<int>? subtotalCentavos,
  }) {
    return DetalleVentaCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitarioCentavos:
          precioUnitarioCentavos ?? this.precioUnitarioCentavos,
      costoUnitarioCentavos:
          costoUnitarioCentavos ?? this.costoUnitarioCentavos,
      subtotalCentavos: subtotalCentavos ?? this.subtotalCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (precioUnitarioCentavos.present) {
      map['precio_unitario_centavos'] = Variable<int>(
        precioUnitarioCentavos.value,
      );
    }
    if (costoUnitarioCentavos.present) {
      map['costo_unitario_centavos'] = Variable<int>(
        costoUnitarioCentavos.value,
      );
    }
    if (subtotalCentavos.present) {
      map['subtotal_centavos'] = Variable<int>(subtotalCentavos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DetalleVentaCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitarioCentavos: $precioUnitarioCentavos, ')
          ..write('costoUnitarioCentavos: $costoUnitarioCentavos, ')
          ..write('subtotalCentavos: $subtotalCentavos')
          ..write(')'))
        .toString();
  }
}

class OperacionEnvase extends Table
    with TableInfo<OperacionEnvase, OperacionEnvaseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  OperacionEnvase(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES venta(id)',
  );
  static const VerificationMeta _tipoEnvaseIdMeta = const VerificationMeta(
    'tipoEnvaseId',
  );
  late final GeneratedColumn<int> tipoEnvaseId = GeneratedColumn<int>(
    'tipo_envase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES tipo_envase(id)',
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (tipo IN (\'DEPOSITO_COBRADO\', \'RECIBIDO\', \'ENTREGADO\', \'PRESTADO\'))',
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad > 0)',
  );
  static const VerificationMeta _montoUnitarioCentavosMeta =
      const VerificationMeta('montoUnitarioCentavos');
  late final GeneratedColumn<int> montoUnitarioCentavos = GeneratedColumn<int>(
    'monto_unitario_centavos',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK ((tipo = \'DEPOSITO_COBRADO\' AND monto_unitario_centavos IS NOT NULL AND monto_unitario_centavos >= 0)OR(tipo != \'DEPOSITO_COBRADO\' AND monto_unitario_centavos IS NULL))',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    tipoEnvaseId,
    tipo,
    cantidad,
    montoUnitarioCentavos,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operacion_envase';
  @override
  VerificationContext validateIntegrity(
    Insertable<OperacionEnvaseData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('tipo_envase_id')) {
      context.handle(
        _tipoEnvaseIdMeta,
        tipoEnvaseId.isAcceptableOrUnknown(
          data['tipo_envase_id']!,
          _tipoEnvaseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoEnvaseIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('monto_unitario_centavos')) {
      context.handle(
        _montoUnitarioCentavosMeta,
        montoUnitarioCentavos.isAcceptableOrUnknown(
          data['monto_unitario_centavos']!,
          _montoUnitarioCentavosMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OperacionEnvaseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperacionEnvaseData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      tipoEnvaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_envase_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      montoUnitarioCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_unitario_centavos'],
      ),
    );
  }

  @override
  OperacionEnvase createAlias(String alias) {
    return OperacionEnvase(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class OperacionEnvaseData extends DataClass
    implements Insertable<OperacionEnvaseData> {
  final int id;
  final int ventaId;
  final int tipoEnvaseId;
  final String tipo;
  final int cantidad;
  final int? montoUnitarioCentavos;
  const OperacionEnvaseData({
    required this.id,
    required this.ventaId,
    required this.tipoEnvaseId,
    required this.tipo,
    required this.cantidad,
    this.montoUnitarioCentavos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['tipo_envase_id'] = Variable<int>(tipoEnvaseId);
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<int>(cantidad);
    if (!nullToAbsent || montoUnitarioCentavos != null) {
      map['monto_unitario_centavos'] = Variable<int>(montoUnitarioCentavos);
    }
    return map;
  }

  OperacionEnvaseCompanion toCompanion(bool nullToAbsent) {
    return OperacionEnvaseCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      tipoEnvaseId: Value(tipoEnvaseId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      montoUnitarioCentavos: montoUnitarioCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(montoUnitarioCentavos),
    );
  }

  factory OperacionEnvaseData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperacionEnvaseData(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['venta_id']),
      tipoEnvaseId: serializer.fromJson<int>(json['tipo_envase_id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      montoUnitarioCentavos: serializer.fromJson<int?>(
        json['monto_unitario_centavos'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'venta_id': serializer.toJson<int>(ventaId),
      'tipo_envase_id': serializer.toJson<int>(tipoEnvaseId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<int>(cantidad),
      'monto_unitario_centavos': serializer.toJson<int?>(montoUnitarioCentavos),
    };
  }

  OperacionEnvaseData copyWith({
    int? id,
    int? ventaId,
    int? tipoEnvaseId,
    String? tipo,
    int? cantidad,
    Value<int?> montoUnitarioCentavos = const Value.absent(),
  }) => OperacionEnvaseData(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
    tipo: tipo ?? this.tipo,
    cantidad: cantidad ?? this.cantidad,
    montoUnitarioCentavos: montoUnitarioCentavos.present
        ? montoUnitarioCentavos.value
        : this.montoUnitarioCentavos,
  );
  OperacionEnvaseData copyWithCompanion(OperacionEnvaseCompanion data) {
    return OperacionEnvaseData(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      tipoEnvaseId: data.tipoEnvaseId.present
          ? data.tipoEnvaseId.value
          : this.tipoEnvaseId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      montoUnitarioCentavos: data.montoUnitarioCentavos.present
          ? data.montoUnitarioCentavos.value
          : this.montoUnitarioCentavos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperacionEnvaseData(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('montoUnitarioCentavos: $montoUnitarioCentavos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ventaId,
    tipoEnvaseId,
    tipo,
    cantidad,
    montoUnitarioCentavos,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperacionEnvaseData &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.tipoEnvaseId == this.tipoEnvaseId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.montoUnitarioCentavos == this.montoUnitarioCentavos);
}

class OperacionEnvaseCompanion extends UpdateCompanion<OperacionEnvaseData> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<int> tipoEnvaseId;
  final Value<String> tipo;
  final Value<int> cantidad;
  final Value<int?> montoUnitarioCentavos;
  const OperacionEnvaseCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.tipoEnvaseId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.montoUnitarioCentavos = const Value.absent(),
  });
  OperacionEnvaseCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required int tipoEnvaseId,
    required String tipo,
    required int cantidad,
    this.montoUnitarioCentavos = const Value.absent(),
  }) : ventaId = Value(ventaId),
       tipoEnvaseId = Value(tipoEnvaseId),
       tipo = Value(tipo),
       cantidad = Value(cantidad);
  static Insertable<OperacionEnvaseData> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<int>? tipoEnvaseId,
    Expression<String>? tipo,
    Expression<int>? cantidad,
    Expression<int>? montoUnitarioCentavos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (tipoEnvaseId != null) 'tipo_envase_id': tipoEnvaseId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (montoUnitarioCentavos != null)
        'monto_unitario_centavos': montoUnitarioCentavos,
    });
  }

  OperacionEnvaseCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<int>? tipoEnvaseId,
    Value<String>? tipo,
    Value<int>? cantidad,
    Value<int?>? montoUnitarioCentavos,
  }) {
    return OperacionEnvaseCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      montoUnitarioCentavos:
          montoUnitarioCentavos ?? this.montoUnitarioCentavos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (tipoEnvaseId.present) {
      map['tipo_envase_id'] = Variable<int>(tipoEnvaseId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (montoUnitarioCentavos.present) {
      map['monto_unitario_centavos'] = Variable<int>(
        montoUnitarioCentavos.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperacionEnvaseCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('montoUnitarioCentavos: $montoUnitarioCentavos')
          ..write(')'))
        .toString();
  }
}

class Pago extends Table with TableInfo<Pago, PagoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Pago(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES venta(id)',
  );
  static const VerificationMeta _metodoMeta = const VerificationMeta('metodo');
  late final GeneratedColumn<String> metodo = GeneratedColumn<String>(
    'metodo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (metodo IN (\'EFECTIVO\', \'TARJETA\'))',
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (monto_centavos > 0)',
  );
  static const VerificationMeta _ivaCentavosMeta = const VerificationMeta(
    'ivaCentavos',
  );
  late final GeneratedColumn<int> ivaCentavos = GeneratedColumn<int>(
    'iva_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0 CHECK ((metodo = \'TARJETA\' AND iva_centavos >= 0 AND iva_centavos <= monto_centavos)OR(metodo = \'EFECTIVO\' AND iva_centavos = 0))',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    metodo,
    montoCentavos,
    ivaCentavos,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pago';
  @override
  VerificationContext validateIntegrity(
    Insertable<PagoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('metodo')) {
      context.handle(
        _metodoMeta,
        metodo.isAcceptableOrUnknown(data['metodo']!, _metodoMeta),
      );
    } else if (isInserting) {
      context.missing(_metodoMeta);
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('iva_centavos')) {
      context.handle(
        _ivaCentavosMeta,
        ivaCentavos.isAcceptableOrUnknown(
          data['iva_centavos']!,
          _ivaCentavosMeta,
        ),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PagoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PagoData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      metodo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metodo'],
      )!,
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
      ivaCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}iva_centavos'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  Pago createAlias(String alias) {
    return Pago(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class PagoData extends DataClass implements Insertable<PagoData> {
  final int id;
  final int ventaId;
  final String metodo;
  final int montoCentavos;
  final int ivaCentavos;
  final String fecha;
  const PagoData({
    required this.id,
    required this.ventaId,
    required this.metodo,
    required this.montoCentavos,
    required this.ivaCentavos,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['metodo'] = Variable<String>(metodo);
    map['monto_centavos'] = Variable<int>(montoCentavos);
    map['iva_centavos'] = Variable<int>(ivaCentavos);
    map['fecha'] = Variable<String>(fecha);
    return map;
  }

  PagoCompanion toCompanion(bool nullToAbsent) {
    return PagoCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      metodo: Value(metodo),
      montoCentavos: Value(montoCentavos),
      ivaCentavos: Value(ivaCentavos),
      fecha: Value(fecha),
    );
  }

  factory PagoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PagoData(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['venta_id']),
      metodo: serializer.fromJson<String>(json['metodo']),
      montoCentavos: serializer.fromJson<int>(json['monto_centavos']),
      ivaCentavos: serializer.fromJson<int>(json['iva_centavos']),
      fecha: serializer.fromJson<String>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'venta_id': serializer.toJson<int>(ventaId),
      'metodo': serializer.toJson<String>(metodo),
      'monto_centavos': serializer.toJson<int>(montoCentavos),
      'iva_centavos': serializer.toJson<int>(ivaCentavos),
      'fecha': serializer.toJson<String>(fecha),
    };
  }

  PagoData copyWith({
    int? id,
    int? ventaId,
    String? metodo,
    int? montoCentavos,
    int? ivaCentavos,
    String? fecha,
  }) => PagoData(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    metodo: metodo ?? this.metodo,
    montoCentavos: montoCentavos ?? this.montoCentavos,
    ivaCentavos: ivaCentavos ?? this.ivaCentavos,
    fecha: fecha ?? this.fecha,
  );
  PagoData copyWithCompanion(PagoCompanion data) {
    return PagoData(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      metodo: data.metodo.present ? data.metodo.value : this.metodo,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      ivaCentavos: data.ivaCentavos.present
          ? data.ivaCentavos.value
          : this.ivaCentavos,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PagoData(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('metodo: $metodo, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('ivaCentavos: $ivaCentavos, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ventaId, metodo, montoCentavos, ivaCentavos, fecha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PagoData &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.metodo == this.metodo &&
          other.montoCentavos == this.montoCentavos &&
          other.ivaCentavos == this.ivaCentavos &&
          other.fecha == this.fecha);
}

class PagoCompanion extends UpdateCompanion<PagoData> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<String> metodo;
  final Value<int> montoCentavos;
  final Value<int> ivaCentavos;
  final Value<String> fecha;
  const PagoCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.metodo = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.ivaCentavos = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  PagoCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required String metodo,
    required int montoCentavos,
    this.ivaCentavos = const Value.absent(),
    this.fecha = const Value.absent(),
  }) : ventaId = Value(ventaId),
       metodo = Value(metodo),
       montoCentavos = Value(montoCentavos);
  static Insertable<PagoData> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<String>? metodo,
    Expression<int>? montoCentavos,
    Expression<int>? ivaCentavos,
    Expression<String>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (metodo != null) 'metodo': metodo,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (ivaCentavos != null) 'iva_centavos': ivaCentavos,
      if (fecha != null) 'fecha': fecha,
    });
  }

  PagoCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<String>? metodo,
    Value<int>? montoCentavos,
    Value<int>? ivaCentavos,
    Value<String>? fecha,
  }) {
    return PagoCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      metodo: metodo ?? this.metodo,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      ivaCentavos: ivaCentavos ?? this.ivaCentavos,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (metodo.present) {
      map['metodo'] = Variable<String>(metodo.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (ivaCentavos.present) {
      map['iva_centavos'] = Variable<int>(ivaCentavos.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagoCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('metodo: $metodo, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('ivaCentavos: $ivaCentavos, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class CuentaMonetariaMov extends Table
    with TableInfo<CuentaMonetariaMov, CuentaMonetariaMovData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CuentaMonetariaMov(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES cliente(id)',
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES venta(id)',
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (tipo IN (\'CARGO\', \'ABONO\', \'CANCELACION\'))',
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (monto_centavos > 0)',
  );
  static const VerificationMeta _referenciaTipoMeta = const VerificationMeta(
    'referenciaTipo',
  );
  late final GeneratedColumn<String> referenciaTipo = GeneratedColumn<String>(
    'referencia_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (referencia_tipo IN (\'VENTA\', \'PAGO_CUENTA\', \'DEVOLUCION\', \'DEVOLUCION_DEPOSITO\', \'CANCELACION_VENTA\'))',
  );
  static const VerificationMeta _referenciaIdMeta = const VerificationMeta(
    'referenciaId',
  );
  late final GeneratedColumn<int> referenciaId = GeneratedColumn<int>(
    'referencia_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _reversaDeIdMeta = const VerificationMeta(
    'reversaDeId',
  );
  late final GeneratedColumn<int> reversaDeId = GeneratedColumn<int>(
    'reversa_de_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES cuenta_monetaria_mov(id)',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    ventaId,
    tipo,
    montoCentavos,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cuenta_monetaria_mov';
  @override
  VerificationContext validateIntegrity(
    Insertable<CuentaMonetariaMovData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('referencia_tipo')) {
      context.handle(
        _referenciaTipoMeta,
        referenciaTipo.isAcceptableOrUnknown(
          data['referencia_tipo']!,
          _referenciaTipoMeta,
        ),
      );
    }
    if (data.containsKey('referencia_id')) {
      context.handle(
        _referenciaIdMeta,
        referenciaId.isAcceptableOrUnknown(
          data['referencia_id']!,
          _referenciaIdMeta,
        ),
      );
    }
    if (data.containsKey('reversa_de_id')) {
      context.handle(
        _reversaDeIdMeta,
        reversaDeId.isAcceptableOrUnknown(
          data['reversa_de_id']!,
          _reversaDeIdMeta,
        ),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuentaMonetariaMovData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CuentaMonetariaMovData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
      referenciaTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia_tipo'],
      ),
      referenciaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referencia_id'],
      ),
      reversaDeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reversa_de_id'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  CuentaMonetariaMov createAlias(String alias) {
    return CuentaMonetariaMov(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CuentaMonetariaMovData extends DataClass
    implements Insertable<CuentaMonetariaMovData> {
  final int id;
  final int clienteId;
  final int? ventaId;
  final String tipo;
  final int montoCentavos;
  final String? referenciaTipo;
  final int? referenciaId;
  final int? reversaDeId;
  final int usuarioId;
  final String fecha;
  const CuentaMonetariaMovData({
    required this.id,
    required this.clienteId,
    this.ventaId,
    required this.tipo,
    required this.montoCentavos,
    this.referenciaTipo,
    this.referenciaId,
    this.reversaDeId,
    required this.usuarioId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    if (!nullToAbsent || ventaId != null) {
      map['venta_id'] = Variable<int>(ventaId);
    }
    map['tipo'] = Variable<String>(tipo);
    map['monto_centavos'] = Variable<int>(montoCentavos);
    if (!nullToAbsent || referenciaTipo != null) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo);
    }
    if (!nullToAbsent || referenciaId != null) {
      map['referencia_id'] = Variable<int>(referenciaId);
    }
    if (!nullToAbsent || reversaDeId != null) {
      map['reversa_de_id'] = Variable<int>(reversaDeId);
    }
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    return map;
  }

  CuentaMonetariaMovCompanion toCompanion(bool nullToAbsent) {
    return CuentaMonetariaMovCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      ventaId: ventaId == null && nullToAbsent
          ? const Value.absent()
          : Value(ventaId),
      tipo: Value(tipo),
      montoCentavos: Value(montoCentavos),
      referenciaTipo: referenciaTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaTipo),
      referenciaId: referenciaId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaId),
      reversaDeId: reversaDeId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversaDeId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
    );
  }

  factory CuentaMonetariaMovData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CuentaMonetariaMovData(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['cliente_id']),
      ventaId: serializer.fromJson<int?>(json['venta_id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      montoCentavos: serializer.fromJson<int>(json['monto_centavos']),
      referenciaTipo: serializer.fromJson<String?>(json['referencia_tipo']),
      referenciaId: serializer.fromJson<int?>(json['referencia_id']),
      reversaDeId: serializer.fromJson<int?>(json['reversa_de_id']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cliente_id': serializer.toJson<int>(clienteId),
      'venta_id': serializer.toJson<int?>(ventaId),
      'tipo': serializer.toJson<String>(tipo),
      'monto_centavos': serializer.toJson<int>(montoCentavos),
      'referencia_tipo': serializer.toJson<String?>(referenciaTipo),
      'referencia_id': serializer.toJson<int?>(referenciaId),
      'reversa_de_id': serializer.toJson<int?>(reversaDeId),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
    };
  }

  CuentaMonetariaMovData copyWith({
    int? id,
    int? clienteId,
    Value<int?> ventaId = const Value.absent(),
    String? tipo,
    int? montoCentavos,
    Value<String?> referenciaTipo = const Value.absent(),
    Value<int?> referenciaId = const Value.absent(),
    Value<int?> reversaDeId = const Value.absent(),
    int? usuarioId,
    String? fecha,
  }) => CuentaMonetariaMovData(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    ventaId: ventaId.present ? ventaId.value : this.ventaId,
    tipo: tipo ?? this.tipo,
    montoCentavos: montoCentavos ?? this.montoCentavos,
    referenciaTipo: referenciaTipo.present
        ? referenciaTipo.value
        : this.referenciaTipo,
    referenciaId: referenciaId.present ? referenciaId.value : this.referenciaId,
    reversaDeId: reversaDeId.present ? reversaDeId.value : this.reversaDeId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
  );
  CuentaMonetariaMovData copyWithCompanion(CuentaMonetariaMovCompanion data) {
    return CuentaMonetariaMovData(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      referenciaTipo: data.referenciaTipo.present
          ? data.referenciaTipo.value
          : this.referenciaTipo,
      referenciaId: data.referenciaId.present
          ? data.referenciaId.value
          : this.referenciaId,
      reversaDeId: data.reversaDeId.present
          ? data.reversaDeId.value
          : this.reversaDeId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CuentaMonetariaMovData(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    ventaId,
    tipo,
    montoCentavos,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuentaMonetariaMovData &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.ventaId == this.ventaId &&
          other.tipo == this.tipo &&
          other.montoCentavos == this.montoCentavos &&
          other.referenciaTipo == this.referenciaTipo &&
          other.referenciaId == this.referenciaId &&
          other.reversaDeId == this.reversaDeId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha);
}

class CuentaMonetariaMovCompanion
    extends UpdateCompanion<CuentaMonetariaMovData> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<int?> ventaId;
  final Value<String> tipo;
  final Value<int> montoCentavos;
  final Value<String?> referenciaTipo;
  final Value<int?> referenciaId;
  final Value<int?> reversaDeId;
  final Value<int> usuarioId;
  final Value<String> fecha;
  const CuentaMonetariaMovCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  CuentaMonetariaMovCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    this.ventaId = const Value.absent(),
    required String tipo,
    required int montoCentavos,
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    required int usuarioId,
    this.fecha = const Value.absent(),
  }) : clienteId = Value(clienteId),
       tipo = Value(tipo),
       montoCentavos = Value(montoCentavos),
       usuarioId = Value(usuarioId);
  static Insertable<CuentaMonetariaMovData> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<int>? ventaId,
    Expression<String>? tipo,
    Expression<int>? montoCentavos,
    Expression<String>? referenciaTipo,
    Expression<int>? referenciaId,
    Expression<int>? reversaDeId,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (ventaId != null) 'venta_id': ventaId,
      if (tipo != null) 'tipo': tipo,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (referenciaTipo != null) 'referencia_tipo': referenciaTipo,
      if (referenciaId != null) 'referencia_id': referenciaId,
      if (reversaDeId != null) 'reversa_de_id': reversaDeId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
    });
  }

  CuentaMonetariaMovCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<int?>? ventaId,
    Value<String>? tipo,
    Value<int>? montoCentavos,
    Value<String?>? referenciaTipo,
    Value<int?>? referenciaId,
    Value<int?>? reversaDeId,
    Value<int>? usuarioId,
    Value<String>? fecha,
  }) {
    return CuentaMonetariaMovCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      ventaId: ventaId ?? this.ventaId,
      tipo: tipo ?? this.tipo,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      referenciaTipo: referenciaTipo ?? this.referenciaTipo,
      referenciaId: referenciaId ?? this.referenciaId,
      reversaDeId: reversaDeId ?? this.reversaDeId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (referenciaTipo.present) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo.value);
    }
    if (referenciaId.present) {
      map['referencia_id'] = Variable<int>(referenciaId.value);
    }
    if (reversaDeId.present) {
      map['reversa_de_id'] = Variable<int>(reversaDeId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuentaMonetariaMovCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class CuentaEnvaseMov extends Table
    with TableInfo<CuentaEnvaseMov, CuentaEnvaseMovData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CuentaEnvaseMov(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES cliente(id)',
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES venta(id)',
  );
  static const VerificationMeta _tipoEnvaseIdMeta = const VerificationMeta(
    'tipoEnvaseId',
  );
  late final GeneratedColumn<int> tipoEnvaseId = GeneratedColumn<int>(
    'tipo_envase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES tipo_envase(id)',
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (tipo IN (\'PRESTAMO\', \'DEVOLUCION\', \'PAGO\', \'CANCELACION\'))',
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad > 0)',
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK ((tipo = \'PAGO\' AND monto_centavos IS NOT NULL AND monto_centavos >= 0)OR(tipo != \'PAGO\' AND monto_centavos IS NULL))',
  );
  static const VerificationMeta _referenciaTipoMeta = const VerificationMeta(
    'referenciaTipo',
  );
  late final GeneratedColumn<String> referenciaTipo = GeneratedColumn<String>(
    'referencia_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (referencia_tipo IN (\'VENTA\', \'AJUSTE_MANUAL\', \'CANCELACION_VENTA\'))',
  );
  static const VerificationMeta _referenciaIdMeta = const VerificationMeta(
    'referenciaId',
  );
  late final GeneratedColumn<int> referenciaId = GeneratedColumn<int>(
    'referencia_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _reversaDeIdMeta = const VerificationMeta(
    'reversaDeId',
  );
  late final GeneratedColumn<int> reversaDeId = GeneratedColumn<int>(
    'reversa_de_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES cuenta_envase_mov(id)',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clienteId,
    ventaId,
    tipoEnvaseId,
    tipo,
    cantidad,
    montoCentavos,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cuenta_envase_mov';
  @override
  VerificationContext validateIntegrity(
    Insertable<CuentaEnvaseMovData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    }
    if (data.containsKey('tipo_envase_id')) {
      context.handle(
        _tipoEnvaseIdMeta,
        tipoEnvaseId.isAcceptableOrUnknown(
          data['tipo_envase_id']!,
          _tipoEnvaseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoEnvaseIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    }
    if (data.containsKey('referencia_tipo')) {
      context.handle(
        _referenciaTipoMeta,
        referenciaTipo.isAcceptableOrUnknown(
          data['referencia_tipo']!,
          _referenciaTipoMeta,
        ),
      );
    }
    if (data.containsKey('referencia_id')) {
      context.handle(
        _referenciaIdMeta,
        referenciaId.isAcceptableOrUnknown(
          data['referencia_id']!,
          _referenciaIdMeta,
        ),
      );
    }
    if (data.containsKey('reversa_de_id')) {
      context.handle(
        _reversaDeIdMeta,
        reversaDeId.isAcceptableOrUnknown(
          data['reversa_de_id']!,
          _reversaDeIdMeta,
        ),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuentaEnvaseMovData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CuentaEnvaseMovData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      ),
      tipoEnvaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_envase_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      ),
      referenciaTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia_tipo'],
      ),
      referenciaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referencia_id'],
      ),
      reversaDeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reversa_de_id'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  CuentaEnvaseMov createAlias(String alias) {
    return CuentaEnvaseMov(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CuentaEnvaseMovData extends DataClass
    implements Insertable<CuentaEnvaseMovData> {
  final int id;
  final int clienteId;
  final int? ventaId;
  final int tipoEnvaseId;
  final String tipo;
  final int cantidad;
  final int? montoCentavos;
  final String? referenciaTipo;
  final int? referenciaId;
  final int? reversaDeId;
  final int usuarioId;
  final String fecha;
  const CuentaEnvaseMovData({
    required this.id,
    required this.clienteId,
    this.ventaId,
    required this.tipoEnvaseId,
    required this.tipo,
    required this.cantidad,
    this.montoCentavos,
    this.referenciaTipo,
    this.referenciaId,
    this.reversaDeId,
    required this.usuarioId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cliente_id'] = Variable<int>(clienteId);
    if (!nullToAbsent || ventaId != null) {
      map['venta_id'] = Variable<int>(ventaId);
    }
    map['tipo_envase_id'] = Variable<int>(tipoEnvaseId);
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<int>(cantidad);
    if (!nullToAbsent || montoCentavos != null) {
      map['monto_centavos'] = Variable<int>(montoCentavos);
    }
    if (!nullToAbsent || referenciaTipo != null) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo);
    }
    if (!nullToAbsent || referenciaId != null) {
      map['referencia_id'] = Variable<int>(referenciaId);
    }
    if (!nullToAbsent || reversaDeId != null) {
      map['reversa_de_id'] = Variable<int>(reversaDeId);
    }
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    return map;
  }

  CuentaEnvaseMovCompanion toCompanion(bool nullToAbsent) {
    return CuentaEnvaseMovCompanion(
      id: Value(id),
      clienteId: Value(clienteId),
      ventaId: ventaId == null && nullToAbsent
          ? const Value.absent()
          : Value(ventaId),
      tipoEnvaseId: Value(tipoEnvaseId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      montoCentavos: montoCentavos == null && nullToAbsent
          ? const Value.absent()
          : Value(montoCentavos),
      referenciaTipo: referenciaTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaTipo),
      referenciaId: referenciaId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaId),
      reversaDeId: reversaDeId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversaDeId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
    );
  }

  factory CuentaEnvaseMovData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CuentaEnvaseMovData(
      id: serializer.fromJson<int>(json['id']),
      clienteId: serializer.fromJson<int>(json['cliente_id']),
      ventaId: serializer.fromJson<int?>(json['venta_id']),
      tipoEnvaseId: serializer.fromJson<int>(json['tipo_envase_id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      montoCentavos: serializer.fromJson<int?>(json['monto_centavos']),
      referenciaTipo: serializer.fromJson<String?>(json['referencia_tipo']),
      referenciaId: serializer.fromJson<int?>(json['referencia_id']),
      reversaDeId: serializer.fromJson<int?>(json['reversa_de_id']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cliente_id': serializer.toJson<int>(clienteId),
      'venta_id': serializer.toJson<int?>(ventaId),
      'tipo_envase_id': serializer.toJson<int>(tipoEnvaseId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<int>(cantidad),
      'monto_centavos': serializer.toJson<int?>(montoCentavos),
      'referencia_tipo': serializer.toJson<String?>(referenciaTipo),
      'referencia_id': serializer.toJson<int?>(referenciaId),
      'reversa_de_id': serializer.toJson<int?>(reversaDeId),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
    };
  }

  CuentaEnvaseMovData copyWith({
    int? id,
    int? clienteId,
    Value<int?> ventaId = const Value.absent(),
    int? tipoEnvaseId,
    String? tipo,
    int? cantidad,
    Value<int?> montoCentavos = const Value.absent(),
    Value<String?> referenciaTipo = const Value.absent(),
    Value<int?> referenciaId = const Value.absent(),
    Value<int?> reversaDeId = const Value.absent(),
    int? usuarioId,
    String? fecha,
  }) => CuentaEnvaseMovData(
    id: id ?? this.id,
    clienteId: clienteId ?? this.clienteId,
    ventaId: ventaId.present ? ventaId.value : this.ventaId,
    tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
    tipo: tipo ?? this.tipo,
    cantidad: cantidad ?? this.cantidad,
    montoCentavos: montoCentavos.present
        ? montoCentavos.value
        : this.montoCentavos,
    referenciaTipo: referenciaTipo.present
        ? referenciaTipo.value
        : this.referenciaTipo,
    referenciaId: referenciaId.present ? referenciaId.value : this.referenciaId,
    reversaDeId: reversaDeId.present ? reversaDeId.value : this.reversaDeId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
  );
  CuentaEnvaseMovData copyWithCompanion(CuentaEnvaseMovCompanion data) {
    return CuentaEnvaseMovData(
      id: data.id.present ? data.id.value : this.id,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      tipoEnvaseId: data.tipoEnvaseId.present
          ? data.tipoEnvaseId.value
          : this.tipoEnvaseId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      referenciaTipo: data.referenciaTipo.present
          ? data.referenciaTipo.value
          : this.referenciaTipo,
      referenciaId: data.referenciaId.present
          ? data.referenciaId.value
          : this.referenciaId,
      reversaDeId: data.reversaDeId.present
          ? data.reversaDeId.value
          : this.reversaDeId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CuentaEnvaseMovData(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clienteId,
    ventaId,
    tipoEnvaseId,
    tipo,
    cantidad,
    montoCentavos,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuentaEnvaseMovData &&
          other.id == this.id &&
          other.clienteId == this.clienteId &&
          other.ventaId == this.ventaId &&
          other.tipoEnvaseId == this.tipoEnvaseId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.montoCentavos == this.montoCentavos &&
          other.referenciaTipo == this.referenciaTipo &&
          other.referenciaId == this.referenciaId &&
          other.reversaDeId == this.reversaDeId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha);
}

class CuentaEnvaseMovCompanion extends UpdateCompanion<CuentaEnvaseMovData> {
  final Value<int> id;
  final Value<int> clienteId;
  final Value<int?> ventaId;
  final Value<int> tipoEnvaseId;
  final Value<String> tipo;
  final Value<int> cantidad;
  final Value<int?> montoCentavos;
  final Value<String?> referenciaTipo;
  final Value<int?> referenciaId;
  final Value<int?> reversaDeId;
  final Value<int> usuarioId;
  final Value<String> fecha;
  const CuentaEnvaseMovCompanion({
    this.id = const Value.absent(),
    this.clienteId = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.tipoEnvaseId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  CuentaEnvaseMovCompanion.insert({
    this.id = const Value.absent(),
    required int clienteId,
    this.ventaId = const Value.absent(),
    required int tipoEnvaseId,
    required String tipo,
    required int cantidad,
    this.montoCentavos = const Value.absent(),
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    required int usuarioId,
    this.fecha = const Value.absent(),
  }) : clienteId = Value(clienteId),
       tipoEnvaseId = Value(tipoEnvaseId),
       tipo = Value(tipo),
       cantidad = Value(cantidad),
       usuarioId = Value(usuarioId);
  static Insertable<CuentaEnvaseMovData> custom({
    Expression<int>? id,
    Expression<int>? clienteId,
    Expression<int>? ventaId,
    Expression<int>? tipoEnvaseId,
    Expression<String>? tipo,
    Expression<int>? cantidad,
    Expression<int>? montoCentavos,
    Expression<String>? referenciaTipo,
    Expression<int>? referenciaId,
    Expression<int>? reversaDeId,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clienteId != null) 'cliente_id': clienteId,
      if (ventaId != null) 'venta_id': ventaId,
      if (tipoEnvaseId != null) 'tipo_envase_id': tipoEnvaseId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (referenciaTipo != null) 'referencia_tipo': referenciaTipo,
      if (referenciaId != null) 'referencia_id': referenciaId,
      if (reversaDeId != null) 'reversa_de_id': reversaDeId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
    });
  }

  CuentaEnvaseMovCompanion copyWith({
    Value<int>? id,
    Value<int>? clienteId,
    Value<int?>? ventaId,
    Value<int>? tipoEnvaseId,
    Value<String>? tipo,
    Value<int>? cantidad,
    Value<int?>? montoCentavos,
    Value<String?>? referenciaTipo,
    Value<int?>? referenciaId,
    Value<int?>? reversaDeId,
    Value<int>? usuarioId,
    Value<String>? fecha,
  }) {
    return CuentaEnvaseMovCompanion(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      ventaId: ventaId ?? this.ventaId,
      tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      referenciaTipo: referenciaTipo ?? this.referenciaTipo,
      referenciaId: referenciaId ?? this.referenciaId,
      reversaDeId: reversaDeId ?? this.reversaDeId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (tipoEnvaseId.present) {
      map['tipo_envase_id'] = Variable<int>(tipoEnvaseId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (referenciaTipo.present) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo.value);
    }
    if (referenciaId.present) {
      map['referencia_id'] = Variable<int>(referenciaId.value);
    }
    if (reversaDeId.present) {
      map['reversa_de_id'] = Variable<int>(reversaDeId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuentaEnvaseMovCompanion(')
          ..write('id: $id, ')
          ..write('clienteId: $clienteId, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class CuentaDepositoEnvaseMov extends Table
    with TableInfo<CuentaDepositoEnvaseMov, CuentaDepositoEnvaseMovData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CuentaDepositoEnvaseMov(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES venta(id)',
  );
  static const VerificationMeta _tipoEnvaseIdMeta = const VerificationMeta(
    'tipoEnvaseId',
  );
  late final GeneratedColumn<int> tipoEnvaseId = GeneratedColumn<int>(
    'tipo_envase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES tipo_envase(id)',
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (tipo IN (\'COBRADO\', \'DEVUELTO\', \'CANCELACION\'))',
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad > 0)',
  );
  static const VerificationMeta _montoUnitarioCentavosMeta =
      const VerificationMeta('montoUnitarioCentavos');
  late final GeneratedColumn<int> montoUnitarioCentavos = GeneratedColumn<int>(
    'monto_unitario_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (monto_unitario_centavos >= 0)',
  );
  static const VerificationMeta _referenciaTipoMeta = const VerificationMeta(
    'referenciaTipo',
  );
  late final GeneratedColumn<String> referenciaTipo = GeneratedColumn<String>(
    'referencia_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (referencia_tipo IN (\'VENTA\', \'CANCELACION_VENTA\'))',
  );
  static const VerificationMeta _referenciaIdMeta = const VerificationMeta(
    'referenciaId',
  );
  late final GeneratedColumn<int> referenciaId = GeneratedColumn<int>(
    'referencia_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _reversaDeIdMeta = const VerificationMeta(
    'reversaDeId',
  );
  late final GeneratedColumn<int> reversaDeId = GeneratedColumn<int>(
    'reversa_de_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES cuenta_deposito_envase_mov(id)',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    tipoEnvaseId,
    tipo,
    cantidad,
    montoUnitarioCentavos,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cuenta_deposito_envase_mov';
  @override
  VerificationContext validateIntegrity(
    Insertable<CuentaDepositoEnvaseMovData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('tipo_envase_id')) {
      context.handle(
        _tipoEnvaseIdMeta,
        tipoEnvaseId.isAcceptableOrUnknown(
          data['tipo_envase_id']!,
          _tipoEnvaseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoEnvaseIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('monto_unitario_centavos')) {
      context.handle(
        _montoUnitarioCentavosMeta,
        montoUnitarioCentavos.isAcceptableOrUnknown(
          data['monto_unitario_centavos']!,
          _montoUnitarioCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoUnitarioCentavosMeta);
    }
    if (data.containsKey('referencia_tipo')) {
      context.handle(
        _referenciaTipoMeta,
        referenciaTipo.isAcceptableOrUnknown(
          data['referencia_tipo']!,
          _referenciaTipoMeta,
        ),
      );
    }
    if (data.containsKey('referencia_id')) {
      context.handle(
        _referenciaIdMeta,
        referenciaId.isAcceptableOrUnknown(
          data['referencia_id']!,
          _referenciaIdMeta,
        ),
      );
    }
    if (data.containsKey('reversa_de_id')) {
      context.handle(
        _reversaDeIdMeta,
        reversaDeId.isAcceptableOrUnknown(
          data['reversa_de_id']!,
          _reversaDeIdMeta,
        ),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CuentaDepositoEnvaseMovData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CuentaDepositoEnvaseMovData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      tipoEnvaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_envase_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      montoUnitarioCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_unitario_centavos'],
      )!,
      referenciaTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia_tipo'],
      ),
      referenciaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referencia_id'],
      ),
      reversaDeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reversa_de_id'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  CuentaDepositoEnvaseMov createAlias(String alias) {
    return CuentaDepositoEnvaseMov(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CuentaDepositoEnvaseMovData extends DataClass
    implements Insertable<CuentaDepositoEnvaseMovData> {
  final int id;
  final int ventaId;
  final int tipoEnvaseId;
  final String tipo;
  final int cantidad;
  final int montoUnitarioCentavos;
  final String? referenciaTipo;
  final int? referenciaId;
  final int? reversaDeId;
  final int usuarioId;
  final String fecha;
  const CuentaDepositoEnvaseMovData({
    required this.id,
    required this.ventaId,
    required this.tipoEnvaseId,
    required this.tipo,
    required this.cantidad,
    required this.montoUnitarioCentavos,
    this.referenciaTipo,
    this.referenciaId,
    this.reversaDeId,
    required this.usuarioId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['tipo_envase_id'] = Variable<int>(tipoEnvaseId);
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<int>(cantidad);
    map['monto_unitario_centavos'] = Variable<int>(montoUnitarioCentavos);
    if (!nullToAbsent || referenciaTipo != null) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo);
    }
    if (!nullToAbsent || referenciaId != null) {
      map['referencia_id'] = Variable<int>(referenciaId);
    }
    if (!nullToAbsent || reversaDeId != null) {
      map['reversa_de_id'] = Variable<int>(reversaDeId);
    }
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    return map;
  }

  CuentaDepositoEnvaseMovCompanion toCompanion(bool nullToAbsent) {
    return CuentaDepositoEnvaseMovCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      tipoEnvaseId: Value(tipoEnvaseId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      montoUnitarioCentavos: Value(montoUnitarioCentavos),
      referenciaTipo: referenciaTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaTipo),
      referenciaId: referenciaId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaId),
      reversaDeId: reversaDeId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversaDeId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
    );
  }

  factory CuentaDepositoEnvaseMovData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CuentaDepositoEnvaseMovData(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['venta_id']),
      tipoEnvaseId: serializer.fromJson<int>(json['tipo_envase_id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      montoUnitarioCentavos: serializer.fromJson<int>(
        json['monto_unitario_centavos'],
      ),
      referenciaTipo: serializer.fromJson<String?>(json['referencia_tipo']),
      referenciaId: serializer.fromJson<int?>(json['referencia_id']),
      reversaDeId: serializer.fromJson<int?>(json['reversa_de_id']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'venta_id': serializer.toJson<int>(ventaId),
      'tipo_envase_id': serializer.toJson<int>(tipoEnvaseId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<int>(cantidad),
      'monto_unitario_centavos': serializer.toJson<int>(montoUnitarioCentavos),
      'referencia_tipo': serializer.toJson<String?>(referenciaTipo),
      'referencia_id': serializer.toJson<int?>(referenciaId),
      'reversa_de_id': serializer.toJson<int?>(reversaDeId),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
    };
  }

  CuentaDepositoEnvaseMovData copyWith({
    int? id,
    int? ventaId,
    int? tipoEnvaseId,
    String? tipo,
    int? cantidad,
    int? montoUnitarioCentavos,
    Value<String?> referenciaTipo = const Value.absent(),
    Value<int?> referenciaId = const Value.absent(),
    Value<int?> reversaDeId = const Value.absent(),
    int? usuarioId,
    String? fecha,
  }) => CuentaDepositoEnvaseMovData(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
    tipo: tipo ?? this.tipo,
    cantidad: cantidad ?? this.cantidad,
    montoUnitarioCentavos: montoUnitarioCentavos ?? this.montoUnitarioCentavos,
    referenciaTipo: referenciaTipo.present
        ? referenciaTipo.value
        : this.referenciaTipo,
    referenciaId: referenciaId.present ? referenciaId.value : this.referenciaId,
    reversaDeId: reversaDeId.present ? reversaDeId.value : this.reversaDeId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
  );
  CuentaDepositoEnvaseMovData copyWithCompanion(
    CuentaDepositoEnvaseMovCompanion data,
  ) {
    return CuentaDepositoEnvaseMovData(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      tipoEnvaseId: data.tipoEnvaseId.present
          ? data.tipoEnvaseId.value
          : this.tipoEnvaseId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      montoUnitarioCentavos: data.montoUnitarioCentavos.present
          ? data.montoUnitarioCentavos.value
          : this.montoUnitarioCentavos,
      referenciaTipo: data.referenciaTipo.present
          ? data.referenciaTipo.value
          : this.referenciaTipo,
      referenciaId: data.referenciaId.present
          ? data.referenciaId.value
          : this.referenciaId,
      reversaDeId: data.reversaDeId.present
          ? data.reversaDeId.value
          : this.reversaDeId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CuentaDepositoEnvaseMovData(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('montoUnitarioCentavos: $montoUnitarioCentavos, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ventaId,
    tipoEnvaseId,
    tipo,
    cantidad,
    montoUnitarioCentavos,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CuentaDepositoEnvaseMovData &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.tipoEnvaseId == this.tipoEnvaseId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.montoUnitarioCentavos == this.montoUnitarioCentavos &&
          other.referenciaTipo == this.referenciaTipo &&
          other.referenciaId == this.referenciaId &&
          other.reversaDeId == this.reversaDeId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha);
}

class CuentaDepositoEnvaseMovCompanion
    extends UpdateCompanion<CuentaDepositoEnvaseMovData> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<int> tipoEnvaseId;
  final Value<String> tipo;
  final Value<int> cantidad;
  final Value<int> montoUnitarioCentavos;
  final Value<String?> referenciaTipo;
  final Value<int?> referenciaId;
  final Value<int?> reversaDeId;
  final Value<int> usuarioId;
  final Value<String> fecha;
  const CuentaDepositoEnvaseMovCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.tipoEnvaseId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.montoUnitarioCentavos = const Value.absent(),
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  CuentaDepositoEnvaseMovCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required int tipoEnvaseId,
    required String tipo,
    required int cantidad,
    required int montoUnitarioCentavos,
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    required int usuarioId,
    this.fecha = const Value.absent(),
  }) : ventaId = Value(ventaId),
       tipoEnvaseId = Value(tipoEnvaseId),
       tipo = Value(tipo),
       cantidad = Value(cantidad),
       montoUnitarioCentavos = Value(montoUnitarioCentavos),
       usuarioId = Value(usuarioId);
  static Insertable<CuentaDepositoEnvaseMovData> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<int>? tipoEnvaseId,
    Expression<String>? tipo,
    Expression<int>? cantidad,
    Expression<int>? montoUnitarioCentavos,
    Expression<String>? referenciaTipo,
    Expression<int>? referenciaId,
    Expression<int>? reversaDeId,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (tipoEnvaseId != null) 'tipo_envase_id': tipoEnvaseId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (montoUnitarioCentavos != null)
        'monto_unitario_centavos': montoUnitarioCentavos,
      if (referenciaTipo != null) 'referencia_tipo': referenciaTipo,
      if (referenciaId != null) 'referencia_id': referenciaId,
      if (reversaDeId != null) 'reversa_de_id': reversaDeId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
    });
  }

  CuentaDepositoEnvaseMovCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<int>? tipoEnvaseId,
    Value<String>? tipo,
    Value<int>? cantidad,
    Value<int>? montoUnitarioCentavos,
    Value<String?>? referenciaTipo,
    Value<int?>? referenciaId,
    Value<int?>? reversaDeId,
    Value<int>? usuarioId,
    Value<String>? fecha,
  }) {
    return CuentaDepositoEnvaseMovCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      montoUnitarioCentavos:
          montoUnitarioCentavos ?? this.montoUnitarioCentavos,
      referenciaTipo: referenciaTipo ?? this.referenciaTipo,
      referenciaId: referenciaId ?? this.referenciaId,
      reversaDeId: reversaDeId ?? this.reversaDeId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (tipoEnvaseId.present) {
      map['tipo_envase_id'] = Variable<int>(tipoEnvaseId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (montoUnitarioCentavos.present) {
      map['monto_unitario_centavos'] = Variable<int>(
        montoUnitarioCentavos.value,
      );
    }
    if (referenciaTipo.present) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo.value);
    }
    if (referenciaId.present) {
      map['referencia_id'] = Variable<int>(referenciaId.value);
    }
    if (reversaDeId.present) {
      map['reversa_de_id'] = Variable<int>(reversaDeId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CuentaDepositoEnvaseMovCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('montoUnitarioCentavos: $montoUnitarioCentavos, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class EnvaseInventarioMov extends Table
    with TableInfo<EnvaseInventarioMov, EnvaseInventarioMovData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EnvaseInventarioMov(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _tipoEnvaseIdMeta = const VerificationMeta(
    'tipoEnvaseId',
  );
  late final GeneratedColumn<int> tipoEnvaseId = GeneratedColumn<int>(
    'tipo_envase_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES tipo_envase(id)',
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (tipo IN (\'COMPRA_PROVEEDOR\', \'SALIDA_PRESTAMO\', \'ENTRADA_DEVOLUCION\', \'COMPRA_ENVASE_CLIENTE\', \'CANCELACION\', \'MERMA\'))',
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad != 0)',
  );
  static const VerificationMeta _referenciaTipoMeta = const VerificationMeta(
    'referenciaTipo',
  );
  late final GeneratedColumn<String> referenciaTipo = GeneratedColumn<String>(
    'referencia_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (referencia_tipo IN (\'VENTA\', \'COMPRA\', \'CANCELACION_VENTA\', \'AJUSTE_MANUAL\'))',
  );
  static const VerificationMeta _referenciaIdMeta = const VerificationMeta(
    'referenciaId',
  );
  late final GeneratedColumn<int> referenciaId = GeneratedColumn<int>(
    'referencia_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _reversaDeIdMeta = const VerificationMeta(
    'reversaDeId',
  );
  late final GeneratedColumn<int> reversaDeId = GeneratedColumn<int>(
    'reversa_de_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES envase_inventario_mov(id)',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipoEnvaseId,
    tipo,
    cantidad,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envase_inventario_mov';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvaseInventarioMovData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tipo_envase_id')) {
      context.handle(
        _tipoEnvaseIdMeta,
        tipoEnvaseId.isAcceptableOrUnknown(
          data['tipo_envase_id']!,
          _tipoEnvaseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoEnvaseIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('referencia_tipo')) {
      context.handle(
        _referenciaTipoMeta,
        referenciaTipo.isAcceptableOrUnknown(
          data['referencia_tipo']!,
          _referenciaTipoMeta,
        ),
      );
    }
    if (data.containsKey('referencia_id')) {
      context.handle(
        _referenciaIdMeta,
        referenciaId.isAcceptableOrUnknown(
          data['referencia_id']!,
          _referenciaIdMeta,
        ),
      );
    }
    if (data.containsKey('reversa_de_id')) {
      context.handle(
        _reversaDeIdMeta,
        reversaDeId.isAcceptableOrUnknown(
          data['reversa_de_id']!,
          _reversaDeIdMeta,
        ),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvaseInventarioMovData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvaseInventarioMovData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipoEnvaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_envase_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      referenciaTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia_tipo'],
      ),
      referenciaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referencia_id'],
      ),
      reversaDeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reversa_de_id'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  EnvaseInventarioMov createAlias(String alias) {
    return EnvaseInventarioMov(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class EnvaseInventarioMovData extends DataClass
    implements Insertable<EnvaseInventarioMovData> {
  final int id;
  final int tipoEnvaseId;
  final String tipo;
  final int cantidad;
  final String? referenciaTipo;
  final int? referenciaId;
  final int? reversaDeId;
  final int usuarioId;
  final String fecha;
  const EnvaseInventarioMovData({
    required this.id,
    required this.tipoEnvaseId,
    required this.tipo,
    required this.cantidad,
    this.referenciaTipo,
    this.referenciaId,
    this.reversaDeId,
    required this.usuarioId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tipo_envase_id'] = Variable<int>(tipoEnvaseId);
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<int>(cantidad);
    if (!nullToAbsent || referenciaTipo != null) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo);
    }
    if (!nullToAbsent || referenciaId != null) {
      map['referencia_id'] = Variable<int>(referenciaId);
    }
    if (!nullToAbsent || reversaDeId != null) {
      map['reversa_de_id'] = Variable<int>(reversaDeId);
    }
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    return map;
  }

  EnvaseInventarioMovCompanion toCompanion(bool nullToAbsent) {
    return EnvaseInventarioMovCompanion(
      id: Value(id),
      tipoEnvaseId: Value(tipoEnvaseId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      referenciaTipo: referenciaTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaTipo),
      referenciaId: referenciaId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaId),
      reversaDeId: reversaDeId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversaDeId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
    );
  }

  factory EnvaseInventarioMovData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvaseInventarioMovData(
      id: serializer.fromJson<int>(json['id']),
      tipoEnvaseId: serializer.fromJson<int>(json['tipo_envase_id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      referenciaTipo: serializer.fromJson<String?>(json['referencia_tipo']),
      referenciaId: serializer.fromJson<int?>(json['referencia_id']),
      reversaDeId: serializer.fromJson<int?>(json['reversa_de_id']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo_envase_id': serializer.toJson<int>(tipoEnvaseId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<int>(cantidad),
      'referencia_tipo': serializer.toJson<String?>(referenciaTipo),
      'referencia_id': serializer.toJson<int?>(referenciaId),
      'reversa_de_id': serializer.toJson<int?>(reversaDeId),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
    };
  }

  EnvaseInventarioMovData copyWith({
    int? id,
    int? tipoEnvaseId,
    String? tipo,
    int? cantidad,
    Value<String?> referenciaTipo = const Value.absent(),
    Value<int?> referenciaId = const Value.absent(),
    Value<int?> reversaDeId = const Value.absent(),
    int? usuarioId,
    String? fecha,
  }) => EnvaseInventarioMovData(
    id: id ?? this.id,
    tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
    tipo: tipo ?? this.tipo,
    cantidad: cantidad ?? this.cantidad,
    referenciaTipo: referenciaTipo.present
        ? referenciaTipo.value
        : this.referenciaTipo,
    referenciaId: referenciaId.present ? referenciaId.value : this.referenciaId,
    reversaDeId: reversaDeId.present ? reversaDeId.value : this.reversaDeId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
  );
  EnvaseInventarioMovData copyWithCompanion(EnvaseInventarioMovCompanion data) {
    return EnvaseInventarioMovData(
      id: data.id.present ? data.id.value : this.id,
      tipoEnvaseId: data.tipoEnvaseId.present
          ? data.tipoEnvaseId.value
          : this.tipoEnvaseId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      referenciaTipo: data.referenciaTipo.present
          ? data.referenciaTipo.value
          : this.referenciaTipo,
      referenciaId: data.referenciaId.present
          ? data.referenciaId.value
          : this.referenciaId,
      reversaDeId: data.reversaDeId.present
          ? data.reversaDeId.value
          : this.reversaDeId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvaseInventarioMovData(')
          ..write('id: $id, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipoEnvaseId,
    tipo,
    cantidad,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvaseInventarioMovData &&
          other.id == this.id &&
          other.tipoEnvaseId == this.tipoEnvaseId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.referenciaTipo == this.referenciaTipo &&
          other.referenciaId == this.referenciaId &&
          other.reversaDeId == this.reversaDeId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha);
}

class EnvaseInventarioMovCompanion
    extends UpdateCompanion<EnvaseInventarioMovData> {
  final Value<int> id;
  final Value<int> tipoEnvaseId;
  final Value<String> tipo;
  final Value<int> cantidad;
  final Value<String?> referenciaTipo;
  final Value<int?> referenciaId;
  final Value<int?> reversaDeId;
  final Value<int> usuarioId;
  final Value<String> fecha;
  const EnvaseInventarioMovCompanion({
    this.id = const Value.absent(),
    this.tipoEnvaseId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  EnvaseInventarioMovCompanion.insert({
    this.id = const Value.absent(),
    required int tipoEnvaseId,
    required String tipo,
    required int cantidad,
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    required int usuarioId,
    this.fecha = const Value.absent(),
  }) : tipoEnvaseId = Value(tipoEnvaseId),
       tipo = Value(tipo),
       cantidad = Value(cantidad),
       usuarioId = Value(usuarioId);
  static Insertable<EnvaseInventarioMovData> custom({
    Expression<int>? id,
    Expression<int>? tipoEnvaseId,
    Expression<String>? tipo,
    Expression<int>? cantidad,
    Expression<String>? referenciaTipo,
    Expression<int>? referenciaId,
    Expression<int>? reversaDeId,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipoEnvaseId != null) 'tipo_envase_id': tipoEnvaseId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (referenciaTipo != null) 'referencia_tipo': referenciaTipo,
      if (referenciaId != null) 'referencia_id': referenciaId,
      if (reversaDeId != null) 'reversa_de_id': reversaDeId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
    });
  }

  EnvaseInventarioMovCompanion copyWith({
    Value<int>? id,
    Value<int>? tipoEnvaseId,
    Value<String>? tipo,
    Value<int>? cantidad,
    Value<String?>? referenciaTipo,
    Value<int?>? referenciaId,
    Value<int?>? reversaDeId,
    Value<int>? usuarioId,
    Value<String>? fecha,
  }) {
    return EnvaseInventarioMovCompanion(
      id: id ?? this.id,
      tipoEnvaseId: tipoEnvaseId ?? this.tipoEnvaseId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      referenciaTipo: referenciaTipo ?? this.referenciaTipo,
      referenciaId: referenciaId ?? this.referenciaId,
      reversaDeId: reversaDeId ?? this.reversaDeId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipoEnvaseId.present) {
      map['tipo_envase_id'] = Variable<int>(tipoEnvaseId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (referenciaTipo.present) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo.value);
    }
    if (referenciaId.present) {
      map['referencia_id'] = Variable<int>(referenciaId.value);
    }
    if (reversaDeId.present) {
      map['reversa_de_id'] = Variable<int>(reversaDeId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvaseInventarioMovCompanion(')
          ..write('id: $id, ')
          ..write('tipoEnvaseId: $tipoEnvaseId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class Devolucion extends Table with TableInfo<Devolucion, DevolucionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Devolucion(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _ventaIdMeta = const VerificationMeta(
    'ventaId',
  );
  late final GeneratedColumn<int> ventaId = GeneratedColumn<int>(
    'venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _detalleVentaIdMeta = const VerificationMeta(
    'detalleVentaId',
  );
  late final GeneratedColumn<int> detalleVentaId = GeneratedColumn<int>(
    'detalle_venta_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _productoIdMeta = const VerificationMeta(
    'productoId',
  );
  late final GeneratedColumn<int> productoId = GeneratedColumn<int>(
    'producto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  late final GeneratedColumn<int> cantidad = GeneratedColumn<int>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cantidad > 0)',
  );
  static const VerificationMeta _montoDevueltoCentavosMeta =
      const VerificationMeta('montoDevueltoCentavos');
  late final GeneratedColumn<int> montoDevueltoCentavos = GeneratedColumn<int>(
    'monto_devuelto_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (monto_devuelto_centavos >= 0)',
  );
  static const VerificationMeta _condicionMeta = const VerificationMeta(
    'condicion',
  );
  late final GeneratedColumn<String> condicion = GeneratedColumn<String>(
    'condicion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (condicion IN (\'BUENO\', \'DAÑADO\'))',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ventaId,
    detalleVentaId,
    productoId,
    cantidad,
    montoDevueltoCentavos,
    condicion,
    usuarioId,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devolucion';
  @override
  VerificationContext validateIntegrity(
    Insertable<DevolucionData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('venta_id')) {
      context.handle(
        _ventaIdMeta,
        ventaId.isAcceptableOrUnknown(data['venta_id']!, _ventaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ventaIdMeta);
    }
    if (data.containsKey('detalle_venta_id')) {
      context.handle(
        _detalleVentaIdMeta,
        detalleVentaId.isAcceptableOrUnknown(
          data['detalle_venta_id']!,
          _detalleVentaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_detalleVentaIdMeta);
    }
    if (data.containsKey('producto_id')) {
      context.handle(
        _productoIdMeta,
        productoId.isAcceptableOrUnknown(data['producto_id']!, _productoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productoIdMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('monto_devuelto_centavos')) {
      context.handle(
        _montoDevueltoCentavosMeta,
        montoDevueltoCentavos.isAcceptableOrUnknown(
          data['monto_devuelto_centavos']!,
          _montoDevueltoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoDevueltoCentavosMeta);
    }
    if (data.containsKey('condicion')) {
      context.handle(
        _condicionMeta,
        condicion.isAcceptableOrUnknown(data['condicion']!, _condicionMeta),
      );
    } else if (isInserting) {
      context.missing(_condicionMeta);
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DevolucionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DevolucionData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ventaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}venta_id'],
      )!,
      detalleVentaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}detalle_venta_id'],
      )!,
      productoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}producto_id'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cantidad'],
      )!,
      montoDevueltoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_devuelto_centavos'],
      )!,
      condicion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condicion'],
      )!,
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  Devolucion createAlias(String alias) {
    return Devolucion(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'FOREIGN KEY(detalle_venta_id, venta_id, producto_id)REFERENCES detalle_venta(id, venta_id, producto_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class DevolucionData extends DataClass implements Insertable<DevolucionData> {
  final int id;
  final int ventaId;
  final int detalleVentaId;
  final int productoId;
  final int cantidad;
  final int montoDevueltoCentavos;
  final String condicion;
  final int usuarioId;
  final String fecha;
  const DevolucionData({
    required this.id,
    required this.ventaId,
    required this.detalleVentaId,
    required this.productoId,
    required this.cantidad,
    required this.montoDevueltoCentavos,
    required this.condicion,
    required this.usuarioId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['venta_id'] = Variable<int>(ventaId);
    map['detalle_venta_id'] = Variable<int>(detalleVentaId);
    map['producto_id'] = Variable<int>(productoId);
    map['cantidad'] = Variable<int>(cantidad);
    map['monto_devuelto_centavos'] = Variable<int>(montoDevueltoCentavos);
    map['condicion'] = Variable<String>(condicion);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    return map;
  }

  DevolucionCompanion toCompanion(bool nullToAbsent) {
    return DevolucionCompanion(
      id: Value(id),
      ventaId: Value(ventaId),
      detalleVentaId: Value(detalleVentaId),
      productoId: Value(productoId),
      cantidad: Value(cantidad),
      montoDevueltoCentavos: Value(montoDevueltoCentavos),
      condicion: Value(condicion),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
    );
  }

  factory DevolucionData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DevolucionData(
      id: serializer.fromJson<int>(json['id']),
      ventaId: serializer.fromJson<int>(json['venta_id']),
      detalleVentaId: serializer.fromJson<int>(json['detalle_venta_id']),
      productoId: serializer.fromJson<int>(json['producto_id']),
      cantidad: serializer.fromJson<int>(json['cantidad']),
      montoDevueltoCentavos: serializer.fromJson<int>(
        json['monto_devuelto_centavos'],
      ),
      condicion: serializer.fromJson<String>(json['condicion']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'venta_id': serializer.toJson<int>(ventaId),
      'detalle_venta_id': serializer.toJson<int>(detalleVentaId),
      'producto_id': serializer.toJson<int>(productoId),
      'cantidad': serializer.toJson<int>(cantidad),
      'monto_devuelto_centavos': serializer.toJson<int>(montoDevueltoCentavos),
      'condicion': serializer.toJson<String>(condicion),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
    };
  }

  DevolucionData copyWith({
    int? id,
    int? ventaId,
    int? detalleVentaId,
    int? productoId,
    int? cantidad,
    int? montoDevueltoCentavos,
    String? condicion,
    int? usuarioId,
    String? fecha,
  }) => DevolucionData(
    id: id ?? this.id,
    ventaId: ventaId ?? this.ventaId,
    detalleVentaId: detalleVentaId ?? this.detalleVentaId,
    productoId: productoId ?? this.productoId,
    cantidad: cantidad ?? this.cantidad,
    montoDevueltoCentavos: montoDevueltoCentavos ?? this.montoDevueltoCentavos,
    condicion: condicion ?? this.condicion,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
  );
  DevolucionData copyWithCompanion(DevolucionCompanion data) {
    return DevolucionData(
      id: data.id.present ? data.id.value : this.id,
      ventaId: data.ventaId.present ? data.ventaId.value : this.ventaId,
      detalleVentaId: data.detalleVentaId.present
          ? data.detalleVentaId.value
          : this.detalleVentaId,
      productoId: data.productoId.present
          ? data.productoId.value
          : this.productoId,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      montoDevueltoCentavos: data.montoDevueltoCentavos.present
          ? data.montoDevueltoCentavos.value
          : this.montoDevueltoCentavos,
      condicion: data.condicion.present ? data.condicion.value : this.condicion,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DevolucionData(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('detalleVentaId: $detalleVentaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('montoDevueltoCentavos: $montoDevueltoCentavos, ')
          ..write('condicion: $condicion, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ventaId,
    detalleVentaId,
    productoId,
    cantidad,
    montoDevueltoCentavos,
    condicion,
    usuarioId,
    fecha,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DevolucionData &&
          other.id == this.id &&
          other.ventaId == this.ventaId &&
          other.detalleVentaId == this.detalleVentaId &&
          other.productoId == this.productoId &&
          other.cantidad == this.cantidad &&
          other.montoDevueltoCentavos == this.montoDevueltoCentavos &&
          other.condicion == this.condicion &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha);
}

class DevolucionCompanion extends UpdateCompanion<DevolucionData> {
  final Value<int> id;
  final Value<int> ventaId;
  final Value<int> detalleVentaId;
  final Value<int> productoId;
  final Value<int> cantidad;
  final Value<int> montoDevueltoCentavos;
  final Value<String> condicion;
  final Value<int> usuarioId;
  final Value<String> fecha;
  const DevolucionCompanion({
    this.id = const Value.absent(),
    this.ventaId = const Value.absent(),
    this.detalleVentaId = const Value.absent(),
    this.productoId = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.montoDevueltoCentavos = const Value.absent(),
    this.condicion = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  DevolucionCompanion.insert({
    this.id = const Value.absent(),
    required int ventaId,
    required int detalleVentaId,
    required int productoId,
    required int cantidad,
    required int montoDevueltoCentavos,
    required String condicion,
    required int usuarioId,
    this.fecha = const Value.absent(),
  }) : ventaId = Value(ventaId),
       detalleVentaId = Value(detalleVentaId),
       productoId = Value(productoId),
       cantidad = Value(cantidad),
       montoDevueltoCentavos = Value(montoDevueltoCentavos),
       condicion = Value(condicion),
       usuarioId = Value(usuarioId);
  static Insertable<DevolucionData> custom({
    Expression<int>? id,
    Expression<int>? ventaId,
    Expression<int>? detalleVentaId,
    Expression<int>? productoId,
    Expression<int>? cantidad,
    Expression<int>? montoDevueltoCentavos,
    Expression<String>? condicion,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ventaId != null) 'venta_id': ventaId,
      if (detalleVentaId != null) 'detalle_venta_id': detalleVentaId,
      if (productoId != null) 'producto_id': productoId,
      if (cantidad != null) 'cantidad': cantidad,
      if (montoDevueltoCentavos != null)
        'monto_devuelto_centavos': montoDevueltoCentavos,
      if (condicion != null) 'condicion': condicion,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
    });
  }

  DevolucionCompanion copyWith({
    Value<int>? id,
    Value<int>? ventaId,
    Value<int>? detalleVentaId,
    Value<int>? productoId,
    Value<int>? cantidad,
    Value<int>? montoDevueltoCentavos,
    Value<String>? condicion,
    Value<int>? usuarioId,
    Value<String>? fecha,
  }) {
    return DevolucionCompanion(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      detalleVentaId: detalleVentaId ?? this.detalleVentaId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      montoDevueltoCentavos:
          montoDevueltoCentavos ?? this.montoDevueltoCentavos,
      condicion: condicion ?? this.condicion,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ventaId.present) {
      map['venta_id'] = Variable<int>(ventaId.value);
    }
    if (detalleVentaId.present) {
      map['detalle_venta_id'] = Variable<int>(detalleVentaId.value);
    }
    if (productoId.present) {
      map['producto_id'] = Variable<int>(productoId.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<int>(cantidad.value);
    }
    if (montoDevueltoCentavos.present) {
      map['monto_devuelto_centavos'] = Variable<int>(
        montoDevueltoCentavos.value,
      );
    }
    if (condicion.present) {
      map['condicion'] = Variable<String>(condicion.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevolucionCompanion(')
          ..write('id: $id, ')
          ..write('ventaId: $ventaId, ')
          ..write('detalleVentaId: $detalleVentaId, ')
          ..write('productoId: $productoId, ')
          ..write('cantidad: $cantidad, ')
          ..write('montoDevueltoCentavos: $montoDevueltoCentavos, ')
          ..write('condicion: $condicion, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

class MovimientoCaja extends Table
    with TableInfo<MovimientoCaja, MovimientoCajaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MovimientoCaja(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _cajaSesionIdMeta = const VerificationMeta(
    'cajaSesionId',
  );
  late final GeneratedColumn<int> cajaSesionId = GeneratedColumn<int>(
    'caja_sesion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES caja_sesion(id)',
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (tipo IN (\'VENTA_EFECTIVO\', \'RETIRO\', \'ENTRADA\', \'DEVOLUCION\', \'PAGO_CUENTA\', \'PAGO_ENVASE\', \'COMPRA_ENVASE_CLIENTE\', \'COMPRA\', \'CANCELACION\'))',
  );
  static const VerificationMeta _montoCentavosMeta = const VerificationMeta(
    'montoCentavos',
  );
  late final GeneratedColumn<int> montoCentavos = GeneratedColumn<int>(
    'monto_centavos',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (monto_centavos != 0)',
  );
  static const VerificationMeta _motivoMeta = const VerificationMeta('motivo');
  late final GeneratedColumn<String> motivo = GeneratedColumn<String>(
    'motivo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _referenciaTipoMeta = const VerificationMeta(
    'referenciaTipo',
  );
  late final GeneratedColumn<String> referenciaTipo = GeneratedColumn<String>(
    'referencia_tipo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (referencia_tipo IN (\'VENTA\', \'DEVOLUCION\', \'PAGO_CUENTA_CLIENTE\', \'PAGO_ENVASE_CLIENTE\', \'COMPRA_ENVASE_CLIENTE\', \'COMPRA\', \'CANCELACION_VENTA\', \'MANUAL\'))',
  );
  static const VerificationMeta _referenciaIdMeta = const VerificationMeta(
    'referenciaId',
  );
  late final GeneratedColumn<int> referenciaId = GeneratedColumn<int>(
    'referencia_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _reversaDeIdMeta = const VerificationMeta(
    'reversaDeId',
  );
  late final GeneratedColumn<int> reversaDeId = GeneratedColumn<int>(
    'reversa_de_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES movimiento_caja(id)',
  );
  static const VerificationMeta _usuarioIdMeta = const VerificationMeta(
    'usuarioId',
  );
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
    'usuario_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES usuario(id)',
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT (datetime(\'now\'))',
    defaultValue: const CustomExpression('datetime(\'now\')'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cajaSesionId,
    tipo,
    montoCentavos,
    motivo,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimiento_caja';
  @override
  VerificationContext validateIntegrity(
    Insertable<MovimientoCajaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('caja_sesion_id')) {
      context.handle(
        _cajaSesionIdMeta,
        cajaSesionId.isAcceptableOrUnknown(
          data['caja_sesion_id']!,
          _cajaSesionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cajaSesionIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('monto_centavos')) {
      context.handle(
        _montoCentavosMeta,
        montoCentavos.isAcceptableOrUnknown(
          data['monto_centavos']!,
          _montoCentavosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentavosMeta);
    }
    if (data.containsKey('motivo')) {
      context.handle(
        _motivoMeta,
        motivo.isAcceptableOrUnknown(data['motivo']!, _motivoMeta),
      );
    }
    if (data.containsKey('referencia_tipo')) {
      context.handle(
        _referenciaTipoMeta,
        referenciaTipo.isAcceptableOrUnknown(
          data['referencia_tipo']!,
          _referenciaTipoMeta,
        ),
      );
    }
    if (data.containsKey('referencia_id')) {
      context.handle(
        _referenciaIdMeta,
        referenciaId.isAcceptableOrUnknown(
          data['referencia_id']!,
          _referenciaIdMeta,
        ),
      );
    }
    if (data.containsKey('reversa_de_id')) {
      context.handle(
        _reversaDeIdMeta,
        reversaDeId.isAcceptableOrUnknown(
          data['reversa_de_id']!,
          _reversaDeIdMeta,
        ),
      );
    }
    if (data.containsKey('usuario_id')) {
      context.handle(
        _usuarioIdMeta,
        usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta),
      );
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MovimientoCajaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovimientoCajaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cajaSesionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caja_sesion_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      montoCentavos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centavos'],
      )!,
      motivo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}motivo'],
      ),
      referenciaTipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia_tipo'],
      ),
      referenciaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referencia_id'],
      ),
      reversaDeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reversa_de_id'],
      ),
      usuarioId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usuario_id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
    );
  }

  @override
  MovimientoCaja createAlias(String alias) {
    return MovimientoCaja(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class MovimientoCajaData extends DataClass
    implements Insertable<MovimientoCajaData> {
  final int id;
  final int cajaSesionId;
  final String tipo;
  final int montoCentavos;
  final String? motivo;
  final String? referenciaTipo;
  final int? referenciaId;
  final int? reversaDeId;
  final int usuarioId;
  final String fecha;
  const MovimientoCajaData({
    required this.id,
    required this.cajaSesionId,
    required this.tipo,
    required this.montoCentavos,
    this.motivo,
    this.referenciaTipo,
    this.referenciaId,
    this.reversaDeId,
    required this.usuarioId,
    required this.fecha,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['caja_sesion_id'] = Variable<int>(cajaSesionId);
    map['tipo'] = Variable<String>(tipo);
    map['monto_centavos'] = Variable<int>(montoCentavos);
    if (!nullToAbsent || motivo != null) {
      map['motivo'] = Variable<String>(motivo);
    }
    if (!nullToAbsent || referenciaTipo != null) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo);
    }
    if (!nullToAbsent || referenciaId != null) {
      map['referencia_id'] = Variable<int>(referenciaId);
    }
    if (!nullToAbsent || reversaDeId != null) {
      map['reversa_de_id'] = Variable<int>(reversaDeId);
    }
    map['usuario_id'] = Variable<int>(usuarioId);
    map['fecha'] = Variable<String>(fecha);
    return map;
  }

  MovimientoCajaCompanion toCompanion(bool nullToAbsent) {
    return MovimientoCajaCompanion(
      id: Value(id),
      cajaSesionId: Value(cajaSesionId),
      tipo: Value(tipo),
      montoCentavos: Value(montoCentavos),
      motivo: motivo == null && nullToAbsent
          ? const Value.absent()
          : Value(motivo),
      referenciaTipo: referenciaTipo == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaTipo),
      referenciaId: referenciaId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenciaId),
      reversaDeId: reversaDeId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversaDeId),
      usuarioId: Value(usuarioId),
      fecha: Value(fecha),
    );
  }

  factory MovimientoCajaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovimientoCajaData(
      id: serializer.fromJson<int>(json['id']),
      cajaSesionId: serializer.fromJson<int>(json['caja_sesion_id']),
      tipo: serializer.fromJson<String>(json['tipo']),
      montoCentavos: serializer.fromJson<int>(json['monto_centavos']),
      motivo: serializer.fromJson<String?>(json['motivo']),
      referenciaTipo: serializer.fromJson<String?>(json['referencia_tipo']),
      referenciaId: serializer.fromJson<int?>(json['referencia_id']),
      reversaDeId: serializer.fromJson<int?>(json['reversa_de_id']),
      usuarioId: serializer.fromJson<int>(json['usuario_id']),
      fecha: serializer.fromJson<String>(json['fecha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caja_sesion_id': serializer.toJson<int>(cajaSesionId),
      'tipo': serializer.toJson<String>(tipo),
      'monto_centavos': serializer.toJson<int>(montoCentavos),
      'motivo': serializer.toJson<String?>(motivo),
      'referencia_tipo': serializer.toJson<String?>(referenciaTipo),
      'referencia_id': serializer.toJson<int?>(referenciaId),
      'reversa_de_id': serializer.toJson<int?>(reversaDeId),
      'usuario_id': serializer.toJson<int>(usuarioId),
      'fecha': serializer.toJson<String>(fecha),
    };
  }

  MovimientoCajaData copyWith({
    int? id,
    int? cajaSesionId,
    String? tipo,
    int? montoCentavos,
    Value<String?> motivo = const Value.absent(),
    Value<String?> referenciaTipo = const Value.absent(),
    Value<int?> referenciaId = const Value.absent(),
    Value<int?> reversaDeId = const Value.absent(),
    int? usuarioId,
    String? fecha,
  }) => MovimientoCajaData(
    id: id ?? this.id,
    cajaSesionId: cajaSesionId ?? this.cajaSesionId,
    tipo: tipo ?? this.tipo,
    montoCentavos: montoCentavos ?? this.montoCentavos,
    motivo: motivo.present ? motivo.value : this.motivo,
    referenciaTipo: referenciaTipo.present
        ? referenciaTipo.value
        : this.referenciaTipo,
    referenciaId: referenciaId.present ? referenciaId.value : this.referenciaId,
    reversaDeId: reversaDeId.present ? reversaDeId.value : this.reversaDeId,
    usuarioId: usuarioId ?? this.usuarioId,
    fecha: fecha ?? this.fecha,
  );
  MovimientoCajaData copyWithCompanion(MovimientoCajaCompanion data) {
    return MovimientoCajaData(
      id: data.id.present ? data.id.value : this.id,
      cajaSesionId: data.cajaSesionId.present
          ? data.cajaSesionId.value
          : this.cajaSesionId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      montoCentavos: data.montoCentavos.present
          ? data.montoCentavos.value
          : this.montoCentavos,
      motivo: data.motivo.present ? data.motivo.value : this.motivo,
      referenciaTipo: data.referenciaTipo.present
          ? data.referenciaTipo.value
          : this.referenciaTipo,
      referenciaId: data.referenciaId.present
          ? data.referenciaId.value
          : this.referenciaId,
      reversaDeId: data.reversaDeId.present
          ? data.reversaDeId.value
          : this.reversaDeId,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoCajaData(')
          ..write('id: $id, ')
          ..write('cajaSesionId: $cajaSesionId, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('motivo: $motivo, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cajaSesionId,
    tipo,
    montoCentavos,
    motivo,
    referenciaTipo,
    referenciaId,
    reversaDeId,
    usuarioId,
    fecha,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovimientoCajaData &&
          other.id == this.id &&
          other.cajaSesionId == this.cajaSesionId &&
          other.tipo == this.tipo &&
          other.montoCentavos == this.montoCentavos &&
          other.motivo == this.motivo &&
          other.referenciaTipo == this.referenciaTipo &&
          other.referenciaId == this.referenciaId &&
          other.reversaDeId == this.reversaDeId &&
          other.usuarioId == this.usuarioId &&
          other.fecha == this.fecha);
}

class MovimientoCajaCompanion extends UpdateCompanion<MovimientoCajaData> {
  final Value<int> id;
  final Value<int> cajaSesionId;
  final Value<String> tipo;
  final Value<int> montoCentavos;
  final Value<String?> motivo;
  final Value<String?> referenciaTipo;
  final Value<int?> referenciaId;
  final Value<int?> reversaDeId;
  final Value<int> usuarioId;
  final Value<String> fecha;
  const MovimientoCajaCompanion({
    this.id = const Value.absent(),
    this.cajaSesionId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.montoCentavos = const Value.absent(),
    this.motivo = const Value.absent(),
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.fecha = const Value.absent(),
  });
  MovimientoCajaCompanion.insert({
    this.id = const Value.absent(),
    required int cajaSesionId,
    required String tipo,
    required int montoCentavos,
    this.motivo = const Value.absent(),
    this.referenciaTipo = const Value.absent(),
    this.referenciaId = const Value.absent(),
    this.reversaDeId = const Value.absent(),
    required int usuarioId,
    this.fecha = const Value.absent(),
  }) : cajaSesionId = Value(cajaSesionId),
       tipo = Value(tipo),
       montoCentavos = Value(montoCentavos),
       usuarioId = Value(usuarioId);
  static Insertable<MovimientoCajaData> custom({
    Expression<int>? id,
    Expression<int>? cajaSesionId,
    Expression<String>? tipo,
    Expression<int>? montoCentavos,
    Expression<String>? motivo,
    Expression<String>? referenciaTipo,
    Expression<int>? referenciaId,
    Expression<int>? reversaDeId,
    Expression<int>? usuarioId,
    Expression<String>? fecha,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cajaSesionId != null) 'caja_sesion_id': cajaSesionId,
      if (tipo != null) 'tipo': tipo,
      if (montoCentavos != null) 'monto_centavos': montoCentavos,
      if (motivo != null) 'motivo': motivo,
      if (referenciaTipo != null) 'referencia_tipo': referenciaTipo,
      if (referenciaId != null) 'referencia_id': referenciaId,
      if (reversaDeId != null) 'reversa_de_id': reversaDeId,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (fecha != null) 'fecha': fecha,
    });
  }

  MovimientoCajaCompanion copyWith({
    Value<int>? id,
    Value<int>? cajaSesionId,
    Value<String>? tipo,
    Value<int>? montoCentavos,
    Value<String?>? motivo,
    Value<String?>? referenciaTipo,
    Value<int?>? referenciaId,
    Value<int?>? reversaDeId,
    Value<int>? usuarioId,
    Value<String>? fecha,
  }) {
    return MovimientoCajaCompanion(
      id: id ?? this.id,
      cajaSesionId: cajaSesionId ?? this.cajaSesionId,
      tipo: tipo ?? this.tipo,
      montoCentavos: montoCentavos ?? this.montoCentavos,
      motivo: motivo ?? this.motivo,
      referenciaTipo: referenciaTipo ?? this.referenciaTipo,
      referenciaId: referenciaId ?? this.referenciaId,
      reversaDeId: reversaDeId ?? this.reversaDeId,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cajaSesionId.present) {
      map['caja_sesion_id'] = Variable<int>(cajaSesionId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (montoCentavos.present) {
      map['monto_centavos'] = Variable<int>(montoCentavos.value);
    }
    if (motivo.present) {
      map['motivo'] = Variable<String>(motivo.value);
    }
    if (referenciaTipo.present) {
      map['referencia_tipo'] = Variable<String>(referenciaTipo.value);
    }
    if (referenciaId.present) {
      map['referencia_id'] = Variable<int>(referenciaId.value);
    }
    if (reversaDeId.present) {
      map['reversa_de_id'] = Variable<int>(reversaDeId.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientoCajaCompanion(')
          ..write('id: $id, ')
          ..write('cajaSesionId: $cajaSesionId, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentavos: $montoCentavos, ')
          ..write('motivo: $motivo, ')
          ..write('referenciaTipo: $referenciaTipo, ')
          ..write('referenciaId: $referenciaId, ')
          ..write('reversaDeId: $reversaDeId, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('fecha: $fecha')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Terminal terminal = Terminal(this);
  late final Usuario usuario = Usuario(this);
  late final CajaSesion cajaSesion = CajaSesion(this);
  late final Index idxCajaTerminal = Index(
    'idx_caja_terminal',
    'CREATE INDEX idx_caja_terminal ON caja_sesion (terminal_id)',
  );
  late final Index idxCajaUnicaAbierta = Index(
    'idx_caja_unica_abierta',
    'CREATE UNIQUE INDEX idx_caja_unica_abierta ON caja_sesion (terminal_id) WHERE estado = \'ABIERTA\'',
  );
  late final Categoria categoria = Categoria(this);
  late final TipoEnvase tipoEnvase = TipoEnvase(this);
  late final Producto producto = Producto(this);
  late final Index idxProductoCodigoBarras = Index(
    'idx_producto_codigo_barras',
    'CREATE INDEX idx_producto_codigo_barras ON producto (codigo_barras)',
  );
  late final Index idxProductoCategoria = Index(
    'idx_producto_categoria',
    'CREATE INDEX idx_producto_categoria ON producto (categoria_id)',
  );
  late final MovimientoInventario movimientoInventario = MovimientoInventario(
    this,
  );
  late final Index idxMovInvProducto = Index(
    'idx_mov_inv_producto',
    'CREATE INDEX idx_mov_inv_producto ON movimiento_inventario (producto_id)',
  );
  late final Index idxMovInvFecha = Index(
    'idx_mov_inv_fecha',
    'CREATE INDEX idx_mov_inv_fecha ON movimiento_inventario (fecha)',
  );
  late final InventarioSaldo inventarioSaldo = InventarioSaldo(this);
  late final SaldoGuard saldoGuard = SaldoGuard(this);
  late final Trigger trgSaldoActualizar = Trigger(
    'CREATE TRIGGER trg_saldo_actualizar AFTER INSERT ON movimiento_inventario BEGIN INSERT INTO saldo_guard (activo) VALUES (1);UPDATE inventario_saldo SET cantidad_actual = cantidad_actual + NEW.cantidad, actualizado_en = datetime(\'now\') WHERE producto_id = NEW.producto_id;INSERT INTO inventario_saldo (producto_id, cantidad_actual, actualizado_en) SELECT NEW.producto_id, NEW.cantidad, datetime(\'now\') WHERE (SELECT changes()) = 0;DELETE FROM saldo_guard;END',
    'trg_saldo_actualizar',
  );
  late final Trigger trgSaldoNoInsertDirecto = Trigger(
    'CREATE TRIGGER trg_saldo_no_insert_directo BEFORE INSERT ON inventario_saldo WHEN NOT EXISTS (SELECT 1 FROM saldo_guard) BEGIN SELECT RAISE (ABORT, \'inventario_saldo no se escribe directamente: solo se actualiza vía movimiento_inventario\');END',
    'trg_saldo_no_insert_directo',
  );
  late final Trigger trgSaldoNoUpdateDirecto = Trigger(
    'CREATE TRIGGER trg_saldo_no_update_directo BEFORE UPDATE ON inventario_saldo WHEN NOT EXISTS (SELECT 1 FROM saldo_guard) BEGIN SELECT RAISE (ABORT, \'inventario_saldo no se escribe directamente: solo se actualiza vía movimiento_inventario\');END',
    'trg_saldo_no_update_directo',
  );
  late final Trigger trgSaldoNoDeleteDirecto = Trigger(
    'CREATE TRIGGER trg_saldo_no_delete_directo BEFORE DELETE ON inventario_saldo WHEN NOT EXISTS (SELECT 1 FROM saldo_guard) BEGIN SELECT RAISE (ABORT, \'inventario_saldo no se elimina directamente (solo vía reconstrucción administrativa controlada)\');END',
    'trg_saldo_no_delete_directo',
  );
  late final Proveedor proveedor = Proveedor(this);
  late final Compra compra = Compra(this);
  late final DetalleCompra detalleCompra = DetalleCompra(this);
  late final Index idxDetalleCompraCompra = Index(
    'idx_detalle_compra_compra',
    'CREATE INDEX idx_detalle_compra_compra ON detalle_compra (compra_id)',
  );
  late final Index idxDetalleCompraProducto = Index(
    'idx_detalle_compra_producto',
    'CREATE INDEX idx_detalle_compra_producto ON detalle_compra (producto_id)',
  );
  late final Cliente cliente = Cliente(this);
  late final Venta venta = Venta(this);
  late final Index idxVentaCliente = Index(
    'idx_venta_cliente',
    'CREATE INDEX idx_venta_cliente ON venta (cliente_id)',
  );
  late final Index idxVentaTerminal = Index(
    'idx_venta_terminal',
    'CREATE INDEX idx_venta_terminal ON venta (terminal_id)',
  );
  late final Index idxVentaFecha = Index(
    'idx_venta_fecha',
    'CREATE INDEX idx_venta_fecha ON venta (fecha)',
  );
  late final DetalleVenta detalleVenta = DetalleVenta(this);
  late final Index idxDetalleVentaVenta = Index(
    'idx_detalle_venta_venta',
    'CREATE INDEX idx_detalle_venta_venta ON detalle_venta (venta_id)',
  );
  late final Index idxDetalleVentaProducto = Index(
    'idx_detalle_venta_producto',
    'CREATE INDEX idx_detalle_venta_producto ON detalle_venta (producto_id)',
  );
  late final Index uqDetalleVentaIntegridad = Index(
    'uq_detalle_venta_integridad',
    'CREATE UNIQUE INDEX uq_detalle_venta_integridad ON detalle_venta (id, venta_id, producto_id)',
  );
  late final OperacionEnvase operacionEnvase = OperacionEnvase(this);
  late final Index idxOperacionEnvaseVenta = Index(
    'idx_operacion_envase_venta',
    'CREATE INDEX idx_operacion_envase_venta ON operacion_envase (venta_id)',
  );
  late final Pago pago = Pago(this);
  late final Index idxPagoVenta = Index(
    'idx_pago_venta',
    'CREATE INDEX idx_pago_venta ON pago (venta_id)',
  );
  late final CuentaMonetariaMov cuentaMonetariaMov = CuentaMonetariaMov(this);
  late final Index idxCtaMonetariaCliente = Index(
    'idx_cta_monetaria_cliente',
    'CREATE INDEX idx_cta_monetaria_cliente ON cuenta_monetaria_mov (cliente_id)',
  );
  late final Index idxCtaMonetariaVenta = Index(
    'idx_cta_monetaria_venta',
    'CREATE INDEX idx_cta_monetaria_venta ON cuenta_monetaria_mov (venta_id)',
  );
  late final CuentaEnvaseMov cuentaEnvaseMov = CuentaEnvaseMov(this);
  late final Index idxCtaEnvaseCliente = Index(
    'idx_cta_envase_cliente',
    'CREATE INDEX idx_cta_envase_cliente ON cuenta_envase_mov (cliente_id)',
  );
  late final Index idxCtaEnvaseVenta = Index(
    'idx_cta_envase_venta',
    'CREATE INDEX idx_cta_envase_venta ON cuenta_envase_mov (venta_id)',
  );
  late final CuentaDepositoEnvaseMov cuentaDepositoEnvaseMov =
      CuentaDepositoEnvaseMov(this);
  late final Index idxCtaDepositoVenta = Index(
    'idx_cta_deposito_venta',
    'CREATE INDEX idx_cta_deposito_venta ON cuenta_deposito_envase_mov (venta_id, tipo_envase_id)',
  );
  late final EnvaseInventarioMov envaseInventarioMov = EnvaseInventarioMov(
    this,
  );
  late final Index idxEnvaseInvTipo = Index(
    'idx_envase_inv_tipo',
    'CREATE INDEX idx_envase_inv_tipo ON envase_inventario_mov (tipo_envase_id)',
  );
  late final Devolucion devolucion = Devolucion(this);
  late final Index idxDevolucionVenta = Index(
    'idx_devolucion_venta',
    'CREATE INDEX idx_devolucion_venta ON devolucion (venta_id)',
  );
  late final Index idxDevolucionDetalle = Index(
    'idx_devolucion_detalle',
    'CREATE INDEX idx_devolucion_detalle ON devolucion (detalle_venta_id)',
  );
  late final MovimientoCaja movimientoCaja = MovimientoCaja(this);
  late final Index idxMovCajaSesion = Index(
    'idx_mov_caja_sesion',
    'CREATE INDEX idx_mov_caja_sesion ON movimiento_caja (caja_sesion_id)',
  );
  late final Index idxMovCajaFecha = Index(
    'idx_mov_caja_fecha',
    'CREATE INDEX idx_mov_caja_fecha ON movimiento_caja (fecha)',
  );
  late final Trigger trgMovimientoCajaSesionAbierta = Trigger(
    'CREATE TRIGGER trg_movimiento_caja_sesion_abierta BEFORE INSERT ON movimiento_caja WHEN NOT EXISTS (SELECT 1 FROM caja_sesion WHERE id = NEW.caja_sesion_id AND estado = \'ABIERTA\') BEGIN SELECT RAISE (ABORT, \'La sesión de caja no está abierta\');END',
    'trg_movimiento_caja_sesion_abierta',
  );
  late final Trigger trgMovCajaTerminalVenta = Trigger(
    'CREATE TRIGGER trg_mov_caja_terminal_venta BEFORE INSERT ON movimiento_caja WHEN NEW.referencia_tipo = \'VENTA\' AND NEW.referencia_id IS NOT NULL AND (SELECT terminal_id FROM caja_sesion WHERE id = NEW.caja_sesion_id) != (SELECT terminal_id FROM venta WHERE id = NEW.referencia_id) BEGIN SELECT RAISE (ABORT, \'La caja usada no pertenece al mismo terminal que la venta\');END',
    'trg_mov_caja_terminal_venta',
  );
  late final Trigger trgMovCajaTerminalCompra = Trigger(
    'CREATE TRIGGER trg_mov_caja_terminal_compra BEFORE INSERT ON movimiento_caja WHEN NEW.referencia_tipo = \'COMPRA\' AND NEW.referencia_id IS NOT NULL AND (SELECT terminal_id FROM caja_sesion WHERE id = NEW.caja_sesion_id) != (SELECT terminal_id FROM compra WHERE id = NEW.referencia_id) BEGIN SELECT RAISE (ABORT, \'La caja usada no pertenece al mismo terminal que la compra\');END',
    'trg_mov_caja_terminal_compra',
  );
  late final Trigger trgPagoNoExcedeTotal = Trigger(
    'CREATE TRIGGER trg_pago_no_excede_total BEFORE INSERT ON pago WHEN((SELECT COALESCE(SUM(monto_centavos), 0) FROM pago WHERE venta_id = NEW.venta_id) + NEW.monto_centavos > (SELECT total_centavos FROM venta WHERE id = NEW.venta_id))BEGIN SELECT RAISE (ABORT, \'La suma de pagos no puede exceder el total de la venta\');END',
    'trg_pago_no_excede_total',
  );
  late final Trigger trgPagoVentaCompletada = Trigger(
    'CREATE TRIGGER trg_pago_venta_completada BEFORE INSERT ON pago WHEN (SELECT estado FROM venta WHERE id = NEW.venta_id) != \'COMPLETADA\' BEGIN SELECT RAISE (ABORT, \'No se pueden registrar pagos sobre una venta cancelada\');END',
    'trg_pago_venta_completada',
  );
  late final Trigger trgDevolucionVentaCompletada = Trigger(
    'CREATE TRIGGER trg_devolucion_venta_completada BEFORE INSERT ON devolucion WHEN (SELECT estado FROM venta WHERE id = NEW.venta_id) != \'COMPLETADA\' BEGIN SELECT RAISE (ABORT, \'No se pueden registrar devoluciones sobre una venta cancelada\');END',
    'trg_devolucion_venta_completada',
  );
  late final Trigger trgDetalleVentaNoExcedeSubtotal = Trigger(
    'CREATE TRIGGER trg_detalle_venta_no_excede_subtotal BEFORE INSERT ON detalle_venta WHEN((SELECT COALESCE(SUM(subtotal_centavos), 0) FROM detalle_venta WHERE venta_id = NEW.venta_id) + NEW.subtotal_centavos > (SELECT subtotal_centavos FROM venta WHERE id = NEW.venta_id))BEGIN SELECT RAISE (ABORT, \'La suma de líneas de venta no puede exceder el subtotal declarado\');END',
    'trg_detalle_venta_no_excede_subtotal',
  );
  late final Trigger trgDetalleCompraNoExcedeTotal = Trigger(
    'CREATE TRIGGER trg_detalle_compra_no_excede_total BEFORE INSERT ON detalle_compra WHEN((SELECT COALESCE(SUM(subtotal_centavos), 0) FROM detalle_compra WHERE compra_id = NEW.compra_id) + NEW.subtotal_centavos > (SELECT total_centavos FROM compra WHERE id = NEW.compra_id))BEGIN SELECT RAISE (ABORT, \'La suma de líneas de compra no puede exceder el total declarado\');END',
    'trg_detalle_compra_no_excede_total',
  );
  late final Trigger trgMonetariaNoExcedePendiente = Trigger(
    'CREATE TRIGGER trg_monetaria_no_excede_pendiente BEFORE INSERT ON cuenta_monetaria_mov WHEN NEW.tipo IN (\'ABONO\', \'CANCELACION\') AND NEW.venta_id IS NOT NULL AND NEW.monto_centavos > (SELECT COALESCE(SUM(CASE tipo WHEN \'CARGO\' THEN monto_centavos ELSE -monto_centavos END), 0) FROM cuenta_monetaria_mov WHERE venta_id = NEW.venta_id) BEGIN SELECT RAISE (ABORT, \'No se puede abonar/cancelar más deuda de la que sigue pendiente para esa venta\');END',
    'trg_monetaria_no_excede_pendiente',
  );
  late final Trigger trgEnvaseNoExcedePrestamo = Trigger(
    'CREATE TRIGGER trg_envase_no_excede_prestamo BEFORE INSERT ON cuenta_envase_mov WHEN NEW.tipo IN (\'DEVOLUCION\', \'PAGO\', \'CANCELACION\') AND NEW.venta_id IS NOT NULL AND NEW.cantidad > (SELECT COALESCE(SUM(CASE tipo WHEN \'PRESTAMO\' THEN cantidad ELSE -cantidad END), 0) FROM cuenta_envase_mov WHERE venta_id = NEW.venta_id AND tipo_envase_id = NEW.tipo_envase_id) BEGIN SELECT RAISE (ABORT, \'No se puede devolver/pagar/cancelar más envase del que sigue prestado en esa venta\');END',
    'trg_envase_no_excede_prestamo',
  );
  late final Trigger trgDepositoNoExcedeCobrado = Trigger(
    'CREATE TRIGGER trg_deposito_no_excede_cobrado BEFORE INSERT ON cuenta_deposito_envase_mov WHEN NEW.tipo IN (\'DEVUELTO\', \'CANCELACION\') AND NEW.cantidad > (SELECT COALESCE(SUM(CASE tipo WHEN \'COBRADO\' THEN cantidad ELSE -cantidad END), 0) FROM cuenta_deposito_envase_mov WHERE venta_id = NEW.venta_id AND tipo_envase_id = NEW.tipo_envase_id) BEGIN SELECT RAISE (ABORT, \'No se puede devolver/cancelar más depósito del que sigue pendiente en esa venta\');END',
    'trg_deposito_no_excede_cobrado',
  );
  late final Trigger trgMovInvReversaValida = Trigger(
    'CREATE TRIGGER trg_mov_inv_reversa_valida BEFORE INSERT ON movimiento_inventario WHEN NEW.reversa_de_id IS NOT NULL AND (SELECT producto_id FROM movimiento_inventario WHERE id = NEW.reversa_de_id) != NEW.producto_id BEGIN SELECT RAISE (ABORT, \'reversa_de_id debe apuntar a un movimiento del mismo producto\');END',
    'trg_mov_inv_reversa_valida',
  );
  late final Trigger trgEnvaseInvReversaValida = Trigger(
    'CREATE TRIGGER trg_envase_inv_reversa_valida BEFORE INSERT ON envase_inventario_mov WHEN NEW.reversa_de_id IS NOT NULL AND (SELECT tipo_envase_id FROM envase_inventario_mov WHERE id = NEW.reversa_de_id) != NEW.tipo_envase_id BEGIN SELECT RAISE (ABORT, \'reversa_de_id debe apuntar a un movimiento del mismo tipo de envase\');END',
    'trg_envase_inv_reversa_valida',
  );
  late final Trigger trgCtaEnvaseReversaValida = Trigger(
    'CREATE TRIGGER trg_cta_envase_reversa_valida BEFORE INSERT ON cuenta_envase_mov WHEN NEW.reversa_de_id IS NOT NULL AND (SELECT tipo_envase_id FROM cuenta_envase_mov WHERE id = NEW.reversa_de_id) != NEW.tipo_envase_id BEGIN SELECT RAISE (ABORT, \'reversa_de_id debe apuntar a un movimiento del mismo tipo de envase\');END',
    'trg_cta_envase_reversa_valida',
  );
  late final Trigger trgCtaDepositoReversaValida = Trigger(
    'CREATE TRIGGER trg_cta_deposito_reversa_valida BEFORE INSERT ON cuenta_deposito_envase_mov WHEN NEW.reversa_de_id IS NOT NULL AND (SELECT tipo_envase_id FROM cuenta_deposito_envase_mov WHERE id = NEW.reversa_de_id) != NEW.tipo_envase_id BEGIN SELECT RAISE (ABORT, \'reversa_de_id debe apuntar a un movimiento del mismo tipo de envase\');END',
    'trg_cta_deposito_reversa_valida',
  );
  late final Trigger trgMonetariaEstadoCoherente = Trigger(
    'CREATE TRIGGER trg_monetaria_estado_coherente BEFORE INSERT ON cuenta_monetaria_mov WHEN NEW.venta_id IS NOT NULL AND((NEW.tipo IN (\'CARGO\', \'ABONO\') AND (SELECT estado FROM venta WHERE id = NEW.venta_id) != \'COMPLETADA\')OR(NEW.tipo = \'CANCELACION\' AND (SELECT estado FROM venta WHERE id = NEW.venta_id) != \'CANCELADA\'))BEGIN SELECT RAISE (ABORT, \'Estado de la venta incompatible con el tipo de movimiento monetario\');END',
    'trg_monetaria_estado_coherente',
  );
  late final Trigger trgEnvaseEstadoCoherente = Trigger(
    'CREATE TRIGGER trg_envase_estado_coherente BEFORE INSERT ON cuenta_envase_mov WHEN NEW.venta_id IS NOT NULL AND((NEW.tipo IN (\'PRESTAMO\', \'DEVOLUCION\', \'PAGO\') AND (SELECT estado FROM venta WHERE id = NEW.venta_id) != \'COMPLETADA\')OR(NEW.tipo = \'CANCELACION\' AND (SELECT estado FROM venta WHERE id = NEW.venta_id) != \'CANCELADA\'))BEGIN SELECT RAISE (ABORT, \'Estado de la venta incompatible con el tipo de movimiento de envase\');END',
    'trg_envase_estado_coherente',
  );
  late final Trigger trgDepositoEstadoCoherente = Trigger(
    'CREATE TRIGGER trg_deposito_estado_coherente BEFORE INSERT ON cuenta_deposito_envase_mov WHEN((NEW.tipo IN (\'COBRADO\', \'DEVUELTO\') AND (SELECT estado FROM venta WHERE id = NEW.venta_id) != \'COMPLETADA\')OR(NEW.tipo = \'CANCELACION\' AND (SELECT estado FROM venta WHERE id = NEW.venta_id) != \'CANCELADA\'))BEGIN SELECT RAISE (ABORT, \'Estado de la venta incompatible con el tipo de movimiento de depósito\');END',
    'trg_deposito_estado_coherente',
  );
  late final Trigger trgMovInvEstadoCoherente = Trigger(
    'CREATE TRIGGER trg_mov_inv_estado_coherente BEFORE INSERT ON movimiento_inventario WHEN NEW.referencia_tipo = \'VENTA\' AND NEW.referencia_id IS NOT NULL AND((NEW.tipo IN (\'VENTA\', \'DEVOLUCION\') AND (SELECT estado FROM venta WHERE id = NEW.referencia_id) != \'COMPLETADA\')OR(NEW.tipo = \'CANCELACION\' AND (SELECT estado FROM venta WHERE id = NEW.referencia_id) != \'CANCELADA\'))BEGIN SELECT RAISE (ABORT, \'Estado de la venta incompatible con el tipo de movimiento de inventario\');END',
    'trg_mov_inv_estado_coherente',
  );
  late final Trigger trgMovInventarioNoUpdate = Trigger(
    'CREATE TRIGGER trg_mov_inventario_no_update BEFORE UPDATE ON movimiento_inventario BEGIN SELECT RAISE (ABORT, \'movimiento_inventario es append-only: no se permite UPDATE\');END',
    'trg_mov_inventario_no_update',
  );
  late final Trigger trgMovInventarioNoDelete = Trigger(
    'CREATE TRIGGER trg_mov_inventario_no_delete BEFORE DELETE ON movimiento_inventario BEGIN SELECT RAISE (ABORT, \'movimiento_inventario es append-only: no se permite DELETE\');END',
    'trg_mov_inventario_no_delete',
  );
  late final Trigger trgEnvaseInvNoUpdate = Trigger(
    'CREATE TRIGGER trg_envase_inv_no_update BEFORE UPDATE ON envase_inventario_mov BEGIN SELECT RAISE (ABORT, \'envase_inventario_mov es append-only: no se permite UPDATE\');END',
    'trg_envase_inv_no_update',
  );
  late final Trigger trgEnvaseInvNoDelete = Trigger(
    'CREATE TRIGGER trg_envase_inv_no_delete BEFORE DELETE ON envase_inventario_mov BEGIN SELECT RAISE (ABORT, \'envase_inventario_mov es append-only: no se permite DELETE\');END',
    'trg_envase_inv_no_delete',
  );
  late final Trigger trgCtaMonetariaNoUpdate = Trigger(
    'CREATE TRIGGER trg_cta_monetaria_no_update BEFORE UPDATE ON cuenta_monetaria_mov BEGIN SELECT RAISE (ABORT, \'cuenta_monetaria_mov es append-only: no se permite UPDATE\');END',
    'trg_cta_monetaria_no_update',
  );
  late final Trigger trgCtaMonetariaNoDelete = Trigger(
    'CREATE TRIGGER trg_cta_monetaria_no_delete BEFORE DELETE ON cuenta_monetaria_mov BEGIN SELECT RAISE (ABORT, \'cuenta_monetaria_mov es append-only: no se permite DELETE\');END',
    'trg_cta_monetaria_no_delete',
  );
  late final Trigger trgCtaEnvaseNoUpdate = Trigger(
    'CREATE TRIGGER trg_cta_envase_no_update BEFORE UPDATE ON cuenta_envase_mov BEGIN SELECT RAISE (ABORT, \'cuenta_envase_mov es append-only: no se permite UPDATE\');END',
    'trg_cta_envase_no_update',
  );
  late final Trigger trgCtaEnvaseNoDelete = Trigger(
    'CREATE TRIGGER trg_cta_envase_no_delete BEFORE DELETE ON cuenta_envase_mov BEGIN SELECT RAISE (ABORT, \'cuenta_envase_mov es append-only: no se permite DELETE\');END',
    'trg_cta_envase_no_delete',
  );
  late final Trigger trgCtaDepositoNoUpdate = Trigger(
    'CREATE TRIGGER trg_cta_deposito_no_update BEFORE UPDATE ON cuenta_deposito_envase_mov BEGIN SELECT RAISE (ABORT, \'cuenta_deposito_envase_mov es append-only: no se permite UPDATE\');END',
    'trg_cta_deposito_no_update',
  );
  late final Trigger trgCtaDepositoNoDelete = Trigger(
    'CREATE TRIGGER trg_cta_deposito_no_delete BEFORE DELETE ON cuenta_deposito_envase_mov BEGIN SELECT RAISE (ABORT, \'cuenta_deposito_envase_mov es append-only: no se permite DELETE\');END',
    'trg_cta_deposito_no_delete',
  );
  late final Trigger trgMovCajaNoUpdate = Trigger(
    'CREATE TRIGGER trg_mov_caja_no_update BEFORE UPDATE ON movimiento_caja BEGIN SELECT RAISE (ABORT, \'movimiento_caja es append-only: no se permite UPDATE\');END',
    'trg_mov_caja_no_update',
  );
  late final Trigger trgMovCajaNoDelete = Trigger(
    'CREATE TRIGGER trg_mov_caja_no_delete BEFORE DELETE ON movimiento_caja BEGIN SELECT RAISE (ABORT, \'movimiento_caja es append-only: no se permite DELETE\');END',
    'trg_mov_caja_no_delete',
  );
  late final Trigger trgPagoNoUpdate = Trigger(
    'CREATE TRIGGER trg_pago_no_update BEFORE UPDATE ON pago BEGIN SELECT RAISE (ABORT, \'pago es append-only: no se permite UPDATE\');END',
    'trg_pago_no_update',
  );
  late final Trigger trgPagoNoDelete = Trigger(
    'CREATE TRIGGER trg_pago_no_delete BEFORE DELETE ON pago BEGIN SELECT RAISE (ABORT, \'pago es append-only: no se permite DELETE\');END',
    'trg_pago_no_delete',
  );
  late final Trigger trgDetalleVentaNoUpdate = Trigger(
    'CREATE TRIGGER trg_detalle_venta_no_update BEFORE UPDATE ON detalle_venta BEGIN SELECT RAISE (ABORT, \'detalle_venta es append-only: no se permite UPDATE\');END',
    'trg_detalle_venta_no_update',
  );
  late final Trigger trgDetalleVentaNoDelete = Trigger(
    'CREATE TRIGGER trg_detalle_venta_no_delete BEFORE DELETE ON detalle_venta BEGIN SELECT RAISE (ABORT, \'detalle_venta es append-only: no se permite DELETE\');END',
    'trg_detalle_venta_no_delete',
  );
  late final Trigger trgDetalleCompraNoUpdate = Trigger(
    'CREATE TRIGGER trg_detalle_compra_no_update BEFORE UPDATE ON detalle_compra BEGIN SELECT RAISE (ABORT, \'detalle_compra es append-only: no se permite UPDATE\');END',
    'trg_detalle_compra_no_update',
  );
  late final Trigger trgDetalleCompraNoDelete = Trigger(
    'CREATE TRIGGER trg_detalle_compra_no_delete BEFORE DELETE ON detalle_compra BEGIN SELECT RAISE (ABORT, \'detalle_compra es append-only: no se permite DELETE\');END',
    'trg_detalle_compra_no_delete',
  );
  late final Trigger trgOperacionEnvaseNoUpdate = Trigger(
    'CREATE TRIGGER trg_operacion_envase_no_update BEFORE UPDATE ON operacion_envase BEGIN SELECT RAISE (ABORT, \'operacion_envase es append-only: no se permite UPDATE\');END',
    'trg_operacion_envase_no_update',
  );
  late final Trigger trgOperacionEnvaseNoDelete = Trigger(
    'CREATE TRIGGER trg_operacion_envase_no_delete BEFORE DELETE ON operacion_envase BEGIN SELECT RAISE (ABORT, \'operacion_envase es append-only: no se permite DELETE\');END',
    'trg_operacion_envase_no_delete',
  );
  late final Trigger trgDevolucionNoUpdate = Trigger(
    'CREATE TRIGGER trg_devolucion_no_update BEFORE UPDATE ON devolucion BEGIN SELECT RAISE (ABORT, \'devolucion es append-only: no se permite UPDATE\');END',
    'trg_devolucion_no_update',
  );
  late final Trigger trgDevolucionNoDelete = Trigger(
    'CREATE TRIGGER trg_devolucion_no_delete BEFORE DELETE ON devolucion BEGIN SELECT RAISE (ABORT, \'devolucion es append-only: no se permite DELETE\');END',
    'trg_devolucion_no_delete',
  );
  late final Trigger trgVentaNoDelete = Trigger(
    'CREATE TRIGGER trg_venta_no_delete BEFORE DELETE ON venta BEGIN SELECT RAISE (ABORT, \'venta nunca se elimina, solo se cancela\');END',
    'trg_venta_no_delete',
  );
  late final Trigger trgVentaSoloCancelar = Trigger(
    'CREATE TRIGGER trg_venta_solo_cancelar BEFORE UPDATE ON venta WHEN NOT(OLD.estado = \'COMPLETADA\' AND NEW.estado = \'CANCELADA\' AND NEW.terminal_id = OLD.terminal_id AND NEW.folio = OLD.folio AND NEW.cliente_id IS OLD.cliente_id AND NEW.usuario_id = OLD.usuario_id AND NEW.fecha = OLD.fecha AND NEW.subtotal_centavos = OLD.subtotal_centavos AND NEW.total_centavos = OLD.total_centavos)BEGIN SELECT RAISE (ABORT, \'venta: solo se permite pasar de COMPLETADA a CANCELADA; ningún otro campo es editable\');END',
    'trg_venta_solo_cancelar',
  );
  late final Trigger trgCompraNoDelete = Trigger(
    'CREATE TRIGGER trg_compra_no_delete BEFORE DELETE ON compra BEGIN SELECT RAISE (ABORT, \'compra nunca se elimina, solo se cancela\');END',
    'trg_compra_no_delete',
  );
  late final Trigger trgCompraSoloCancelar = Trigger(
    'CREATE TRIGGER trg_compra_solo_cancelar BEFORE UPDATE ON compra WHEN NOT(OLD.estado = \'COMPLETADA\' AND NEW.estado = \'CANCELADA\' AND NEW.terminal_id = OLD.terminal_id AND NEW.caja_sesion_id IS OLD.caja_sesion_id AND NEW.folio = OLD.folio AND NEW.proveedor_id = OLD.proveedor_id AND NEW.usuario_id = OLD.usuario_id AND NEW.fecha = OLD.fecha AND NEW.total_centavos = OLD.total_centavos)BEGIN SELECT RAISE (ABORT, \'compra: solo se permite pasar de COMPLETADA a CANCELADA; ningún otro campo es editable\');END',
    'trg_compra_solo_cancelar',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    terminal,
    usuario,
    cajaSesion,
    idxCajaTerminal,
    idxCajaUnicaAbierta,
    categoria,
    tipoEnvase,
    producto,
    idxProductoCodigoBarras,
    idxProductoCategoria,
    movimientoInventario,
    idxMovInvProducto,
    idxMovInvFecha,
    inventarioSaldo,
    saldoGuard,
    trgSaldoActualizar,
    trgSaldoNoInsertDirecto,
    trgSaldoNoUpdateDirecto,
    trgSaldoNoDeleteDirecto,
    proveedor,
    compra,
    detalleCompra,
    idxDetalleCompraCompra,
    idxDetalleCompraProducto,
    cliente,
    venta,
    idxVentaCliente,
    idxVentaTerminal,
    idxVentaFecha,
    detalleVenta,
    idxDetalleVentaVenta,
    idxDetalleVentaProducto,
    uqDetalleVentaIntegridad,
    operacionEnvase,
    idxOperacionEnvaseVenta,
    pago,
    idxPagoVenta,
    cuentaMonetariaMov,
    idxCtaMonetariaCliente,
    idxCtaMonetariaVenta,
    cuentaEnvaseMov,
    idxCtaEnvaseCliente,
    idxCtaEnvaseVenta,
    cuentaDepositoEnvaseMov,
    idxCtaDepositoVenta,
    envaseInventarioMov,
    idxEnvaseInvTipo,
    devolucion,
    idxDevolucionVenta,
    idxDevolucionDetalle,
    movimientoCaja,
    idxMovCajaSesion,
    idxMovCajaFecha,
    trgMovimientoCajaSesionAbierta,
    trgMovCajaTerminalVenta,
    trgMovCajaTerminalCompra,
    trgPagoNoExcedeTotal,
    trgPagoVentaCompletada,
    trgDevolucionVentaCompletada,
    trgDetalleVentaNoExcedeSubtotal,
    trgDetalleCompraNoExcedeTotal,
    trgMonetariaNoExcedePendiente,
    trgEnvaseNoExcedePrestamo,
    trgDepositoNoExcedeCobrado,
    trgMovInvReversaValida,
    trgEnvaseInvReversaValida,
    trgCtaEnvaseReversaValida,
    trgCtaDepositoReversaValida,
    trgMonetariaEstadoCoherente,
    trgEnvaseEstadoCoherente,
    trgDepositoEstadoCoherente,
    trgMovInvEstadoCoherente,
    trgMovInventarioNoUpdate,
    trgMovInventarioNoDelete,
    trgEnvaseInvNoUpdate,
    trgEnvaseInvNoDelete,
    trgCtaMonetariaNoUpdate,
    trgCtaMonetariaNoDelete,
    trgCtaEnvaseNoUpdate,
    trgCtaEnvaseNoDelete,
    trgCtaDepositoNoUpdate,
    trgCtaDepositoNoDelete,
    trgMovCajaNoUpdate,
    trgMovCajaNoDelete,
    trgPagoNoUpdate,
    trgPagoNoDelete,
    trgDetalleVentaNoUpdate,
    trgDetalleVentaNoDelete,
    trgDetalleCompraNoUpdate,
    trgDetalleCompraNoDelete,
    trgOperacionEnvaseNoUpdate,
    trgOperacionEnvaseNoDelete,
    trgDevolucionNoUpdate,
    trgDevolucionNoDelete,
    trgVentaNoDelete,
    trgVentaSoloCancelar,
    trgCompraNoDelete,
    trgCompraSoloCancelar,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_inventario',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [
        TableUpdate('saldo_guard', kind: UpdateKind.insert),
        TableUpdate('inventario_saldo', kind: UpdateKind.update),
        TableUpdate('inventario_saldo', kind: UpdateKind.insert),
        TableUpdate('saldo_guard', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inventario_saldo',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inventario_saldo',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'inventario_saldo',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_caja',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_caja',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_caja',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pago',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pago',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devolucion',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'detalle_venta',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'detalle_compra',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_monetaria_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_envase_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_deposito_envase_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_inventario',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'envase_inventario_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_envase_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_deposito_envase_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_monetaria_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_envase_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_deposito_envase_mov',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_inventario',
        limitUpdateKind: UpdateKind.insert,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_inventario',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_inventario',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'envase_inventario_mov',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'envase_inventario_mov',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_monetaria_mov',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_monetaria_mov',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_envase_mov',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_envase_mov',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_deposito_envase_mov',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cuenta_deposito_envase_mov',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_caja',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'movimiento_caja',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pago',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'pago',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'detalle_venta',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'detalle_venta',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'detalle_compra',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'detalle_compra',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'operacion_envase',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'operacion_envase',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devolucion',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'devolucion',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'venta',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'venta',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'compra',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'compra',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
  ]);
}

typedef $TerminalCreateCompanionBuilder = TerminalCompanion Function({
  Value<int> id,
  required String nombre,
  required String codigo,
  Value<int> activo,
});
typedef $TerminalUpdateCompanionBuilder = TerminalCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> codigo,
  Value<int> activo,
});

final class $TerminalReferences
    extends BaseReferences<_$AppDatabase, Terminal, TerminalData> {
  $TerminalReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<CajaSesion, List<CajaSesionData>>
  _cajaSesionRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cajaSesion,
    aliasName: 'terminal__id__caja_sesion__terminal_id',
  );

  $CajaSesionProcessedTableManager get cajaSesionRefs {
    final manager = $CajaSesionTableManager(
      $_db,
      $_db.cajaSesion,
    ).filter((f) => f.terminalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_cajaSesionRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Compra, List<CompraData>> _compraRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.compra,
    aliasName: 'terminal__id__compra__terminal_id',
  );

  $CompraProcessedTableManager get compraRefs {
    final manager = $CompraTableManager(
      $_db,
      $_db.compra,
    ).filter((f) => f.terminalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_compraRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Venta, List<VentaData>> _ventaRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.venta,
    aliasName: 'terminal__id__venta__terminal_id',
  );

  $VentaProcessedTableManager get ventaRefs {
    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.terminalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $TerminalFilterComposer extends Composer<_$AppDatabase, Terminal> {
  $TerminalFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cajaSesionRefs(
    Expression<bool> Function($CajaSesionFilterComposer f) f,
  ) {
    final $CajaSesionFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cajaSesion,
      getReferencedColumn: (t) => t.terminalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CajaSesionFilterComposer(
            $db: $db,
            $table: $db.cajaSesion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> compraRefs(
    Expression<bool> Function($CompraFilterComposer f) f,
  ) {
    final $CompraFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.terminalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraFilterComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventaRefs(
    Expression<bool> Function($VentaFilterComposer f) f,
  ) {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.terminalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TerminalOrderingComposer extends Composer<_$AppDatabase, Terminal> {
  $TerminalOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TerminalAnnotationComposer extends Composer<_$AppDatabase, Terminal> {
  $TerminalAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> cajaSesionRefs<T extends Object>(
    Expression<T> Function($CajaSesionAnnotationComposer a) f,
  ) {
    final $CajaSesionAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cajaSesion,
      getReferencedColumn: (t) => t.terminalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CajaSesionAnnotationComposer(
            $db: $db,
            $table: $db.cajaSesion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> compraRefs<T extends Object>(
    Expression<T> Function($CompraAnnotationComposer a) f,
  ) {
    final $CompraAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.terminalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraAnnotationComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ventaRefs<T extends Object>(
    Expression<T> Function($VentaAnnotationComposer a) f,
  ) {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.terminalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TerminalTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Terminal,
          TerminalData,
          $TerminalFilterComposer,
          $TerminalOrderingComposer,
          $TerminalAnnotationComposer,
          $TerminalCreateCompanionBuilder,
          $TerminalUpdateCompanionBuilder,
          (TerminalData, $TerminalReferences),
          TerminalData,
          PrefetchHooks Function({
            bool cajaSesionRefs,
            bool compraRefs,
            bool ventaRefs,
          })
        > {
  $TerminalTableManager(_$AppDatabase db, Terminal table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TerminalFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TerminalOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TerminalAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> codigo = const Value.absent(),
                Value<int> activo = const Value.absent(),
              }) => TerminalCompanion(
                id: id,
                nombre: nombre,
                codigo: codigo,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String codigo,
                Value<int> activo = const Value.absent(),
              }) => TerminalCompanion.insert(
                id: id,
                nombre: nombre,
                codigo: codigo,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Terminal, TerminalData>(table),
                  $TerminalReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cajaSesionRefs = false,
                compraRefs = false,
                ventaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cajaSesionRefs) db.cajaSesion,
                    if (compraRefs) db.compra,
                    if (ventaRefs) db.venta,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cajaSesionRefs)
                        await $_getPrefetchedData<
                          TerminalData,
                          Terminal,
                          CajaSesionData
                        >(
                          currentTable: table,
                          referencedTable: $TerminalReferences
                              ._cajaSesionRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $TerminalReferences(db, table, p0).cajaSesionRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.terminalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (compraRefs)
                        await $_getPrefetchedData<
                          TerminalData,
                          Terminal,
                          CompraData
                        >(
                          currentTable: table,
                          referencedTable: $TerminalReferences._compraRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $TerminalReferences(db, table, p0).compraRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.terminalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ventaRefs)
                        await $_getPrefetchedData<
                          TerminalData,
                          Terminal,
                          VentaData
                        >(
                          currentTable: table,
                          referencedTable: $TerminalReferences._ventaRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $TerminalReferences(db, table, p0).ventaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.terminalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $TerminalProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Terminal,
      TerminalData,
      $TerminalFilterComposer,
      $TerminalOrderingComposer,
      $TerminalAnnotationComposer,
      $TerminalCreateCompanionBuilder,
      $TerminalUpdateCompanionBuilder,
      (TerminalData, $TerminalReferences),
      TerminalData,
      PrefetchHooks Function({
        bool cajaSesionRefs,
        bool compraRefs,
        bool ventaRefs,
      })
    >;
typedef $UsuarioCreateCompanionBuilder = UsuarioCompanion Function({
  Value<int> id,
  required String nombre,
  required String rol,
  Value<int> activo,
  Value<String> creadoEn,
});
typedef $UsuarioUpdateCompanionBuilder = UsuarioCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String> rol,
  Value<int> activo,
  Value<String> creadoEn,
});

final class $UsuarioReferences
    extends BaseReferences<_$AppDatabase, Usuario, UsuarioData> {
  $UsuarioReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    MovimientoInventario,
    List<MovimientoInventarioData>
  >
  _movimientoInventarioRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientoInventario,
        aliasName: 'usuario__id__movimiento_inventario__usuario_id',
      );

  $MovimientoInventarioProcessedTableManager get movimientoInventarioRefs {
    final manager = $MovimientoInventarioTableManager(
      $_db,
      $_db.movimientoInventario,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientoInventarioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Compra, List<CompraData>> _compraRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.compra,
    aliasName: 'usuario__id__compra__usuario_id',
  );

  $CompraProcessedTableManager get compraRefs {
    final manager = $CompraTableManager(
      $_db,
      $_db.compra,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_compraRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Venta, List<VentaData>> _ventaRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.venta,
    aliasName: 'usuario__id__venta__usuario_id',
  );

  $VentaProcessedTableManager get ventaRefs {
    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CuentaMonetariaMov, List<CuentaMonetariaMovData>>
  _cuentaMonetariaMovRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cuentaMonetariaMov,
        aliasName: 'usuario__id__cuenta_monetaria_mov__usuario_id',
      );

  $CuentaMonetariaMovProcessedTableManager get cuentaMonetariaMovRefs {
    final manager = $CuentaMonetariaMovTableManager(
      $_db,
      $_db.cuentaMonetariaMov,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaMonetariaMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CuentaEnvaseMov, List<CuentaEnvaseMovData>>
  _cuentaEnvaseMovRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cuentaEnvaseMov,
    aliasName: 'usuario__id__cuenta_envase_mov__usuario_id',
  );

  $CuentaEnvaseMovProcessedTableManager get cuentaEnvaseMovRefs {
    final manager = $CuentaEnvaseMovTableManager(
      $_db,
      $_db.cuentaEnvaseMov,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaEnvaseMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    CuentaDepositoEnvaseMov,
    List<CuentaDepositoEnvaseMovData>
  >
  _cuentaDepositoEnvaseMovRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cuentaDepositoEnvaseMov,
        aliasName: 'usuario__id__cuenta_deposito_envase_mov__usuario_id',
      );

  $CuentaDepositoEnvaseMovProcessedTableManager
  get cuentaDepositoEnvaseMovRefs {
    final manager = $CuentaDepositoEnvaseMovTableManager(
      $_db,
      $_db.cuentaDepositoEnvaseMov,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaDepositoEnvaseMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<EnvaseInventarioMov, List<EnvaseInventarioMovData>>
  _envaseInventarioMovRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.envaseInventarioMov,
        aliasName: 'usuario__id__envase_inventario_mov__usuario_id',
      );

  $EnvaseInventarioMovProcessedTableManager get envaseInventarioMovRefs {
    final manager = $EnvaseInventarioMovTableManager(
      $_db,
      $_db.envaseInventarioMov,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _envaseInventarioMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Devolucion, List<DevolucionData>>
  _devolucionRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.devolucion,
    aliasName: 'usuario__id__devolucion__usuario_id',
  );

  $DevolucionProcessedTableManager get devolucionRefs {
    final manager = $DevolucionTableManager(
      $_db,
      $_db.devolucion,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_devolucionRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<MovimientoCaja, List<MovimientoCajaData>>
  _movimientoCajaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientoCaja,
    aliasName: 'usuario__id__movimiento_caja__usuario_id',
  );

  $MovimientoCajaProcessedTableManager get movimientoCajaRefs {
    final manager = $MovimientoCajaTableManager(
      $_db,
      $_db.movimientoCaja,
    ).filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientoCajaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $UsuarioFilterComposer extends Composer<_$AppDatabase, Usuario> {
  $UsuarioFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> movimientoInventarioRefs(
    Expression<bool> Function($MovimientoInventarioFilterComposer f) f,
  ) {
    final $MovimientoInventarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientoInventario,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoInventarioFilterComposer(
            $db: $db,
            $table: $db.movimientoInventario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> compraRefs(
    Expression<bool> Function($CompraFilterComposer f) f,
  ) {
    final $CompraFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraFilterComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ventaRefs(
    Expression<bool> Function($VentaFilterComposer f) f,
  ) {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaMonetariaMovRefs(
    Expression<bool> Function($CuentaMonetariaMovFilterComposer f) f,
  ) {
    final $CuentaMonetariaMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovFilterComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaEnvaseMovRefs(
    Expression<bool> Function($CuentaEnvaseMovFilterComposer f) f,
  ) {
    final $CuentaEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaDepositoEnvaseMovRefs(
    Expression<bool> Function($CuentaDepositoEnvaseMovFilterComposer f) f,
  ) {
    final $CuentaDepositoEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaDepositoEnvaseMov,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaDepositoEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaDepositoEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> envaseInventarioMovRefs(
    Expression<bool> Function($EnvaseInventarioMovFilterComposer f) f,
  ) {
    final $EnvaseInventarioMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.envaseInventarioMov,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnvaseInventarioMovFilterComposer(
            $db: $db,
            $table: $db.envaseInventarioMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> devolucionRefs(
    Expression<bool> Function($DevolucionFilterComposer f) f,
  ) {
    final $DevolucionFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.devolucion,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DevolucionFilterComposer(
            $db: $db,
            $table: $db.devolucion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientoCajaRefs(
    Expression<bool> Function($MovimientoCajaFilterComposer f) f,
  ) {
    final $MovimientoCajaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientoCaja,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoCajaFilterComposer(
            $db: $db,
            $table: $db.movimientoCaja,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $UsuarioOrderingComposer extends Composer<_$AppDatabase, Usuario> {
  $UsuarioOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rol => $composableBuilder(
    column: $table.rol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $UsuarioAnnotationComposer extends Composer<_$AppDatabase, Usuario> {
  $UsuarioAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get rol =>
      $composableBuilder(column: $table.rol, builder: (column) => column);

  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<String> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> movimientoInventarioRefs<T extends Object>(
    Expression<T> Function($MovimientoInventarioAnnotationComposer a) f,
  ) {
    final $MovimientoInventarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientoInventario,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoInventarioAnnotationComposer(
            $db: $db,
            $table: $db.movimientoInventario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> compraRefs<T extends Object>(
    Expression<T> Function($CompraAnnotationComposer a) f,
  ) {
    final $CompraAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraAnnotationComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ventaRefs<T extends Object>(
    Expression<T> Function($VentaAnnotationComposer a) f,
  ) {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaMonetariaMovRefs<T extends Object>(
    Expression<T> Function($CuentaMonetariaMovAnnotationComposer a) f,
  ) {
    final $CuentaMonetariaMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaEnvaseMovRefs<T extends Object>(
    Expression<T> Function($CuentaEnvaseMovAnnotationComposer a) f,
  ) {
    final $CuentaEnvaseMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaDepositoEnvaseMovRefs<T extends Object>(
    Expression<T> Function($CuentaDepositoEnvaseMovAnnotationComposer a) f,
  ) {
    final $CuentaDepositoEnvaseMovAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cuentaDepositoEnvaseMov,
          getReferencedColumn: (t) => t.usuarioId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $CuentaDepositoEnvaseMovAnnotationComposer(
                $db: $db,
                $table: $db.cuentaDepositoEnvaseMov,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> envaseInventarioMovRefs<T extends Object>(
    Expression<T> Function($EnvaseInventarioMovAnnotationComposer a) f,
  ) {
    final $EnvaseInventarioMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.envaseInventarioMov,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnvaseInventarioMovAnnotationComposer(
            $db: $db,
            $table: $db.envaseInventarioMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> devolucionRefs<T extends Object>(
    Expression<T> Function($DevolucionAnnotationComposer a) f,
  ) {
    final $DevolucionAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.devolucion,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DevolucionAnnotationComposer(
            $db: $db,
            $table: $db.devolucion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientoCajaRefs<T extends Object>(
    Expression<T> Function($MovimientoCajaAnnotationComposer a) f,
  ) {
    final $MovimientoCajaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientoCaja,
      getReferencedColumn: (t) => t.usuarioId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoCajaAnnotationComposer(
            $db: $db,
            $table: $db.movimientoCaja,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $UsuarioTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Usuario,
          UsuarioData,
          $UsuarioFilterComposer,
          $UsuarioOrderingComposer,
          $UsuarioAnnotationComposer,
          $UsuarioCreateCompanionBuilder,
          $UsuarioUpdateCompanionBuilder,
          (UsuarioData, $UsuarioReferences),
          UsuarioData,
          PrefetchHooks Function({
            bool movimientoInventarioRefs,
            bool compraRefs,
            bool ventaRefs,
            bool cuentaMonetariaMovRefs,
            bool cuentaEnvaseMovRefs,
            bool cuentaDepositoEnvaseMovRefs,
            bool envaseInventarioMovRefs,
            bool devolucionRefs,
            bool movimientoCajaRefs,
          })
        > {
  $UsuarioTableManager(_$AppDatabase db, Usuario table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $UsuarioFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $UsuarioOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $UsuarioAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> rol = const Value.absent(),
                Value<int> activo = const Value.absent(),
                Value<String> creadoEn = const Value.absent(),
              }) => UsuarioCompanion(
                id: id,
                nombre: nombre,
                rol: rol,
                activo: activo,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String rol,
                Value<int> activo = const Value.absent(),
                Value<String> creadoEn = const Value.absent(),
              }) => UsuarioCompanion.insert(
                id: id,
                nombre: nombre,
                rol: rol,
                activo: activo,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Usuario, UsuarioData>(table),
                  $UsuarioReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                movimientoInventarioRefs = false,
                compraRefs = false,
                ventaRefs = false,
                cuentaMonetariaMovRefs = false,
                cuentaEnvaseMovRefs = false,
                cuentaDepositoEnvaseMovRefs = false,
                envaseInventarioMovRefs = false,
                devolucionRefs = false,
                movimientoCajaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientoInventarioRefs) db.movimientoInventario,
                    if (compraRefs) db.compra,
                    if (ventaRefs) db.venta,
                    if (cuentaMonetariaMovRefs) db.cuentaMonetariaMov,
                    if (cuentaEnvaseMovRefs) db.cuentaEnvaseMov,
                    if (cuentaDepositoEnvaseMovRefs) db.cuentaDepositoEnvaseMov,
                    if (envaseInventarioMovRefs) db.envaseInventarioMov,
                    if (devolucionRefs) db.devolucion,
                    if (movimientoCajaRefs) db.movimientoCaja,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientoInventarioRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          MovimientoInventarioData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences
                              ._movimientoInventarioRefsTable(db),
                          managerFromTypedResult: (p0) => $UsuarioReferences(
                            db,
                            table,
                            p0,
                          ).movimientoInventarioRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (compraRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          CompraData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences._compraRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsuarioReferences(db, table, p0).compraRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ventaRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          VentaData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences._ventaRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $UsuarioReferences(db, table, p0).ventaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaMonetariaMovRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          CuentaMonetariaMovData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences
                              ._cuentaMonetariaMovRefsTable(db),
                          managerFromTypedResult: (p0) => $UsuarioReferences(
                            db,
                            table,
                            p0,
                          ).cuentaMonetariaMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaEnvaseMovRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          CuentaEnvaseMovData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences
                              ._cuentaEnvaseMovRefsTable(db),
                          managerFromTypedResult: (p0) => $UsuarioReferences(
                            db,
                            table,
                            p0,
                          ).cuentaEnvaseMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaDepositoEnvaseMovRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          CuentaDepositoEnvaseMovData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences
                              ._cuentaDepositoEnvaseMovRefsTable(db),
                          managerFromTypedResult: (p0) => $UsuarioReferences(
                            db,
                            table,
                            p0,
                          ).cuentaDepositoEnvaseMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (envaseInventarioMovRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          EnvaseInventarioMovData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences
                              ._envaseInventarioMovRefsTable(db),
                          managerFromTypedResult: (p0) => $UsuarioReferences(
                            db,
                            table,
                            p0,
                          ).envaseInventarioMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (devolucionRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          DevolucionData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences
                              ._devolucionRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $UsuarioReferences(db, table, p0).devolucionRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientoCajaRefs)
                        await $_getPrefetchedData<
                          UsuarioData,
                          Usuario,
                          MovimientoCajaData
                        >(
                          currentTable: table,
                          referencedTable: $UsuarioReferences
                              ._movimientoCajaRefsTable(db),
                          managerFromTypedResult: (p0) => $UsuarioReferences(
                            db,
                            table,
                            p0,
                          ).movimientoCajaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.usuarioId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $UsuarioProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Usuario,
      UsuarioData,
      $UsuarioFilterComposer,
      $UsuarioOrderingComposer,
      $UsuarioAnnotationComposer,
      $UsuarioCreateCompanionBuilder,
      $UsuarioUpdateCompanionBuilder,
      (UsuarioData, $UsuarioReferences),
      UsuarioData,
      PrefetchHooks Function({
        bool movimientoInventarioRefs,
        bool compraRefs,
        bool ventaRefs,
        bool cuentaMonetariaMovRefs,
        bool cuentaEnvaseMovRefs,
        bool cuentaDepositoEnvaseMovRefs,
        bool envaseInventarioMovRefs,
        bool devolucionRefs,
        bool movimientoCajaRefs,
      })
    >;
typedef $CajaSesionCreateCompanionBuilder = CajaSesionCompanion Function({
  Value<int> id,
  required int terminalId,
  required int usuarioAperturaId,
  Value<int?> usuarioCierreId,
  Value<String> fechaApertura,
  required int efectivoInicialCentavos,
  Value<String?> fechaCierre,
  Value<int?> efectivoEsperadoCentavos,
  Value<int?> efectivoContadoCentavos,
  Value<int?> diferenciaCentavos,
  Value<String> estado,
});
typedef $CajaSesionUpdateCompanionBuilder = CajaSesionCompanion Function({
  Value<int> id,
  Value<int> terminalId,
  Value<int> usuarioAperturaId,
  Value<int?> usuarioCierreId,
  Value<String> fechaApertura,
  Value<int> efectivoInicialCentavos,
  Value<String?> fechaCierre,
  Value<int?> efectivoEsperadoCentavos,
  Value<int?> efectivoContadoCentavos,
  Value<int?> diferenciaCentavos,
  Value<String> estado,
});

final class $CajaSesionReferences
    extends BaseReferences<_$AppDatabase, CajaSesion, CajaSesionData> {
  $CajaSesionReferences(super.$_db, super.$_table, super.$_typedResult);

  static Terminal _terminalIdTable(_$AppDatabase db) =>
      db.terminal.createAlias('caja_sesion__terminal_id__terminal__id');

  $TerminalProcessedTableManager get terminalId {
    final $_column = $_itemColumn<int>('terminal_id')!;

    final manager = $TerminalTableManager(
      $_db,
      $_db.terminal,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_terminalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioAperturaIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('caja_sesion__usuario_apertura_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioAperturaId {
    final $_column = $_itemColumn<int>('usuario_apertura_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioAperturaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioCierreIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('caja_sesion__usuario_cierre_id__usuario__id');

  $UsuarioProcessedTableManager? get usuarioCierreId {
    final $_column = $_itemColumn<int>('usuario_cierre_id');
    if ($_column == null) return null;
    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioCierreIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Compra, List<CompraData>> _compraRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.compra,
    aliasName: 'caja_sesion__id__compra__caja_sesion_id',
  );

  $CompraProcessedTableManager get compraRefs {
    final manager = $CompraTableManager(
      $_db,
      $_db.compra,
    ).filter((f) => f.cajaSesionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_compraRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<MovimientoCaja, List<MovimientoCajaData>>
  _movimientoCajaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientoCaja,
    aliasName: 'caja_sesion__id__movimiento_caja__caja_sesion_id',
  );

  $MovimientoCajaProcessedTableManager get movimientoCajaRefs {
    final manager = $MovimientoCajaTableManager(
      $_db,
      $_db.movimientoCaja,
    ).filter((f) => f.cajaSesionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientoCajaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $CajaSesionFilterComposer extends Composer<_$AppDatabase, CajaSesion> {
  $CajaSesionFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaApertura => $composableBuilder(
    column: $table.fechaApertura,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get efectivoInicialCentavos => $composableBuilder(
    column: $table.efectivoInicialCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get efectivoEsperadoCentavos => $composableBuilder(
    column: $table.efectivoEsperadoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get efectivoContadoCentavos => $composableBuilder(
    column: $table.efectivoContadoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diferenciaCentavos => $composableBuilder(
    column: $table.diferenciaCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  $TerminalFilterComposer get terminalId {
    final $TerminalFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalFilterComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioAperturaId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioAperturaId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioCierreId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioCierreId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> compraRefs(
    Expression<bool> Function($CompraFilterComposer f) f,
  ) {
    final $CompraFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.cajaSesionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraFilterComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientoCajaRefs(
    Expression<bool> Function($MovimientoCajaFilterComposer f) f,
  ) {
    final $MovimientoCajaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientoCaja,
      getReferencedColumn: (t) => t.cajaSesionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoCajaFilterComposer(
            $db: $db,
            $table: $db.movimientoCaja,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CajaSesionOrderingComposer extends Composer<_$AppDatabase, CajaSesion> {
  $CajaSesionOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaApertura => $composableBuilder(
    column: $table.fechaApertura,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get efectivoInicialCentavos => $composableBuilder(
    column: $table.efectivoInicialCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get efectivoEsperadoCentavos => $composableBuilder(
    column: $table.efectivoEsperadoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get efectivoContadoCentavos => $composableBuilder(
    column: $table.efectivoContadoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diferenciaCentavos => $composableBuilder(
    column: $table.diferenciaCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  $TerminalOrderingComposer get terminalId {
    final $TerminalOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalOrderingComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioAperturaId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioAperturaId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioCierreId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioCierreId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CajaSesionAnnotationComposer
    extends Composer<_$AppDatabase, CajaSesion> {
  $CajaSesionAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fechaApertura => $composableBuilder(
    column: $table.fechaApertura,
    builder: (column) => column,
  );

  GeneratedColumn<int> get efectivoInicialCentavos => $composableBuilder(
    column: $table.efectivoInicialCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fechaCierre => $composableBuilder(
    column: $table.fechaCierre,
    builder: (column) => column,
  );

  GeneratedColumn<int> get efectivoEsperadoCentavos => $composableBuilder(
    column: $table.efectivoEsperadoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get efectivoContadoCentavos => $composableBuilder(
    column: $table.efectivoContadoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diferenciaCentavos => $composableBuilder(
    column: $table.diferenciaCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  $TerminalAnnotationComposer get terminalId {
    final $TerminalAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalAnnotationComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioAperturaId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioAperturaId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioCierreId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioCierreId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> compraRefs<T extends Object>(
    Expression<T> Function($CompraAnnotationComposer a) f,
  ) {
    final $CompraAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.cajaSesionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraAnnotationComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientoCajaRefs<T extends Object>(
    Expression<T> Function($MovimientoCajaAnnotationComposer a) f,
  ) {
    final $MovimientoCajaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientoCaja,
      getReferencedColumn: (t) => t.cajaSesionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoCajaAnnotationComposer(
            $db: $db,
            $table: $db.movimientoCaja,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CajaSesionTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CajaSesion,
          CajaSesionData,
          $CajaSesionFilterComposer,
          $CajaSesionOrderingComposer,
          $CajaSesionAnnotationComposer,
          $CajaSesionCreateCompanionBuilder,
          $CajaSesionUpdateCompanionBuilder,
          (CajaSesionData, $CajaSesionReferences),
          CajaSesionData,
          PrefetchHooks Function({
            bool terminalId,
            bool usuarioAperturaId,
            bool usuarioCierreId,
            bool compraRefs,
            bool movimientoCajaRefs,
          })
        > {
  $CajaSesionTableManager(_$AppDatabase db, CajaSesion table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CajaSesionFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CajaSesionOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CajaSesionAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> terminalId = const Value.absent(),
                Value<int> usuarioAperturaId = const Value.absent(),
                Value<int?> usuarioCierreId = const Value.absent(),
                Value<String> fechaApertura = const Value.absent(),
                Value<int> efectivoInicialCentavos = const Value.absent(),
                Value<String?> fechaCierre = const Value.absent(),
                Value<int?> efectivoEsperadoCentavos = const Value.absent(),
                Value<int?> efectivoContadoCentavos = const Value.absent(),
                Value<int?> diferenciaCentavos = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => CajaSesionCompanion(
                id: id,
                terminalId: terminalId,
                usuarioAperturaId: usuarioAperturaId,
                usuarioCierreId: usuarioCierreId,
                fechaApertura: fechaApertura,
                efectivoInicialCentavos: efectivoInicialCentavos,
                fechaCierre: fechaCierre,
                efectivoEsperadoCentavos: efectivoEsperadoCentavos,
                efectivoContadoCentavos: efectivoContadoCentavos,
                diferenciaCentavos: diferenciaCentavos,
                estado: estado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int terminalId,
                required int usuarioAperturaId,
                Value<int?> usuarioCierreId = const Value.absent(),
                Value<String> fechaApertura = const Value.absent(),
                required int efectivoInicialCentavos,
                Value<String?> fechaCierre = const Value.absent(),
                Value<int?> efectivoEsperadoCentavos = const Value.absent(),
                Value<int?> efectivoContadoCentavos = const Value.absent(),
                Value<int?> diferenciaCentavos = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => CajaSesionCompanion.insert(
                id: id,
                terminalId: terminalId,
                usuarioAperturaId: usuarioAperturaId,
                usuarioCierreId: usuarioCierreId,
                fechaApertura: fechaApertura,
                efectivoInicialCentavos: efectivoInicialCentavos,
                fechaCierre: fechaCierre,
                efectivoEsperadoCentavos: efectivoEsperadoCentavos,
                efectivoContadoCentavos: efectivoContadoCentavos,
                diferenciaCentavos: diferenciaCentavos,
                estado: estado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<CajaSesion, CajaSesionData>(table),
                  $CajaSesionReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                terminalId = false,
                usuarioAperturaId = false,
                usuarioCierreId = false,
                compraRefs = false,
                movimientoCajaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (compraRefs) db.compra,
                    if (movimientoCajaRefs) db.movimientoCaja,
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
                        if (terminalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.terminalId,
                            referencedTable: $CajaSesionReferences
                                ._terminalIdTable(db),
                            referencedColumn: $CajaSesionReferences
                                ._terminalIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioAperturaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioAperturaId,
                            referencedTable: $CajaSesionReferences
                                ._usuarioAperturaIdTable(db),
                            referencedColumn: $CajaSesionReferences
                                ._usuarioAperturaIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioCierreId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioCierreId,
                            referencedTable: $CajaSesionReferences
                                ._usuarioCierreIdTable(db),
                            referencedColumn: $CajaSesionReferences
                                ._usuarioCierreIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (compraRefs)
                        await $_getPrefetchedData<
                          CajaSesionData,
                          CajaSesion,
                          CompraData
                        >(
                          currentTable: table,
                          referencedTable: $CajaSesionReferences
                              ._compraRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CajaSesionReferences(db, table, p0).compraRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cajaSesionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (movimientoCajaRefs)
                        await $_getPrefetchedData<
                          CajaSesionData,
                          CajaSesion,
                          MovimientoCajaData
                        >(
                          currentTable: table,
                          referencedTable: $CajaSesionReferences
                              ._movimientoCajaRefsTable(db),
                          managerFromTypedResult: (p0) => $CajaSesionReferences(
                            db,
                            table,
                            p0,
                          ).movimientoCajaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cajaSesionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $CajaSesionProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CajaSesion,
      CajaSesionData,
      $CajaSesionFilterComposer,
      $CajaSesionOrderingComposer,
      $CajaSesionAnnotationComposer,
      $CajaSesionCreateCompanionBuilder,
      $CajaSesionUpdateCompanionBuilder,
      (CajaSesionData, $CajaSesionReferences),
      CajaSesionData,
      PrefetchHooks Function({
        bool terminalId,
        bool usuarioAperturaId,
        bool usuarioCierreId,
        bool compraRefs,
        bool movimientoCajaRefs,
      })
    >;
typedef $CategoriaCreateCompanionBuilder = CategoriaCompanion Function({
  Value<int> id,
  required String nombre,
});
typedef $CategoriaUpdateCompanionBuilder = CategoriaCompanion Function({
  Value<int> id,
  Value<String> nombre,
});

final class $CategoriaReferences
    extends BaseReferences<_$AppDatabase, Categoria, CategoriaData> {
  $CategoriaReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Producto, List<ProductoData>> _productoRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.producto,
    aliasName: 'categoria__id__producto__categoria_id',
  );

  $ProductoProcessedTableManager get productoRefs {
    final manager = $ProductoTableManager(
      $_db,
      $_db.producto,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $CategoriaFilterComposer extends Composer<_$AppDatabase, Categoria> {
  $CategoriaFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productoRefs(
    Expression<bool> Function($ProductoFilterComposer f) f,
  ) {
    final $ProductoFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoFilterComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CategoriaOrderingComposer extends Composer<_$AppDatabase, Categoria> {
  $CategoriaOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $CategoriaAnnotationComposer extends Composer<_$AppDatabase, Categoria> {
  $CategoriaAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  Expression<T> productoRefs<T extends Object>(
    Expression<T> Function($ProductoAnnotationComposer a) f,
  ) {
    final $ProductoAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoAnnotationComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CategoriaTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Categoria,
          CategoriaData,
          $CategoriaFilterComposer,
          $CategoriaOrderingComposer,
          $CategoriaAnnotationComposer,
          $CategoriaCreateCompanionBuilder,
          $CategoriaUpdateCompanionBuilder,
          (CategoriaData, $CategoriaReferences),
          CategoriaData,
          PrefetchHooks Function({bool productoRefs})
        > {
  $CategoriaTableManager(_$AppDatabase db, Categoria table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CategoriaFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CategoriaOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CategoriaAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
          }) => CategoriaCompanion(id: id, nombre: nombre),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
          }) => CategoriaCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Categoria, CategoriaData>(table),
                  $CategoriaReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productoRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productoRefs) db.producto],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productoRefs)
                    await $_getPrefetchedData<
                      CategoriaData,
                      Categoria,
                      ProductoData
                    >(
                      currentTable: table,
                      referencedTable: $CategoriaReferences._productoRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $CategoriaReferences(db, table, p0).productoRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.categoriaId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $CategoriaProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Categoria,
      CategoriaData,
      $CategoriaFilterComposer,
      $CategoriaOrderingComposer,
      $CategoriaAnnotationComposer,
      $CategoriaCreateCompanionBuilder,
      $CategoriaUpdateCompanionBuilder,
      (CategoriaData, $CategoriaReferences),
      CategoriaData,
      PrefetchHooks Function({bool productoRefs})
    >;
typedef $TipoEnvaseCreateCompanionBuilder = TipoEnvaseCompanion Function({
  Value<int> id,
  required String nombre,
  Value<int> valorDepositoCentavos,
  Value<int?> valorReposicionCentavos,
  Value<int> activo,
});
typedef $TipoEnvaseUpdateCompanionBuilder = TipoEnvaseCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<int> valorDepositoCentavos,
  Value<int?> valorReposicionCentavos,
  Value<int> activo,
});

final class $TipoEnvaseReferences
    extends BaseReferences<_$AppDatabase, TipoEnvase, TipoEnvaseData> {
  $TipoEnvaseReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Producto, List<ProductoData>> _productoRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.producto,
    aliasName: 'tipo_envase__id__producto__tipo_envase_id',
  );

  $ProductoProcessedTableManager get productoRefs {
    final manager = $ProductoTableManager(
      $_db,
      $_db.producto,
    ).filter((f) => f.tipoEnvaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<OperacionEnvase, List<OperacionEnvaseData>>
  _operacionEnvaseRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.operacionEnvase,
    aliasName: 'tipo_envase__id__operacion_envase__tipo_envase_id',
  );

  $OperacionEnvaseProcessedTableManager get operacionEnvaseRefs {
    final manager = $OperacionEnvaseTableManager(
      $_db,
      $_db.operacionEnvase,
    ).filter((f) => f.tipoEnvaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _operacionEnvaseRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CuentaEnvaseMov, List<CuentaEnvaseMovData>>
  _cuentaEnvaseMovRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cuentaEnvaseMov,
    aliasName: 'tipo_envase__id__cuenta_envase_mov__tipo_envase_id',
  );

  $CuentaEnvaseMovProcessedTableManager get cuentaEnvaseMovRefs {
    final manager = $CuentaEnvaseMovTableManager(
      $_db,
      $_db.cuentaEnvaseMov,
    ).filter((f) => f.tipoEnvaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaEnvaseMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    CuentaDepositoEnvaseMov,
    List<CuentaDepositoEnvaseMovData>
  >
  _cuentaDepositoEnvaseMovRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cuentaDepositoEnvaseMov,
        aliasName:
            'tipo_envase__id__cuenta_deposito_envase_mov__tipo_envase_id',
      );

  $CuentaDepositoEnvaseMovProcessedTableManager
  get cuentaDepositoEnvaseMovRefs {
    final manager = $CuentaDepositoEnvaseMovTableManager(
      $_db,
      $_db.cuentaDepositoEnvaseMov,
    ).filter((f) => f.tipoEnvaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaDepositoEnvaseMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<EnvaseInventarioMov, List<EnvaseInventarioMovData>>
  _envaseInventarioMovRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.envaseInventarioMov,
        aliasName: 'tipo_envase__id__envase_inventario_mov__tipo_envase_id',
      );

  $EnvaseInventarioMovProcessedTableManager get envaseInventarioMovRefs {
    final manager = $EnvaseInventarioMovTableManager(
      $_db,
      $_db.envaseInventarioMov,
    ).filter((f) => f.tipoEnvaseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _envaseInventarioMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $TipoEnvaseFilterComposer extends Composer<_$AppDatabase, TipoEnvase> {
  $TipoEnvaseFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorDepositoCentavos => $composableBuilder(
    column: $table.valorDepositoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valorReposicionCentavos => $composableBuilder(
    column: $table.valorReposicionCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productoRefs(
    Expression<bool> Function($ProductoFilterComposer f) f,
  ) {
    final $ProductoFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoFilterComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> operacionEnvaseRefs(
    Expression<bool> Function($OperacionEnvaseFilterComposer f) f,
  ) {
    final $OperacionEnvaseFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.operacionEnvase,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $OperacionEnvaseFilterComposer(
            $db: $db,
            $table: $db.operacionEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaEnvaseMovRefs(
    Expression<bool> Function($CuentaEnvaseMovFilterComposer f) f,
  ) {
    final $CuentaEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaDepositoEnvaseMovRefs(
    Expression<bool> Function($CuentaDepositoEnvaseMovFilterComposer f) f,
  ) {
    final $CuentaDepositoEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaDepositoEnvaseMov,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaDepositoEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaDepositoEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> envaseInventarioMovRefs(
    Expression<bool> Function($EnvaseInventarioMovFilterComposer f) f,
  ) {
    final $EnvaseInventarioMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.envaseInventarioMov,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnvaseInventarioMovFilterComposer(
            $db: $db,
            $table: $db.envaseInventarioMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TipoEnvaseOrderingComposer extends Composer<_$AppDatabase, TipoEnvase> {
  $TipoEnvaseOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorDepositoCentavos => $composableBuilder(
    column: $table.valorDepositoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valorReposicionCentavos => $composableBuilder(
    column: $table.valorReposicionCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $TipoEnvaseAnnotationComposer
    extends Composer<_$AppDatabase, TipoEnvase> {
  $TipoEnvaseAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<int> get valorDepositoCentavos => $composableBuilder(
    column: $table.valorDepositoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get valorReposicionCentavos => $composableBuilder(
    column: $table.valorReposicionCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  Expression<T> productoRefs<T extends Object>(
    Expression<T> Function($ProductoAnnotationComposer a) f,
  ) {
    final $ProductoAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoAnnotationComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> operacionEnvaseRefs<T extends Object>(
    Expression<T> Function($OperacionEnvaseAnnotationComposer a) f,
  ) {
    final $OperacionEnvaseAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.operacionEnvase,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $OperacionEnvaseAnnotationComposer(
            $db: $db,
            $table: $db.operacionEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaEnvaseMovRefs<T extends Object>(
    Expression<T> Function($CuentaEnvaseMovAnnotationComposer a) f,
  ) {
    final $CuentaEnvaseMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaDepositoEnvaseMovRefs<T extends Object>(
    Expression<T> Function($CuentaDepositoEnvaseMovAnnotationComposer a) f,
  ) {
    final $CuentaDepositoEnvaseMovAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cuentaDepositoEnvaseMov,
          getReferencedColumn: (t) => t.tipoEnvaseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $CuentaDepositoEnvaseMovAnnotationComposer(
                $db: $db,
                $table: $db.cuentaDepositoEnvaseMov,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> envaseInventarioMovRefs<T extends Object>(
    Expression<T> Function($EnvaseInventarioMovAnnotationComposer a) f,
  ) {
    final $EnvaseInventarioMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.envaseInventarioMov,
      getReferencedColumn: (t) => t.tipoEnvaseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnvaseInventarioMovAnnotationComposer(
            $db: $db,
            $table: $db.envaseInventarioMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $TipoEnvaseTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          TipoEnvase,
          TipoEnvaseData,
          $TipoEnvaseFilterComposer,
          $TipoEnvaseOrderingComposer,
          $TipoEnvaseAnnotationComposer,
          $TipoEnvaseCreateCompanionBuilder,
          $TipoEnvaseUpdateCompanionBuilder,
          (TipoEnvaseData, $TipoEnvaseReferences),
          TipoEnvaseData,
          PrefetchHooks Function({
            bool productoRefs,
            bool operacionEnvaseRefs,
            bool cuentaEnvaseMovRefs,
            bool cuentaDepositoEnvaseMovRefs,
            bool envaseInventarioMovRefs,
          })
        > {
  $TipoEnvaseTableManager(_$AppDatabase db, TipoEnvase table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TipoEnvaseFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TipoEnvaseOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TipoEnvaseAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<int> valorDepositoCentavos = const Value.absent(),
                Value<int?> valorReposicionCentavos = const Value.absent(),
                Value<int> activo = const Value.absent(),
              }) => TipoEnvaseCompanion(
                id: id,
                nombre: nombre,
                valorDepositoCentavos: valorDepositoCentavos,
                valorReposicionCentavos: valorReposicionCentavos,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<int> valorDepositoCentavos = const Value.absent(),
                Value<int?> valorReposicionCentavos = const Value.absent(),
                Value<int> activo = const Value.absent(),
              }) => TipoEnvaseCompanion.insert(
                id: id,
                nombre: nombre,
                valorDepositoCentavos: valorDepositoCentavos,
                valorReposicionCentavos: valorReposicionCentavos,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<TipoEnvase, TipoEnvaseData>(table),
                  $TipoEnvaseReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                productoRefs = false,
                operacionEnvaseRefs = false,
                cuentaEnvaseMovRefs = false,
                cuentaDepositoEnvaseMovRefs = false,
                envaseInventarioMovRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (productoRefs) db.producto,
                    if (operacionEnvaseRefs) db.operacionEnvase,
                    if (cuentaEnvaseMovRefs) db.cuentaEnvaseMov,
                    if (cuentaDepositoEnvaseMovRefs) db.cuentaDepositoEnvaseMov,
                    if (envaseInventarioMovRefs) db.envaseInventarioMov,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (productoRefs)
                        await $_getPrefetchedData<
                          TipoEnvaseData,
                          TipoEnvase,
                          ProductoData
                        >(
                          currentTable: table,
                          referencedTable: $TipoEnvaseReferences
                              ._productoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $TipoEnvaseReferences(db, table, p0).productoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tipoEnvaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (operacionEnvaseRefs)
                        await $_getPrefetchedData<
                          TipoEnvaseData,
                          TipoEnvase,
                          OperacionEnvaseData
                        >(
                          currentTable: table,
                          referencedTable: $TipoEnvaseReferences
                              ._operacionEnvaseRefsTable(db),
                          managerFromTypedResult: (p0) => $TipoEnvaseReferences(
                            db,
                            table,
                            p0,
                          ).operacionEnvaseRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tipoEnvaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaEnvaseMovRefs)
                        await $_getPrefetchedData<
                          TipoEnvaseData,
                          TipoEnvase,
                          CuentaEnvaseMovData
                        >(
                          currentTable: table,
                          referencedTable: $TipoEnvaseReferences
                              ._cuentaEnvaseMovRefsTable(db),
                          managerFromTypedResult: (p0) => $TipoEnvaseReferences(
                            db,
                            table,
                            p0,
                          ).cuentaEnvaseMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tipoEnvaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaDepositoEnvaseMovRefs)
                        await $_getPrefetchedData<
                          TipoEnvaseData,
                          TipoEnvase,
                          CuentaDepositoEnvaseMovData
                        >(
                          currentTable: table,
                          referencedTable: $TipoEnvaseReferences
                              ._cuentaDepositoEnvaseMovRefsTable(db),
                          managerFromTypedResult: (p0) => $TipoEnvaseReferences(
                            db,
                            table,
                            p0,
                          ).cuentaDepositoEnvaseMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tipoEnvaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (envaseInventarioMovRefs)
                        await $_getPrefetchedData<
                          TipoEnvaseData,
                          TipoEnvase,
                          EnvaseInventarioMovData
                        >(
                          currentTable: table,
                          referencedTable: $TipoEnvaseReferences
                              ._envaseInventarioMovRefsTable(db),
                          managerFromTypedResult: (p0) => $TipoEnvaseReferences(
                            db,
                            table,
                            p0,
                          ).envaseInventarioMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tipoEnvaseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $TipoEnvaseProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      TipoEnvase,
      TipoEnvaseData,
      $TipoEnvaseFilterComposer,
      $TipoEnvaseOrderingComposer,
      $TipoEnvaseAnnotationComposer,
      $TipoEnvaseCreateCompanionBuilder,
      $TipoEnvaseUpdateCompanionBuilder,
      (TipoEnvaseData, $TipoEnvaseReferences),
      TipoEnvaseData,
      PrefetchHooks Function({
        bool productoRefs,
        bool operacionEnvaseRefs,
        bool cuentaEnvaseMovRefs,
        bool cuentaDepositoEnvaseMovRefs,
        bool envaseInventarioMovRefs,
      })
    >;
typedef $ProductoCreateCompanionBuilder = ProductoCompanion Function({
  Value<int> id,
  Value<int?> categoriaId,
  Value<int?> tipoEnvaseId,
  required String nombre,
  Value<String?> codigoBarras,
  required String codigoInterno,
  required String unidad,
  required int precioVentaCentavos,
  Value<int?> costoReferenciaCentavos,
  Value<int> activo,
  Value<String> creadoEn,
});
typedef $ProductoUpdateCompanionBuilder = ProductoCompanion Function({
  Value<int> id,
  Value<int?> categoriaId,
  Value<int?> tipoEnvaseId,
  Value<String> nombre,
  Value<String?> codigoBarras,
  Value<String> codigoInterno,
  Value<String> unidad,
  Value<int> precioVentaCentavos,
  Value<int?> costoReferenciaCentavos,
  Value<int> activo,
  Value<String> creadoEn,
});

final class $ProductoReferences
    extends BaseReferences<_$AppDatabase, Producto, ProductoData> {
  $ProductoReferences(super.$_db, super.$_table, super.$_typedResult);

  static Categoria _categoriaIdTable(_$AppDatabase db) =>
      db.categoria.createAlias('producto__categoria_id__categoria__id');

  $CategoriaProcessedTableManager? get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id');
    if ($_column == null) return null;
    final manager = $CategoriaTableManager(
      $_db,
      $_db.categoria,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static TipoEnvase _tipoEnvaseIdTable(_$AppDatabase db) =>
      db.tipoEnvase.createAlias('producto__tipo_envase_id__tipo_envase__id');

  $TipoEnvaseProcessedTableManager? get tipoEnvaseId {
    final $_column = $_itemColumn<int>('tipo_envase_id');
    if ($_column == null) return null;
    final manager = $TipoEnvaseTableManager(
      $_db,
      $_db.tipoEnvase,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoEnvaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    MovimientoInventario,
    List<MovimientoInventarioData>
  >
  _movimientoInventarioRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.movimientoInventario,
        aliasName: 'producto__id__movimiento_inventario__producto_id',
      );

  $MovimientoInventarioProcessedTableManager get movimientoInventarioRefs {
    final manager = $MovimientoInventarioTableManager(
      $_db,
      $_db.movimientoInventario,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _movimientoInventarioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<InventarioSaldo, List<InventarioSaldoData>>
  _inventarioSaldoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventarioSaldo,
    aliasName: 'producto__id__inventario_saldo__producto_id',
  );

  $InventarioSaldoProcessedTableManager get inventarioSaldoRefs {
    final manager = $InventarioSaldoTableManager(
      $_db,
      $_db.inventarioSaldo,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inventarioSaldoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<DetalleCompra, List<DetalleCompraData>>
  _detalleCompraRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.detalleCompra,
    aliasName: 'producto__id__detalle_compra__producto_id',
  );

  $DetalleCompraProcessedTableManager get detalleCompraRefs {
    final manager = $DetalleCompraTableManager(
      $_db,
      $_db.detalleCompra,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_detalleCompraRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<DetalleVenta, List<DetalleVentaData>>
  _detalleVentaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.detalleVenta,
    aliasName: 'producto__id__detalle_venta__producto_id',
  );

  $DetalleVentaProcessedTableManager get detalleVentaRefs {
    final manager = $DetalleVentaTableManager(
      $_db,
      $_db.detalleVenta,
    ).filter((f) => f.productoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_detalleVentaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $ProductoFilterComposer extends Composer<_$AppDatabase, Producto> {
  $ProductoFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigoInterno => $composableBuilder(
    column: $table.codigoInterno,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get precioVentaCentavos => $composableBuilder(
    column: $table.precioVentaCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoReferenciaCentavos => $composableBuilder(
    column: $table.costoReferenciaCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $CategoriaFilterComposer get categoriaId {
    final $CategoriaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categoria,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriaFilterComposer(
            $db: $db,
            $table: $db.categoria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseFilterComposer get tipoEnvaseId {
    final $TipoEnvaseFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseFilterComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movimientoInventarioRefs(
    Expression<bool> Function($MovimientoInventarioFilterComposer f) f,
  ) {
    final $MovimientoInventarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientoInventario,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoInventarioFilterComposer(
            $db: $db,
            $table: $db.movimientoInventario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inventarioSaldoRefs(
    Expression<bool> Function($InventarioSaldoFilterComposer f) f,
  ) {
    final $InventarioSaldoFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarioSaldo,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $InventarioSaldoFilterComposer(
            $db: $db,
            $table: $db.inventarioSaldo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> detalleCompraRefs(
    Expression<bool> Function($DetalleCompraFilterComposer f) f,
  ) {
    final $DetalleCompraFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detalleCompra,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DetalleCompraFilterComposer(
            $db: $db,
            $table: $db.detalleCompra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> detalleVentaRefs(
    Expression<bool> Function($DetalleVentaFilterComposer f) f,
  ) {
    final $DetalleVentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detalleVenta,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DetalleVentaFilterComposer(
            $db: $db,
            $table: $db.detalleVenta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ProductoOrderingComposer extends Composer<_$AppDatabase, Producto> {
  $ProductoOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigoInterno => $composableBuilder(
    column: $table.codigoInterno,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get precioVentaCentavos => $composableBuilder(
    column: $table.precioVentaCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoReferenciaCentavos => $composableBuilder(
    column: $table.costoReferenciaCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $CategoriaOrderingComposer get categoriaId {
    final $CategoriaOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categoria,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriaOrderingComposer(
            $db: $db,
            $table: $db.categoria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseOrderingComposer get tipoEnvaseId {
    final $TipoEnvaseOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseOrderingComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $ProductoAnnotationComposer extends Composer<_$AppDatabase, Producto> {
  $ProductoAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get codigoBarras => $composableBuilder(
    column: $table.codigoBarras,
    builder: (column) => column,
  );

  GeneratedColumn<String> get codigoInterno => $composableBuilder(
    column: $table.codigoInterno,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<int> get precioVentaCentavos => $composableBuilder(
    column: $table.precioVentaCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoReferenciaCentavos => $composableBuilder(
    column: $table.costoReferenciaCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<String> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  $CategoriaAnnotationComposer get categoriaId {
    final $CategoriaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categoria,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriaAnnotationComposer(
            $db: $db,
            $table: $db.categoria,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseAnnotationComposer get tipoEnvaseId {
    final $TipoEnvaseAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseAnnotationComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movimientoInventarioRefs<T extends Object>(
    Expression<T> Function($MovimientoInventarioAnnotationComposer a) f,
  ) {
    final $MovimientoInventarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientoInventario,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoInventarioAnnotationComposer(
            $db: $db,
            $table: $db.movimientoInventario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inventarioSaldoRefs<T extends Object>(
    Expression<T> Function($InventarioSaldoAnnotationComposer a) f,
  ) {
    final $InventarioSaldoAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventarioSaldo,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $InventarioSaldoAnnotationComposer(
            $db: $db,
            $table: $db.inventarioSaldo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> detalleCompraRefs<T extends Object>(
    Expression<T> Function($DetalleCompraAnnotationComposer a) f,
  ) {
    final $DetalleCompraAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detalleCompra,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DetalleCompraAnnotationComposer(
            $db: $db,
            $table: $db.detalleCompra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> detalleVentaRefs<T extends Object>(
    Expression<T> Function($DetalleVentaAnnotationComposer a) f,
  ) {
    final $DetalleVentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detalleVenta,
      getReferencedColumn: (t) => t.productoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DetalleVentaAnnotationComposer(
            $db: $db,
            $table: $db.detalleVenta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ProductoTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Producto,
          ProductoData,
          $ProductoFilterComposer,
          $ProductoOrderingComposer,
          $ProductoAnnotationComposer,
          $ProductoCreateCompanionBuilder,
          $ProductoUpdateCompanionBuilder,
          (ProductoData, $ProductoReferences),
          ProductoData,
          PrefetchHooks Function({
            bool categoriaId,
            bool tipoEnvaseId,
            bool movimientoInventarioRefs,
            bool inventarioSaldoRefs,
            bool detalleCompraRefs,
            bool detalleVentaRefs,
          })
        > {
  $ProductoTableManager(_$AppDatabase db, Producto table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ProductoFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ProductoOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ProductoAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<int?> tipoEnvaseId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> codigoBarras = const Value.absent(),
                Value<String> codigoInterno = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<int> precioVentaCentavos = const Value.absent(),
                Value<int?> costoReferenciaCentavos = const Value.absent(),
                Value<int> activo = const Value.absent(),
                Value<String> creadoEn = const Value.absent(),
              }) => ProductoCompanion(
                id: id,
                categoriaId: categoriaId,
                tipoEnvaseId: tipoEnvaseId,
                nombre: nombre,
                codigoBarras: codigoBarras,
                codigoInterno: codigoInterno,
                unidad: unidad,
                precioVentaCentavos: precioVentaCentavos,
                costoReferenciaCentavos: costoReferenciaCentavos,
                activo: activo,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<int?> tipoEnvaseId = const Value.absent(),
                required String nombre,
                Value<String?> codigoBarras = const Value.absent(),
                required String codigoInterno,
                required String unidad,
                required int precioVentaCentavos,
                Value<int?> costoReferenciaCentavos = const Value.absent(),
                Value<int> activo = const Value.absent(),
                Value<String> creadoEn = const Value.absent(),
              }) => ProductoCompanion.insert(
                id: id,
                categoriaId: categoriaId,
                tipoEnvaseId: tipoEnvaseId,
                nombre: nombre,
                codigoBarras: codigoBarras,
                codigoInterno: codigoInterno,
                unidad: unidad,
                precioVentaCentavos: precioVentaCentavos,
                costoReferenciaCentavos: costoReferenciaCentavos,
                activo: activo,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Producto, ProductoData>(table),
                  $ProductoReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoriaId = false,
                tipoEnvaseId = false,
                movimientoInventarioRefs = false,
                inventarioSaldoRefs = false,
                detalleCompraRefs = false,
                detalleVentaRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientoInventarioRefs) db.movimientoInventario,
                    if (inventarioSaldoRefs) db.inventarioSaldo,
                    if (detalleCompraRefs) db.detalleCompra,
                    if (detalleVentaRefs) db.detalleVenta,
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
                        if (categoriaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoriaId,
                            referencedTable: $ProductoReferences
                                ._categoriaIdTable(db),
                            referencedColumn: $ProductoReferences
                                ._categoriaIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (tipoEnvaseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.tipoEnvaseId,
                            referencedTable: $ProductoReferences
                                ._tipoEnvaseIdTable(db),
                            referencedColumn: $ProductoReferences
                                ._tipoEnvaseIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientoInventarioRefs)
                        await $_getPrefetchedData<
                          ProductoData,
                          Producto,
                          MovimientoInventarioData
                        >(
                          currentTable: table,
                          referencedTable: $ProductoReferences
                              ._movimientoInventarioRefsTable(db),
                          managerFromTypedResult: (p0) => $ProductoReferences(
                            db,
                            table,
                            p0,
                          ).movimientoInventarioRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inventarioSaldoRefs)
                        await $_getPrefetchedData<
                          ProductoData,
                          Producto,
                          InventarioSaldoData
                        >(
                          currentTable: table,
                          referencedTable: $ProductoReferences
                              ._inventarioSaldoRefsTable(db),
                          managerFromTypedResult: (p0) => $ProductoReferences(
                            db,
                            table,
                            p0,
                          ).inventarioSaldoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (detalleCompraRefs)
                        await $_getPrefetchedData<
                          ProductoData,
                          Producto,
                          DetalleCompraData
                        >(
                          currentTable: table,
                          referencedTable: $ProductoReferences
                              ._detalleCompraRefsTable(db),
                          managerFromTypedResult: (p0) => $ProductoReferences(
                            db,
                            table,
                            p0,
                          ).detalleCompraRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (detalleVentaRefs)
                        await $_getPrefetchedData<
                          ProductoData,
                          Producto,
                          DetalleVentaData
                        >(
                          currentTable: table,
                          referencedTable: $ProductoReferences
                              ._detalleVentaRefsTable(db),
                          managerFromTypedResult: (p0) => $ProductoReferences(
                            db,
                            table,
                            p0,
                          ).detalleVentaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productoId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $ProductoProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Producto,
      ProductoData,
      $ProductoFilterComposer,
      $ProductoOrderingComposer,
      $ProductoAnnotationComposer,
      $ProductoCreateCompanionBuilder,
      $ProductoUpdateCompanionBuilder,
      (ProductoData, $ProductoReferences),
      ProductoData,
      PrefetchHooks Function({
        bool categoriaId,
        bool tipoEnvaseId,
        bool movimientoInventarioRefs,
        bool inventarioSaldoRefs,
        bool detalleCompraRefs,
        bool detalleVentaRefs,
      })
    >;
typedef $MovimientoInventarioCreateCompanionBuilder =
    MovimientoInventarioCompanion Function({
      Value<int> id,
      required int productoId,
      required String tipo,
      required int cantidad,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      required int usuarioId,
      Value<String> fecha,
    });
typedef $MovimientoInventarioUpdateCompanionBuilder =
    MovimientoInventarioCompanion Function({
      Value<int> id,
      Value<int> productoId,
      Value<String> tipo,
      Value<int> cantidad,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      Value<int> usuarioId,
      Value<String> fecha,
    });

final class $MovimientoInventarioReferences
    extends
        BaseReferences<
          _$AppDatabase,
          MovimientoInventario,
          MovimientoInventarioData
        > {
  $MovimientoInventarioReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static Producto _productoIdTable(_$AppDatabase db) => db.producto.createAlias(
    'movimiento_inventario__producto_id__producto__id',
  );

  $ProductoProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $ProductoTableManager(
      $_db,
      $_db.producto,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MovimientoInventario _reversaDeIdTable(_$AppDatabase db) =>
      db.movimientoInventario.createAlias(
        'movimiento_inventario__reversa_de_id__movimiento_inventario__id',
      );

  $MovimientoInventarioProcessedTableManager? get reversaDeId {
    final $_column = $_itemColumn<int>('reversa_de_id');
    if ($_column == null) return null;
    final manager = $MovimientoInventarioTableManager(
      $_db,
      $_db.movimientoInventario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversaDeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('movimiento_inventario__usuario_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $MovimientoInventarioFilterComposer
    extends Composer<_$AppDatabase, MovimientoInventario> {
  $MovimientoInventarioFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $ProductoFilterComposer get productoId {
    final $ProductoFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoFilterComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MovimientoInventarioFilterComposer get reversaDeId {
    final $MovimientoInventarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.movimientoInventario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoInventarioFilterComposer(
            $db: $db,
            $table: $db.movimientoInventario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MovimientoInventarioOrderingComposer
    extends Composer<_$AppDatabase, MovimientoInventario> {
  $MovimientoInventarioOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $ProductoOrderingComposer get productoId {
    final $ProductoOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoOrderingComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MovimientoInventarioOrderingComposer get reversaDeId {
    final $MovimientoInventarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.movimientoInventario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoInventarioOrderingComposer(
            $db: $db,
            $table: $db.movimientoInventario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MovimientoInventarioAnnotationComposer
    extends Composer<_$AppDatabase, MovimientoInventario> {
  $MovimientoInventarioAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $ProductoAnnotationComposer get productoId {
    final $ProductoAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoAnnotationComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MovimientoInventarioAnnotationComposer get reversaDeId {
    final $MovimientoInventarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.movimientoInventario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoInventarioAnnotationComposer(
            $db: $db,
            $table: $db.movimientoInventario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MovimientoInventarioTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          MovimientoInventario,
          MovimientoInventarioData,
          $MovimientoInventarioFilterComposer,
          $MovimientoInventarioOrderingComposer,
          $MovimientoInventarioAnnotationComposer,
          $MovimientoInventarioCreateCompanionBuilder,
          $MovimientoInventarioUpdateCompanionBuilder,
          (MovimientoInventarioData, $MovimientoInventarioReferences),
          MovimientoInventarioData,
          PrefetchHooks Function({
            bool productoId,
            bool reversaDeId,
            bool usuarioId,
          })
        > {
  $MovimientoInventarioTableManager(
    _$AppDatabase db,
    MovimientoInventario table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MovimientoInventarioFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MovimientoInventarioOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MovimientoInventarioAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => MovimientoInventarioCompanion(
                id: id,
                productoId: productoId,
                tipo: tipo,
                cantidad: cantidad,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productoId,
                required String tipo,
                required int cantidad,
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
              }) => MovimientoInventarioCompanion.insert(
                id: id,
                productoId: productoId,
                tipo: tipo,
                cantidad: cantidad,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<MovimientoInventario, MovimientoInventarioData>(
                    table,
                  ),
                  $MovimientoInventarioReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productoId = false, reversaDeId = false, usuarioId = false}) {
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
                        if (productoId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.productoId,
                            referencedTable: $MovimientoInventarioReferences
                                ._productoIdTable(db),
                            referencedColumn: $MovimientoInventarioReferences
                                ._productoIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (reversaDeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reversaDeId,
                            referencedTable: $MovimientoInventarioReferences
                                ._reversaDeIdTable(db),
                            referencedColumn: $MovimientoInventarioReferences
                                ._reversaDeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioId,
                            referencedTable: $MovimientoInventarioReferences
                                ._usuarioIdTable(db),
                            referencedColumn: $MovimientoInventarioReferences
                                ._usuarioIdTable(db)
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

typedef $MovimientoInventarioProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      MovimientoInventario,
      MovimientoInventarioData,
      $MovimientoInventarioFilterComposer,
      $MovimientoInventarioOrderingComposer,
      $MovimientoInventarioAnnotationComposer,
      $MovimientoInventarioCreateCompanionBuilder,
      $MovimientoInventarioUpdateCompanionBuilder,
      (MovimientoInventarioData, $MovimientoInventarioReferences),
      MovimientoInventarioData,
      PrefetchHooks Function({
        bool productoId,
        bool reversaDeId,
        bool usuarioId,
      })
    >;
typedef $InventarioSaldoCreateCompanionBuilder =
    InventarioSaldoCompanion Function({
      Value<int> productoId,
      required int cantidadActual,
      Value<String> actualizadoEn,
    });
typedef $InventarioSaldoUpdateCompanionBuilder =
    InventarioSaldoCompanion Function({
      Value<int> productoId,
      Value<int> cantidadActual,
      Value<String> actualizadoEn,
    });

final class $InventarioSaldoReferences
    extends
        BaseReferences<_$AppDatabase, InventarioSaldo, InventarioSaldoData> {
  $InventarioSaldoReferences(super.$_db, super.$_table, super.$_typedResult);

  static Producto _productoIdTable(_$AppDatabase db) =>
      db.producto.createAlias('inventario_saldo__producto_id__producto__id');

  $ProductoProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $ProductoTableManager(
      $_db,
      $_db.producto,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $InventarioSaldoFilterComposer
    extends Composer<_$AppDatabase, InventarioSaldo> {
  $InventarioSaldoFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $ProductoFilterComposer get productoId {
    final $ProductoFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoFilterComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $InventarioSaldoOrderingComposer
    extends Composer<_$AppDatabase, InventarioSaldo> {
  $InventarioSaldoOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $ProductoOrderingComposer get productoId {
    final $ProductoOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoOrderingComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $InventarioSaldoAnnotationComposer
    extends Composer<_$AppDatabase, InventarioSaldo> {
  $InventarioSaldoAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get cantidadActual => $composableBuilder(
    column: $table.cantidadActual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actualizadoEn => $composableBuilder(
    column: $table.actualizadoEn,
    builder: (column) => column,
  );

  $ProductoAnnotationComposer get productoId {
    final $ProductoAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoAnnotationComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $InventarioSaldoTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          InventarioSaldo,
          InventarioSaldoData,
          $InventarioSaldoFilterComposer,
          $InventarioSaldoOrderingComposer,
          $InventarioSaldoAnnotationComposer,
          $InventarioSaldoCreateCompanionBuilder,
          $InventarioSaldoUpdateCompanionBuilder,
          (InventarioSaldoData, $InventarioSaldoReferences),
          InventarioSaldoData,
          PrefetchHooks Function({bool productoId})
        > {
  $InventarioSaldoTableManager(_$AppDatabase db, InventarioSaldo table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $InventarioSaldoFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $InventarioSaldoOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $InventarioSaldoAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> productoId = const Value.absent(),
                Value<int> cantidadActual = const Value.absent(),
                Value<String> actualizadoEn = const Value.absent(),
              }) => InventarioSaldoCompanion(
                productoId: productoId,
                cantidadActual: cantidadActual,
                actualizadoEn: actualizadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> productoId = const Value.absent(),
                required int cantidadActual,
                Value<String> actualizadoEn = const Value.absent(),
              }) => InventarioSaldoCompanion.insert(
                productoId: productoId,
                cantidadActual: cantidadActual,
                actualizadoEn: actualizadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<InventarioSaldo, InventarioSaldoData>(table),
                  $InventarioSaldoReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productoId = false}) {
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
                    if (productoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.productoId,
                        referencedTable: $InventarioSaldoReferences
                            ._productoIdTable(db),
                        referencedColumn: $InventarioSaldoReferences
                            ._productoIdTable(db)
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

typedef $InventarioSaldoProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      InventarioSaldo,
      InventarioSaldoData,
      $InventarioSaldoFilterComposer,
      $InventarioSaldoOrderingComposer,
      $InventarioSaldoAnnotationComposer,
      $InventarioSaldoCreateCompanionBuilder,
      $InventarioSaldoUpdateCompanionBuilder,
      (InventarioSaldoData, $InventarioSaldoReferences),
      InventarioSaldoData,
      PrefetchHooks Function({bool productoId})
    >;
typedef $SaldoGuardCreateCompanionBuilder = SaldoGuardCompanion Function({
  required int activo,
  Value<int> rowid,
});
typedef $SaldoGuardUpdateCompanionBuilder = SaldoGuardCompanion Function({
  Value<int> activo,
  Value<int> rowid,
});

class $SaldoGuardFilterComposer extends Composer<_$AppDatabase, SaldoGuard> {
  $SaldoGuardFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );
}

class $SaldoGuardOrderingComposer extends Composer<_$AppDatabase, SaldoGuard> {
  $SaldoGuardOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SaldoGuardAnnotationComposer
    extends Composer<_$AppDatabase, SaldoGuard> {
  $SaldoGuardAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);
}

class $SaldoGuardTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SaldoGuard,
          SaldoGuardData,
          $SaldoGuardFilterComposer,
          $SaldoGuardOrderingComposer,
          $SaldoGuardAnnotationComposer,
          $SaldoGuardCreateCompanionBuilder,
          $SaldoGuardUpdateCompanionBuilder,
          (
            SaldoGuardData,
            BaseReferences<_$AppDatabase, SaldoGuard, SaldoGuardData>,
          ),
          SaldoGuardData,
          PrefetchHooks Function()
        > {
  $SaldoGuardTableManager(_$AppDatabase db, SaldoGuard table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SaldoGuardFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SaldoGuardOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SaldoGuardAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> activo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SaldoGuardCompanion(activo: activo, rowid: rowid),
          createCompanionCallback: ({
            required int activo,
            Value<int> rowid = const Value.absent(),
          }) => SaldoGuardCompanion.insert(activo: activo, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<SaldoGuard, SaldoGuardData>(table),
                  BaseReferences<_$AppDatabase, SaldoGuard, SaldoGuardData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $SaldoGuardProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SaldoGuard,
      SaldoGuardData,
      $SaldoGuardFilterComposer,
      $SaldoGuardOrderingComposer,
      $SaldoGuardAnnotationComposer,
      $SaldoGuardCreateCompanionBuilder,
      $SaldoGuardUpdateCompanionBuilder,
      (
        SaldoGuardData,
        BaseReferences<_$AppDatabase, SaldoGuard, SaldoGuardData>,
      ),
      SaldoGuardData,
      PrefetchHooks Function()
    >;
typedef $ProveedorCreateCompanionBuilder = ProveedorCompanion Function({
  Value<int> id,
  required String nombre,
});
typedef $ProveedorUpdateCompanionBuilder = ProveedorCompanion Function({
  Value<int> id,
  Value<String> nombre,
});

final class $ProveedorReferences
    extends BaseReferences<_$AppDatabase, Proveedor, ProveedorData> {
  $ProveedorReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Compra, List<CompraData>> _compraRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.compra,
    aliasName: 'proveedor__id__compra__proveedor_id',
  );

  $CompraProcessedTableManager get compraRefs {
    final manager = $CompraTableManager(
      $_db,
      $_db.compra,
    ).filter((f) => f.proveedorId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_compraRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $ProveedorFilterComposer extends Composer<_$AppDatabase, Proveedor> {
  $ProveedorFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> compraRefs(
    Expression<bool> Function($CompraFilterComposer f) f,
  ) {
    final $CompraFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraFilterComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ProveedorOrderingComposer extends Composer<_$AppDatabase, Proveedor> {
  $ProveedorOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ProveedorAnnotationComposer extends Composer<_$AppDatabase, Proveedor> {
  $ProveedorAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  Expression<T> compraRefs<T extends Object>(
    Expression<T> Function($CompraAnnotationComposer a) f,
  ) {
    final $CompraAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.proveedorId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraAnnotationComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ProveedorTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Proveedor,
          ProveedorData,
          $ProveedorFilterComposer,
          $ProveedorOrderingComposer,
          $ProveedorAnnotationComposer,
          $ProveedorCreateCompanionBuilder,
          $ProveedorUpdateCompanionBuilder,
          (ProveedorData, $ProveedorReferences),
          ProveedorData,
          PrefetchHooks Function({bool compraRefs})
        > {
  $ProveedorTableManager(_$AppDatabase db, Proveedor table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ProveedorFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ProveedorOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ProveedorAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nombre = const Value.absent(),
          }) => ProveedorCompanion(id: id, nombre: nombre),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nombre,
          }) => ProveedorCompanion.insert(id: id, nombre: nombre),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Proveedor, ProveedorData>(table),
                  $ProveedorReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({compraRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (compraRefs) db.compra],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (compraRefs)
                    await $_getPrefetchedData<
                      ProveedorData,
                      Proveedor,
                      CompraData
                    >(
                      currentTable: table,
                      referencedTable: $ProveedorReferences._compraRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $ProveedorReferences(db, table, p0).compraRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.proveedorId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $ProveedorProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Proveedor,
      ProveedorData,
      $ProveedorFilterComposer,
      $ProveedorOrderingComposer,
      $ProveedorAnnotationComposer,
      $ProveedorCreateCompanionBuilder,
      $ProveedorUpdateCompanionBuilder,
      (ProveedorData, $ProveedorReferences),
      ProveedorData,
      PrefetchHooks Function({bool compraRefs})
    >;
typedef $CompraCreateCompanionBuilder = CompraCompanion Function({
  Value<int> id,
  required int terminalId,
  Value<int?> cajaSesionId,
  required String folio,
  required int proveedorId,
  required int usuarioId,
  Value<String> fecha,
  Value<int> totalCentavos,
  Value<String> estado,
});
typedef $CompraUpdateCompanionBuilder = CompraCompanion Function({
  Value<int> id,
  Value<int> terminalId,
  Value<int?> cajaSesionId,
  Value<String> folio,
  Value<int> proveedorId,
  Value<int> usuarioId,
  Value<String> fecha,
  Value<int> totalCentavos,
  Value<String> estado,
});

final class $CompraReferences
    extends BaseReferences<_$AppDatabase, Compra, CompraData> {
  $CompraReferences(super.$_db, super.$_table, super.$_typedResult);

  static Terminal _terminalIdTable(_$AppDatabase db) =>
      db.terminal.createAlias('compra__terminal_id__terminal__id');

  $TerminalProcessedTableManager get terminalId {
    final $_column = $_itemColumn<int>('terminal_id')!;

    final manager = $TerminalTableManager(
      $_db,
      $_db.terminal,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_terminalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static CajaSesion _cajaSesionIdTable(_$AppDatabase db) =>
      db.cajaSesion.createAlias('compra__caja_sesion_id__caja_sesion__id');

  $CajaSesionProcessedTableManager? get cajaSesionId {
    final $_column = $_itemColumn<int>('caja_sesion_id');
    if ($_column == null) return null;
    final manager = $CajaSesionTableManager(
      $_db,
      $_db.cajaSesion,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cajaSesionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Proveedor _proveedorIdTable(_$AppDatabase db) =>
      db.proveedor.createAlias('compra__proveedor_id__proveedor__id');

  $ProveedorProcessedTableManager get proveedorId {
    final $_column = $_itemColumn<int>('proveedor_id')!;

    final manager = $ProveedorTableManager(
      $_db,
      $_db.proveedor,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_proveedorIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('compra__usuario_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<DetalleCompra, List<DetalleCompraData>>
  _detalleCompraRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.detalleCompra,
    aliasName: 'compra__id__detalle_compra__compra_id',
  );

  $DetalleCompraProcessedTableManager get detalleCompraRefs {
    final manager = $DetalleCompraTableManager(
      $_db,
      $_db.detalleCompra,
    ).filter((f) => f.compraId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_detalleCompraRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $CompraFilterComposer extends Composer<_$AppDatabase, Compra> {
  $CompraFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  $TerminalFilterComposer get terminalId {
    final $TerminalFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalFilterComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CajaSesionFilterComposer get cajaSesionId {
    final $CajaSesionFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cajaSesionId,
      referencedTable: $db.cajaSesion,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CajaSesionFilterComposer(
            $db: $db,
            $table: $db.cajaSesion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProveedorFilterComposer get proveedorId {
    final $ProveedorFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedor,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProveedorFilterComposer(
            $db: $db,
            $table: $db.proveedor,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> detalleCompraRefs(
    Expression<bool> Function($DetalleCompraFilterComposer f) f,
  ) {
    final $DetalleCompraFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detalleCompra,
      getReferencedColumn: (t) => t.compraId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DetalleCompraFilterComposer(
            $db: $db,
            $table: $db.detalleCompra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CompraOrderingComposer extends Composer<_$AppDatabase, Compra> {
  $CompraOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  $TerminalOrderingComposer get terminalId {
    final $TerminalOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalOrderingComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CajaSesionOrderingComposer get cajaSesionId {
    final $CajaSesionOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cajaSesionId,
      referencedTable: $db.cajaSesion,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CajaSesionOrderingComposer(
            $db: $db,
            $table: $db.cajaSesion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProveedorOrderingComposer get proveedorId {
    final $ProveedorOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedor,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProveedorOrderingComposer(
            $db: $db,
            $table: $db.proveedor,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CompraAnnotationComposer extends Composer<_$AppDatabase, Compra> {
  $CompraAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folio =>
      $composableBuilder(column: $table.folio, builder: (column) => column);

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  $TerminalAnnotationComposer get terminalId {
    final $TerminalAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalAnnotationComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CajaSesionAnnotationComposer get cajaSesionId {
    final $CajaSesionAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cajaSesionId,
      referencedTable: $db.cajaSesion,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CajaSesionAnnotationComposer(
            $db: $db,
            $table: $db.cajaSesion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProveedorAnnotationComposer get proveedorId {
    final $ProveedorAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.proveedorId,
      referencedTable: $db.proveedor,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProveedorAnnotationComposer(
            $db: $db,
            $table: $db.proveedor,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> detalleCompraRefs<T extends Object>(
    Expression<T> Function($DetalleCompraAnnotationComposer a) f,
  ) {
    final $DetalleCompraAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detalleCompra,
      getReferencedColumn: (t) => t.compraId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DetalleCompraAnnotationComposer(
            $db: $db,
            $table: $db.detalleCompra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CompraTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Compra,
          CompraData,
          $CompraFilterComposer,
          $CompraOrderingComposer,
          $CompraAnnotationComposer,
          $CompraCreateCompanionBuilder,
          $CompraUpdateCompanionBuilder,
          (CompraData, $CompraReferences),
          CompraData,
          PrefetchHooks Function({
            bool terminalId,
            bool cajaSesionId,
            bool proveedorId,
            bool usuarioId,
            bool detalleCompraRefs,
          })
        > {
  $CompraTableManager(_$AppDatabase db, Compra table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CompraFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CompraOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CompraAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> terminalId = const Value.absent(),
                Value<int?> cajaSesionId = const Value.absent(),
                Value<String> folio = const Value.absent(),
                Value<int> proveedorId = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
                Value<int> totalCentavos = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => CompraCompanion(
                id: id,
                terminalId: terminalId,
                cajaSesionId: cajaSesionId,
                folio: folio,
                proveedorId: proveedorId,
                usuarioId: usuarioId,
                fecha: fecha,
                totalCentavos: totalCentavos,
                estado: estado,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int terminalId,
                Value<int?> cajaSesionId = const Value.absent(),
                required String folio,
                required int proveedorId,
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
                Value<int> totalCentavos = const Value.absent(),
                Value<String> estado = const Value.absent(),
              }) => CompraCompanion.insert(
                id: id,
                terminalId: terminalId,
                cajaSesionId: cajaSesionId,
                folio: folio,
                proveedorId: proveedorId,
                usuarioId: usuarioId,
                fecha: fecha,
                totalCentavos: totalCentavos,
                estado: estado,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Compra, CompraData>(table),
                  $CompraReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                terminalId = false,
                cajaSesionId = false,
                proveedorId = false,
                usuarioId = false,
                detalleCompraRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (detalleCompraRefs) db.detalleCompra,
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
                        if (terminalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.terminalId,
                            referencedTable: $CompraReferences._terminalIdTable(
                              db,
                            ),
                            referencedColumn: $CompraReferences
                                ._terminalIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (cajaSesionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cajaSesionId,
                            referencedTable: $CompraReferences
                                ._cajaSesionIdTable(db),
                            referencedColumn: $CompraReferences
                                ._cajaSesionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (proveedorId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.proveedorId,
                            referencedTable: $CompraReferences
                                ._proveedorIdTable(db),
                            referencedColumn: $CompraReferences
                                ._proveedorIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioId,
                            referencedTable: $CompraReferences._usuarioIdTable(
                              db,
                            ),
                            referencedColumn: $CompraReferences
                                ._usuarioIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (detalleCompraRefs)
                        await $_getPrefetchedData<
                          CompraData,
                          Compra,
                          DetalleCompraData
                        >(
                          currentTable: table,
                          referencedTable: $CompraReferences
                              ._detalleCompraRefsTable(db),
                          managerFromTypedResult: (p0) => $CompraReferences(
                            db,
                            table,
                            p0,
                          ).detalleCompraRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.compraId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $CompraProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Compra,
      CompraData,
      $CompraFilterComposer,
      $CompraOrderingComposer,
      $CompraAnnotationComposer,
      $CompraCreateCompanionBuilder,
      $CompraUpdateCompanionBuilder,
      (CompraData, $CompraReferences),
      CompraData,
      PrefetchHooks Function({
        bool terminalId,
        bool cajaSesionId,
        bool proveedorId,
        bool usuarioId,
        bool detalleCompraRefs,
      })
    >;
typedef $DetalleCompraCreateCompanionBuilder = DetalleCompraCompanion Function({
  Value<int> id,
  required int compraId,
  required int productoId,
  required int cantidad,
  required int costoUnitarioCentavos,
  required int subtotalCentavos,
});
typedef $DetalleCompraUpdateCompanionBuilder = DetalleCompraCompanion Function({
  Value<int> id,
  Value<int> compraId,
  Value<int> productoId,
  Value<int> cantidad,
  Value<int> costoUnitarioCentavos,
  Value<int> subtotalCentavos,
});

final class $DetalleCompraReferences
    extends BaseReferences<_$AppDatabase, DetalleCompra, DetalleCompraData> {
  $DetalleCompraReferences(super.$_db, super.$_table, super.$_typedResult);

  static Compra _compraIdTable(_$AppDatabase db) =>
      db.compra.createAlias('detalle_compra__compra_id__compra__id');

  $CompraProcessedTableManager get compraId {
    final $_column = $_itemColumn<int>('compra_id')!;

    final manager = $CompraTableManager(
      $_db,
      $_db.compra,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_compraIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Producto _productoIdTable(_$AppDatabase db) =>
      db.producto.createAlias('detalle_compra__producto_id__producto__id');

  $ProductoProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $ProductoTableManager(
      $_db,
      $_db.producto,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $DetalleCompraFilterComposer
    extends Composer<_$AppDatabase, DetalleCompra> {
  $DetalleCompraFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoUnitarioCentavos => $composableBuilder(
    column: $table.costoUnitarioCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $CompraFilterComposer get compraId {
    final $CompraFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compraId,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraFilterComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProductoFilterComposer get productoId {
    final $ProductoFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoFilterComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DetalleCompraOrderingComposer
    extends Composer<_$AppDatabase, DetalleCompra> {
  $DetalleCompraOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoUnitarioCentavos => $composableBuilder(
    column: $table.costoUnitarioCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $CompraOrderingComposer get compraId {
    final $CompraOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compraId,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraOrderingComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProductoOrderingComposer get productoId {
    final $ProductoOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoOrderingComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DetalleCompraAnnotationComposer
    extends Composer<_$AppDatabase, DetalleCompra> {
  $DetalleCompraAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<int> get costoUnitarioCentavos => $composableBuilder(
    column: $table.costoUnitarioCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => column,
  );

  $CompraAnnotationComposer get compraId {
    final $CompraAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.compraId,
      referencedTable: $db.compra,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CompraAnnotationComposer(
            $db: $db,
            $table: $db.compra,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProductoAnnotationComposer get productoId {
    final $ProductoAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoAnnotationComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DetalleCompraTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DetalleCompra,
          DetalleCompraData,
          $DetalleCompraFilterComposer,
          $DetalleCompraOrderingComposer,
          $DetalleCompraAnnotationComposer,
          $DetalleCompraCreateCompanionBuilder,
          $DetalleCompraUpdateCompanionBuilder,
          (DetalleCompraData, $DetalleCompraReferences),
          DetalleCompraData,
          PrefetchHooks Function({bool compraId, bool productoId})
        > {
  $DetalleCompraTableManager(_$AppDatabase db, DetalleCompra table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DetalleCompraFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DetalleCompraOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DetalleCompraAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> compraId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int> costoUnitarioCentavos = const Value.absent(),
                Value<int> subtotalCentavos = const Value.absent(),
              }) => DetalleCompraCompanion(
                id: id,
                compraId: compraId,
                productoId: productoId,
                cantidad: cantidad,
                costoUnitarioCentavos: costoUnitarioCentavos,
                subtotalCentavos: subtotalCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int compraId,
                required int productoId,
                required int cantidad,
                required int costoUnitarioCentavos,
                required int subtotalCentavos,
              }) => DetalleCompraCompanion.insert(
                id: id,
                compraId: compraId,
                productoId: productoId,
                cantidad: cantidad,
                costoUnitarioCentavos: costoUnitarioCentavos,
                subtotalCentavos: subtotalCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DetalleCompra, DetalleCompraData>(table),
                  $DetalleCompraReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({compraId = false, productoId = false}) {
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
                    if (compraId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.compraId,
                        referencedTable: $DetalleCompraReferences
                            ._compraIdTable(db),
                        referencedColumn: $DetalleCompraReferences
                            ._compraIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (productoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.productoId,
                        referencedTable: $DetalleCompraReferences
                            ._productoIdTable(db),
                        referencedColumn: $DetalleCompraReferences
                            ._productoIdTable(db)
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

typedef $DetalleCompraProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DetalleCompra,
      DetalleCompraData,
      $DetalleCompraFilterComposer,
      $DetalleCompraOrderingComposer,
      $DetalleCompraAnnotationComposer,
      $DetalleCompraCreateCompanionBuilder,
      $DetalleCompraUpdateCompanionBuilder,
      (DetalleCompraData, $DetalleCompraReferences),
      DetalleCompraData,
      PrefetchHooks Function({bool compraId, bool productoId})
    >;
typedef $ClienteCreateCompanionBuilder = ClienteCompanion Function({
  Value<int> id,
  required String nombre,
  Value<String?> telefono,
  Value<int?> umbralAdvertenciaCentavos,
  Value<int> activo,
  Value<String> creadoEn,
});
typedef $ClienteUpdateCompanionBuilder = ClienteCompanion Function({
  Value<int> id,
  Value<String> nombre,
  Value<String?> telefono,
  Value<int?> umbralAdvertenciaCentavos,
  Value<int> activo,
  Value<String> creadoEn,
});

final class $ClienteReferences
    extends BaseReferences<_$AppDatabase, Cliente, ClienteData> {
  $ClienteReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Venta, List<VentaData>> _ventaRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.venta,
    aliasName: 'cliente__id__venta__cliente_id',
  );

  $VentaProcessedTableManager get ventaRefs {
    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ventaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CuentaMonetariaMov, List<CuentaMonetariaMovData>>
  _cuentaMonetariaMovRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cuentaMonetariaMov,
        aliasName: 'cliente__id__cuenta_monetaria_mov__cliente_id',
      );

  $CuentaMonetariaMovProcessedTableManager get cuentaMonetariaMovRefs {
    final manager = $CuentaMonetariaMovTableManager(
      $_db,
      $_db.cuentaMonetariaMov,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaMonetariaMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CuentaEnvaseMov, List<CuentaEnvaseMovData>>
  _cuentaEnvaseMovRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cuentaEnvaseMov,
    aliasName: 'cliente__id__cuenta_envase_mov__cliente_id',
  );

  $CuentaEnvaseMovProcessedTableManager get cuentaEnvaseMovRefs {
    final manager = $CuentaEnvaseMovTableManager(
      $_db,
      $_db.cuentaEnvaseMov,
    ).filter((f) => f.clienteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaEnvaseMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $ClienteFilterComposer extends Composer<_$AppDatabase, Cliente> {
  $ClienteFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get umbralAdvertenciaCentavos => $composableBuilder(
    column: $table.umbralAdvertenciaCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ventaRefs(
    Expression<bool> Function($VentaFilterComposer f) f,
  ) {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaMonetariaMovRefs(
    Expression<bool> Function($CuentaMonetariaMovFilterComposer f) f,
  ) {
    final $CuentaMonetariaMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovFilterComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaEnvaseMovRefs(
    Expression<bool> Function($CuentaEnvaseMovFilterComposer f) f,
  ) {
    final $CuentaEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ClienteOrderingComposer extends Composer<_$AppDatabase, Cliente> {
  $ClienteOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get umbralAdvertenciaCentavos => $composableBuilder(
    column: $table.umbralAdvertenciaCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $ClienteAnnotationComposer extends Composer<_$AppDatabase, Cliente> {
  $ClienteAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<int> get umbralAdvertenciaCentavos => $composableBuilder(
    column: $table.umbralAdvertenciaCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<String> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  Expression<T> ventaRefs<T extends Object>(
    Expression<T> Function($VentaAnnotationComposer a) f,
  ) {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaMonetariaMovRefs<T extends Object>(
    Expression<T> Function($CuentaMonetariaMovAnnotationComposer a) f,
  ) {
    final $CuentaMonetariaMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaEnvaseMovRefs<T extends Object>(
    Expression<T> Function($CuentaEnvaseMovAnnotationComposer a) f,
  ) {
    final $CuentaEnvaseMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.clienteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $ClienteTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Cliente,
          ClienteData,
          $ClienteFilterComposer,
          $ClienteOrderingComposer,
          $ClienteAnnotationComposer,
          $ClienteCreateCompanionBuilder,
          $ClienteUpdateCompanionBuilder,
          (ClienteData, $ClienteReferences),
          ClienteData,
          PrefetchHooks Function({
            bool ventaRefs,
            bool cuentaMonetariaMovRefs,
            bool cuentaEnvaseMovRefs,
          })
        > {
  $ClienteTableManager(_$AppDatabase db, Cliente table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ClienteFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ClienteOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ClienteAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<int?> umbralAdvertenciaCentavos = const Value.absent(),
                Value<int> activo = const Value.absent(),
                Value<String> creadoEn = const Value.absent(),
              }) => ClienteCompanion(
                id: id,
                nombre: nombre,
                telefono: telefono,
                umbralAdvertenciaCentavos: umbralAdvertenciaCentavos,
                activo: activo,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                Value<String?> telefono = const Value.absent(),
                Value<int?> umbralAdvertenciaCentavos = const Value.absent(),
                Value<int> activo = const Value.absent(),
                Value<String> creadoEn = const Value.absent(),
              }) => ClienteCompanion.insert(
                id: id,
                nombre: nombre,
                telefono: telefono,
                umbralAdvertenciaCentavos: umbralAdvertenciaCentavos,
                activo: activo,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Cliente, ClienteData>(table),
                  $ClienteReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ventaRefs = false,
                cuentaMonetariaMovRefs = false,
                cuentaEnvaseMovRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ventaRefs) db.venta,
                    if (cuentaMonetariaMovRefs) db.cuentaMonetariaMov,
                    if (cuentaEnvaseMovRefs) db.cuentaEnvaseMov,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ventaRefs)
                        await $_getPrefetchedData<
                          ClienteData,
                          Cliente,
                          VentaData
                        >(
                          currentTable: table,
                          referencedTable: $ClienteReferences._ventaRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $ClienteReferences(db, table, p0).ventaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaMonetariaMovRefs)
                        await $_getPrefetchedData<
                          ClienteData,
                          Cliente,
                          CuentaMonetariaMovData
                        >(
                          currentTable: table,
                          referencedTable: $ClienteReferences
                              ._cuentaMonetariaMovRefsTable(db),
                          managerFromTypedResult: (p0) => $ClienteReferences(
                            db,
                            table,
                            p0,
                          ).cuentaMonetariaMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaEnvaseMovRefs)
                        await $_getPrefetchedData<
                          ClienteData,
                          Cliente,
                          CuentaEnvaseMovData
                        >(
                          currentTable: table,
                          referencedTable: $ClienteReferences
                              ._cuentaEnvaseMovRefsTable(db),
                          managerFromTypedResult: (p0) => $ClienteReferences(
                            db,
                            table,
                            p0,
                          ).cuentaEnvaseMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clienteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $ClienteProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Cliente,
      ClienteData,
      $ClienteFilterComposer,
      $ClienteOrderingComposer,
      $ClienteAnnotationComposer,
      $ClienteCreateCompanionBuilder,
      $ClienteUpdateCompanionBuilder,
      (ClienteData, $ClienteReferences),
      ClienteData,
      PrefetchHooks Function({
        bool ventaRefs,
        bool cuentaMonetariaMovRefs,
        bool cuentaEnvaseMovRefs,
      })
    >;
typedef $VentaCreateCompanionBuilder = VentaCompanion Function({
  Value<int> id,
  required int terminalId,
  required String folio,
  Value<int?> clienteId,
  required int usuarioId,
  Value<String> fecha,
  Value<String> estado,
  Value<int> subtotalCentavos,
  Value<int> totalCentavos,
});
typedef $VentaUpdateCompanionBuilder = VentaCompanion Function({
  Value<int> id,
  Value<int> terminalId,
  Value<String> folio,
  Value<int?> clienteId,
  Value<int> usuarioId,
  Value<String> fecha,
  Value<String> estado,
  Value<int> subtotalCentavos,
  Value<int> totalCentavos,
});

final class $VentaReferences
    extends BaseReferences<_$AppDatabase, Venta, VentaData> {
  $VentaReferences(super.$_db, super.$_table, super.$_typedResult);

  static Terminal _terminalIdTable(_$AppDatabase db) =>
      db.terminal.createAlias('venta__terminal_id__terminal__id');

  $TerminalProcessedTableManager get terminalId {
    final $_column = $_itemColumn<int>('terminal_id')!;

    final manager = $TerminalTableManager(
      $_db,
      $_db.terminal,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_terminalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Cliente _clienteIdTable(_$AppDatabase db) =>
      db.cliente.createAlias('venta__cliente_id__cliente__id');

  $ClienteProcessedTableManager? get clienteId {
    final $_column = $_itemColumn<int>('cliente_id');
    if ($_column == null) return null;
    final manager = $ClienteTableManager(
      $_db,
      $_db.cliente,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('venta__usuario_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<DetalleVenta, List<DetalleVentaData>>
  _detalleVentaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.detalleVenta,
    aliasName: 'venta__id__detalle_venta__venta_id',
  );

  $DetalleVentaProcessedTableManager get detalleVentaRefs {
    final manager = $DetalleVentaTableManager(
      $_db,
      $_db.detalleVenta,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_detalleVentaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<OperacionEnvase, List<OperacionEnvaseData>>
  _operacionEnvaseRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.operacionEnvase,
    aliasName: 'venta__id__operacion_envase__venta_id',
  );

  $OperacionEnvaseProcessedTableManager get operacionEnvaseRefs {
    final manager = $OperacionEnvaseTableManager(
      $_db,
      $_db.operacionEnvase,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _operacionEnvaseRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Pago, List<PagoData>> _pagoRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pago,
    aliasName: 'venta__id__pago__venta_id',
  );

  $PagoProcessedTableManager get pagoRefs {
    final manager = $PagoTableManager(
      $_db,
      $_db.pago,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pagoRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CuentaMonetariaMov, List<CuentaMonetariaMovData>>
  _cuentaMonetariaMovRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cuentaMonetariaMov,
        aliasName: 'venta__id__cuenta_monetaria_mov__venta_id',
      );

  $CuentaMonetariaMovProcessedTableManager get cuentaMonetariaMovRefs {
    final manager = $CuentaMonetariaMovTableManager(
      $_db,
      $_db.cuentaMonetariaMov,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaMonetariaMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CuentaEnvaseMov, List<CuentaEnvaseMovData>>
  _cuentaEnvaseMovRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cuentaEnvaseMov,
    aliasName: 'venta__id__cuenta_envase_mov__venta_id',
  );

  $CuentaEnvaseMovProcessedTableManager get cuentaEnvaseMovRefs {
    final manager = $CuentaEnvaseMovTableManager(
      $_db,
      $_db.cuentaEnvaseMov,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaEnvaseMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    CuentaDepositoEnvaseMov,
    List<CuentaDepositoEnvaseMovData>
  >
  _cuentaDepositoEnvaseMovRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cuentaDepositoEnvaseMov,
        aliasName: 'venta__id__cuenta_deposito_envase_mov__venta_id',
      );

  $CuentaDepositoEnvaseMovProcessedTableManager
  get cuentaDepositoEnvaseMovRefs {
    final manager = $CuentaDepositoEnvaseMovTableManager(
      $_db,
      $_db.cuentaDepositoEnvaseMov,
    ).filter((f) => f.ventaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cuentaDepositoEnvaseMovRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $VentaFilterComposer extends Composer<_$AppDatabase, Venta> {
  $VentaFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $TerminalFilterComposer get terminalId {
    final $TerminalFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalFilterComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ClienteFilterComposer get clienteId {
    final $ClienteFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteFilterComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> detalleVentaRefs(
    Expression<bool> Function($DetalleVentaFilterComposer f) f,
  ) {
    final $DetalleVentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detalleVenta,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DetalleVentaFilterComposer(
            $db: $db,
            $table: $db.detalleVenta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> operacionEnvaseRefs(
    Expression<bool> Function($OperacionEnvaseFilterComposer f) f,
  ) {
    final $OperacionEnvaseFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.operacionEnvase,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $OperacionEnvaseFilterComposer(
            $db: $db,
            $table: $db.operacionEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pagoRefs(
    Expression<bool> Function($PagoFilterComposer f) f,
  ) {
    final $PagoFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pago,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PagoFilterComposer(
            $db: $db,
            $table: $db.pago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaMonetariaMovRefs(
    Expression<bool> Function($CuentaMonetariaMovFilterComposer f) f,
  ) {
    final $CuentaMonetariaMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovFilterComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaEnvaseMovRefs(
    Expression<bool> Function($CuentaEnvaseMovFilterComposer f) f,
  ) {
    final $CuentaEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cuentaDepositoEnvaseMovRefs(
    Expression<bool> Function($CuentaDepositoEnvaseMovFilterComposer f) f,
  ) {
    final $CuentaDepositoEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaDepositoEnvaseMov,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaDepositoEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaDepositoEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $VentaOrderingComposer extends Composer<_$AppDatabase, Venta> {
  $VentaOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get estado => $composableBuilder(
    column: $table.estado,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $TerminalOrderingComposer get terminalId {
    final $TerminalOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalOrderingComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ClienteOrderingComposer get clienteId {
    final $ClienteOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteOrderingComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $VentaAnnotationComposer extends Composer<_$AppDatabase, Venta> {
  $VentaAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get folio =>
      $composableBuilder(column: $table.folio, builder: (column) => column);

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get estado =>
      $composableBuilder(column: $table.estado, builder: (column) => column);

  GeneratedColumn<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCentavos => $composableBuilder(
    column: $table.totalCentavos,
    builder: (column) => column,
  );

  $TerminalAnnotationComposer get terminalId {
    final $TerminalAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.terminalId,
      referencedTable: $db.terminal,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TerminalAnnotationComposer(
            $db: $db,
            $table: $db.terminal,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ClienteAnnotationComposer get clienteId {
    final $ClienteAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteAnnotationComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> detalleVentaRefs<T extends Object>(
    Expression<T> Function($DetalleVentaAnnotationComposer a) f,
  ) {
    final $DetalleVentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.detalleVenta,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DetalleVentaAnnotationComposer(
            $db: $db,
            $table: $db.detalleVenta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> operacionEnvaseRefs<T extends Object>(
    Expression<T> Function($OperacionEnvaseAnnotationComposer a) f,
  ) {
    final $OperacionEnvaseAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.operacionEnvase,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $OperacionEnvaseAnnotationComposer(
            $db: $db,
            $table: $db.operacionEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pagoRefs<T extends Object>(
    Expression<T> Function($PagoAnnotationComposer a) f,
  ) {
    final $PagoAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pago,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PagoAnnotationComposer(
            $db: $db,
            $table: $db.pago,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaMonetariaMovRefs<T extends Object>(
    Expression<T> Function($CuentaMonetariaMovAnnotationComposer a) f,
  ) {
    final $CuentaMonetariaMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaEnvaseMovRefs<T extends Object>(
    Expression<T> Function($CuentaEnvaseMovAnnotationComposer a) f,
  ) {
    final $CuentaEnvaseMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.ventaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cuentaDepositoEnvaseMovRefs<T extends Object>(
    Expression<T> Function($CuentaDepositoEnvaseMovAnnotationComposer a) f,
  ) {
    final $CuentaDepositoEnvaseMovAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cuentaDepositoEnvaseMov,
          getReferencedColumn: (t) => t.ventaId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $CuentaDepositoEnvaseMovAnnotationComposer(
                $db: $db,
                $table: $db.cuentaDepositoEnvaseMov,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $VentaTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Venta,
          VentaData,
          $VentaFilterComposer,
          $VentaOrderingComposer,
          $VentaAnnotationComposer,
          $VentaCreateCompanionBuilder,
          $VentaUpdateCompanionBuilder,
          (VentaData, $VentaReferences),
          VentaData,
          PrefetchHooks Function({
            bool terminalId,
            bool clienteId,
            bool usuarioId,
            bool detalleVentaRefs,
            bool operacionEnvaseRefs,
            bool pagoRefs,
            bool cuentaMonetariaMovRefs,
            bool cuentaEnvaseMovRefs,
            bool cuentaDepositoEnvaseMovRefs,
          })
        > {
  $VentaTableManager(_$AppDatabase db, Venta table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $VentaFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $VentaOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $VentaAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> terminalId = const Value.absent(),
                Value<String> folio = const Value.absent(),
                Value<int?> clienteId = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int> subtotalCentavos = const Value.absent(),
                Value<int> totalCentavos = const Value.absent(),
              }) => VentaCompanion(
                id: id,
                terminalId: terminalId,
                folio: folio,
                clienteId: clienteId,
                usuarioId: usuarioId,
                fecha: fecha,
                estado: estado,
                subtotalCentavos: subtotalCentavos,
                totalCentavos: totalCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int terminalId,
                required String folio,
                Value<int?> clienteId = const Value.absent(),
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
                Value<String> estado = const Value.absent(),
                Value<int> subtotalCentavos = const Value.absent(),
                Value<int> totalCentavos = const Value.absent(),
              }) => VentaCompanion.insert(
                id: id,
                terminalId: terminalId,
                folio: folio,
                clienteId: clienteId,
                usuarioId: usuarioId,
                fecha: fecha,
                estado: estado,
                subtotalCentavos: subtotalCentavos,
                totalCentavos: totalCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Venta, VentaData>(table),
                  $VentaReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                terminalId = false,
                clienteId = false,
                usuarioId = false,
                detalleVentaRefs = false,
                operacionEnvaseRefs = false,
                pagoRefs = false,
                cuentaMonetariaMovRefs = false,
                cuentaEnvaseMovRefs = false,
                cuentaDepositoEnvaseMovRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (detalleVentaRefs) db.detalleVenta,
                    if (operacionEnvaseRefs) db.operacionEnvase,
                    if (pagoRefs) db.pago,
                    if (cuentaMonetariaMovRefs) db.cuentaMonetariaMov,
                    if (cuentaEnvaseMovRefs) db.cuentaEnvaseMov,
                    if (cuentaDepositoEnvaseMovRefs) db.cuentaDepositoEnvaseMov,
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
                        if (terminalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.terminalId,
                            referencedTable: $VentaReferences._terminalIdTable(
                              db,
                            ),
                            referencedColumn: $VentaReferences
                                ._terminalIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (clienteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clienteId,
                            referencedTable: $VentaReferences._clienteIdTable(
                              db,
                            ),
                            referencedColumn: $VentaReferences
                                ._clienteIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioId,
                            referencedTable: $VentaReferences._usuarioIdTable(
                              db,
                            ),
                            referencedColumn: $VentaReferences
                                ._usuarioIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (detalleVentaRefs)
                        await $_getPrefetchedData<
                          VentaData,
                          Venta,
                          DetalleVentaData
                        >(
                          currentTable: table,
                          referencedTable: $VentaReferences
                              ._detalleVentaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $VentaReferences(db, table, p0).detalleVentaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (operacionEnvaseRefs)
                        await $_getPrefetchedData<
                          VentaData,
                          Venta,
                          OperacionEnvaseData
                        >(
                          currentTable: table,
                          referencedTable: $VentaReferences
                              ._operacionEnvaseRefsTable(db),
                          managerFromTypedResult: (p0) => $VentaReferences(
                            db,
                            table,
                            p0,
                          ).operacionEnvaseRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pagoRefs)
                        await $_getPrefetchedData<VentaData, Venta, PagoData>(
                          currentTable: table,
                          referencedTable: $VentaReferences._pagoRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $VentaReferences(db, table, p0).pagoRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaMonetariaMovRefs)
                        await $_getPrefetchedData<
                          VentaData,
                          Venta,
                          CuentaMonetariaMovData
                        >(
                          currentTable: table,
                          referencedTable: $VentaReferences
                              ._cuentaMonetariaMovRefsTable(db),
                          managerFromTypedResult: (p0) => $VentaReferences(
                            db,
                            table,
                            p0,
                          ).cuentaMonetariaMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaEnvaseMovRefs)
                        await $_getPrefetchedData<
                          VentaData,
                          Venta,
                          CuentaEnvaseMovData
                        >(
                          currentTable: table,
                          referencedTable: $VentaReferences
                              ._cuentaEnvaseMovRefsTable(db),
                          managerFromTypedResult: (p0) => $VentaReferences(
                            db,
                            table,
                            p0,
                          ).cuentaEnvaseMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cuentaDepositoEnvaseMovRefs)
                        await $_getPrefetchedData<
                          VentaData,
                          Venta,
                          CuentaDepositoEnvaseMovData
                        >(
                          currentTable: table,
                          referencedTable: $VentaReferences
                              ._cuentaDepositoEnvaseMovRefsTable(db),
                          managerFromTypedResult: (p0) => $VentaReferences(
                            db,
                            table,
                            p0,
                          ).cuentaDepositoEnvaseMovRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ventaId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $VentaProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Venta,
      VentaData,
      $VentaFilterComposer,
      $VentaOrderingComposer,
      $VentaAnnotationComposer,
      $VentaCreateCompanionBuilder,
      $VentaUpdateCompanionBuilder,
      (VentaData, $VentaReferences),
      VentaData,
      PrefetchHooks Function({
        bool terminalId,
        bool clienteId,
        bool usuarioId,
        bool detalleVentaRefs,
        bool operacionEnvaseRefs,
        bool pagoRefs,
        bool cuentaMonetariaMovRefs,
        bool cuentaEnvaseMovRefs,
        bool cuentaDepositoEnvaseMovRefs,
      })
    >;
typedef $DetalleVentaCreateCompanionBuilder = DetalleVentaCompanion Function({
  Value<int> id,
  required int ventaId,
  required int productoId,
  required int cantidad,
  required int precioUnitarioCentavos,
  required int costoUnitarioCentavos,
  required int subtotalCentavos,
});
typedef $DetalleVentaUpdateCompanionBuilder = DetalleVentaCompanion Function({
  Value<int> id,
  Value<int> ventaId,
  Value<int> productoId,
  Value<int> cantidad,
  Value<int> precioUnitarioCentavos,
  Value<int> costoUnitarioCentavos,
  Value<int> subtotalCentavos,
});

final class $DetalleVentaReferences
    extends BaseReferences<_$AppDatabase, DetalleVenta, DetalleVentaData> {
  $DetalleVentaReferences(super.$_db, super.$_table, super.$_typedResult);

  static Venta _ventaIdTable(_$AppDatabase db) =>
      db.venta.createAlias('detalle_venta__venta_id__venta__id');

  $VentaProcessedTableManager get ventaId {
    final $_column = $_itemColumn<int>('venta_id')!;

    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Producto _productoIdTable(_$AppDatabase db) =>
      db.producto.createAlias('detalle_venta__producto_id__producto__id');

  $ProductoProcessedTableManager get productoId {
    final $_column = $_itemColumn<int>('producto_id')!;

    final manager = $ProductoTableManager(
      $_db,
      $_db.producto,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $DetalleVentaFilterComposer
    extends Composer<_$AppDatabase, DetalleVenta> {
  $DetalleVentaFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get precioUnitarioCentavos => $composableBuilder(
    column: $table.precioUnitarioCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costoUnitarioCentavos => $composableBuilder(
    column: $table.costoUnitarioCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $VentaFilterComposer get ventaId {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProductoFilterComposer get productoId {
    final $ProductoFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoFilterComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DetalleVentaOrderingComposer
    extends Composer<_$AppDatabase, DetalleVenta> {
  $DetalleVentaOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get precioUnitarioCentavos => $composableBuilder(
    column: $table.precioUnitarioCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costoUnitarioCentavos => $composableBuilder(
    column: $table.costoUnitarioCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $VentaOrderingComposer get ventaId {
    final $VentaOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaOrderingComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProductoOrderingComposer get productoId {
    final $ProductoOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoOrderingComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DetalleVentaAnnotationComposer
    extends Composer<_$AppDatabase, DetalleVenta> {
  $DetalleVentaAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<int> get precioUnitarioCentavos => $composableBuilder(
    column: $table.precioUnitarioCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costoUnitarioCentavos => $composableBuilder(
    column: $table.costoUnitarioCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotalCentavos => $composableBuilder(
    column: $table.subtotalCentavos,
    builder: (column) => column,
  );

  $VentaAnnotationComposer get ventaId {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $ProductoAnnotationComposer get productoId {
    final $ProductoAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productoId,
      referencedTable: $db.producto,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ProductoAnnotationComposer(
            $db: $db,
            $table: $db.producto,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DetalleVentaTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DetalleVenta,
          DetalleVentaData,
          $DetalleVentaFilterComposer,
          $DetalleVentaOrderingComposer,
          $DetalleVentaAnnotationComposer,
          $DetalleVentaCreateCompanionBuilder,
          $DetalleVentaUpdateCompanionBuilder,
          (DetalleVentaData, $DetalleVentaReferences),
          DetalleVentaData,
          PrefetchHooks Function({bool ventaId, bool productoId})
        > {
  $DetalleVentaTableManager(_$AppDatabase db, DetalleVenta table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DetalleVentaFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DetalleVentaOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DetalleVentaAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int> precioUnitarioCentavos = const Value.absent(),
                Value<int> costoUnitarioCentavos = const Value.absent(),
                Value<int> subtotalCentavos = const Value.absent(),
              }) => DetalleVentaCompanion(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                cantidad: cantidad,
                precioUnitarioCentavos: precioUnitarioCentavos,
                costoUnitarioCentavos: costoUnitarioCentavos,
                subtotalCentavos: subtotalCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required int productoId,
                required int cantidad,
                required int precioUnitarioCentavos,
                required int costoUnitarioCentavos,
                required int subtotalCentavos,
              }) => DetalleVentaCompanion.insert(
                id: id,
                ventaId: ventaId,
                productoId: productoId,
                cantidad: cantidad,
                precioUnitarioCentavos: precioUnitarioCentavos,
                costoUnitarioCentavos: costoUnitarioCentavos,
                subtotalCentavos: subtotalCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DetalleVenta, DetalleVentaData>(table),
                  $DetalleVentaReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventaId = false, productoId = false}) {
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
                    if (ventaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ventaId,
                        referencedTable: $DetalleVentaReferences._ventaIdTable(
                          db,
                        ),
                        referencedColumn: $DetalleVentaReferences
                            ._ventaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (productoId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.productoId,
                        referencedTable: $DetalleVentaReferences
                            ._productoIdTable(db),
                        referencedColumn: $DetalleVentaReferences
                            ._productoIdTable(db)
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

typedef $DetalleVentaProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DetalleVenta,
      DetalleVentaData,
      $DetalleVentaFilterComposer,
      $DetalleVentaOrderingComposer,
      $DetalleVentaAnnotationComposer,
      $DetalleVentaCreateCompanionBuilder,
      $DetalleVentaUpdateCompanionBuilder,
      (DetalleVentaData, $DetalleVentaReferences),
      DetalleVentaData,
      PrefetchHooks Function({bool ventaId, bool productoId})
    >;
typedef $OperacionEnvaseCreateCompanionBuilder =
    OperacionEnvaseCompanion Function({
      Value<int> id,
      required int ventaId,
      required int tipoEnvaseId,
      required String tipo,
      required int cantidad,
      Value<int?> montoUnitarioCentavos,
    });
typedef $OperacionEnvaseUpdateCompanionBuilder =
    OperacionEnvaseCompanion Function({
      Value<int> id,
      Value<int> ventaId,
      Value<int> tipoEnvaseId,
      Value<String> tipo,
      Value<int> cantidad,
      Value<int?> montoUnitarioCentavos,
    });

final class $OperacionEnvaseReferences
    extends
        BaseReferences<_$AppDatabase, OperacionEnvase, OperacionEnvaseData> {
  $OperacionEnvaseReferences(super.$_db, super.$_table, super.$_typedResult);

  static Venta _ventaIdTable(_$AppDatabase db) =>
      db.venta.createAlias('operacion_envase__venta_id__venta__id');

  $VentaProcessedTableManager get ventaId {
    final $_column = $_itemColumn<int>('venta_id')!;

    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static TipoEnvase _tipoEnvaseIdTable(_$AppDatabase db) => db.tipoEnvase
      .createAlias('operacion_envase__tipo_envase_id__tipo_envase__id');

  $TipoEnvaseProcessedTableManager get tipoEnvaseId {
    final $_column = $_itemColumn<int>('tipo_envase_id')!;

    final manager = $TipoEnvaseTableManager(
      $_db,
      $_db.tipoEnvase,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoEnvaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $OperacionEnvaseFilterComposer
    extends Composer<_$AppDatabase, OperacionEnvase> {
  $OperacionEnvaseFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoUnitarioCentavos => $composableBuilder(
    column: $table.montoUnitarioCentavos,
    builder: (column) => ColumnFilters(column),
  );

  $VentaFilterComposer get ventaId {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseFilterComposer get tipoEnvaseId {
    final $TipoEnvaseFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseFilterComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $OperacionEnvaseOrderingComposer
    extends Composer<_$AppDatabase, OperacionEnvase> {
  $OperacionEnvaseOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoUnitarioCentavos => $composableBuilder(
    column: $table.montoUnitarioCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  $VentaOrderingComposer get ventaId {
    final $VentaOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaOrderingComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseOrderingComposer get tipoEnvaseId {
    final $TipoEnvaseOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseOrderingComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $OperacionEnvaseAnnotationComposer
    extends Composer<_$AppDatabase, OperacionEnvase> {
  $OperacionEnvaseAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<int> get montoUnitarioCentavos => $composableBuilder(
    column: $table.montoUnitarioCentavos,
    builder: (column) => column,
  );

  $VentaAnnotationComposer get ventaId {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseAnnotationComposer get tipoEnvaseId {
    final $TipoEnvaseAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseAnnotationComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $OperacionEnvaseTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          OperacionEnvase,
          OperacionEnvaseData,
          $OperacionEnvaseFilterComposer,
          $OperacionEnvaseOrderingComposer,
          $OperacionEnvaseAnnotationComposer,
          $OperacionEnvaseCreateCompanionBuilder,
          $OperacionEnvaseUpdateCompanionBuilder,
          (OperacionEnvaseData, $OperacionEnvaseReferences),
          OperacionEnvaseData,
          PrefetchHooks Function({bool ventaId, bool tipoEnvaseId})
        > {
  $OperacionEnvaseTableManager(_$AppDatabase db, OperacionEnvase table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $OperacionEnvaseFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $OperacionEnvaseOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $OperacionEnvaseAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<int> tipoEnvaseId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int?> montoUnitarioCentavos = const Value.absent(),
              }) => OperacionEnvaseCompanion(
                id: id,
                ventaId: ventaId,
                tipoEnvaseId: tipoEnvaseId,
                tipo: tipo,
                cantidad: cantidad,
                montoUnitarioCentavos: montoUnitarioCentavos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required int tipoEnvaseId,
                required String tipo,
                required int cantidad,
                Value<int?> montoUnitarioCentavos = const Value.absent(),
              }) => OperacionEnvaseCompanion.insert(
                id: id,
                ventaId: ventaId,
                tipoEnvaseId: tipoEnvaseId,
                tipo: tipo,
                cantidad: cantidad,
                montoUnitarioCentavos: montoUnitarioCentavos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<OperacionEnvase, OperacionEnvaseData>(table),
                  $OperacionEnvaseReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventaId = false, tipoEnvaseId = false}) {
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
                    if (ventaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ventaId,
                        referencedTable: $OperacionEnvaseReferences
                            ._ventaIdTable(db),
                        referencedColumn: $OperacionEnvaseReferences
                            ._ventaIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (tipoEnvaseId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.tipoEnvaseId,
                        referencedTable: $OperacionEnvaseReferences
                            ._tipoEnvaseIdTable(db),
                        referencedColumn: $OperacionEnvaseReferences
                            ._tipoEnvaseIdTable(db)
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

typedef $OperacionEnvaseProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      OperacionEnvase,
      OperacionEnvaseData,
      $OperacionEnvaseFilterComposer,
      $OperacionEnvaseOrderingComposer,
      $OperacionEnvaseAnnotationComposer,
      $OperacionEnvaseCreateCompanionBuilder,
      $OperacionEnvaseUpdateCompanionBuilder,
      (OperacionEnvaseData, $OperacionEnvaseReferences),
      OperacionEnvaseData,
      PrefetchHooks Function({bool ventaId, bool tipoEnvaseId})
    >;
typedef $PagoCreateCompanionBuilder = PagoCompanion Function({
  Value<int> id,
  required int ventaId,
  required String metodo,
  required int montoCentavos,
  Value<int> ivaCentavos,
  Value<String> fecha,
});
typedef $PagoUpdateCompanionBuilder = PagoCompanion Function({
  Value<int> id,
  Value<int> ventaId,
  Value<String> metodo,
  Value<int> montoCentavos,
  Value<int> ivaCentavos,
  Value<String> fecha,
});

final class $PagoReferences
    extends BaseReferences<_$AppDatabase, Pago, PagoData> {
  $PagoReferences(super.$_db, super.$_table, super.$_typedResult);

  static Venta _ventaIdTable(_$AppDatabase db) =>
      db.venta.createAlias('pago__venta_id__venta__id');

  $VentaProcessedTableManager get ventaId {
    final $_column = $_itemColumn<int>('venta_id')!;

    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $PagoFilterComposer extends Composer<_$AppDatabase, Pago> {
  $PagoFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ivaCentavos => $composableBuilder(
    column: $table.ivaCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $VentaFilterComposer get ventaId {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PagoOrderingComposer extends Composer<_$AppDatabase, Pago> {
  $PagoOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodo => $composableBuilder(
    column: $table.metodo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ivaCentavos => $composableBuilder(
    column: $table.ivaCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $VentaOrderingComposer get ventaId {
    final $VentaOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaOrderingComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PagoAnnotationComposer extends Composer<_$AppDatabase, Pago> {
  $PagoAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get metodo =>
      $composableBuilder(column: $table.metodo, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ivaCentavos => $composableBuilder(
    column: $table.ivaCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $VentaAnnotationComposer get ventaId {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PagoTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Pago,
          PagoData,
          $PagoFilterComposer,
          $PagoOrderingComposer,
          $PagoAnnotationComposer,
          $PagoCreateCompanionBuilder,
          $PagoUpdateCompanionBuilder,
          (PagoData, $PagoReferences),
          PagoData,
          PrefetchHooks Function({bool ventaId})
        > {
  $PagoTableManager(_$AppDatabase db, Pago table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $PagoFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $PagoOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $PagoAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<String> metodo = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
                Value<int> ivaCentavos = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => PagoCompanion(
                id: id,
                ventaId: ventaId,
                metodo: metodo,
                montoCentavos: montoCentavos,
                ivaCentavos: ivaCentavos,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required String metodo,
                required int montoCentavos,
                Value<int> ivaCentavos = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => PagoCompanion.insert(
                id: id,
                ventaId: ventaId,
                metodo: metodo,
                montoCentavos: montoCentavos,
                ivaCentavos: ivaCentavos,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Pago, PagoData>(table),
                  $PagoReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ventaId = false}) {
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
                    if (ventaId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ventaId,
                        referencedTable: $PagoReferences._ventaIdTable(db),
                        referencedColumn: $PagoReferences._ventaIdTable(db).id,
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

typedef $PagoProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Pago,
      PagoData,
      $PagoFilterComposer,
      $PagoOrderingComposer,
      $PagoAnnotationComposer,
      $PagoCreateCompanionBuilder,
      $PagoUpdateCompanionBuilder,
      (PagoData, $PagoReferences),
      PagoData,
      PrefetchHooks Function({bool ventaId})
    >;
typedef $CuentaMonetariaMovCreateCompanionBuilder =
    CuentaMonetariaMovCompanion Function({
      Value<int> id,
      required int clienteId,
      Value<int?> ventaId,
      required String tipo,
      required int montoCentavos,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      required int usuarioId,
      Value<String> fecha,
    });
typedef $CuentaMonetariaMovUpdateCompanionBuilder =
    CuentaMonetariaMovCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<int?> ventaId,
      Value<String> tipo,
      Value<int> montoCentavos,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      Value<int> usuarioId,
      Value<String> fecha,
    });

final class $CuentaMonetariaMovReferences
    extends
        BaseReferences<
          _$AppDatabase,
          CuentaMonetariaMov,
          CuentaMonetariaMovData
        > {
  $CuentaMonetariaMovReferences(super.$_db, super.$_table, super.$_typedResult);

  static Cliente _clienteIdTable(_$AppDatabase db) =>
      db.cliente.createAlias('cuenta_monetaria_mov__cliente_id__cliente__id');

  $ClienteProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $ClienteTableManager(
      $_db,
      $_db.cliente,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Venta _ventaIdTable(_$AppDatabase db) =>
      db.venta.createAlias('cuenta_monetaria_mov__venta_id__venta__id');

  $VentaProcessedTableManager? get ventaId {
    final $_column = $_itemColumn<int>('venta_id');
    if ($_column == null) return null;
    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static CuentaMonetariaMov _reversaDeIdTable(_$AppDatabase db) =>
      db.cuentaMonetariaMov.createAlias(
        'cuenta_monetaria_mov__reversa_de_id__cuenta_monetaria_mov__id',
      );

  $CuentaMonetariaMovProcessedTableManager? get reversaDeId {
    final $_column = $_itemColumn<int>('reversa_de_id');
    if ($_column == null) return null;
    final manager = $CuentaMonetariaMovTableManager(
      $_db,
      $_db.cuentaMonetariaMov,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversaDeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('cuenta_monetaria_mov__usuario_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $CuentaMonetariaMovFilterComposer
    extends Composer<_$AppDatabase, CuentaMonetariaMov> {
  $CuentaMonetariaMovFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $ClienteFilterComposer get clienteId {
    final $ClienteFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteFilterComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VentaFilterComposer get ventaId {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaMonetariaMovFilterComposer get reversaDeId {
    final $CuentaMonetariaMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovFilterComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaMonetariaMovOrderingComposer
    extends Composer<_$AppDatabase, CuentaMonetariaMov> {
  $CuentaMonetariaMovOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $ClienteOrderingComposer get clienteId {
    final $ClienteOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteOrderingComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VentaOrderingComposer get ventaId {
    final $VentaOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaOrderingComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaMonetariaMovOrderingComposer get reversaDeId {
    final $CuentaMonetariaMovOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovOrderingComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaMonetariaMovAnnotationComposer
    extends Composer<_$AppDatabase, CuentaMonetariaMov> {
  $CuentaMonetariaMovAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $ClienteAnnotationComposer get clienteId {
    final $ClienteAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteAnnotationComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VentaAnnotationComposer get ventaId {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaMonetariaMovAnnotationComposer get reversaDeId {
    final $CuentaMonetariaMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.cuentaMonetariaMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaMonetariaMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaMonetariaMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaMonetariaMovTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CuentaMonetariaMov,
          CuentaMonetariaMovData,
          $CuentaMonetariaMovFilterComposer,
          $CuentaMonetariaMovOrderingComposer,
          $CuentaMonetariaMovAnnotationComposer,
          $CuentaMonetariaMovCreateCompanionBuilder,
          $CuentaMonetariaMovUpdateCompanionBuilder,
          (CuentaMonetariaMovData, $CuentaMonetariaMovReferences),
          CuentaMonetariaMovData,
          PrefetchHooks Function({
            bool clienteId,
            bool ventaId,
            bool reversaDeId,
            bool usuarioId,
          })
        > {
  $CuentaMonetariaMovTableManager(_$AppDatabase db, CuentaMonetariaMov table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CuentaMonetariaMovFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CuentaMonetariaMovOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CuentaMonetariaMovAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<int?> ventaId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => CuentaMonetariaMovCompanion(
                id: id,
                clienteId: clienteId,
                ventaId: ventaId,
                tipo: tipo,
                montoCentavos: montoCentavos,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                Value<int?> ventaId = const Value.absent(),
                required String tipo,
                required int montoCentavos,
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
              }) => CuentaMonetariaMovCompanion.insert(
                id: id,
                clienteId: clienteId,
                ventaId: ventaId,
                tipo: tipo,
                montoCentavos: montoCentavos,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<CuentaMonetariaMov, CuentaMonetariaMovData>(
                    table,
                  ),
                  $CuentaMonetariaMovReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                ventaId = false,
                reversaDeId = false,
                usuarioId = false,
              }) {
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
                        if (clienteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clienteId,
                            referencedTable: $CuentaMonetariaMovReferences
                                ._clienteIdTable(db),
                            referencedColumn: $CuentaMonetariaMovReferences
                                ._clienteIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (ventaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ventaId,
                            referencedTable: $CuentaMonetariaMovReferences
                                ._ventaIdTable(db),
                            referencedColumn: $CuentaMonetariaMovReferences
                                ._ventaIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (reversaDeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reversaDeId,
                            referencedTable: $CuentaMonetariaMovReferences
                                ._reversaDeIdTable(db),
                            referencedColumn: $CuentaMonetariaMovReferences
                                ._reversaDeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioId,
                            referencedTable: $CuentaMonetariaMovReferences
                                ._usuarioIdTable(db),
                            referencedColumn: $CuentaMonetariaMovReferences
                                ._usuarioIdTable(db)
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

typedef $CuentaMonetariaMovProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CuentaMonetariaMov,
      CuentaMonetariaMovData,
      $CuentaMonetariaMovFilterComposer,
      $CuentaMonetariaMovOrderingComposer,
      $CuentaMonetariaMovAnnotationComposer,
      $CuentaMonetariaMovCreateCompanionBuilder,
      $CuentaMonetariaMovUpdateCompanionBuilder,
      (CuentaMonetariaMovData, $CuentaMonetariaMovReferences),
      CuentaMonetariaMovData,
      PrefetchHooks Function({
        bool clienteId,
        bool ventaId,
        bool reversaDeId,
        bool usuarioId,
      })
    >;
typedef $CuentaEnvaseMovCreateCompanionBuilder =
    CuentaEnvaseMovCompanion Function({
      Value<int> id,
      required int clienteId,
      Value<int?> ventaId,
      required int tipoEnvaseId,
      required String tipo,
      required int cantidad,
      Value<int?> montoCentavos,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      required int usuarioId,
      Value<String> fecha,
    });
typedef $CuentaEnvaseMovUpdateCompanionBuilder =
    CuentaEnvaseMovCompanion Function({
      Value<int> id,
      Value<int> clienteId,
      Value<int?> ventaId,
      Value<int> tipoEnvaseId,
      Value<String> tipo,
      Value<int> cantidad,
      Value<int?> montoCentavos,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      Value<int> usuarioId,
      Value<String> fecha,
    });

final class $CuentaEnvaseMovReferences
    extends
        BaseReferences<_$AppDatabase, CuentaEnvaseMov, CuentaEnvaseMovData> {
  $CuentaEnvaseMovReferences(super.$_db, super.$_table, super.$_typedResult);

  static Cliente _clienteIdTable(_$AppDatabase db) =>
      db.cliente.createAlias('cuenta_envase_mov__cliente_id__cliente__id');

  $ClienteProcessedTableManager get clienteId {
    final $_column = $_itemColumn<int>('cliente_id')!;

    final manager = $ClienteTableManager(
      $_db,
      $_db.cliente,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clienteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Venta _ventaIdTable(_$AppDatabase db) =>
      db.venta.createAlias('cuenta_envase_mov__venta_id__venta__id');

  $VentaProcessedTableManager? get ventaId {
    final $_column = $_itemColumn<int>('venta_id');
    if ($_column == null) return null;
    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static TipoEnvase _tipoEnvaseIdTable(_$AppDatabase db) => db.tipoEnvase
      .createAlias('cuenta_envase_mov__tipo_envase_id__tipo_envase__id');

  $TipoEnvaseProcessedTableManager get tipoEnvaseId {
    final $_column = $_itemColumn<int>('tipo_envase_id')!;

    final manager = $TipoEnvaseTableManager(
      $_db,
      $_db.tipoEnvase,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoEnvaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static CuentaEnvaseMov _reversaDeIdTable(_$AppDatabase db) => db
      .cuentaEnvaseMov
      .createAlias('cuenta_envase_mov__reversa_de_id__cuenta_envase_mov__id');

  $CuentaEnvaseMovProcessedTableManager? get reversaDeId {
    final $_column = $_itemColumn<int>('reversa_de_id');
    if ($_column == null) return null;
    final manager = $CuentaEnvaseMovTableManager(
      $_db,
      $_db.cuentaEnvaseMov,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversaDeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('cuenta_envase_mov__usuario_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $CuentaEnvaseMovFilterComposer
    extends Composer<_$AppDatabase, CuentaEnvaseMov> {
  $CuentaEnvaseMovFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $ClienteFilterComposer get clienteId {
    final $ClienteFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteFilterComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VentaFilterComposer get ventaId {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseFilterComposer get tipoEnvaseId {
    final $TipoEnvaseFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseFilterComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaEnvaseMovFilterComposer get reversaDeId {
    final $CuentaEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaEnvaseMovOrderingComposer
    extends Composer<_$AppDatabase, CuentaEnvaseMov> {
  $CuentaEnvaseMovOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $ClienteOrderingComposer get clienteId {
    final $ClienteOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteOrderingComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VentaOrderingComposer get ventaId {
    final $VentaOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaOrderingComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseOrderingComposer get tipoEnvaseId {
    final $TipoEnvaseOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseOrderingComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaEnvaseMovOrderingComposer get reversaDeId {
    final $CuentaEnvaseMovOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovOrderingComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaEnvaseMovAnnotationComposer
    extends Composer<_$AppDatabase, CuentaEnvaseMov> {
  $CuentaEnvaseMovAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $ClienteAnnotationComposer get clienteId {
    final $ClienteAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clienteId,
      referencedTable: $db.cliente,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ClienteAnnotationComposer(
            $db: $db,
            $table: $db.cliente,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $VentaAnnotationComposer get ventaId {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseAnnotationComposer get tipoEnvaseId {
    final $TipoEnvaseAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseAnnotationComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaEnvaseMovAnnotationComposer get reversaDeId {
    final $CuentaEnvaseMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.cuentaEnvaseMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaEnvaseMovAnnotationComposer(
            $db: $db,
            $table: $db.cuentaEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaEnvaseMovTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CuentaEnvaseMov,
          CuentaEnvaseMovData,
          $CuentaEnvaseMovFilterComposer,
          $CuentaEnvaseMovOrderingComposer,
          $CuentaEnvaseMovAnnotationComposer,
          $CuentaEnvaseMovCreateCompanionBuilder,
          $CuentaEnvaseMovUpdateCompanionBuilder,
          (CuentaEnvaseMovData, $CuentaEnvaseMovReferences),
          CuentaEnvaseMovData,
          PrefetchHooks Function({
            bool clienteId,
            bool ventaId,
            bool tipoEnvaseId,
            bool reversaDeId,
            bool usuarioId,
          })
        > {
  $CuentaEnvaseMovTableManager(_$AppDatabase db, CuentaEnvaseMov table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CuentaEnvaseMovFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CuentaEnvaseMovOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CuentaEnvaseMovAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
                Value<int?> ventaId = const Value.absent(),
                Value<int> tipoEnvaseId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int?> montoCentavos = const Value.absent(),
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => CuentaEnvaseMovCompanion(
                id: id,
                clienteId: clienteId,
                ventaId: ventaId,
                tipoEnvaseId: tipoEnvaseId,
                tipo: tipo,
                cantidad: cantidad,
                montoCentavos: montoCentavos,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int clienteId,
                Value<int?> ventaId = const Value.absent(),
                required int tipoEnvaseId,
                required String tipo,
                required int cantidad,
                Value<int?> montoCentavos = const Value.absent(),
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
              }) => CuentaEnvaseMovCompanion.insert(
                id: id,
                clienteId: clienteId,
                ventaId: ventaId,
                tipoEnvaseId: tipoEnvaseId,
                tipo: tipo,
                cantidad: cantidad,
                montoCentavos: montoCentavos,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<CuentaEnvaseMov, CuentaEnvaseMovData>(table),
                  $CuentaEnvaseMovReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clienteId = false,
                ventaId = false,
                tipoEnvaseId = false,
                reversaDeId = false,
                usuarioId = false,
              }) {
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
                        if (clienteId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.clienteId,
                            referencedTable: $CuentaEnvaseMovReferences
                                ._clienteIdTable(db),
                            referencedColumn: $CuentaEnvaseMovReferences
                                ._clienteIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (ventaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ventaId,
                            referencedTable: $CuentaEnvaseMovReferences
                                ._ventaIdTable(db),
                            referencedColumn: $CuentaEnvaseMovReferences
                                ._ventaIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (tipoEnvaseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.tipoEnvaseId,
                            referencedTable: $CuentaEnvaseMovReferences
                                ._tipoEnvaseIdTable(db),
                            referencedColumn: $CuentaEnvaseMovReferences
                                ._tipoEnvaseIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (reversaDeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reversaDeId,
                            referencedTable: $CuentaEnvaseMovReferences
                                ._reversaDeIdTable(db),
                            referencedColumn: $CuentaEnvaseMovReferences
                                ._reversaDeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioId,
                            referencedTable: $CuentaEnvaseMovReferences
                                ._usuarioIdTable(db),
                            referencedColumn: $CuentaEnvaseMovReferences
                                ._usuarioIdTable(db)
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

typedef $CuentaEnvaseMovProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CuentaEnvaseMov,
      CuentaEnvaseMovData,
      $CuentaEnvaseMovFilterComposer,
      $CuentaEnvaseMovOrderingComposer,
      $CuentaEnvaseMovAnnotationComposer,
      $CuentaEnvaseMovCreateCompanionBuilder,
      $CuentaEnvaseMovUpdateCompanionBuilder,
      (CuentaEnvaseMovData, $CuentaEnvaseMovReferences),
      CuentaEnvaseMovData,
      PrefetchHooks Function({
        bool clienteId,
        bool ventaId,
        bool tipoEnvaseId,
        bool reversaDeId,
        bool usuarioId,
      })
    >;
typedef $CuentaDepositoEnvaseMovCreateCompanionBuilder =
    CuentaDepositoEnvaseMovCompanion Function({
      Value<int> id,
      required int ventaId,
      required int tipoEnvaseId,
      required String tipo,
      required int cantidad,
      required int montoUnitarioCentavos,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      required int usuarioId,
      Value<String> fecha,
    });
typedef $CuentaDepositoEnvaseMovUpdateCompanionBuilder =
    CuentaDepositoEnvaseMovCompanion Function({
      Value<int> id,
      Value<int> ventaId,
      Value<int> tipoEnvaseId,
      Value<String> tipo,
      Value<int> cantidad,
      Value<int> montoUnitarioCentavos,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      Value<int> usuarioId,
      Value<String> fecha,
    });

final class $CuentaDepositoEnvaseMovReferences
    extends
        BaseReferences<
          _$AppDatabase,
          CuentaDepositoEnvaseMov,
          CuentaDepositoEnvaseMovData
        > {
  $CuentaDepositoEnvaseMovReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static Venta _ventaIdTable(_$AppDatabase db) =>
      db.venta.createAlias('cuenta_deposito_envase_mov__venta_id__venta__id');

  $VentaProcessedTableManager get ventaId {
    final $_column = $_itemColumn<int>('venta_id')!;

    final manager = $VentaTableManager(
      $_db,
      $_db.venta,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ventaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static TipoEnvase _tipoEnvaseIdTable(_$AppDatabase db) =>
      db.tipoEnvase.createAlias(
        'cuenta_deposito_envase_mov__tipo_envase_id__tipo_envase__id',
      );

  $TipoEnvaseProcessedTableManager get tipoEnvaseId {
    final $_column = $_itemColumn<int>('tipo_envase_id')!;

    final manager = $TipoEnvaseTableManager(
      $_db,
      $_db.tipoEnvase,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoEnvaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static CuentaDepositoEnvaseMov _reversaDeIdTable(
    _$AppDatabase db,
  ) => db.cuentaDepositoEnvaseMov.createAlias(
    'cuenta_deposito_envase_mov__reversa_de_id__cuenta_deposito_envase_mov__id',
  );

  $CuentaDepositoEnvaseMovProcessedTableManager? get reversaDeId {
    final $_column = $_itemColumn<int>('reversa_de_id');
    if ($_column == null) return null;
    final manager = $CuentaDepositoEnvaseMovTableManager(
      $_db,
      $_db.cuentaDepositoEnvaseMov,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversaDeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioIdTable(_$AppDatabase db) => db.usuario.createAlias(
    'cuenta_deposito_envase_mov__usuario_id__usuario__id',
  );

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $CuentaDepositoEnvaseMovFilterComposer
    extends Composer<_$AppDatabase, CuentaDepositoEnvaseMov> {
  $CuentaDepositoEnvaseMovFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoUnitarioCentavos => $composableBuilder(
    column: $table.montoUnitarioCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $VentaFilterComposer get ventaId {
    final $VentaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaFilterComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseFilterComposer get tipoEnvaseId {
    final $TipoEnvaseFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseFilterComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaDepositoEnvaseMovFilterComposer get reversaDeId {
    final $CuentaDepositoEnvaseMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.cuentaDepositoEnvaseMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaDepositoEnvaseMovFilterComposer(
            $db: $db,
            $table: $db.cuentaDepositoEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaDepositoEnvaseMovOrderingComposer
    extends Composer<_$AppDatabase, CuentaDepositoEnvaseMov> {
  $CuentaDepositoEnvaseMovOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoUnitarioCentavos => $composableBuilder(
    column: $table.montoUnitarioCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $VentaOrderingComposer get ventaId {
    final $VentaOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaOrderingComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseOrderingComposer get tipoEnvaseId {
    final $TipoEnvaseOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseOrderingComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaDepositoEnvaseMovOrderingComposer get reversaDeId {
    final $CuentaDepositoEnvaseMovOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.cuentaDepositoEnvaseMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CuentaDepositoEnvaseMovOrderingComposer(
            $db: $db,
            $table: $db.cuentaDepositoEnvaseMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaDepositoEnvaseMovAnnotationComposer
    extends Composer<_$AppDatabase, CuentaDepositoEnvaseMov> {
  $CuentaDepositoEnvaseMovAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<int> get montoUnitarioCentavos => $composableBuilder(
    column: $table.montoUnitarioCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $VentaAnnotationComposer get ventaId {
    final $VentaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ventaId,
      referencedTable: $db.venta,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $VentaAnnotationComposer(
            $db: $db,
            $table: $db.venta,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $TipoEnvaseAnnotationComposer get tipoEnvaseId {
    final $TipoEnvaseAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseAnnotationComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CuentaDepositoEnvaseMovAnnotationComposer get reversaDeId {
    final $CuentaDepositoEnvaseMovAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.reversaDeId,
          referencedTable: $db.cuentaDepositoEnvaseMov,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $CuentaDepositoEnvaseMovAnnotationComposer(
                $db: $db,
                $table: $db.cuentaDepositoEnvaseMov,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CuentaDepositoEnvaseMovTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CuentaDepositoEnvaseMov,
          CuentaDepositoEnvaseMovData,
          $CuentaDepositoEnvaseMovFilterComposer,
          $CuentaDepositoEnvaseMovOrderingComposer,
          $CuentaDepositoEnvaseMovAnnotationComposer,
          $CuentaDepositoEnvaseMovCreateCompanionBuilder,
          $CuentaDepositoEnvaseMovUpdateCompanionBuilder,
          (CuentaDepositoEnvaseMovData, $CuentaDepositoEnvaseMovReferences),
          CuentaDepositoEnvaseMovData,
          PrefetchHooks Function({
            bool ventaId,
            bool tipoEnvaseId,
            bool reversaDeId,
            bool usuarioId,
          })
        > {
  $CuentaDepositoEnvaseMovTableManager(
    _$AppDatabase db,
    CuentaDepositoEnvaseMov table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CuentaDepositoEnvaseMovFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CuentaDepositoEnvaseMovOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CuentaDepositoEnvaseMovAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<int> tipoEnvaseId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int> montoUnitarioCentavos = const Value.absent(),
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => CuentaDepositoEnvaseMovCompanion(
                id: id,
                ventaId: ventaId,
                tipoEnvaseId: tipoEnvaseId,
                tipo: tipo,
                cantidad: cantidad,
                montoUnitarioCentavos: montoUnitarioCentavos,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required int tipoEnvaseId,
                required String tipo,
                required int cantidad,
                required int montoUnitarioCentavos,
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
              }) => CuentaDepositoEnvaseMovCompanion.insert(
                id: id,
                ventaId: ventaId,
                tipoEnvaseId: tipoEnvaseId,
                tipo: tipo,
                cantidad: cantidad,
                montoUnitarioCentavos: montoUnitarioCentavos,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    CuentaDepositoEnvaseMov,
                    CuentaDepositoEnvaseMovData
                  >(table),
                  $CuentaDepositoEnvaseMovReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ventaId = false,
                tipoEnvaseId = false,
                reversaDeId = false,
                usuarioId = false,
              }) {
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
                        if (ventaId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ventaId,
                            referencedTable: $CuentaDepositoEnvaseMovReferences
                                ._ventaIdTable(db),
                            referencedColumn: $CuentaDepositoEnvaseMovReferences
                                ._ventaIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (tipoEnvaseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.tipoEnvaseId,
                            referencedTable: $CuentaDepositoEnvaseMovReferences
                                ._tipoEnvaseIdTable(db),
                            referencedColumn: $CuentaDepositoEnvaseMovReferences
                                ._tipoEnvaseIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (reversaDeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reversaDeId,
                            referencedTable: $CuentaDepositoEnvaseMovReferences
                                ._reversaDeIdTable(db),
                            referencedColumn: $CuentaDepositoEnvaseMovReferences
                                ._reversaDeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioId,
                            referencedTable: $CuentaDepositoEnvaseMovReferences
                                ._usuarioIdTable(db),
                            referencedColumn: $CuentaDepositoEnvaseMovReferences
                                ._usuarioIdTable(db)
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

typedef $CuentaDepositoEnvaseMovProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CuentaDepositoEnvaseMov,
      CuentaDepositoEnvaseMovData,
      $CuentaDepositoEnvaseMovFilterComposer,
      $CuentaDepositoEnvaseMovOrderingComposer,
      $CuentaDepositoEnvaseMovAnnotationComposer,
      $CuentaDepositoEnvaseMovCreateCompanionBuilder,
      $CuentaDepositoEnvaseMovUpdateCompanionBuilder,
      (CuentaDepositoEnvaseMovData, $CuentaDepositoEnvaseMovReferences),
      CuentaDepositoEnvaseMovData,
      PrefetchHooks Function({
        bool ventaId,
        bool tipoEnvaseId,
        bool reversaDeId,
        bool usuarioId,
      })
    >;
typedef $EnvaseInventarioMovCreateCompanionBuilder =
    EnvaseInventarioMovCompanion Function({
      Value<int> id,
      required int tipoEnvaseId,
      required String tipo,
      required int cantidad,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      required int usuarioId,
      Value<String> fecha,
    });
typedef $EnvaseInventarioMovUpdateCompanionBuilder =
    EnvaseInventarioMovCompanion Function({
      Value<int> id,
      Value<int> tipoEnvaseId,
      Value<String> tipo,
      Value<int> cantidad,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      Value<int> usuarioId,
      Value<String> fecha,
    });

final class $EnvaseInventarioMovReferences
    extends
        BaseReferences<
          _$AppDatabase,
          EnvaseInventarioMov,
          EnvaseInventarioMovData
        > {
  $EnvaseInventarioMovReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static TipoEnvase _tipoEnvaseIdTable(_$AppDatabase db) => db.tipoEnvase
      .createAlias('envase_inventario_mov__tipo_envase_id__tipo_envase__id');

  $TipoEnvaseProcessedTableManager get tipoEnvaseId {
    final $_column = $_itemColumn<int>('tipo_envase_id')!;

    final manager = $TipoEnvaseTableManager(
      $_db,
      $_db.tipoEnvase,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tipoEnvaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static EnvaseInventarioMov _reversaDeIdTable(_$AppDatabase db) =>
      db.envaseInventarioMov.createAlias(
        'envase_inventario_mov__reversa_de_id__envase_inventario_mov__id',
      );

  $EnvaseInventarioMovProcessedTableManager? get reversaDeId {
    final $_column = $_itemColumn<int>('reversa_de_id');
    if ($_column == null) return null;
    final manager = $EnvaseInventarioMovTableManager(
      $_db,
      $_db.envaseInventarioMov,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversaDeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('envase_inventario_mov__usuario_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $EnvaseInventarioMovFilterComposer
    extends Composer<_$AppDatabase, EnvaseInventarioMov> {
  $EnvaseInventarioMovFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $TipoEnvaseFilterComposer get tipoEnvaseId {
    final $TipoEnvaseFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseFilterComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnvaseInventarioMovFilterComposer get reversaDeId {
    final $EnvaseInventarioMovFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.envaseInventarioMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnvaseInventarioMovFilterComposer(
            $db: $db,
            $table: $db.envaseInventarioMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EnvaseInventarioMovOrderingComposer
    extends Composer<_$AppDatabase, EnvaseInventarioMov> {
  $EnvaseInventarioMovOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $TipoEnvaseOrderingComposer get tipoEnvaseId {
    final $TipoEnvaseOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseOrderingComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnvaseInventarioMovOrderingComposer get reversaDeId {
    final $EnvaseInventarioMovOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.envaseInventarioMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnvaseInventarioMovOrderingComposer(
            $db: $db,
            $table: $db.envaseInventarioMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EnvaseInventarioMovAnnotationComposer
    extends Composer<_$AppDatabase, EnvaseInventarioMov> {
  $EnvaseInventarioMovAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $TipoEnvaseAnnotationComposer get tipoEnvaseId {
    final $TipoEnvaseAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tipoEnvaseId,
      referencedTable: $db.tipoEnvase,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipoEnvaseAnnotationComposer(
            $db: $db,
            $table: $db.tipoEnvase,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EnvaseInventarioMovAnnotationComposer get reversaDeId {
    final $EnvaseInventarioMovAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.envaseInventarioMov,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EnvaseInventarioMovAnnotationComposer(
            $db: $db,
            $table: $db.envaseInventarioMov,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $EnvaseInventarioMovTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          EnvaseInventarioMov,
          EnvaseInventarioMovData,
          $EnvaseInventarioMovFilterComposer,
          $EnvaseInventarioMovOrderingComposer,
          $EnvaseInventarioMovAnnotationComposer,
          $EnvaseInventarioMovCreateCompanionBuilder,
          $EnvaseInventarioMovUpdateCompanionBuilder,
          (EnvaseInventarioMovData, $EnvaseInventarioMovReferences),
          EnvaseInventarioMovData,
          PrefetchHooks Function({
            bool tipoEnvaseId,
            bool reversaDeId,
            bool usuarioId,
          })
        > {
  $EnvaseInventarioMovTableManager(_$AppDatabase db, EnvaseInventarioMov table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EnvaseInventarioMovFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EnvaseInventarioMovOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EnvaseInventarioMovAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> tipoEnvaseId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => EnvaseInventarioMovCompanion(
                id: id,
                tipoEnvaseId: tipoEnvaseId,
                tipo: tipo,
                cantidad: cantidad,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int tipoEnvaseId,
                required String tipo,
                required int cantidad,
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
              }) => EnvaseInventarioMovCompanion.insert(
                id: id,
                tipoEnvaseId: tipoEnvaseId,
                tipo: tipo,
                cantidad: cantidad,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<EnvaseInventarioMov, EnvaseInventarioMovData>(
                    table,
                  ),
                  $EnvaseInventarioMovReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({tipoEnvaseId = false, reversaDeId = false, usuarioId = false}) {
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
                        if (tipoEnvaseId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.tipoEnvaseId,
                            referencedTable: $EnvaseInventarioMovReferences
                                ._tipoEnvaseIdTable(db),
                            referencedColumn: $EnvaseInventarioMovReferences
                                ._tipoEnvaseIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (reversaDeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reversaDeId,
                            referencedTable: $EnvaseInventarioMovReferences
                                ._reversaDeIdTable(db),
                            referencedColumn: $EnvaseInventarioMovReferences
                                ._reversaDeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioId,
                            referencedTable: $EnvaseInventarioMovReferences
                                ._usuarioIdTable(db),
                            referencedColumn: $EnvaseInventarioMovReferences
                                ._usuarioIdTable(db)
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

typedef $EnvaseInventarioMovProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      EnvaseInventarioMov,
      EnvaseInventarioMovData,
      $EnvaseInventarioMovFilterComposer,
      $EnvaseInventarioMovOrderingComposer,
      $EnvaseInventarioMovAnnotationComposer,
      $EnvaseInventarioMovCreateCompanionBuilder,
      $EnvaseInventarioMovUpdateCompanionBuilder,
      (EnvaseInventarioMovData, $EnvaseInventarioMovReferences),
      EnvaseInventarioMovData,
      PrefetchHooks Function({
        bool tipoEnvaseId,
        bool reversaDeId,
        bool usuarioId,
      })
    >;
typedef $DevolucionCreateCompanionBuilder = DevolucionCompanion Function({
  Value<int> id,
  required int ventaId,
  required int detalleVentaId,
  required int productoId,
  required int cantidad,
  required int montoDevueltoCentavos,
  required String condicion,
  required int usuarioId,
  Value<String> fecha,
});
typedef $DevolucionUpdateCompanionBuilder = DevolucionCompanion Function({
  Value<int> id,
  Value<int> ventaId,
  Value<int> detalleVentaId,
  Value<int> productoId,
  Value<int> cantidad,
  Value<int> montoDevueltoCentavos,
  Value<String> condicion,
  Value<int> usuarioId,
  Value<String> fecha,
});

final class $DevolucionReferences
    extends BaseReferences<_$AppDatabase, Devolucion, DevolucionData> {
  $DevolucionReferences(super.$_db, super.$_table, super.$_typedResult);

  static Usuario _usuarioIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('devolucion__usuario_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $DevolucionFilterComposer extends Composer<_$AppDatabase, Devolucion> {
  $DevolucionFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ventaId => $composableBuilder(
    column: $table.ventaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get detalleVentaId => $composableBuilder(
    column: $table.detalleVentaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoDevueltoCentavos => $composableBuilder(
    column: $table.montoDevueltoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condicion => $composableBuilder(
    column: $table.condicion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DevolucionOrderingComposer extends Composer<_$AppDatabase, Devolucion> {
  $DevolucionOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ventaId => $composableBuilder(
    column: $table.ventaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get detalleVentaId => $composableBuilder(
    column: $table.detalleVentaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoDevueltoCentavos => $composableBuilder(
    column: $table.montoDevueltoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condicion => $composableBuilder(
    column: $table.condicion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DevolucionAnnotationComposer
    extends Composer<_$AppDatabase, Devolucion> {
  $DevolucionAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ventaId =>
      $composableBuilder(column: $table.ventaId, builder: (column) => column);

  GeneratedColumn<int> get detalleVentaId => $composableBuilder(
    column: $table.detalleVentaId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get productoId => $composableBuilder(
    column: $table.productoId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<int> get montoDevueltoCentavos => $composableBuilder(
    column: $table.montoDevueltoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get condicion =>
      $composableBuilder(column: $table.condicion, builder: (column) => column);

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DevolucionTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Devolucion,
          DevolucionData,
          $DevolucionFilterComposer,
          $DevolucionOrderingComposer,
          $DevolucionAnnotationComposer,
          $DevolucionCreateCompanionBuilder,
          $DevolucionUpdateCompanionBuilder,
          (DevolucionData, $DevolucionReferences),
          DevolucionData,
          PrefetchHooks Function({bool usuarioId})
        > {
  $DevolucionTableManager(_$AppDatabase db, Devolucion table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DevolucionFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DevolucionOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DevolucionAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ventaId = const Value.absent(),
                Value<int> detalleVentaId = const Value.absent(),
                Value<int> productoId = const Value.absent(),
                Value<int> cantidad = const Value.absent(),
                Value<int> montoDevueltoCentavos = const Value.absent(),
                Value<String> condicion = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => DevolucionCompanion(
                id: id,
                ventaId: ventaId,
                detalleVentaId: detalleVentaId,
                productoId: productoId,
                cantidad: cantidad,
                montoDevueltoCentavos: montoDevueltoCentavos,
                condicion: condicion,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ventaId,
                required int detalleVentaId,
                required int productoId,
                required int cantidad,
                required int montoDevueltoCentavos,
                required String condicion,
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
              }) => DevolucionCompanion.insert(
                id: id,
                ventaId: ventaId,
                detalleVentaId: detalleVentaId,
                productoId: productoId,
                cantidad: cantidad,
                montoDevueltoCentavos: montoDevueltoCentavos,
                condicion: condicion,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Devolucion, DevolucionData>(table),
                  $DevolucionReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({usuarioId = false}) {
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
                    if (usuarioId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.usuarioId,
                        referencedTable: $DevolucionReferences._usuarioIdTable(
                          db,
                        ),
                        referencedColumn: $DevolucionReferences
                            ._usuarioIdTable(db)
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

typedef $DevolucionProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Devolucion,
      DevolucionData,
      $DevolucionFilterComposer,
      $DevolucionOrderingComposer,
      $DevolucionAnnotationComposer,
      $DevolucionCreateCompanionBuilder,
      $DevolucionUpdateCompanionBuilder,
      (DevolucionData, $DevolucionReferences),
      DevolucionData,
      PrefetchHooks Function({bool usuarioId})
    >;
typedef $MovimientoCajaCreateCompanionBuilder =
    MovimientoCajaCompanion Function({
      Value<int> id,
      required int cajaSesionId,
      required String tipo,
      required int montoCentavos,
      Value<String?> motivo,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      required int usuarioId,
      Value<String> fecha,
    });
typedef $MovimientoCajaUpdateCompanionBuilder =
    MovimientoCajaCompanion Function({
      Value<int> id,
      Value<int> cajaSesionId,
      Value<String> tipo,
      Value<int> montoCentavos,
      Value<String?> motivo,
      Value<String?> referenciaTipo,
      Value<int?> referenciaId,
      Value<int?> reversaDeId,
      Value<int> usuarioId,
      Value<String> fecha,
    });

final class $MovimientoCajaReferences
    extends BaseReferences<_$AppDatabase, MovimientoCaja, MovimientoCajaData> {
  $MovimientoCajaReferences(super.$_db, super.$_table, super.$_typedResult);

  static CajaSesion _cajaSesionIdTable(_$AppDatabase db) => db.cajaSesion
      .createAlias('movimiento_caja__caja_sesion_id__caja_sesion__id');

  $CajaSesionProcessedTableManager get cajaSesionId {
    final $_column = $_itemColumn<int>('caja_sesion_id')!;

    final manager = $CajaSesionTableManager(
      $_db,
      $_db.cajaSesion,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cajaSesionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MovimientoCaja _reversaDeIdTable(_$AppDatabase db) => db.movimientoCaja
      .createAlias('movimiento_caja__reversa_de_id__movimiento_caja__id');

  $MovimientoCajaProcessedTableManager? get reversaDeId {
    final $_column = $_itemColumn<int>('reversa_de_id');
    if ($_column == null) return null;
    final manager = $MovimientoCajaTableManager(
      $_db,
      $_db.movimientoCaja,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversaDeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Usuario _usuarioIdTable(_$AppDatabase db) =>
      db.usuario.createAlias('movimiento_caja__usuario_id__usuario__id');

  $UsuarioProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $UsuarioTableManager(
      $_db,
      $_db.usuario,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $MovimientoCajaFilterComposer
    extends Composer<_$AppDatabase, MovimientoCaja> {
  $MovimientoCajaFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  $CajaSesionFilterComposer get cajaSesionId {
    final $CajaSesionFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cajaSesionId,
      referencedTable: $db.cajaSesion,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CajaSesionFilterComposer(
            $db: $db,
            $table: $db.cajaSesion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MovimientoCajaFilterComposer get reversaDeId {
    final $MovimientoCajaFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.movimientoCaja,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoCajaFilterComposer(
            $db: $db,
            $table: $db.movimientoCaja,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioFilterComposer get usuarioId {
    final $UsuarioFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioFilterComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MovimientoCajaOrderingComposer
    extends Composer<_$AppDatabase, MovimientoCaja> {
  $MovimientoCajaOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get motivo => $composableBuilder(
    column: $table.motivo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  $CajaSesionOrderingComposer get cajaSesionId {
    final $CajaSesionOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cajaSesionId,
      referencedTable: $db.cajaSesion,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CajaSesionOrderingComposer(
            $db: $db,
            $table: $db.cajaSesion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MovimientoCajaOrderingComposer get reversaDeId {
    final $MovimientoCajaOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.movimientoCaja,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoCajaOrderingComposer(
            $db: $db,
            $table: $db.movimientoCaja,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioOrderingComposer get usuarioId {
    final $UsuarioOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioOrderingComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MovimientoCajaAnnotationComposer
    extends Composer<_$AppDatabase, MovimientoCaja> {
  $MovimientoCajaAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get montoCentavos => $composableBuilder(
    column: $table.montoCentavos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get motivo =>
      $composableBuilder(column: $table.motivo, builder: (column) => column);

  GeneratedColumn<String> get referenciaTipo => $composableBuilder(
    column: $table.referenciaTipo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referenciaId => $composableBuilder(
    column: $table.referenciaId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  $CajaSesionAnnotationComposer get cajaSesionId {
    final $CajaSesionAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cajaSesionId,
      referencedTable: $db.cajaSesion,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CajaSesionAnnotationComposer(
            $db: $db,
            $table: $db.cajaSesion,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MovimientoCajaAnnotationComposer get reversaDeId {
    final $MovimientoCajaAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversaDeId,
      referencedTable: $db.movimientoCaja,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MovimientoCajaAnnotationComposer(
            $db: $db,
            $table: $db.movimientoCaja,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $UsuarioAnnotationComposer get usuarioId {
    final $UsuarioAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.usuarioId,
      referencedTable: $db.usuario,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $UsuarioAnnotationComposer(
            $db: $db,
            $table: $db.usuario,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MovimientoCajaTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          MovimientoCaja,
          MovimientoCajaData,
          $MovimientoCajaFilterComposer,
          $MovimientoCajaOrderingComposer,
          $MovimientoCajaAnnotationComposer,
          $MovimientoCajaCreateCompanionBuilder,
          $MovimientoCajaUpdateCompanionBuilder,
          (MovimientoCajaData, $MovimientoCajaReferences),
          MovimientoCajaData,
          PrefetchHooks Function({
            bool cajaSesionId,
            bool reversaDeId,
            bool usuarioId,
          })
        > {
  $MovimientoCajaTableManager(_$AppDatabase db, MovimientoCaja table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MovimientoCajaFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MovimientoCajaOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MovimientoCajaAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cajaSesionId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<int> montoCentavos = const Value.absent(),
                Value<String?> motivo = const Value.absent(),
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                Value<int> usuarioId = const Value.absent(),
                Value<String> fecha = const Value.absent(),
              }) => MovimientoCajaCompanion(
                id: id,
                cajaSesionId: cajaSesionId,
                tipo: tipo,
                montoCentavos: montoCentavos,
                motivo: motivo,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cajaSesionId,
                required String tipo,
                required int montoCentavos,
                Value<String?> motivo = const Value.absent(),
                Value<String?> referenciaTipo = const Value.absent(),
                Value<int?> referenciaId = const Value.absent(),
                Value<int?> reversaDeId = const Value.absent(),
                required int usuarioId,
                Value<String> fecha = const Value.absent(),
              }) => MovimientoCajaCompanion.insert(
                id: id,
                cajaSesionId: cajaSesionId,
                tipo: tipo,
                montoCentavos: montoCentavos,
                motivo: motivo,
                referenciaTipo: referenciaTipo,
                referenciaId: referenciaId,
                reversaDeId: reversaDeId,
                usuarioId: usuarioId,
                fecha: fecha,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<MovimientoCaja, MovimientoCajaData>(table),
                  $MovimientoCajaReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cajaSesionId = false, reversaDeId = false, usuarioId = false}) {
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
                        if (cajaSesionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cajaSesionId,
                            referencedTable: $MovimientoCajaReferences
                                ._cajaSesionIdTable(db),
                            referencedColumn: $MovimientoCajaReferences
                                ._cajaSesionIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (reversaDeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reversaDeId,
                            referencedTable: $MovimientoCajaReferences
                                ._reversaDeIdTable(db),
                            referencedColumn: $MovimientoCajaReferences
                                ._reversaDeIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (usuarioId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.usuarioId,
                            referencedTable: $MovimientoCajaReferences
                                ._usuarioIdTable(db),
                            referencedColumn: $MovimientoCajaReferences
                                ._usuarioIdTable(db)
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

typedef $MovimientoCajaProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      MovimientoCaja,
      MovimientoCajaData,
      $MovimientoCajaFilterComposer,
      $MovimientoCajaOrderingComposer,
      $MovimientoCajaAnnotationComposer,
      $MovimientoCajaCreateCompanionBuilder,
      $MovimientoCajaUpdateCompanionBuilder,
      (MovimientoCajaData, $MovimientoCajaReferences),
      MovimientoCajaData,
      PrefetchHooks Function({
        bool cajaSesionId,
        bool reversaDeId,
        bool usuarioId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $TerminalTableManager get terminal =>
      $TerminalTableManager(_db, _db.terminal);
  $UsuarioTableManager get usuario => $UsuarioTableManager(_db, _db.usuario);
  $CajaSesionTableManager get cajaSesion =>
      $CajaSesionTableManager(_db, _db.cajaSesion);
  $CategoriaTableManager get categoria =>
      $CategoriaTableManager(_db, _db.categoria);
  $TipoEnvaseTableManager get tipoEnvase =>
      $TipoEnvaseTableManager(_db, _db.tipoEnvase);
  $ProductoTableManager get producto =>
      $ProductoTableManager(_db, _db.producto);
  $MovimientoInventarioTableManager get movimientoInventario =>
      $MovimientoInventarioTableManager(_db, _db.movimientoInventario);
  $InventarioSaldoTableManager get inventarioSaldo =>
      $InventarioSaldoTableManager(_db, _db.inventarioSaldo);
  $SaldoGuardTableManager get saldoGuard =>
      $SaldoGuardTableManager(_db, _db.saldoGuard);
  $ProveedorTableManager get proveedor =>
      $ProveedorTableManager(_db, _db.proveedor);
  $CompraTableManager get compra => $CompraTableManager(_db, _db.compra);
  $DetalleCompraTableManager get detalleCompra =>
      $DetalleCompraTableManager(_db, _db.detalleCompra);
  $ClienteTableManager get cliente => $ClienteTableManager(_db, _db.cliente);
  $VentaTableManager get venta => $VentaTableManager(_db, _db.venta);
  $DetalleVentaTableManager get detalleVenta =>
      $DetalleVentaTableManager(_db, _db.detalleVenta);
  $OperacionEnvaseTableManager get operacionEnvase =>
      $OperacionEnvaseTableManager(_db, _db.operacionEnvase);
  $PagoTableManager get pago => $PagoTableManager(_db, _db.pago);
  $CuentaMonetariaMovTableManager get cuentaMonetariaMov =>
      $CuentaMonetariaMovTableManager(_db, _db.cuentaMonetariaMov);
  $CuentaEnvaseMovTableManager get cuentaEnvaseMov =>
      $CuentaEnvaseMovTableManager(_db, _db.cuentaEnvaseMov);
  $CuentaDepositoEnvaseMovTableManager get cuentaDepositoEnvaseMov =>
      $CuentaDepositoEnvaseMovTableManager(_db, _db.cuentaDepositoEnvaseMov);
  $EnvaseInventarioMovTableManager get envaseInventarioMov =>
      $EnvaseInventarioMovTableManager(_db, _db.envaseInventarioMov);
  $DevolucionTableManager get devolucion =>
      $DevolucionTableManager(_db, _db.devolucion);
  $MovimientoCajaTableManager get movimientoCaja =>
      $MovimientoCajaTableManager(_db, _db.movimientoCaja);
}
