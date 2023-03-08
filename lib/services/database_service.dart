import 'package:help_mei/services/i_on_create.dart';
import 'package:help_mei/services/i_on_upgrade.dart';
import 'package:sqflite/sqflite.dart';

abstract class DatabaseService {
  final IOnUpgrade onUpgrade;
  final IOnCreate onCreate;

  DatabaseService({required this.onCreate, required this.onUpgrade});

  Future<Database> initDatabase();

  Future<Database> get database;

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }
}
