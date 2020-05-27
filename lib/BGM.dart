import 'package:air_archer/controllers/GameValues.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class BGM {
  static List _tracks = List();
  static int _currentTrack = -1;
  static bool _ableToPlay = true;
  static _BGMWidgetsBindingObserver _bgmwbo;

  static _BGMWidgetsBindingObserver get widgetsBindingObserver {
    if (_bgmwbo == null) {
      _bgmwbo = _BGMWidgetsBindingObserver();
    }
    return _bgmwbo;
  }

  static Future add(String filename) async {
    AudioCache newTrack = AudioCache(prefix: 'audio/', fixedPlayer: AudioPlayer());
    await newTrack.load(filename);
    await newTrack.fixedPlayer.setReleaseMode(ReleaseMode.LOOP);
    _tracks.add(newTrack);
  }

  static void remove(int trackIndex) async {
    if (trackIndex >= _tracks.length) {
      return;
    }

    if (GameValues.get_soundEnabled()) {
      if (_currentTrack == trackIndex) {
        await _stop(); // se estiver tocando a musica que deseja remover, para a musica
      }
      if (_currentTrack > trackIndex) {
        _currentTrack -= 1; //atualiza indice se a musica a remover estiver "para trás no array"
      }
    }
    _tracks.removeAt(trackIndex); //remove
  }

  static Future _update() async {
    if (_currentTrack == -1) {
      return;
    }

    print ("able ${_ableToPlay} sound ${GameValues.get_soundEnabled()}");
    if (_ableToPlay && GameValues.get_soundEnabled()) {
      await _tracks[_currentTrack].fixedPlayer.resume();
    } else {
      await _tracks[_currentTrack].fixedPlayer.pause();
    }
  }

  static void removeAll() {
    if (GameValues.get_soundEnabled()) {
      _stop();
    }
    _tracks.clear();
  }

  static Future play(int trackIndex, {double vol = 1.0}) async {
    if (_currentTrack == trackIndex && GameValues.get_soundEnabled()) {
      return;
    }

    if (GameValues.get_soundEnabled()) {
      await _stop();
      GameValues.set_soundEnabled(true);
    }

    _currentTrack = trackIndex;
    //GameValues.set_soundEnabled(true);
    AudioCache t = _tracks[_currentTrack];
    await t.loop(t.loadedFiles.keys.first, volume: vol);
    _update();
  }

  static Future _stop() async {
    if(_currentTrack > -1) {
      await _tracks[_currentTrack].fixedPlayer.stop();
      _currentTrack = -1;
    }
    GameValues.set_soundEnabled(false);
  }

  static resumeMusic() { //dá play na musica que estava
    if (_currentTrack > -1) {
      _update();
    }
  }

  static pauseMusic() async { //dá play na musica que estava
    if (_currentTrack > -1) {
      await _tracks[_currentTrack].fixedPlayer.stop();
      _update();
    }
  }

  static void onPause() {
    _ableToPlay = false;
    _update();
  }

  static void onResume() {
    _ableToPlay = true;
    _update();
  }

  static void attachWidgetBindingListener() {
    WidgetsBinding.instance.addObserver(BGM.widgetsBindingObserver);
  }
}

class _BGMWidgetsBindingObserver extends WidgetsBindingObserver {
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      BGM.onResume();
    } else {
      BGM.onPause();
    }
  }
}