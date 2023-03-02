abstract class Entity {
  final String tableName;

  Entity({required this.tableName});

  Map<String, dynamic> toMap();

  Map<String, String> getPrimaryKeys();

  Entity fromMap(Map<dynamic, dynamic> map);
}
