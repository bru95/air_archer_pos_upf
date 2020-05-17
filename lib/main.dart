import 'package:air_archer/gameLoop.dart';
import 'package:flutter/material.dart';
import 'package:flame/util.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/flame.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  Util flameUtil = Util();
  await flameUtil.setOrientation(DeviceOrientation.landscapeLeft);
  await flameUtil.fullScreen();

  Flame.images.loadAll(<String>[
    'background/bg.png',
    'archer/archer_shooting.png',
    'archer/archer_moving1.png',
    'archer/archer_moving2.png',
    'archer_dead/archer_dead_1.png',
    'archer_dead/archer_dead_2.png',
    'archer_dead/archer_dead_3.png',
    'archer_dead/archer_dead_4.png',
    'archer_dead/archer_dead_5.png',
    'archer_dead/archer_dead_6.png',
    'monster/monster_purple_angry1.png',
    'monster/monster_purple_angry2.png',
    'monster/monster_purple_hit1.png',
    'monster/monster_purple_hit2.png',
    'monster/monster_purple_hit3.png',
    'monster/monster_red_angry1.png',
    'monster/monster_red_angry2.png',
    'monster/monster_red_hit1.png',
    'monster/monster_red_hit2.png',
    'monster/monster_red_hit3.png',
    'monster/monster_hard_angry1.png',
    'monster/monster_hard_angry2.png',
    'monster/monster_hard_hit1.png',
    'monster/monster_hard_hit2.png',
    'monster/monster_hard_hit3.png',
    'arrow/arrow.png',
    'dead_effect/dead_1.png',
    'dead_effect/dead_2.png',
    'dead_effect/dead_3.png',
    'dead_effect/dead_4.png',
    'dead_effect/dead_5.png',
    'dead_effect/dead_6.png'
  ]);

  gameLoop game = gameLoop();

  runApp(game.widget);

  VerticalDragGestureRecognizer dragRecognizer = VerticalDragGestureRecognizer();
  dragRecognizer.onStart = game.onStartVerticalDragArcher;
  dragRecognizer.onUpdate = game.onVerticalDragArcher;
  dragRecognizer.onEnd = game.onEndVerticalDragArcher;
  flameUtil.addGestureRecognizer(dragRecognizer);

  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapUp = game.shoot;
  flameUtil.addGestureRecognizer(tapper);
}