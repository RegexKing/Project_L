package units 
{
	import org.flixel.plugin.photonstorm.FlxDelay;
	import maps.Map;
	import org.flixel.FlxGroup;
	import org.flixel.plugin.photonstorm.FlxBar;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Skeleton extends Enemy
	{
		
		private var deaths:uint;
		private var ressurectDelay:FlxDelay;
		
		public function Skeleton(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyBars:FlxGroup) 
		{
			super(_player, _map);
			
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