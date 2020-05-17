import 'dart:ui';
import 'package:air_archer/gameLoop.dart';
import 'package:flame/sprite.dart';

class Background {

  final gameLoop game;
  Sprite bgSprite;
  Rect bgRect;

  Background(this.game) {
    bgSprite = Sprite("background/bg.png");
    bgRect = Rect.fromLTWH(
      0,
      0,
      game.tileSize * 17,
      game.tileSize * 5,
    );
  }

  void render (Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }
}