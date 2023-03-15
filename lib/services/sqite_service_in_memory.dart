import 'package:help_mei/helpers/constantes.dart';
import 'package:help_mei/services/database_service.dart';
import 'package:help_mei/services/tables/on_create_current.dart';
import 'package:help_mei/services/tables/on_upgrade_current.dart';
import 'package:sqflite/sqflite.dart';

class SqliteServiceInMemory extends DatabaseService {
  static Database? _database;

  SqliteServiceInMemory._()
      : super(
          onCreate: OnCreateCurrent(),
          onUpgrade: OnUpgradeCurrent(),
        );
  static final SqliteServiceInMemory instance = SqliteServiceInMemory._();
  factory SqliteServiceInMemory() => instance;

  @override
  Future<Database> initDatabase() async {
    return await openDatabase(
      inMemoryDatabasePath,
      version: databaseVersion,
      onCreate: onCreate.onCreate,
      onConfigure: onConfigure,
      onUpgrade: onUpgrade.onUpgrade,
    );
  }

  @override
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }
}
