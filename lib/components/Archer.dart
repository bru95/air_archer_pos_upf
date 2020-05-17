import 'dart:ui';
import 'package:air_archer/gameLoop.dart';
import 'package:flame/sprite.dart';

class Archer {

  final gameLoop game;

  Rect archerRect;
  Sprite shootingSprite;
  List<Sprite> movingSprite;
  List<Sprite> deadSprite;

  double spriteIndex = 0;
  bool moving = false;
  bool isDead = false;

  Archer(this.game) {
    double y = (game.screenSize.height / 2) - (game.tileSize / 2);
    archerRect = Rect.fromLTWH(0, y, game.tileSize * 2, game.tileSize * 2);

    shootingSprite = Sprite("archer/archer_shooting.png");

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
      shootingSprite.renderRect(canvas, archerRect);
    } else {
      movingSprite[spriteIndex.toInt()].renderRect(canvas, archerRect);
    }
  }

  void update(double time) {
    if(moving) {
      spriteIndex += 15 * time;
      spriteIndex = spriteIndex % movingSprite.length;
    } else {
      spriteIndex = 0;
    }
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