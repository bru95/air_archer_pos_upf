import 'dart:ui';

import 'package:air_archer/BGM.dart';
import 'package:air_archer/View.dart';
import 'package:air_archer/components/Background.dart';
import 'package:air_archer/components/HighScoreDisplay.dart';
import 'package:air_archer/components/SoundButton.dart';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:air_archer/view/Home.dart';
import 'package:air_archer/view/Lost.dart';
import 'package:air_archer/view/Playing.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';


class GameLoop extends Game {

  View activeView;

  Background background;
  HighScoreDisplay highScore;
  SoundButton soundButton;

  //VIEWS
  Home homeView;
  Playing playingView;
  Lost lostView;

  GameLoop() {
    initialize();
  }

  void initialize() async{
    resize(await Flame.util.initialDimensions());

    background = Background();
    homeView = Home();
    playingView = Playing(this);
    lostView = Lost();
    highScore = HighScoreDisplay();
    soundButton = SoundButton();

    setHomeView();
  }

  void resize(Size size) {
    GameValues.screenSize = size;
    GameValues.tileSize = GameValues.screenSize.height / 5;
  }

  void setHomeView() {
    activeView = View.home;
    homeView.start();
  }

  void setPlayingView() {
    activeView = View.playing;
    GameValues.restartGameValues();
    playingView.start();
  }

  void setLostView() {
    activeView = View.lost;
    lostView.start();
  }


  void update (double time) {
    if (activeView == View.playing) {
      playingView.update(time);
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

    highScore.render(canvas);
    soundButton.render(canvas);
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

  void onTapUp(TapUpDetails details){
    if(soundButton.rect.contains(details.globalPosition)) {
      soundButton.change();
      return;
    }

    if(activeView == View.home || activeView == View.lost) {
      setPlayingView();
    } else {
      playingView.shoot();
    }
  }

  void updateHighScore() {
    if (GameValues.gameScore > (GameValues.storage.getInt('highscore') ?? 0)) {
      GameValues.storage.setInt('highscore', GameValues.gameScore);
      highScore.update();
    }
  }

}