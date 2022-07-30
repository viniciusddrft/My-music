import 'dart:io';

abstract class IfilePickerService {
  Future<File?> getFile();
}
