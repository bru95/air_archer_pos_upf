import 'package:air_archer/components/Monster.dart';
import 'package:air_archer/GameLoop.dart';
import 'package:flame/sprite.dart';


class RedMonster extends Monster {

  RedMonster (GameLoop game) : super(game) {
    speed = game.tileSize;
    audio_death = 'death_monster1.wav';

    angrySprite = List<Sprite>();
    angrySprite.add(Sprite("monster/monster_red_angry1.png"));
    angrySprite.add(Sprite("monster/monster_red_angry2.png"));

    hitSprite = List<Sprite>();
    hitSprite.add(Sprite("monster/monster_red_hit1.png"));
    hitSprite.add(Sprite("monster/monster_red_hit2.png"));
    hitSprite.add(Sprite("monster/monster_red_hit3.png"));
  }

}