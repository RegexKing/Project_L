package  units
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	import org.flixel.plugin.photonstorm.FlxBar;
	import maps.*;
	 
	public class Bat extends Enemy
	{
		
		public function Bat(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyBars:FlxGroup,  _itemEmitter:FlxEmitter=null) 
		{
			super(_player, _map,  _itemEmitter);
			
			patrolSpeed = 140;
			alertSpeed = 220;
			health = 2;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			loadGraphic(AssetsRegistry.batPNG, true, true, 64, 64);
			width = 38;
			height = 38;
			offset.x = 18;
			offset.y = 18;
			addAnimation("run", [0, 1, 2, 3], 10);
			play("run");
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
			
		}	
		
		override public function kill():void
		{
			super.kill();
			
			// play sound
			FlxG.play(AssetsRegistry.batDieMP3);
		}
	}

}