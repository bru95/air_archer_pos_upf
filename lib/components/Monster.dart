import 'dart:math';
import 'dart:ui';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:flame/sprite.dart';

class Monster {

  Rect monsterRect;
  double deltaInflate;
  List<Sprite> angrySprite;
  List<Sprite> hitSprite;
  List<Sprite> deadSprite;
  String audio_death;

  double speed; //quanto o monstro anda em 1 segundo
  int life = 1;
  double spriteIndex = 0;
  bool isDead = false;
  bool gone = false;
  bool jelly = false;

  //ocupa um tile
  Monster() {
    Random rnd = Random();
    deltaInflate = GameValues.tileSize * 0.18; //quanto vai ser diminuido do tile para depois ser inflado
    double y = rnd.nextDouble() * (GameValues.screenSize.height - GameValues.tileSize); // coordenada y aleatória
    //soma-se o deltainflate para que não "saia" dos limites da tela quando renderiza
    monsterRect = Rect.fromLTWH(GameValues.screenSize.width + deltaInflate,
                                y + deltaInflate,
                                GameValues.tileSize - (deltaInflate * 2),
                                GameValues.tileSize - (deltaInflate * 2));

    deadSprite = List<Sprite>();
    deadSprite.add(Sprite("dead_effect/dead_1.png"));
    deadSprite.add(Sprite("dead_effect/dead_2.png"));
    deadSprite.add(Sprite("dead_effect/dead_3.png"));
    deadSprite.add(Sprite("dead_effect/dead_4.png"));
    deadSprite.add(Sprite("dead_effect/dead_5.png"));
    deadSprite.add(Sprite("dead_effect/dead_6.png"));
  }

  void restartPosition() {
    monsterRect = monsterRect.shift(Offset(GameValues.screenSize.width, 0));
  }

  void render(Canvas canvas) {
    //canvas.drawRect(monsterRect.inflate(deltaInflate), Paint()..color = Color(0x77ffffff));
    //canvas.drawRect(monsterRect, Paint()..color = Color(0x88000000));
    if (isDead) {
      deadSprite[spriteIndex.toInt()].renderRect(canvas, monsterRect.inflate(deltaInflate));
    } else if(life == 2){
      angrySprite[spriteIndex.toInt()].renderRect(canvas, monsterRect.inflate(deltaInflate));
    } else if(life == 1){
      hitSprite[spriteIndex.toInt()].renderRect(canvas, monsterRect.inflate(deltaInflate));
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
      spriteIndex = spriteIndex % (deadSprite.length + 1); //gerar um indice a mais para saber se ja acabou o efeito de morte
      if(spriteIndex >= deadSprite.length) {
        spriteIndex -= 1;
        gone = true;
      }
    }
  }

  bool die() {
    life = life - 1;
    if(life == 0) {
      spriteIndex = 0;
      isDead = true;
      return true;
    }
    return false;
  }

}