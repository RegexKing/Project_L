package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import flash.utils.ByteArray;  
	 
	public class GameUtil 
	{
		
		// Formula:  rate = (totalLevels / last level difficulty factor)
		//ex: 2 = 20 levels / 10x stronger
		
		private static const DAMAGE_SCALING:Number = 10;
		private static const HEALTH_SCALING:Number = 1.5;
		
		public function GameUtil() {}
		
		public static function scaleHealth(_health:Number):Number
		{
			var scaledHealth:Number = _health * (GameData.level / HEALTH_SCALING);
			
			if (scaledHealth < _health) return _health;
			else return scaledHealth;
		}
		
		public static function scaleDamage(_damage:Number):Number
		{
			var scaledDamage:Number = _damage * (GameData.level / DAMAGE_SCALING);
			
			if (scaledDamage < _damage) return _damage;
			else return scaledDamage;
		}
		
		public static function beast_scaleHealth(_health:Number):Number
		{
			var scaledHealth:Number = _health * (GameData.LAST_LEVEL-1 / HEALTH_SCALING);
			
			if (scaledHealth < _health) return _health;
			else return scaledHealth;
		}
		
		public static function beast_scaleDamage(_damage:Number):Number
		{
			var scaledDamage:Number = _damage * (GameData.LAST_LEVEL-1 / DAMAGE_SCALING);
			
			if (scaledDamage < _damage) return _damage;
			else return scaledDamage;
		}
		
		public static function cloneArray(source:Array):Array
		{ 
			var newArray:Array = new Array();
			
			for (var i:int = 0; i < source.length; i++)
			{
				newArray.push(source[i]);
			}
			
			return newArray;
		}
		
	}

}