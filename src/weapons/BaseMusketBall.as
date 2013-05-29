package weapons 
{
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	import org.flixel.plugin.photonstorm.FlxWeapon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class BaseMusketBall extends Bullet
	{
		
		public function BaseMusketBall(weapon:FlxWeapon, id:uint) 
		{
			super(weapon, id);
			attackValue = 1;
		}
		
	}

}