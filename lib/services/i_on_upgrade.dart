import 'package:sqflite/sqflite.dart';

abstract class IOnUpgrade {
  Future onUpgrade(Database db, int oldVersion, int newVersion);
}
