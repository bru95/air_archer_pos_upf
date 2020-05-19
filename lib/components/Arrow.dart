import 'dart:ui';
import 'package:air_archer/gameLoop.dart';
import 'package:flame/sprite.dart';

class Arrow {

  final gameLoop game;

  Rect arrowRect;
  Rect hitRect;
  Sprite arrow;

  double speed; //quanto a flecha anda em 1 segundo
  bool gone = false;

  Arrow(this.game, double x, double y) {
    double size = game.tileSize * 1.20;
    arrowRect = Rect.fromLTWH(x, y, size, size);
    hitRect = Rect.fromLTWH(arrowRect.left + (arrowRect.height * 0.5),
                            arrowRect.top + (arrowRect.height * 0.35),
                            arrowRect.width * 0.5,
                            arrowRect.height * 0.15);
    arrow = Sprite("arrow/arrow.png");
    speed = game.tileSize * 3;
  }

  void render(Canvas canvas) {
    //canvas.drawRect(arrowRect, Paint()..color = Color(0x77ffffff));
    //canvas.drawRect(hitRect, Paint()..color = Color(0x88000000));
    arrow.renderRect(canvas, arrowRect);
  }

  void update(double time) {
    double stepDistance = speed * time;
    Offset targetLocation = Offset(game.screenSize.width, arrowRect.top);
    Offset toTarget = targetLocation - Offset(arrowRect.left, arrowRect.top);
    if (stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      arrowRect = arrowRect.shift(stepToTarget);
      hitRect = hitRect.shift(stepToTarget);
    } else {
      arrowRect = arrowRect.shift(toTarget);
      hitRect = hitRect.shift(toTarget);
      gone = true;
    }
  }

}