package units 
{
	import org.flixel.plugin.photonstorm.FlxDelay;
	import maps.Map;
	import org.flixel.FlxGroup;
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxG;
	import com.newgrounds.API;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Skeleton extends Enemy
	{
		
		private var deaths:uint;
		private var ressurectDelay:FlxDelay;
		private var riseDelay:FlxDelay;
		
		
		public function Skeleton(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyBars:FlxGroup,  _itemEmitter:FlxEmitter=null) 
		{
			super(_player, _map,  _itemEmitter);
			
			deaths = 0;
			
			patrolSpeed = 160;
			alertSpeed = 200;
			health = 2;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			loadGraphic(AssetsRegistry.skeletonPNG, true, true, 64, 64);
			width = 20;
			height = 47;
			offset.x = 22;
			offset.y = 8.5;
			this.addAnimation("run", [1, 2, 3, 4, 5, 6, 7 , 8], 10);
			this.addAnimation("kill", [13, 14, 15, 16, 17, 18], 10, false);
			this.addAnimation("ressurect", [18, 17, 16, 15, 14, 13], 10, false);
			
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
			if (solid)
			{
				super.update();
				
				//play run animation
				play("run");
			}
			
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
				
				riseDelay = new FlxDelay(2000);
				riseDelay.callback = rise;
				riseDelay.start();
				
				// play death animation
				play("kill");
			}
			
			else 
			{
				super.kill();
				
				//unlock medal
				API.unlockMedal("And Stay Dead!");
			}
			
			//play sound
			FlxG.play(AssetsRegistry.skeletonDieMP3);
		}
		
		protected function ressurect():void
		{
			health = 1;
			health = GameUtil.scaleHealth(health);
			
			solid = true;
		}
		
		protected function rise():void
		{
			//play ressurect animation
			play("ressurect");
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			if (ressurectDelay != null)
			{
				ressurectDelay.abort();
				ressurectDelay = null;
			}
			
			if (riseDelay != null)
			{
				riseDelay.abort();
				riseDelay = null;
			}
		}
		
	}

}