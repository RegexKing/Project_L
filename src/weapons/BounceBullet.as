package weapons 
{
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.FlxGroup;
	import flash.utils.getTimer;
	import util.FlxTrail;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class BounceBullet extends Bullet
	{
		
		public var trail:FlxTrail;
		
		public function BounceBullet(weapon:FlxWeapon, id:uint) 
		{
			super(weapon, id);
			
			attackValue = 1;
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
			
		}
		
		override protected function postFire():void
		{
			super.postFire();
			trail.resetTrail();
			trail.increaseLength(10);
			trail.exists = true;
		}
		
		public function getTrail():FlxTrail
		{
			trail = new FlxTrail(this, null, 10, 1, 0.6);
			trail.rotationsEnabled = false;
			
			return trail;
		}
		
		override public function kill():void
		{
			super.kill();
			
			trail.exists = false;
		}
	}

}