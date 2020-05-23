import 'dart:math';
import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:air_archer/View.dart';
import 'package:air_archer/components/Archer.dart';
import 'package:air_archer/components/Arrow.dart';
import 'package:air_archer/components/Bird.dart';
import 'package:air_archer/components/HardMonster.dart';
import 'package:air_archer/components/HighScoreDisplay.dart';
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
  List<Bird> birds;
  Score scoreDisplay;

  int maxInterval = 3000;
  int nextSpawn;
  Random rnd;

  Playing(this.game) {
    rnd = Random();
    archer = Archer(game);
    monsters = List<Monster>();
    arrows = List<Arrow>();
    birds = List<Bird>();
    scoreDisplay = Score(game);
  }

  void start() {
    archer.initialize();
    monsters.clear();
    arrows.clear();

    nextSpawn = DateTime.now().millisecondsSinceEpoch + maxInterval;
  }

  void update(double time) {
    addMonster(time);

    archer.update(time);
    if (archer.gone) game.activeView = View.lost;

    birds.forEach((bird) {
      bird.update(time);
    });

    monsters.forEach((monster) {
      monster.update(time);
      if (monster.monsterRect.overlaps(archer.archerRect) && !monster.isDead) {
        endGame();
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
          bool died = monster.die();
          if(died) {
            game.score += 1;
            game.updateHighScore();
          }
        }
      });

      birds.forEach((bird) {
        if(arrow.hitRect.overlaps(bird.birdRect)) {
          arrow.gone = true;
          endGame();
        }
      });
    });
    arrows.removeWhere((arrow) {
      return arrow.gone;
    });

    scoreDisplay.update(time);
  }

  void endGame() {
    archer.die();
  }

  void addMonster(double time) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (nowTimestamp >= nextSpawn && !archer.gone) {
      switch(rnd.nextInt(5)) {
        case(0):
          monsters.add(RedMonster(game));
          break;
        case(1):
          monsters.add(PurpleMonster(game));
          break;
        case(2):
          monsters.add(HardMonster(game));
          break;
        case(3):
          birds.add(Bird(game));
          break;

      }
      nextSpawn = nowTimestamp + maxInterval;
    }

  }

  void render(Canvas canvas) {
    archer.render(canvas);

    arrows.forEach((arrow) {
      arrow.render(canvas);
    });

    birds.forEach((bird) {
      bird.render(canvas);
    });

    monsters.forEach((monster) {
      monster.render(canvas);
    });

    scoreDisplay.render(canvas);
  }


  void startMoveArcher(DragStartDetails details) {
    archer.startMove();
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