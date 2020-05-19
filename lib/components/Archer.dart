import 'dart:ui';
import 'package:air_archer/gameLoop.dart';
import 'package:flame/sprite.dart';

class Archer {

  final gameLoop game;

  Rect archerRect;
  double deltaInflate;

  Sprite shootingSprite;
  List<Sprite> movingSprite;
  List<Sprite> deadSprite;

  double spriteIndex = 0;
  bool moving = false;
  bool isDead = false;

  Archer(this.game) {
    double size = game.tileSize * 1.20; //ocupar 20% a mais que o tamanho do tile
    deltaInflate = size * 0.2;
    double y = (game.screenSize.height / 2) - (size / 2); //iniciar no meio da tela
    archerRect = Rect.fromLTWH(0 + deltaInflate,
                                y + deltaInflate,
                                size - (deltaInflate * 2),
                                size - (deltaInflate * 2));

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
    //canvas.drawRect(archerRect.inflate(deltaInflate), Paint()..color = Color(0x77ffffff));
    //canvas.drawRect(archerRect, Paint()..color = Color(0x88000000));
    if(!moving) {
      shootingSprite.renderRect(canvas, archerRect.inflate(deltaInflate));
    } else {
      movingSprite[spriteIndex.toInt()].renderRect(canvas, archerRect.inflate(deltaInflate));
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
    if (delta.direction < 0) { //movendo pra cima
      Offset target = Offset(archerRect.left, archerRect.top - deltaInflate) + delta;
      if(target.dy >= 0) { //dentro da tela
        archerRect = archerRect.shift(delta);
      }
    } else if(delta.direction > 0) { //movendo pra baixo
      Offset target = Offset(archerRect.left, archerRect.bottom + deltaInflate) + delta;
      if(target.dy <= game.screenSize.height) { //dentro da tela
        archerRect = archerRect.shift(delta);
      }
    }
  }

  void stopMove(){
    moving = false;
  }

}