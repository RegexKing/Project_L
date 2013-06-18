package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;  
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import com.newgrounds.API;
	 
	public class BeastMan extends Enemy
	{
		
		public static var isAnnoyed:Boolean = false;
		
		public static var angry:Boolean;
		private var functionCallback:Function;
		
		public function BeastMan(_player:Player, _gibsGroup:FlxGroup, _functionCallback:Function, _enemyBars:FlxGroup)
		{
			super(_player);
			
			functionCallback = _functionCallback;
			
			immovable = true;
			
			angry = false;
			health = 12;
			attackValue = 3;
			
			health = GameUtil.beast_scaleHealth(health);
			attackValue = GameUtil.beast_scaleDamage(attackValue);
			
			elasticity = 0.5;
			
			loadGraphic(AssetsRegistry.beastPNG, true, true, 96, 96);
			width = 36;
			height = 56;
			offset.x = 30;
			offset.y = 20;
			addAnimation("idle", [24, 25, 26, 27], 5);
			addAnimation("run", [16, 17, 18, 19, 20, 21, 22, 23], 10);
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
		}
		
		override public function update():void
		{
			if (angry && player.active)
			{
				FlxVelocity.moveTowardsObject(this, player, 160);
			}
			
			else if (justTouched(FLOOR) || justTouched(CEILING) || justTouched(LEFT) || justTouched(RIGHT))
			{
				//function callback to dialogue box
				functionCallback("beast");
			}
			
			if (velocity.x == 0 && velocity.y == 0) play("idle");
			else play("run");
			
			// change facing
			if (velocity.x <= 0) _facing = LEFT;
			else _facing = RIGHT;
		}
		
		public function closeToPlayer():Boolean
		{
			if (FlxVelocity.distanceBetween(this, player) <= this.height * 2 && !angry)
			{
				return true;
			}
			
			else return false;
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			super.hurt(_damagePoints);
			angry = true;
			isAnnoyed = true;
			
			//unlock medal
			API.unlockMedal("Terrible Friend");
		}
		
		override public function kill():void
		{
			super.kill();
			GameData.isBeastManDead = true;
			
			//play sound
			FlxG.play(AssetsRegistry.beastDieMP3);
			
			//unlock medal
			API.unlockMedal("You Bastard!");
		}
	}

}