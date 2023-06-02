import 'dart:io';

abstract interface class IfilePickerService {
  Future<File?> getFile();
}
