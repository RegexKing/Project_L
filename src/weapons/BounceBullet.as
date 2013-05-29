package weapons 
{
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.plugin.photonstorm.FlxMath;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class BounceBullet extends Bullet
	{
		
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
		}
		
	}

}