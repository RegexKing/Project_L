package weapons 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.FlxGroup;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import flash.utils.getTimer;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class CrossbowArrow extends Bullet
	{
		
		private var explosionTimer:FlxDelay;
		private var explosionParticles:FlxEmitter;
		
		private var causeExplosion:Boolean = false;
		
		private var particleNumber:uint = 50;
		
		public var isTracking:Boolean = false;
		private var trackingObject:FlxObject;
		
		private var stuckCoords:FlxPoint;
		
		public function CrossbowArrow(weapon:FlxWeapon, id:uint, _bulletGroup:FlxGroup, _isEnemy:Boolean) 
		{
			super(weapon, id);
			
			stuckCoords = new FlxPoint();
			
			attackValue = 0;
					
			explosionTimer = new FlxDelay(1100);
			explosionTimer.callback = kill;
			
			explosionParticles = new FlxEmitter(0, 0, particleNumber);
			explosionParticles.setRotation(0, 0);
			explosionParticles.setXSpeed(-400,400);
			explosionParticles.setYSpeed( -400, 400);
			
			for (var i:int = 0; i < particleNumber; i++)
			{
				explosionParticles.add(new CrossbowParticle(_isEnemy));
			}
			
			_bulletGroup.add(explosionParticles);
		}
		
		override public function update():void
		{
			if (lifespan > 0 && getTimer() > expiresTime)
			{
				kill();
			}
			
			if (FlxMath.pointInFlxRect(x, y, weapon.bounds) == false)
			{
				kill();
			}
			
			if (!this.onScreen()) kill();
			
			if (touching && solid)
			{
				causeExplosion = true;
				
				solid = false;
				velocity.x = velocity.y = 0;
				
				explosionTimer.start();
			}
			
			if (isTracking)
			{
				this.x =  trackingObject.x + stuckCoords.x;
				this.y = trackingObject.y + stuckCoords.y;
				
				if (!trackingObject.alive) kill();
			}
			
		}
		
		public function trackTarget(_sprite:FlxObject):void
		{
			isTracking = true;
			trackingObject = _sprite;
			
			stuckCoords.x = this.x - trackingObject.x;
			stuckCoords.y = this.y - trackingObject.y;
			
			causeExplosion = true;
			
			solid = false;
			velocity.x = velocity.y = 0;
				
			explosionTimer.start();
		}
		
		override public function kill():void
		{
			if(causeExplosion)
			{
				causeExplosion = false;
				
				explosionTimer.abort();
			
				if (trackingObject == null || trackingObject.alive)
				{
					explosionParticles.at(this);
					explosionParticles.start(true, 0.5, 0);
				}
				
				//play explosion sound
				chooseExplosionSound();
			}
			
			else
			{
				causeExplosion = false;
				explosionTimer.abort();
			}
			
			
			super.kill();
			
			solid = true;
			isTracking = false;
			trackingObject = null;
			
		}
		
		private function chooseExplosionSound():void
		{
			var diceRoll:uint = Math.ceil(Math.random() * 4);
			
			if (diceRoll == 1) FlxG.play(AssetsRegistry.crossbowExplosion1MP3);
			else if (diceRoll == 2) FlxG.play(AssetsRegistry.crossbowExplosion2MP3);
			else if (diceRoll == 3) FlxG.play(AssetsRegistry.crossbowExplosion3MP3);
			else FlxG.play(AssetsRegistry.crossbowExplosion4MP3);
		}
		
		override public function destroy():void
		{
			explosionTimer.abort();
			explosionTimer = null;
			explosionParticles.destroy();
			
			super.destroy();
		}
		
	}

}