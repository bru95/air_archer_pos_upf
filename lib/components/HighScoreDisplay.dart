import 'dart:ui';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:flutter/painting.dart';

class HighScoreDisplay {

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  HighScoreDisplay() {
    painter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      fontFamily: 'Cabin_Sketch',
      color: Color(0xffffffff),
      fontSize: 20,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;

    update();
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update() {
    int highscore = GameValues.storage.getInt('highscore') ?? 0;

    painter.text = TextSpan(
      text: 'High-score: ' + highscore.toString(),
      style: textStyle,
    );

    painter.layout();

    position = Offset(GameValues.screenSize.width - (painter.width), 0);
  }
}