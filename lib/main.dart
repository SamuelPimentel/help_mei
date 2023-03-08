import 'dart:io';

import 'package:flutter/material.dart';
import 'package:help_mei/pages/home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'colors.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    home: HomePage(),
    theme: buildTheme(),
  ));
}

ThemeData buildTheme() {
  ThemeData base = ThemeData.dark();
  return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: periwinle,
        secondary: maize,
      ),
      scaffoldBackgroundColor: vanDykePaper,
      primaryColor: periwinle);
}
