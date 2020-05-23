import 'dart:ui';
import 'package:air_archer/GameLoop.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';

class Lost {
  final GameLoop game;

  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  Rect archerLostRect;
  Sprite archerLost;

  Lost(this.game) {
    archerLost = Sprite("archer/archer_lost.png");
    archerLostRect = Rect.fromLTWH((game.screenSize.width / 2) - game.tileSize,
                                    game.screenSize.height - (game.tileSize * 2),
                                    game.tileSize * 2,
                                    game.tileSize * 2);

    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      fontFamily: 'Lobster',
      color: Color(0xffffffff),
      fontSize: 70,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Color(0xff000000),
          offset: Offset(3, 3),
        ),
      ],
    );

    painter.text = TextSpan(
      text: "Você perdeu!",
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
      (game.screenSize.height * .25) - (painter.height / 2),
    );
  }

  void render(Canvas canvas) {
    painter.paint(canvas, position);
    archerLost.renderRect(canvas, archerLostRect);
  }

  void update(double time) {

  }
}