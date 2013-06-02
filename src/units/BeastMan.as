package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;  
	import org.flixel.plugin.photonstorm.*;
	 
	public class BeastMan extends Enemy
	{
		
		public static var isAnnoyed:Boolean = false;
		
		public static var angry:Boolean;
		private var functionCallback:Function;
		
		public function BeastMan(_player:Player, _gibsGroup:FlxGroup, _functionCallback:Function)
		{
			super(_player);
			
			functionCallback = _functionCallback;
			
			immovable = true;
			
			angry = false;
			health = 10;
			attackValue = 2;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			elasticity = 0.5;
			
			makeGraphic(50, 60, 0xff00FF00);
			
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
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			super.hurt(_damagePoints);
			angry = true;
			isAnnoyed = true;
		}
		
		override public function kill():void
		{
			super.kill();
			GameData.isBeastManDead = true;
		}
	}

}