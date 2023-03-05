import 'package:help_mei/entities/entity.dart';

class ForeignKey {
  Entity tableEntity;
  Map<String, dynamic> keys;
  ForeignKey({required this.tableEntity, required this.keys}) {
    tableEntity.setPrimaryKeys(keys);
  }
}

abstract class IForeignKey {
  List<ForeignKey> getForeignKeys();
  void insertForeignValues(Map<String, dynamic> values);
}
