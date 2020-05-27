import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class GameValues {

  static bool _soundEnabled = true;
  static Size screenSize;
  static double tileSize;

  static SharedPreferences storage;
  static int gameScore = 0;

  static void restartGameValues () {
    gameScore = 0;
  }

  static void setStorage (SharedPreferences sharedPreferences) {
    storage = sharedPreferences;
  }

  static bool get_soundEnabled() {
    return _soundEnabled;
  }

  static void set_soundEnabled(bool enable) {
    _soundEnabled = enable;
  }
}