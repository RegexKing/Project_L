package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	 
	public class GameData 
	{
		//Constants
		public static const RENDER_WIDTH:uint = 320;
		public static const RENDER_HEIGHT:uint = 240;
		
		//changable
		public static var diamonds:int = 0;
		public static var health:int = 4;
		public static var weapon:uint = 0;
		
		//player attributes
		public static var totalHealth:int = 4; // when this is needs to be increased, call increaseBarRange on lifebar
		public static var defenseMultiplier:Number = 0;
		public static var damageMultiplier:Number = 0;
		public static var fireRateMultiplier:Number = 0;
		
		
		public function GameData() {}

	}
}