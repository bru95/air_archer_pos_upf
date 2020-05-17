import 'dart:ui';
import 'package:air_archer/gameLoop.dart';
import 'package:flame/sprite.dart';

class Arrow {

  final gameLoop game;

  Rect arrowRect;
  Sprite arrow;

  double speed; //quanto a flecha anda em 1 segundo
  bool gone = false;

  Arrow(this.game, double x, double y) {
    arrowRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    arrow = Sprite("arrow/arrow.png");
    speed = game.tileSize * 3;
  }

  void render(Canvas canvas) {
   arrow.renderRect(canvas, arrowRect);
  }

  void update(double time) {
    double stepDistance = speed * time;
    Offset targetLocation = Offset(game.screenSize.width, arrowRect.top);
    Offset toTarget = targetLocation - Offset(arrowRect.left, arrowRect.top);
    if (stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      arrowRect = arrowRect.shift(stepToTarget);
    } else {
      arrowRect = arrowRect.shift(toTarget);
      gone = true;
    }
  }

}