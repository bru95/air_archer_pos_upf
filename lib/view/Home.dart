import 'dart:ui';
import 'package:air_archer/BGM.dart';
import 'package:air_archer/GameLoop.dart';
import 'package:flame/sprite.dart';

class Home {
  final GameLoop game;

  Sprite sprite;
  Rect rect;

  Home(this.game) {
    rect = Rect.fromLTWH((game.screenSize.width / 2) - game.tileSize * 2.5,
                                0,
                                game.tileSize * 5,
                                game.tileSize * 5
    );
    sprite = Sprite("ui/home.png");
  }

  void render(Canvas canvas) {
    sprite.renderRect(canvas, rect);
  }

  void start() {
    BGM.play(0, game.soundButton.enable, vol: 0.5);
  }
}