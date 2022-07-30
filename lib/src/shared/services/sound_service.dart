import 'package:my_music/src/shared/services/interfaces/isound_service.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService implements IsoundService {
  final _player = AudioPlayer();

  @override
  Stream<PlayerState> get playerState => _player.onPlayerStateChanged;

  @override
  Stream<Duration> get positionState => _player.onPositionChanged;

  @override
  Stream<Duration> get durationState => _player.onDurationChanged;

  @override
  void playUrl(String url) async {
    await _player.play(UrlSource(url));
  }

  @override
  void changePositionMusic(double seconds) async {
    await _player.seek(Duration(seconds: seconds.round()));
  }

  @override
  void playFile(String path) async {
    await _player.play(DeviceFileSource(path));
  }

  @override
  void setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  @override
  void resume() async {
    await _player.resume();
  }

  @override
  void pause() async {
    await _player.pause();
  }

  @override
  void dispose() {
    _player.dispose();
  }
}
