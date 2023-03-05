abstract class Entity {
  final String tableName;

  Entity({required this.tableName});

  Map<String, dynamic> toMap();

  Map<String, String> getPrimaryKeys();

  void setPrimaryKeys(Map<String, dynamic> keys);

  Entity fromMap(Map<dynamic, dynamic> map);
}
