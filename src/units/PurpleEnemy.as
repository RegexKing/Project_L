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
	 
	public class PurpleEnemy extends Enemy
	{
		
		public function PurpleEnemy(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyBars:FlxGroup) 
		{
			super(_player, _map);
			
			patrolSpeed = 160;
			alertSpeed = 500;
			health = 1;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(40, 40, 0xff00FF00);
			width = 40;
			height = 40;
			
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
			super.update();
			
			if (aware)
			{
				this.pathSpeed = 120;
			}
		}	
	}

}