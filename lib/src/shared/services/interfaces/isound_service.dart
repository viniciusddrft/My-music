abstract interface class IsoundService {
  Stream get playerState;
  Stream<Duration> get positionState;
  Stream<Duration> get durationState;

  void dispose();
  void playUrl(String url);
  void playFile(String path);
  void changePositionMusic(double seconds);
  void setVolume(double volume);
  void pause();
  void resume();
}
