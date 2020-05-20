import 'dart:math';
import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:flame/sprite.dart';

class Bird {

  final GameLoop game;

  Rect birdRect;
  List<Sprite> birdSprites;
  Offset targetLocation;

  double speed;
  bool gone = false;
  double spriteIndex = 0;

  Bird(this.game) {
    double size = game.tileSize;
    double x = (game.tileSize * 2);
    birdRect = Rect.fromLTWH(x, game.screenSize.height, size, size);
    birdSprites = List<Sprite>();
    birdSprites.add(Sprite("bird/bird_1.png"));
    birdSprites.add(Sprite("bird/bird_2.png"));
    birdSprites.add(Sprite("bird/bird_3.png"));
    birdSprites.add(Sprite("bird/bird_4.png"));
    birdSprites.add(Sprite("bird/bird_5.png"));
    birdSprites.add(Sprite("bird/bird_6.png"));
    speed = game.tileSize * 1.5;

    targetLocation = Offset(game.screenSize.width, 0);
  }

  void render(Canvas canvas) {
    birdSprites[spriteIndex.toInt()].renderRect(canvas, birdRect);
  }

  void update(double time) {
    spriteIndex += 5 * time;
    spriteIndex = spriteIndex % birdSprites.length;

    double stepDistance = speed * time;
    Offset toTarget = targetLocation - Offset(birdRect.left, birdRect.top);
    if (stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      birdRect = birdRect.shift(stepToTarget);
    } else {
      birdRect = birdRect.shift(toTarget);
      gone = true;
    }

  }

}