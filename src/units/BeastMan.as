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
		
		public var angry:Boolean;
		
		public function BeastMan(_player:Player, _gibsGroup:FlxGroup) 
		{
			super(_player);
			
			immovable = true;
			
			angry = false;
			health = 15;
			attackValue = 2;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(25, 30, 0xff00FF00);
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
		}
		
		override public function update():void
		{
			if (angry)
			{
				FlxVelocity.moveTowardsObject(this, player, 80);
			}
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			super.hurt(_damagePoints);
			angry = true;
		}
		
		override public function kill():void
		{
			super.kill();
			GameData.isBeastManDead = true;
		}
	}

}