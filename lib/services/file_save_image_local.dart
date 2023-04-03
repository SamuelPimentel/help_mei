import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ImageService {
  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String path = appDocumentsDirectory.path;
    return path;
  }
}
