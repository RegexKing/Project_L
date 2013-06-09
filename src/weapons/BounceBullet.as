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
		
		private var trail:FlxTrail;
		private var spriteAddons:FlxGroup;
		
		public function BounceBullet(weapon:FlxWeapon, id:uint) 
		{
			super(weapon, id);
			//spriteAddons = _spriteAddons;
			
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
		
		public function setTrail():void
		{
			trail = new FlxTrail(this, null, 10, 3);
			trail.rotationsEnabled = false;
			spriteAddons.add(trail);
		}
		
		override public function kill():void
		{
			super.kill();
			
			//trail.kill();
		}
		
	}

}