import 'package:air_archer/components/Monster.dart';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:flame/sprite.dart';


class PurpleMonster extends Monster {

  PurpleMonster () : super() {
    speed = GameValues.tileSize * 1.5;
    audio_death = 'death_monster2.mp3';
    life = 2; //mais dificil de matar
    jelly = true; //tem o poder de jogar geleia

    angrySprite = List<Sprite>();
    angrySprite.add(Sprite("monster/monster_purple_angry1.png"));
    angrySprite.add(Sprite("monster/monster_purple_angry2.png"));

    hitSprite = List<Sprite>();
    hitSprite.add(Sprite("monster/monster_purple_hit1.png"));
    hitSprite.add(Sprite("monster/monster_purple_hit2.png"));
    hitSprite.add(Sprite("monster/monster_purple_hit3.png"));
  }

}