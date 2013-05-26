package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import flash.net.SharedObject; 
	 
	public class GameData 
	{
		public static var saveFile:SharedObject = SharedObject.getLocal("myData");
		
		//Constants
		public static const RENDER_WIDTH:uint = 320;
		public static const RENDER_HEIGHT:uint = 240;
		
		//Flag to check if new game
		public static var isNewGame:Boolean; //TODO if this is undefined, then disable continue button
		
		//changable
		public static var level:uint = 0;
		public static var diamonds:int = 0;
		public static var health:Number = 4;
		public static var weapon:uint = 0;
		
		//player attributes
		public static var totalHealth:Number = 4; // when this is needs to be increased, call increaseBarRange on lifebar
		public static var defenseMultiplier:Number = 0; //this is to be incrememnted by .10 up to 5 upgrades
		public static var damageMultiplier:Number = 0;
		public static var fireRateMultiplier:Number = 0; //this to be incrememnted by .20 up to 5 upgrades
		
		
		public function GameData() { }
		
		public static function resetData():void
		{
			level = 0;
			diamonds = 0;
			health = 3;
			weapon = 0;
			
			totalHealth = 3;
			defenseMultiplier = 0;
			damageMultiplier = 0;
			fireRateMultiplier = 0;
			
			saveData();
		}
		
		public static function saveData():void
		{
			isNewGame = false;
			saveFile.data.isNewGame = isNewGame;
			
			saveFile.data.level = level;
			saveFile.data.diamonds = diamonds;
			saveFile.data.health = health;
			saveFile.data.weapon = weapon;
			
			saveFile.data.totalHealth = totalHealth;
			saveFile.data.defenseMultiplier = defenseMultiplier;
			saveFile.data.damageMultiplier = damageMultiplier;
			saveFile.data.fireRateMultiplier = fireRateMultiplier;
			
			saveFile.flush();
		}
		
		public static function loadData():void
		{
			level = saveFile.data.level;
			diamonds = saveFile.data.diamonds;
			health = saveFile.data.health;
			weapon = saveFile.data.weapon;
			
			totalHealth = saveFile.data.totalHealth;
			defenseMultiplier = saveFile.data.defenseMultiplier;
			damageMultiplier = saveFile.data.damageMultiplier;
			fireRateMultiplier = saveFile.data.fireRateMultiplier;
		}
		
		

	}
}