import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:flame/sprite.dart';

class Jelly {

  final GameLoop game;

  Rect jellyRect;
  List<Sprite> jellySprites;
  Offset targetLocation;
  double speed;
  double deltaInflate;
  bool gone = false;
  double spriteIndex = 0;

  Jelly(this.game, double x, double y, this.speed) {
    double size = game.tileSize * 0.5;
    deltaInflate = size * 0.3;
    jellyRect = Rect.fromLTWH(x, y, size - (deltaInflate * 2), size - (deltaInflate * 2));
    jellySprites = List<Sprite>();
    jellySprites.add(Sprite("jelly/jelly_1.png"));
    jellySprites.add(Sprite("jelly/jelly_2.png"));
    jellySprites.add(Sprite("jelly/jelly_3.png"));
    jellySprites.add(Sprite("jelly/jelly_4.png"));

    targetLocation = Offset(0, y);
  }

  void render(Canvas canvas) {
    canvas.drawRect(jellyRect.inflate(deltaInflate), Paint()..color = Color(0x77ffffff));
    canvas.drawRect(jellyRect, Paint()..color = Color(0x88000000));
    jellySprites[spriteIndex.toInt()].renderRect(canvas, jellyRect.inflate(deltaInflate));
  }

  void update(double time) {
    spriteIndex += 10 * time;
    spriteIndex = spriteIndex % jellySprites.length;

    double stepDistance = speed * time;
    Offset toTarget = targetLocation - Offset(jellyRect.left, jellyRect.top);
    if (stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      jellyRect = jellyRect.shift(stepToTarget);
    } else {
      jellyRect = jellyRect.shift(toTarget);
      gone = true;
    }

  }

}