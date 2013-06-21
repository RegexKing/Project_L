package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import maps.Map;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.plugin.photonstorm.FlxBar;
	 
	public class Abom extends Enemy
	{
		private var acidNumber:uint = 30;
		protected var acidParticles:FlxEmitter;
		
		public function Abom(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemiesGroup:FlxGroup, _collideableEnemies:FlxGroup, _enemyBars:FlxGroup, _spriteAddons:FlxGroup, _itemEmitter:FlxEmitter=null) 
		{
			super(_player, _map,  _itemEmitter);
			
			
			acidParticles = new FlxEmitter(0, 0, acidNumber);
			acidParticles.setRotation(0, 0);
			acidParticles.setXSpeed(-400,400);
			acidParticles.setYSpeed( -400, 400);
			
			patrolSpeed = 100;
			alertSpeed = 200;
			health = 3;
			attackValue = 0;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			loadGraphic(AssetsRegistry.abomPNG, true, true, 64, 64);
			width = 36;
			height = 60;
			offset.x = 14;
			offset.y = 2;
			this.addAnimation("run", [0, 1, 2, 3], 10);
			play("run");
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
			
			for (var i:int = 0; i < acidNumber; i++)
			{
				var acid:Acid = new Acid(player, map, _enemiesGroup)
				
				acidParticles.add(acid);
			}
			
			_spriteAddons.add(acidParticles);
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
			
			//play death
			FlxG.play(AssetsRegistry.abomDieMP3);
		}
	}

}