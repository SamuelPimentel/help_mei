import 'dart:io';

import 'package:help_mei/services/database_service.dart';
import 'package:help_mei/services/tables/on_create_current.dart';
import 'package:help_mei/services/tables/on_upgrade_current.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqliteServiceOnDisk extends DatabaseService {
  static const _databaseVersion = 2;
  static Database? _database;
  static const _databaseName = 'HelpMeiData.db';

  SqliteServiceOnDisk._()
      : super(
          onCreate: OnCreateCurrent(),
          onUpgrade: OnUpgradeCurrent(),
        );

  static final SqliteServiceOnDisk instance = SqliteServiceOnDisk._();
  factory SqliteServiceOnDisk() => instance;

  @override
  // TODO: implement database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  @override
  Future<Database> initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String databasePath = join(documentDirectory.path, _databaseName);
    return openDatabase(
      databasePath,
      version: _databaseVersion,
      onConfigure: onConfigure,
      onCreate: onCreate.onCreate,
      onUpgrade: onUpgrade.onUpgrade,
    );
  }
}
