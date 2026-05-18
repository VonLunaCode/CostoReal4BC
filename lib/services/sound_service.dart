import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService instance = SoundService._();
  SoundService._();

  AudioPlayer? _player;

  Future<void> playAlarm() async {
    await _player?.dispose();
    _player = AudioPlayer();
    await _player!.setReleaseMode(ReleaseMode.loop);
    await _player!.play(AssetSource('sounds/alarm.mp3'));
  }

  Future<void> stop() async {
    await _player?.stop();
    await _player?.dispose();
    _player = null;
  }
}
