import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:air_archer/GameLoop.dart';

class Background {

  final GameLoop game;
  Sprite bgSprite;
  Rect bgRect;


  Background(this.game) {
    bgSprite = Sprite("background/bg.png");
    bgRect = Rect.fromLTWH(
      0,
      0,
      game.tileSize * 17.22222,
      game.tileSize * 5,
    );
  }

  void render (Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }
}