import 'dart:math';
import 'dart:ui';
import 'package:air_archer/BGM.dart';
import 'package:air_archer/GameLoop.dart';
import 'package:air_archer/components/Archer.dart';
import 'package:air_archer/components/Arrow.dart';
import 'package:air_archer/components/Bird.dart';
import 'package:air_archer/components/Jelly.dart';
import 'package:air_archer/components/Monster.dart';
import 'package:air_archer/components/Score.dart';
import 'package:air_archer/components/SoundButton.dart';
import 'package:air_archer/controllers/EnemiesController.dart';
import 'package:air_archer/controllers/GameValues.dart';
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
    archer = Archer();
    monsters = List<Monster>();
    arrows = List<Arrow>();
    birds = List<Bird>();
    jellies = List<Jelly>();
    scoreDisplay = Score();
    enemiesController = EnemiesController(this);
  }

  void start() {
    archer.initialize();
    enemiesController.restart();
    BGM.play(1, vol: 0.25);
  }

  void update(double time) {
    //atualiza arqueiro
    archer.update(time);
    if (archer.gone) game.setLostView(); //se archeiro parou de cair, mostra view lost

    //verifica se esta na hora de um novo inimigo e determina qual
    enemiesController.newEnemy(time);

    //tira da lista (tela) tudo o que ja sumiu
    arrows.removeWhere((arrow) {
      return arrow.gone;
    });
    jellies.removeWhere((jelly) {
      return jelly.gone;
    });
    monsters.removeWhere((monster) {
      return monster.gone;
    });
    birds.removeWhere((bird) {
      return bird.gone;
    });

    //atualiza passarinhos
    birds.forEach((bird) {
      bird.update(time);
    });

    //atualiza monstros
    monsters.forEach((monster) {
      monster.update(time);

      //se monstro atingir arqueiro acaba jogo
      if (monster.monsterRect.overlaps(archer.archerRect) && !monster.isDead && !archer.isDead) {
        endGame();
      }
    });

    //atualiza flechas
    arrows.forEach((arrow) {
      arrow.update(time);

      birds.forEach((bird) {
        if(arrow.hitRect.overlaps(bird.birdRect) && !archer.isDead) {
          arrow.gone = true;
          endGame();
        }
      });

      //se a flecha atingir alguma geleia, flecha some
      jellies.forEach((jelly) {
        if(jelly.jellyRect.overlaps(arrow.hitRect) && !arrow.gone) {
          arrow.gone = true;
        }
      });

      //se flecha atingir algum monstro, mostro perde uma vida
      monsters.forEach((monster) {
        if (arrow.hitRect.overlaps(monster.monsterRect) && !monster.isDead && !arrow.gone) {
          arrow.gone = true;
          bool died = monster.die();
          if(died) {
            monsterDied(monster);
          } else {
            enemiesController.newJelly(monster.jelly,
                                      monster.monsterRect.left - monster.deltaInflate,
                                      monster.monsterRect.top - monster.deltaInflate,
                                      monster.speed);
          }
        }
      });
    });

    //atualiza geleias
    jellies.forEach((jelly) {
      jelly.update(time);

      //se geleia acertar arqueiro, acaba jogo
      if (jelly.jellyRect.overlaps(archer.archerRect) && !archer.isDead) {
        endGame();
      }
    });

    scoreDisplay.update(time);
  }

  void monsterDied(Monster monster) {
    if(GameValues.get_soundEnabled()) {
      Flame.audio.audioCache.play(monster.audio_death, volume: 1.5);
    }
    GameValues.gameScore += 1;
    game.updateHighScore();
    enemiesController.updateLevel();
  }

  void endGame() {
    archer.die();
    if(GameValues.get_soundEnabled()) {
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

    jellies.forEach((jelly) {
      jelly.render(canvas);
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

  void shoot(){
    if(!archer.moving && !archer.isDead) {
      //x e y da flecha calculado levando em consideração o inflate
      double x = archer.archerRect.left - archer.deltaInflate;
      double y = archer.archerRect.top - archer.deltaInflate;
      arrows.add(Arrow(x, y));
    }
  }
}