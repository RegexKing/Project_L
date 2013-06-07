package units 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxParticle;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	import org.flixel.FlxPoint
	import maps.Map; 
	/**
	 * ...
	 * @author Frank Fazio
	 */
	 
	public class SlimeBaby extends Enemy
	{
		protected var doneExploding:Boolean;
		protected var movementDelay:FlxDelay;
		
		public function SlimeBaby(_player:Player, _map:Map) 
		{
			super(_player, _map);
			gibs = null;
			player = _player;
			
			exists = false;
			doneExploding = false;
			
			alertSpeed = 200
			aware = true;
			
			health = 1;
			attackValue = 1;
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(10, 10, 0xff00FF00);
			
			
			movementDelay = new FlxDelay(700);
			movementDelay.callback = startMovement;
		}
		
		override public function update():void
		{
			//super.update();
			
			if (doneExploding) super.update();
			//trace(doneExploding);
		}
		
		override public function onEmit():void
		{
			elasticity = 0.8;
			drag = new FlxPoint(200, 200);
			movementDelay.start();
		}
		
		protected function startMovement():void
		{
			movementDelay.abort();
			movementDelay = null;
			
			doneExploding = true;
		}
		
	}

}