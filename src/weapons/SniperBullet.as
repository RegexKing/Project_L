package weapons 
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class SniperBullet extends BaseBullet
	{
		
		public function SniperBullet(weapon:FlxWeapon, id:uint, _isEnemy:Boolean) 
		{
			super(weapon, id, _isEnemy);
			
			attackValue = 0.5;
			
			if (_isEnemy)
			{
				attackValue = 2;
				
				attackValue = GameUtil.scaleDamage(attackValue);
			}
		}
		
	}

}