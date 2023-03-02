import 'package:help_mei/entities/entity.dart';
import 'package:sqflite/sqflite.dart';

import '../services/sqlite_service.dart';

class EntityController {
  Future insertEntity(Entity entity) async {
    Database db = await SqliteService.instance.database;
    await db.insert(entity.tableName, entity.toMap());
  }

  Future deleteEntity(Entity entity) async {
    Database db = await SqliteService.instance.database;
    await db.delete(entity.tableName,
        where: _recoverWhere(entity), whereArgs: _recoverWhereArgs(entity));
  }

  Future updateEntity(Entity entity) async {
    Database db = await SqliteService.instance.database;
    await db.update(entity.tableName, entity.toMap(),
        where: _recoverWhere(entity), whereArgs: _recoverWhereArgs(entity));
  }

  Future<List<Entity>> getEntities(Entity entity) async {
    Database db = await SqliteService.instance.database;
    List<Map<String, dynamic>> maps = await db.query(entity.tableName);
    return maps.map((e) => entity.fromMap(e)).toList();
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
