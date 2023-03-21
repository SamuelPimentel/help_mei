import 'package:help_mei/entities/entity.dart';
import 'package:help_mei/entities/foreign_key.dart';
import 'package:help_mei/entities/interfaces/irelationship_multiple.dart';
import 'package:help_mei/entities/interfaces/irequest_new_primary_key.dart';
import 'package:help_mei/entities/interfaces/isearch_simple.dart';
import 'package:help_mei/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class EntityControllerGeneric {
  DatabaseService service;
  EntityControllerGeneric({required this.service});
  Future insertEntity(Entity entity, [Database? database]) async {
    Database db;
    if (database == null) {
      db = await service.database;
    } else {
      db = database;
    }
    try {
      await db.insert(entity.tableName, entity.toMap());
      if (entity is IRelationshipMultiple) {
        var values = (entity as IRelationshipMultiple).insertValues();
        for (var val in values.keys) {
          for (var ent in values[val]!) {
            await insertEntity(ent, db);
          }
        }
      }
    } catch (ex) {
      if (ex is DatabaseException) {
        if (ex.isUniqueConstraintError()) {
          var result = await getEntity(entity);
          if (result != null) {
            if (entity is IRequestNewPrimaryKey) {
              (entity as IRequestNewPrimaryKey).requestNewPrimaryKeys();
              await insertEntity(entity, db);
            } else {
              rethrow;
            }
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
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
/*
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
  }*/

  Future<Entity?> getEntity(Entity entity) async {
    var result = await getEntitiesWhere(entity, entity.getPrimaryKeys());
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<Entity?> getEntityWhere(
      Entity entity, Map<String, String> whereArgs) async {
    var result = await getEntitiesWhere(entity, whereArgs);
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<Entity?> getEntityParameters(Entity entity) async {
    if (entity is! ISearchSimple) return null;

    var result =
        await getEntitiesWhere(entity, (entity as ISearchSimple).parameters());
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<List<Entity>> getEntitiesParameters(Entity entity) async {
    if (entity is! ISearchSimple) return [];
    var result =
        await getEntitiesWhere(entity, (entity as ISearchSimple).parameters());
    if (result.isEmpty) return [];
    return result;
  }

  Future<List<Entity>> getEntitiesWhere(
      Entity entity, Map<String, String> whereArgs) async {
    Database db = await service.database;
    List<Map<String, dynamic>> maps = await db.query(
      entity.tableName,
      where: _generateWhere(whereArgs),
      whereArgs: _generateWhereArgs(whereArgs),
    );
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
      if (entity is IRelationshipMultiple) {
        var conditions =
            (entity as IRelationshipMultiple).relationshipSearchCondition();
        for (var table in conditions.keys) {
          var values = await getEntitiesWhere(table, conditions[table]!);
          Map<String, List<Entity>> map = {};
          map[table.tableName] = values;
          (entity as IRelationshipMultiple).addRelationshipValues(map);
        }
      }
    }
    return entities;
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
      bool isnull = false;
      for (var v in key.keys.values) {
        if (v == null) {
          isnull = true;
          break;
        }
      }
      if (isnull) {
        continue;
      }
      var value = await getEntity(key.tableEntity);
      if (value != null) {
        values[value.tableName] = value;
      }
    }
    return values;
  }

  String _generateWhere(Map<String, String> args) {
    String where = '';

    for (var val in args.keys) {
      if (where.isNotEmpty) {
        where = '$where AND $val = ?';
      } else {
        where = '($val = ?';
      }
    }

    where = '$where )';

    return where;
  }

  List<String> _generateWhereArgs(Map<String, String> args) {
    List<String> whereArgs = [];
    for (var val in args.values) {
      whereArgs.add(val);
    }

    return whereArgs;
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
