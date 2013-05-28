package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class GameUtil 
	{
		
		// Formula:  rate = (totalLevels / last level difficulty factor)
		//ex: 2 = 20 levels / 10x stronger
		
		private static const DAMAGE_SCALING:Number = 2;
		private static const HEALTH_SCALING:Number = 2;
		
		public function GameUtil() {}
		
		public static function scaleHealth(_health:Number):Number
		{
			return _health * (GameData.level / HEALTH_SCALING);
		}
		
		public static function scaleDamage(_damage:Number):Number
		{
			return _damage * (GameData.level / DAMAGE_SCALING);
		}
		
	}

}