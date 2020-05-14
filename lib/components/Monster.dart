import 'dart:math';
import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:flame/sprite.dart';

class Monster {

  final GameLoop game;

  Rect monsterRect;
  List<Sprite> angrySprite;
  List<Sprite> hitSprite;
  List<Sprite> deadSprite;

  double speed; //quanto o monstro anda em 1 segundo
  int life = 1;
  double spriteIndex = 0;
  bool isDead = false;
  bool gone = false;

  Monster(this.game) {
    Random rnd = Random();
    double y = rnd.nextDouble() * (game.screenSize.height - game.tileSize);
    monsterRect = Rect.fromLTWH(game.screenSize.width, y, game.tileSize, game.tileSize);

    deadSprite = List<Sprite>();
    deadSprite.add(Sprite("dead_effect/dead_1.png"));
    deadSprite.add(Sprite("dead_effect/dead_2.png"));
    deadSprite.add(Sprite("dead_effect/dead_3.png"));
    deadSprite.add(Sprite("dead_effect/dead_4.png"));
    deadSprite.add(Sprite("dead_effect/dead_5.png"));
    deadSprite.add(Sprite("dead_effect/dead_6.png"));
  }

  void restartPosition() {
    monsterRect = Rect.fromLTWH(game.screenSize.width, monsterRect.top, game.tileSize, game.tileSize);
  }

  void render(Canvas canvas) {
    if (isDead) {
      deadSprite[spriteIndex.toInt()].renderRect(canvas, monsterRect);
    } else if(life == 2){
      angrySprite[spriteIndex.toInt()].renderRect(canvas, monsterRect);
    } else if(life == 1){
      hitSprite[spriteIndex.toInt()].renderRect(canvas, monsterRect);
    }
  }

  void update(double time) {
    if(!isDead) {
      double stepDistance = speed * time;
      Offset targetLocation = Offset(0, monsterRect.top);
      Offset toTarget = targetLocation - Offset(monsterRect.right, monsterRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        monsterRect = monsterRect.shift(stepToTarget);
      } else {
        monsterRect = monsterRect.shift(toTarget);
        restartPosition();
      }
      spriteIndex += 15 * time;
      switch(life) {
        case 2:
          spriteIndex = spriteIndex % angrySprite.length;
          break;
        case 1:
          spriteIndex = spriteIndex % hitSprite.length;
          break;
        default:
          spriteIndex = spriteIndex % hitSprite.length;
          break;
      }
    } else {
      spriteIndex += 10 * time;
      spriteIndex = spriteIndex % (deadSprite.length + 1);
      if(spriteIndex >= deadSprite.length) {
        gone = true;
      }
    }
  }

  void die() {
    life = life - 1;
    if(life == 0) {
      spriteIndex = 0;
      isDead = true;
    }
  }

}