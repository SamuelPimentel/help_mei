import 'dart:math';

import 'package:help_mei/helpers/constantes.dart';

int nextPrimaryKey() {
  var rnd = Random();
  return rnd.nextInt(maxInt32);
}

int generateTodayIdData() {
  DateTime data = DateTime.now();
  String id = '${data.year}${data.month}${data.day}';
  return int.parse(id);
}

int generateIdData(DateTime data) {
  String id = '${data.year}${data.month}${data.day}';
  return int.parse(id);
}
