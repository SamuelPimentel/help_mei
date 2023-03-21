import 'package:help_mei/entities/entity.dart';

abstract class IRelationshipMultiple {
  Map<String, List<Entity>> insertValues();
  Map<Entity, Map<String, String>> relationshipSearchCondition();
  void addRelationshipValues(Map<String, List<Entity>> values);
}
