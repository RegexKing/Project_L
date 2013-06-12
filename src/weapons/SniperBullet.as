package weapons 
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class SniperBullet extends BaseBullet
	{
		
		public function SniperBullet(weapon:FlxWeapon, id:uint) 
		{
			super(weapon, id);
			
			attackValue = 0.5;
		}
		
	}

}