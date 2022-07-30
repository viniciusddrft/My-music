import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'interfaces/ifilepicker_service.dart';

class FilePickerService implements IfilePickerService {
  @override
  Future<File?> getFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }
}
