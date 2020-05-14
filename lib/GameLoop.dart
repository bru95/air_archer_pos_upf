import 'dart:ui';

import 'package:air_archer/components/Archer.dart';
import 'package:air_archer/components/Arrow.dart';
import 'package:air_archer/components/Background.dart';
import 'package:air_archer/components/HardMonster.dart';
import 'package:air_archer/components/Monster.dart';
import 'package:air_archer/components/PurpleMonster.dart';
import 'package:air_archer/components/RedMonster.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';


class GameLoop extends Game {

  Size screenSize;
  double tileSize;
  Background background;
  Archer archer;
  List<Arrow> arrows;
  List<Monster> monsters;

  GameLoop() {
    initialize();
  }

  void initialize() async {
    resize(await Flame.util.initialDimensions());

    background = Background(this);
    archer = Archer(this);
    monsters = List<Monster>();
    arrows = List<Arrow>();

    //USAR UMA LOGICA PARA DISPARO DOS MONSTROS
    monsters.add(RedMonster(this));
    monsters.add(PurpleMonster(this));
    monsters.add(HardMonster(this));
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.height / 5;
  }


  void update (double time) {
    archer.update(time);

    monsters.forEach((monster) {
      monster.update(time);
    });
    monsters.removeWhere((monster) {
      return monster.gone;
    });

    arrows.forEach((arrow) {
      arrow.update(time);

      monsters.forEach((monster) {
        if (arrow.arrowRect.overlaps(monster.monsterRect) && !monster.isDead) {
          arrow.gone = true;
          monster.die();
        }
      });
    });
    arrows.removeWhere((arrow) {
      return arrow.gone;
    });
  }

  void render(Canvas canvas) {
    background.render(canvas);

    archer.render(canvas);

    arrows.forEach((arrow) {
      arrow.render(canvas);
    });

    monsters.forEach((monster) {
      monster.render(canvas);
    });
  }

  void onStartVerticalDragArcher(DragStartDetails details) {
    if(archer.archerRect.contains(details.globalPosition)) {
      archer.startMove();
    }
  }

  void onVerticalDragArcher(DragUpdateDetails details) {
    if(archer.moving) {
      archer.onMove(details.delta);
    }
  }

  void onEndVerticalDragArcher(DragEndDetails details) {
    archer.stopMove();
  }

  void shoot(TapUpDetails details){
    if(!archer.moving) {
      double y = (archer.archerRect.top + archer.archerRect.bottom) / 2;
      arrows.add(Arrow(this, archer.archerRect.left + tileSize, y));
    }
  }

}