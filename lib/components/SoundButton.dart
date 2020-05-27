import 'dart:ui';
import 'package:air_archer/BGM.dart';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:flame/sprite.dart';

class SoundButton {

  Rect rect;
  Sprite spriteEnable;
  Sprite spriteDisable;

  SoundButton() {
    rect = Rect.fromLTWH(
      (GameValues.screenSize.width / 2) - (GameValues.tileSize / 2),
      0,
      GameValues.tileSize / 2,
      GameValues.tileSize / 2,
    );
    spriteEnable = Sprite('ui/icon-sound-enabled.png');
    spriteDisable = Sprite('ui/icon-sound-disabled.png');
  }

  void render(Canvas canvas) {
    if (GameValues.get_soundEnabled()) {
      spriteEnable.renderRect(canvas, rect);
    } else {
      spriteDisable.renderRect(canvas, rect);
    }
  }

  void change() {
    bool sound = !GameValues.get_soundEnabled();
    GameValues.set_soundEnabled(sound);
    if(sound) {
      BGM.resumeMusic();
    } else {
      BGM.pauseMusic();
    }
  }

}