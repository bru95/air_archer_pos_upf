import 'dart:ui';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:flame/sprite.dart';

class Background {

  Sprite bgSprite;
  Rect bgRect;

  Background() {
    bgSprite = Sprite("background/bg.png");
    bgRect = Rect.fromLTWH(
      0,
      0,
      GameValues.tileSize * 17,
      GameValues.tileSize * 5,
    );
  }

  void render (Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }
}