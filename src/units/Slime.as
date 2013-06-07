package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxGroup;
	import maps.Map;
	 
	public class Slime extends Enemy
	{
		
		private var babyNumber:uint = 5;
		protected var babySlimes:FlxEmitter;
		
		public function Slime(_player:Player, _map:Map, _enemiesGroup:FlxGroup, _collideableEnemies:FlxGroup) 
		{
			super(_player, _map);
			
			babySlimes = new FlxEmitter(0, 0, babyNumber);
			babySlimes.setRotation(0, 0);
			babySlimes.setXSpeed(-400,400);
			babySlimes.setYSpeed( -400, 400);
			
			patrolSpeed = 160;
			alertSpeed = 500;
			health = 1;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(40, 40, 0xff00FF00);
			width = 40;
			height = 40;
			
			
	
			gibs = null;
			
			for (var i:int = 0; i < babyNumber; i++)
			{
				babySlimes.add(new SlimeBaby(player, map));
			}
			
			_enemiesGroup.add(babySlimes);
			_collideableEnemies.add(babySlimes);
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
		}
		
	}

}