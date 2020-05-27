import 'dart:ui';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:flame/sprite.dart';

class Bird {

  Rect birdRect;
  List<Sprite> birdSprites;
  Offset targetLocation;
  double deltaInflate;
  double speed;
  bool gone = false;
  double spriteIndex = 0;

  Bird() {
    double size = GameValues.tileSize * 1.2;
    deltaInflate = size * 0.3;
    double x = (GameValues.tileSize * 2);
    birdRect = Rect.fromLTWH(x,
                            GameValues.screenSize.height,
                            size - (deltaInflate * 2),
                            size - (deltaInflate * 2));

    birdSprites = List<Sprite>();
    birdSprites.add(Sprite("bird/bird_1.png"));
    birdSprites.add(Sprite("bird/bird_2.png"));
    birdSprites.add(Sprite("bird/bird_3.png"));
    birdSprites.add(Sprite("bird/bird_4.png"));
    birdSprites.add(Sprite("bird/bird_5.png"));
    birdSprites.add(Sprite("bird/bird_6.png"));
    speed = GameValues.tileSize * 1.5;

    targetLocation = Offset(GameValues.screenSize.width, 0);
  }

  void render(Canvas canvas) {
    //canvas.drawRect(birdRect.inflate(deltaInflate), Paint()..color = Color(0x77ffffff));
    //canvas.drawRect(birdRect, Paint()..color = Color(0x88000000));
    birdSprites[spriteIndex.toInt()].renderRect(canvas, birdRect.inflate(deltaInflate));
  }

  void update(double time) {
    spriteIndex += 5 * time;
    spriteIndex = spriteIndex % birdSprites.length;

    double stepDistance = speed * time;
    Offset toTarget = targetLocation - Offset(birdRect.left, birdRect.bottom);
    if (stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      birdRect = birdRect.shift(stepToTarget);
    } else {
      birdRect = birdRect.shift(toTarget);
      gone = true;
    }

  }

}