package  units
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import maps.Dungeon;
	 
	public class PurpleEnemy extends Enemy
	{
		
		public function PurpleEnemy(_player:Player, _dungeon:Dungeon, _gibsGroup:FlxGroup) 
		{
			super(_player, _dungeon, _gibsGroup);
			
			speed = 50;
			health = 2;
			attackValue = 2;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(20, 20, 0xff00FF00);
			width = 20;
			height = 20;
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 100, 10, true, 0.5);
			
		}	
		
	}

}