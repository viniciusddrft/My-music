import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../../shared/services/filepicker_service.dart';
import '../../shared/services/sound_service.dart';

class HomeController {
  final soundService = SoundService();
  final _ifilePickerService = FilePickerService();
  final ValueNotifier<Duration> durationMusic =
      ValueNotifier<Duration>(Duration.zero);

  final ValueNotifier<Duration> positionMusic =
      ValueNotifier<Duration>(Duration.zero);

  final ValueNotifier<PlayerState> playerState =
      ValueNotifier<PlayerState>(PlayerState.stopped);

  final ValueNotifier<double> volumeMusic = ValueNotifier<double>(1);

  final ValueNotifier<String> nameMusic = ValueNotifier<String>('');

  void playFile() async {
    final File? file = await _ifilePickerService.getFile();

    if (file != null) {
      nameMusic.value = file.path.split('/').last;
      soundService.playFile(file.path);
    }
  }

  void pause() {
    soundService.pause();
  }

  void resume() {
    soundService.resume();
  }

  void playUrl() async {
    soundService.playUrl(
        'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3');
  }

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
