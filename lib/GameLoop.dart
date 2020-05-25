import 'dart:ui';

import 'package:air_archer/BGM.dart';
import 'package:air_archer/View.dart';
import 'package:air_archer/components/Background.dart';
import 'package:air_archer/components/HighScoreDisplay.dart';
import 'package:air_archer/components/SoundButton.dart';
import 'package:air_archer/view/Home.dart';
import 'package:air_archer/view/Lost.dart';
import 'package:air_archer/view/Playing.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GameLoop extends Game {

  View activeView;

  Size screenSize;
  double tileSize;

  Background background;
  HighScoreDisplay highScore;
  SoundButton soundButton;

  final SharedPreferences storage;

  //VIEWS
  Home homeView;
  Playing playingView;
  Lost lostView;

  int score;


  GameLoop(this.storage) {
    initialize();
  }

  void initialize() async{
    resize(await Flame.util.initialDimensions());

    score = 0;

    background = Background(this);
    homeView = Home(this);
    playingView = Playing(this);
    lostView = Lost(this);
    highScore = HighScoreDisplay(this);
    soundButton = SoundButton(this);

    setHomeView();
  }

  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.height / 5;
  }

  void setHomeView() {
    activeView = View.home;
    homeView.start();
  }

  void setPlayingView() {
    activeView = View.playing;
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
      if(soundButton.change()) {
        BGM.resume();
      } else {
        BGM.pause();
      }
      return;
    }

    if(activeView == View.home || activeView == View.lost) {
      score = 0;
      playingView.start();
      setPlayingView();
    } else {
      playingView.shoot();
    }
  }

  void updateHighScore() {
    if (score > (storage.getInt('highscore') ?? 0)) {
      storage.setInt('highscore', score);
      highScore.update();
    }
  }

}