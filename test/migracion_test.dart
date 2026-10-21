import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_mg/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('migración v1 → v3 agrega login, credencial_offline y dispositivo_config', () async {
    final dir = await Directory.systemTemp.createTemp('pos_mg_migracion');
    addTearDown(() => dir.delete(recursive: true));
    final archivo = File('${dir.path}/pos.sqlite');

    // Se crea el esquema actual y se "regresa" a v1 a mano: sin la
    // tablas, índices ni columnas que agregan la v2 y la v3.
    final nueva = AppDatabase.forTesting(NativeDatabase(archivo));
    await nueva.customSelect('SELECT 1').get();
    await nueva.close();

    final raw = sqlite3.open(archivo.path);
    raw.execute('''
      DROP TABLE dispositivo_config;
      DROP TABLE credencial_offline;
      DROP INDEX uq_usuario_remoto_id;
      DROP INDEX uq_usuario_nombre_usuario;
      ALTER TABLE usuario DROP COLUMN remoto_id;
      ALTER TABLE usuario DROP COLUMN nombre_usuario;
      ALTER TABLE usuario DROP COLUMN sucursal_id;
      INSERT INTO usuario (nombre, rol) VALUES ('Cajero', 'CAJERO');
      PRAGMA user_version = 1;
    ''');
    raw.close();

    final db = AppDatabase.forTesting(NativeDatabase(archivo));
    addTearDown(db.close);

    final usuarios = await db.select(db.usuario).get();
    expect(usuarios.single.nombre, 'Cajero');
    expect(usuarios.single.nombreUsuario, isNull);
    expect(await db.select(db.credencialOffline).get(), isEmpty);
    expect(await db.select(db.dispositivoConfig).get(), isEmpty);

    final indices = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'index' "
          "AND tbl_name = 'usuario'",
        )
        .map((r) => r.read<String>('name'))
        .get();
    expect(indices, containsAll(['uq_usuario_remoto_id', 'uq_usuario_nombre_usuario']));
  });
}
