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
        where: _generateWhere(entity.getPrimaryKeys()),
        whereArgs: _generateWhereArgs(entity.getPrimaryKeys()));
  }

  Future deleteEntityWhere(Entity entity, Map<String, String> whereArgs) async {
    Database db = await service.database;
    await db.delete(
      entity.tableName,
      where: _generateWhere(whereArgs),
      whereArgs: _generateWhereArgs(whereArgs),
    );
  }

  Future updateEntity(Entity entity) async {
    Database db = await service.database;
    var oldEntity = await getEntity(entity);
    if (oldEntity == null) {
      insertEntity(entity);
      return;
    }
    await db.update(
      entity.tableName,
      entity.toMap(),
      where: _generateWhere(entity.getPrimaryKeys()),
      whereArgs: _generateWhereArgs(entity.getPrimaryKeys()),
    );
    if (entity is IRelationshipMultiple) {
      var oldMap = (oldEntity as IRelationshipMultiple).insertValues();
      for (var table in oldMap.keys) {
        var values = oldMap[table];
        if (values != null) {
          for (var v in values) {
            await deleteEntity(v);
          }
        }
      }

      var map = (entity as IRelationshipMultiple).insertValues();
      for (var table in map.keys) {
        var values = map[table];
        if (values != null) {
          for (var v in values) {
            await insertEntity(v, db);
          }
        }
      }
    }
  }

  /// Recupera uma entidade com a chave primária igual a passada pelo parametro
  Future<Entity?> getEntity(Entity entity) async {
    var result = await getEntitiesWhere(entity, entity.getPrimaryKeys());
    if (result.isEmpty) return null;
    return result.first;
  }

  /// Recupera uma entidade que seja igual aos parametros passados
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

  Future<Map<String, List<Entity>>> _getRelationshipValue(
      IRelationshipMultiple entity) async {
    Map<String, List<Entity>> map = {};
    var conditions = entity.relationshipSearchCondition();
    for (var table in conditions.keys) {
      var values = await getEntitiesWhere(table, conditions[table]!);
      map[table.tableName] = values;
    }
    return map;
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

    await _getForeignValues(entities);
    await _getRelationshipValues(entities);

    return entities;
  }

  Future<List<Entity>> getEntities(Entity entity) async {
    Database db = await service.database;
    List<Map<String, dynamic>> maps = await db.query(entity.tableName);
    var entities = maps.map((e) => entity.fromMap(e)).toList();

    await _getForeignValues(entities);
    await _getRelationshipValues(entities);

    return entities;
  }

  Future _getForeignValues(List<Entity> entities) async {
    for (var entity in entities) {
      if (entity is IForeignKey) {
        var values = await _getForeignValue(entity as IForeignKey);
        (entity as IForeignKey).insertForeignValues(values);
      }
    }
  }

  Future<Map<String, dynamic>> _getForeignValue(IForeignKey entity) async {
    Map<String, dynamic> values = {};
    for (var key in (entity).getForeignKeys()) {
      var value = await getEntity(key.tableEntity);
      if (value != null) {
        values[value.tableName] = value;
      }
    }
    return values;
  }

  Future _getRelationshipValues(List<Entity> entities) async {
    for (var entity in entities) {
      if (entity is IRelationshipMultiple) {
        var map = await _getRelationshipValue(entity as IRelationshipMultiple);
        (entity as IRelationshipMultiple).addRelationshipValues(map);
      }
    }
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
}
