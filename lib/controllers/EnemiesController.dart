import 'dart:math';

import 'package:air_archer/components/Bird.dart';
import 'package:air_archer/components/HardMonster.dart';
import 'package:air_archer/components/Jelly.dart';
import 'package:air_archer/components/PurpleMonster.dart';
import 'package:air_archer/components/RedMonster.dart';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:air_archer/view/Playing.dart';

/**
 * Level 0 - score de 0 até 4 => libera um monstro vermelho a cada 2.5s
 * Level 1 - score de 5 até 9 => libera monstro vermelho ou roxo a cada 2s
 * Level 2 - score de 10 até 14 => libera qualquer monstro a cada 1.5s
 * Level 3 - score de 15 até 19 => libera qualquer monstro ou passarinho a cada 1.5s
 * A partir do level 4 libera qualquer monstro ou passarinho a cada 1.5s com habilidades especiais (geléia)
 *
 * Monstro vermelho (0)
 * Monstro roxo (1)
 * Monstro hard (2)
 * Passarinho (3)
 */

class EnemiesController {

  final Playing playView;
  Random rnd;
  int level = 0;
  int idMonster = 1;

  final int initInterval = 2500;
  int maxMonsterOnScreen = 4;
  int interval;
  int nextSpawn;


  EnemiesController(this.playView) {
    rnd = Random();
    interval = initInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + interval;
  }

  void clearAll() {
    playView.monsters.clear();
    playView.arrows.clear();
    playView.birds.clear();
    playView.jellies.clear();
  }

  void restart() {
    clearAll();
    level = 0;
    idMonster = 1;
    interval = initInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + interval;
  }

  void updateLevel() {
    int nextLevel = (GameValues.gameScore / 5).toInt();
    if(nextLevel > level) {
      level = nextLevel;
      idMonster = level < 4 ? level + 1 : 4;
      interval = level < 3 ? initInterval - (level * 500) : interval;
      maxMonsterOnScreen = level < 2 ? 4 : 7;
    }
  }

  void newEnemy(double time) {
    int nowTimestamp = DateTime.now().millisecondsSinceEpoch;

    int livingMonster = 0;
    playView.monsters.forEach((monster) {
      if (!monster.isDead) livingMonster += 1;
    });

    int nextMonster = rnd.nextInt(idMonster);

    if (nowTimestamp >= nextSpawn && (livingMonster < maxMonsterOnScreen || nextMonster == 3)) {
      switch (nextMonster) {
        case(0):
          playView.monsters.add(RedMonster());
          break;
        case(1):
          playView.monsters.add(PurpleMonster());
          break;
        case(2):
          playView.monsters.add(HardMonster());
          break;
        case(3):
          playView.birds.add(Bird());
          break;
      }
      nextSpawn = nowTimestamp + interval;
    }
  }

  void newJelly(bool ableThrowJelly, double x, double y, double speed) {
    if(level >= 4 && ableThrowJelly) {
      x = x - (GameValues.tileSize / 4);
      playView.jellies.add(Jelly(x, y, speed * 1.5));
    }
  }
}