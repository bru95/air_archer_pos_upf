import 'dart:math';
import 'dart:ui';
import 'package:air_archer/BGM.dart';
import 'package:air_archer/GameLoop.dart';
import 'package:air_archer/components/Archer.dart';
import 'package:air_archer/components/Arrow.dart';
import 'package:air_archer/components/Bird.dart';
import 'package:air_archer/components/HardMonster.dart';
import 'package:air_archer/components/Jelly.dart';
import 'package:air_archer/components/Monster.dart';
import 'package:air_archer/components/PurpleMonster.dart';
import 'package:air_archer/components/RedMonster.dart';
import 'package:air_archer/components/Score.dart';
import 'package:air_archer/controllers/EnemiesController.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';

class Playing {
  final GameLoop game;

  Archer archer;
  List<Arrow> arrows;
  List<Monster> monsters;
  List<Bird> birds;
  List<Jelly> jellies;
  EnemiesController enemiesController;
  Score scoreDisplay;
  Random rnd;

  Playing(this.game) {
    rnd = Random();
    archer = Archer(game);
    monsters = List<Monster>();
    arrows = List<Arrow>();
    birds = List<Bird>();
    jellies = List<Jelly>();
    scoreDisplay = Score(game);
    enemiesController = EnemiesController(this);
  }

  void start() {
    archer.initialize();
    enemiesController.clearAll();
    BGM.play(1, game.soundButton.enable, vol: 0.25);
  }

  void update(double time) {
    enemiesController.newEnemie(time); //verifica se esta na hora de um novo inimigo e determina qual

    //atualiza arqueiro
    archer.update(time);
    if (archer.gone) game.setLostView(); //se archeiro parou de cair, mostra view lost

    //atualiza passarinhos
    birds.forEach((bird) {
      bird.update(time);
    });
    birds.removeWhere((bird) {
      return bird.gone;
    });

    //atualiza as geleias
    jellies.forEach((jelly) {
      jelly.update(time);

      //se alguma geleia acertar o arqueiro, acaba o jogo
      if (jelly.jellyRect.overlaps(archer.archerRect) && !archer.isDead) {
        endGame();
      }

      //se alguma geleia acertar uma flecha, flecha some
      arrows.forEach((arrow) {
        if(jelly.jellyRect.overlaps(arrow.hitRect) && !arrow.gone) {
          arrow.gone = true;
        }
      });
    });
    jellies.removeWhere((jelly) {
      return jelly.gone;
    });

    //atualiza os monstros
    monsters.forEach((monster) {
      monster.update(time);
      //se algum monstro acertar arqueiro acaba o jogo
      if (monster.monsterRect.overlaps(archer.archerRect) && !monster.isDead && !archer.isDead) {
        endGame();
      }
    });
    monsters.removeWhere((monster) {
      return monster.gone;
    });

    //atualiza as flechas
    arrows.forEach((arrow) {
      arrow.update(time);

      //se a flecha acertar algum passarinho acaba o jogo
      birds.forEach((bird) {
        if(arrow.hitRect.overlaps(bird.birdRect) && !archer.isDead) {
          arrow.gone = true;
          endGame();
        }
      });

      //se a flecha acertar um monstro diminui uma vida
      monsters.forEach((monster) {
        if (arrow.hitRect.overlaps(monster.monsterRect) && !monster.isDead) {
          arrow.gone = true;
          bool died = monster.die();
          if(died) {
            monsterDied(monster);
          } else {
            enemiesController.newJelly(monster.monsterRect.left, monster.monsterRect.top, monster.speed);
          }
        }
      });
    });
    arrows.removeWhere((arrow) {
      return arrow.gone;
    });

    scoreDisplay.update(time);
  }

  void monsterDied(Monster monster) {
    if(game.soundButton.enable) {
      Flame.audio.audioCache.play(monster.audio_death, volume: 1.5);
    }
    game.score += 1;
    game.updateHighScore();
    enemiesController.updateLevel();
  }

  void endGame() {
    archer.die();
    if(game.soundButton.enable) {
      Flame.audio.audioCache.play('round_end.mp3', volume: 0.25);
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

    jellies.forEach((jelly) {
      jelly.render(canvas);
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

  void shoot(){
    if(!archer.moving && !archer.isDead) {
      double x = archer.archerRect.left - archer.deltaInflate;
      double y = archer.archerRect.top - archer.deltaInflate;
      arrows.add(Arrow(game, x, y));
    }
  }
}