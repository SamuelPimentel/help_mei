import 'dart:math';

import 'package:help_mei/helpers/constantes.dart';

int nextPrimaryKey() {
  var rnd = Random();
  return rnd.nextInt(maxInt32);
}
