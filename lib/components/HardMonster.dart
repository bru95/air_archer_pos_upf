
import 'package:air_archer/components/Monster.dart';
import 'package:air_archer/GameLoop.dart';
import 'package:air_archer/controllers/GameValues.dart';
import 'package:flame/sprite.dart';


class HardMonster extends Monster {

  HardMonster () : super() {
    speed = GameValues.tileSize * 2.5;
    audio_death = 'death_monster3.mp3';
    life = 2; //mais dificil de matar

    angrySprite = List<Sprite>();
    angrySprite.add(Sprite("monster/monster_hard_angry1.png"));
    angrySprite.add(Sprite("monster/monster_hard_angry2.png"));

    hitSprite = List<Sprite>();
    hitSprite.add(Sprite("monster/monster_hard_hit1.png"));
    hitSprite.add(Sprite("monster/monster_hard_hit2.png"));
    hitSprite.add(Sprite("monster/monster_hard_hit3.png"));
  }

}