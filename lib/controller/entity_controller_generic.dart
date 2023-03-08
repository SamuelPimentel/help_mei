import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

import '../services/sqlite_service.dart';

class EntityControllerGeneric {
  DatabaseService service;
  EntityControllerGeneric({required this.service});
  Future insertEntity(Entity entity) async {
    Database db = await service.database;
    await db.insert(entity.tableName, entity.toMap());
  }

  Future deleteEntity(Entity entity) async {
    Database db = await service.database;
    await db.delete(entity.tableName,
        where: _recoverWhere(entity), whereArgs: _recoverWhereArgs(entity));
  }

  Future updateEntity(Entity entity) async {
    Database db = await service.database;
    await db.update(entity.tableName, entity.toMap(),
        where: _recoverWhere(entity), whereArgs: _recoverWhereArgs(entity));
  }

  Future<Entity?> getEntity(Entity entity) async {
    Database db = await service.database;
    List<Map> maps = await db.query(
      entity.tableName,
      where: _recoverWhere(entity),
      whereArgs: _recoverWhereArgs(entity),
    );
    if (maps.isNotEmpty) {
      var en = entity.fromMap(maps.first);
      if (en is IForeignKey) {
        var values = await _getForeignValues(en);
        (en as IForeignKey).insertForeignValues(values);
        return en;
      }
      return en;
    }
    return null;
  }

  Future<List<Entity>> getEntities(Entity entity) async {
    Database db = await service.database;
    List<Map<String, dynamic>> maps = await db.query(entity.tableName);
    var entities = maps.map((e) => entity.fromMap(e)).toList();

    for (var entity in entities) {
      if (entity is IForeignKey) {
        Map<String, dynamic> values = {};
        for (var key in (entity as IForeignKey).getForeignKeys()) {
          var value = await getEntity(key.tableEntity);
          if (value != null) {
            values[value.tableName] = value;
          }
        }

        (entity as IForeignKey).insertForeignValues(values);
      }
    }

    return entities;
  }

  Future<Map<String, dynamic>> _getForeignValues(Entity entity) async {
    Map<String, dynamic> values = {};
    for (var key in (entity as IForeignKey).getForeignKeys()) {
      var value = await getEntity(key.tableEntity);
      if (value != null) {
        values[value.tableName] = value;
      }
    }
    return values;
  }

  String _recoverWhere(Entity entity) {
    String where = '';
    for (var ent in entity.getPrimaryKeys().keys) {
      if (where.isNotEmpty) {
        where = '$where, $ent = ?';
      } else {
        where = '$ent = ?';
      }
    }
    return where;
  }

  List<String> _recoverWhereArgs(Entity entity) {
    List<String> whereArgs = [];
    for (var whr in entity.getPrimaryKeys().values) {
      whereArgs.add(whr);
    }
    return whereArgs;
  }
}
