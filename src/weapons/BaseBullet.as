package weapons 
{
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	import org.flixel.plugin.photonstorm.FlxWeapon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class BaseBullet extends Bullet
	{
		
		public function BaseBullet(weapon:FlxWeapon, id:uint) 
		{
			super(weapon, id);
			attackValue = 1;
		}
		
	}

}