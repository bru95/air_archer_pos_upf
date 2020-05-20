import 'dart:ui';

import 'package:air_archer/View.dart';
import 'package:air_archer/components/Background.dart';
import 'package:air_archer/view/Home.dart';
import 'package:air_archer/view/Lost.dart';
import 'package:air_archer/view/Playing.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';


class GameLoop extends Game {

  View activeView = View.home;

  Size screenSize;
  double tileSize;

  Background background;

  //VIEWS
  Home homeView;
  Playing playingView;
  Lost lostView;

  int score;


  GameLoop() {
    initialize();
  }

  void initialize() async{
    resize(await Flame.util.initialDimensions());

    score = 0;

    background = Background(this);

    homeView = Home(this);
    playingView = Playing(this);
    lostView = Lost(this);
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.height / 5;
  }


  void update (double time) {
    if (activeView == View.home) {
      homeView.update(time);
    } else if (activeView == View.playing) {
      playingView.update(time);
    } else if (activeView == View.lost) {
      lostView.update(time);
    }
  }

  void render(Canvas canvas) {
    background.render(canvas);

    if (activeView == View.home) {
      homeView.render(canvas);
    } else if (activeView == View.playing) {
      playingView.render(canvas);
    } else if (activeView == View.lost) {
      lostView.render(canvas);
    }
  }


  void onStartVerticalDragArcher(DragStartDetails details) {
    playingView.startMoveArcher(details);
  }

  void onVerticalDragArcher(DragUpdateDetails details) {
    playingView.moveArcher(details);
  }

  void onEndVerticalDragArcher(DragEndDetails details) {
    playingView.stopMoveArcher(details);
  }

  void archerShoot(TapUpDetails details){
    if(activeView == View.home || activeView == View.lost) {
      score = 0;
      playingView.start();
      activeView = View.playing;
    } else {
      playingView.shoot(details);
    }
  }

}