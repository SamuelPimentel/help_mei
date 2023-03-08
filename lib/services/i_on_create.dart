import 'package:sqflite/sqflite.dart';

abstract class IOnCreate {
  Future onCreate(Database db, int version);
}
