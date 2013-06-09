package units 
{
	import org.flixel.plugin.photonstorm.FlxDelay;
	import maps.Map;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Skeleton extends Enemy
	{
		
		private var deaths:uint;
		private var ressurectDelay:FlxDelay;
		
		public function Skeleton(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyLifeBars:FlxGroup) 
		{
			super(_player, _map, _enemyLifeBars);
			
			deaths = 0;
			
			patrolSpeed = 160;
			alertSpeed = 200;
			health = 1;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(40, 40, 0xff00FF00);
			width = 40;
			height = 40;
	
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
		}
		
		override public function update():void
		{
			if (solid) super.update();
			
			else
			{
				if (this.path != null) 
				{
					destroyPath();
					//play death animation
				}
			}
		}
		
		override public function kill():void
		{
			
			deaths++;
			
			if (deaths < 2)
			{
				solid = false;
				
				ressurectDelay = new FlxDelay(3000);
				ressurectDelay.callback = ressurect;
				ressurectDelay.start();
			}
			
			else super.kill();
		}
		
		protected function ressurect():void
		{
			health = 1;
			health = GameUtil.scaleHealth(health);
			
			solid = true;
			
			//play ressurect animation
		}
		
	}

}