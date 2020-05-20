import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:air_archer/View.dart';
import 'package:air_archer/components/Archer.dart';
import 'package:air_archer/components/Arrow.dart';
import 'package:air_archer/components/Monster.dart';
import 'package:air_archer/components/PurpleMonster.dart';
import 'package:air_archer/components/RedMonster.dart';
import 'package:air_archer/components/Score.dart';
import 'package:flutter/gestures.dart';

class Playing {
  final GameLoop game;

  Archer archer;
  List<Arrow> arrows;
  List<Monster> monsters;
  Score scoreDisplay;

  int maxInterval = 2000;
  int nextSpawn;


  Playing(this.game) {
    archer = Archer(game);
    monsters = List<Monster>();
    arrows = List<Arrow>();
    scoreDisplay = Score(game);
  }

  void start() {
    archer.initialize();
    monsters.clear();
    arrows.clear();

    nextSpawn = DateTime.now().millisecondsSinceEpoch + maxInterval;
  }

  void update(double time) {
    addMonster();

    archer.update(time);
    if (archer.gone) game.activeView = View.lost;

    monsters.forEach((monster) {
      monster.update(time);
      if (monster.monsterRect.overlaps(archer.archerRect) && !monster.isDead) {
        archer.die();
      }
    });
    monsters.removeWhere((monster) {
      return monster.gone;
    });

    arrows.forEach((arrow) {
      arrow.update(time);

      monsters.forEach((monster) {
        if (arrow.hitRect.overlaps(monster.monsterRect) && !monster.isDead) {
          arrow.gone = true;
          monster.die();
        }
      });
    });
    arrows.removeWhere((arrow) {
      return arrow.gone;
    });

    scoreDisplay.update(time);
  }

  void addMonster() {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (nowTimestamp >= nextSpawn) {
      if(game.score >= 3) {
        monsters.add(PurpleMonster(game));
      } else {
        monsters.add(RedMonster(game));
      }
      nextSpawn = nowTimestamp + maxInterval;
    }
  }

  void render(Canvas canvas) {
    archer.render(canvas);

    arrows.forEach((arrow) {
      arrow.render(canvas);
    });

    monsters.forEach((monster) {
      monster.render(canvas);
    });

    scoreDisplay.render(canvas);
  }


  void startMoveArcher(DragStartDetails details) {
    if(archer.archerRect.contains(details.globalPosition)) {
      archer.startMove();
    }
  }

  void moveArcher(DragUpdateDetails details) {
    if(archer.moving) {
      archer.onMove(details.delta);
    }
  }

  void stopMoveArcher(DragEndDetails details) {
    archer.stopMove();
  }

  void shoot(TapUpDetails details){
    if(!archer.moving && !archer.isDead) {
      double x = archer.archerRect.left - archer.deltaInflate;
      double y = archer.archerRect.top - archer.deltaInflate;
      arrows.add(Arrow(game, x, y));
    }
  }
}