package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxGroup;
	import maps.Map;
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.FlxG;
	 
	public class Slime extends Enemy
	{
		
		private var babyNumber:uint = 4;
		protected var babySlimes:FlxEmitter;
		protected var enemyBars:FlxGroup;
		
		public function Slime(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemiesGroup:FlxGroup, _collideableEnemies:FlxGroup, _enemyBars:FlxGroup, _slimeAddons:FlxGroup,  _itemEmitter:FlxEmitter=null) 
		{
			super(_player, _map,  _itemEmitter);
			
			enemyBars = _enemyBars;
			
			babySlimes = new FlxEmitter(0, 0, babyNumber);
			babySlimes.setRotation(0, 0);
			babySlimes.setXSpeed(-300, 300);
			babySlimes.setYSpeed( -300, 300);
			
			patrolSpeed = 160;
			alertSpeed = 500;
			health = 4;
			attackValue = 2;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			loadGraphic(AssetsRegistry.slimePNG, true, true, 64, 32);
			width = 60;
			offset.x = 2;
			this.addAnimation("bounce", [0, 1, 2, 3], 10);
			play("bounce");
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
	
			gibs = null;
			
			for (var i:int = 0; i < babyNumber; i++)
			{
				babySlimes.add(new SlimeBaby(player, map, _gibsGroup, _enemiesGroup, enemyBars));
			}
			
			_collideableEnemies.add(babySlimes);
			_slimeAddons.add(babySlimes);
		}
		
		override public function update():void
		{
			super.update();
			
			if (aware)
			{
				this.pathSpeed = 120;
			}
		}	
		
		override public function kill():void
		{
			super.kill();
			
			if(babySlimes != null)
			{
				babySlimes.at(this);
				babySlimes.start(true, 0, 0);
			}
			
			//play sound
			if (this.onScreen()) FlxG.play(AssetsRegistry.slimeDieMP3);
		}
		
	}

}