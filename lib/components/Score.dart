import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:flutter/painting.dart';

class Score {

  final GameLoop game;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  Score(this.game) {
    painter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      fontFamily: 'Cabin_Sketch',
      color: Color(0xffffffff),
      fontSize: 20,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    position = Offset.zero;
  }

  void render(Canvas c) {
    painter.paint(c, position);
  }

  void update(double t) {
    if ((painter.text?.text ?? '') != game.score.toString()) {
      painter.text = TextSpan(
        text: " Score: ${game.score.toString()}",
        style: textStyle,
      );

      painter.layout();
    }
  }
}