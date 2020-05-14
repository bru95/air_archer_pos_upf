import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:flame/sprite.dart';

class Archer {

  final GameLoop game;

  Rect archerRect;
  List<Sprite> flyingSprite;
  List<Sprite> movingSprite;
  List<Sprite> deadSprite;

  double spriteIndex = 0;
  bool moving = false;
  bool isDead = false;

  Archer(this.game) {
    double y = (game.screenSize.height / 2) - (game.tileSize / 2);
    archerRect = Rect.fromLTWH(0, y, game.tileSize * 2, game.tileSize * 2);

    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite("archer/archer_shooting4.png"));

    movingSprite = List<Sprite>();
    movingSprite.add(Sprite("archer/archer_moving1.png"));
    movingSprite.add(Sprite("archer/archer_moving2.png"));

    deadSprite = List<Sprite>();
    deadSprite.add(Sprite("archer_dead/archer_dead_1.png"));
    deadSprite.add(Sprite("archer_dead/archer_dead_2.png"));
    deadSprite.add(Sprite("archer_dead/archer_dead_3.png"));
    deadSprite.add(Sprite("archer_dead/archer_dead_4.png"));
    deadSprite.add(Sprite("archer_dead/archer_dead_5.png"));
    deadSprite.add(Sprite("archer_dead/archer_dead_6.png"));
  }

  void render(Canvas canvas) {
    if(!moving) {
      flyingSprite[spriteIndex.toInt()].renderRect(canvas, archerRect);
    }
    else {
      movingSprite[spriteIndex.toInt()].renderRect(canvas, archerRect);
    }
  }

  void update(double time) {
    int lengthArraySprite = 1;
    if(moving) {
      lengthArraySprite = movingSprite.length;
    } else {
      lengthArraySprite = flyingSprite.length;
    }

    spriteIndex += 15 * time;
    spriteIndex = spriteIndex % lengthArraySprite;
  }

  void startMove() {
    moving = true;
  }

  void onMove(Offset delta){
    archerRect = archerRect.shift(delta);
  }

  void stopMove(){
    moving = false;
  }

}