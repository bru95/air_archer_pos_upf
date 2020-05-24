import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:flame/sprite.dart';

class SoundButton {

  final GameLoop game;

  Rect rect;
  Sprite spriteEnable;
  Sprite spriteDisable;
  bool enable = true;

  SoundButton(this.game) {
    rect = Rect.fromLTWH(
      (game.screenSize.width / 2) - (game.tileSize / 2),
      0,
      game.tileSize / 2,
      game.tileSize / 2,
    );
    spriteEnable = Sprite('ui/icon-sound-enabled.png');
    spriteDisable = Sprite('ui/icon-sound-disabled.png');
  }

  void render(Canvas canvas) {
    if (enable) {
      spriteEnable.renderRect(canvas, rect);
    } else {
      spriteDisable.renderRect(canvas, rect);
    }
  }

  void change() {
    enable = !enable;
  }

}