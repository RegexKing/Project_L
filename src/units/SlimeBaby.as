package units 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxParticle;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.FlxPoint
	import maps.Map; 
	import org.flixel.plugin.photonstorm.FlxBar;
	import org.flixel.FlxEmitter;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	 
	public class SlimeBaby extends Enemy
	{
		protected var doneExploding:Boolean;
		protected var movementDelay:FlxDelay;
		protected var enemiesGroup:FlxGroup;
		
		public function SlimeBaby(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemiesGroup:FlxGroup, _enemyBars:FlxGroup,  _itemEmitter:FlxEmitter=null) 
		{
			super(_player, _map,  _itemEmitter);
			player = _player;
			enemiesGroup = _enemiesGroup;
			
			exists = false;
			doneExploding = false;
			
			alertSpeed = 100;
			aware = true;
			
			health = 1;
			attackValue = 1;
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			loadGraphic(AssetsRegistry.babySlimePNG, true, true, 32, 16);
			width = 30;
			offset.x = 1;
			this.addAnimation("bounce", [0, 1, 2, 3], 10);
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
			
			movementDelay = new FlxDelay(700);
			movementDelay.callback = startMovement;
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 10, 10, true);
			_gibsGroup.add(gibs);
		}
		
		override public function update():void
		{
			if (doneExploding) super.update();
		}
		
		override public function onEmit():void
		{
			elasticity = 0.8;
			drag = new FlxPoint(200, 200);
			
			enemiesGroup.add(this);
			
			movementDelay.start();
			this.play("bounce");
		}
		
		protected function startMovement():void
		{
			movementDelay.abort();
			movementDelay = null;
			
			doneExploding = true;
		}
		
	}

}