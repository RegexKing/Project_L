package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxGroup;
	import maps.Map;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	 
	public class Abom extends Enemy
	{
		private var acidNumber:uint = 30;
		protected var acidParticles:FlxEmitter;
		
		public function Abom(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemiesGroup:FlxGroup, _collideableEnemies:FlxGroup) 
		{
			super(_player, _map);
			
			
			acidParticles = new FlxEmitter(0, 0, acidNumber);
			acidParticles.setRotation(0, 0);
			acidParticles.setXSpeed(-400,400);
			acidParticles.setYSpeed( -400, 400);
			
			patrolSpeed = 100;
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
			
			for (var i:int = 0; i < acidNumber; i++)
			{
				acidParticles.add(new Acid(player, map));
			}
			
			_enemiesGroup.add(acidParticles);
			_collideableEnemies.add(acidParticles);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxVelocity.distanceBetween(this, player) <= this.width * 2) kill();
		}
		
		override public function kill():void
		{
			super.kill();
			
			if(acidParticles != null)
			{
				acidParticles.at(this);
				acidParticles.start(true, 0, 0);
			}
		}
	}

}