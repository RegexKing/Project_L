package weapons 
{
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	import org.flixel.plugin.photonstorm.FlxWeapon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class BounceBullet extends Bullet
	{
		
		public function BounceBullet(weapon:FlxWeapon, id:uint, _isEnemy:Boolean) 
		{
			super(weapon, id);
			
			attackValue = 2;
			
			if (_isEnemy)
			{
				attackValue = GameUtil.scaleDamage(attackValue);
			}
		}
		
	}

}