import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../../shared/services/filepicker_service.dart';
import '../../shared/services/sound_service.dart';

class HomeController {
  final soundService = SoundService();
  final _ifilePickerService = FilePickerService();
  final durationMusic = ValueNotifier<Duration>(Duration.zero);
  final positionMusic = ValueNotifier<Duration>(Duration.zero);
  final playerState = ValueNotifier<PlayerState>(PlayerState.stopped);
  final volumeMusic = ValueNotifier<double>(1);
  final nameMusic = ValueNotifier<String>('');

  void playFile() async {
    final File? file = await _ifilePickerService.getFile();

    if (file != null) {
      nameMusic.value = file.path.split('/').last;
      soundService.playFile(file.path);
    }
  }

  void pause() => soundService.pause();

  void resume() => soundService.resume();

  void setVolume(double volume) {
    volumeMusic.value = volume;
    soundService.setVolume(volumeMusic.value);
  }

  void changePositionMusic(double seconds) {
    soundService.changePositionMusic(seconds);
  }

  void dispose() {
    soundService.dispose();
    durationMusic.dispose();
    positionMusic.dispose();
    volumeMusic.dispose();
    nameMusic.dispose();
  }
}
