import 'dart:ui';
import 'package:air_archer/BGM.dart';
import 'package:air_archer/GameLoop.dart';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:flame/sprite.dart';

class Home {
  Sprite sprite;
  Rect rect;

  Home() {
    rect = Rect.fromLTWH((GameValues.screenSize.width / 2) - GameValues.tileSize * 2.5,
                                0,
                                GameValues.tileSize * 5,
                                GameValues.tileSize * 5
    );
    sprite = Sprite("ui/home.png");
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }

  void start() {
    BGM.play(0, vol: 0.5);
  }
}