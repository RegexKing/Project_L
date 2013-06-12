package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import flash.net.SharedObject; 
	import units.BeastMan;
	 
	public class GameData 
	{
		public static var saveFile:SharedObject = SharedObject.getLocal("myData");
		
		//Constants
		public static const RENDER_WIDTH:uint = 512;
		public static const RENDER_HEIGHT:uint = 480;
		
		public static const DIAMONDS_PER_LEVEL:uint = 4;
		public static const MAX_UPGRADES:uint = 8;
		
		
		// Formula:  rate = (target max value/number_of_upgrades)
		public static const HEALTH_FACTOR:Number = 1; 
		public static const DEFENSE_FACTOR:Number = 0.0625; 
		public static const DAMAGE_FACTOR:Number = 0.75;
		public static const FIRERATE_FACTOR:Number = 0.0625;
		
		public static const LAST_LEVEL:uint = 41;
		
		//Flag to check if new game
		public static var isNewGame:Boolean;
		public static var cravenMode:Boolean = false;
		public static var completionTime:Number = 0;
		
		// check if beast is dead
		public static var isBeastManDead:Boolean = false;
		
		//changable
		
		public static var level:uint = 1;
		public static var diamonds:int = 0;
		public static var playerHealth:Number = 3;
		public static var weapon:uint = 4;
		
		//player attributes
		public static var vitalityUpgrades:uint = 0; 
		public static var defenseUpgrades:uint = 0; 
		public static var attackUpgrades:uint = 0; 
		public static var rateUpgrades:uint = 0;
		
		public static var totalHealth:Number = 3; // when this is needs to be increased, call increaseBarRange on lifebar
		public static var defenseMultiplier:Number = 0; //this is to be incrememnted by .1 up to 5 upgrades
		public static var damageMultiplier:Number = 0; // this to be incrememnted by .6 up to 5 upgrades
		public static var fireRateMultiplier:Number = 0; //this to be incrememnted by .1 up to 5 upgrades
		
		
		public function GameData() { }
		
		public static function resetData():void //to be used to start new game
		{
			isNewGame = true;
			
			completionTime = 0;
			
			isBeastManDead = false;
			BeastMan.isAnnoyed = false;
			
			level = 1;
			diamonds = 0;
			playerHealth = 3;
			
			weapon = 0;
			
			totalHealth = 3;
			defenseMultiplier = 0;
			damageMultiplier = 0;
			fireRateMultiplier = 0;
			
			vitalityUpgrades = 0; 
			defenseUpgrades = 0; 
			attackUpgrades = 0; 
			rateUpgrades = 0;
			
			saveData(true);
		}
		
		public static function saveData(_startNewGame:Boolean=false):void // used to save game
		{
			isNewGame = _startNewGame;
			
			saveFile.data.completionTime = completionTime;
			
			saveFile.data.isNewGame = isNewGame;
			saveFile.data.cravenMode = cravenMode;
			
			saveFile.data.isBeastManDead = isBeastManDead;
			
			saveFile.data.level = level;
			saveFile.data.diamonds = diamonds;
			saveFile.data.playerHealth = playerHealth;
			saveFile.data.weapon = weapon;
			
			saveFile.data.totalHealth = totalHealth;
			saveFile.data.defenseMultiplier = defenseMultiplier;
			saveFile.data.damageMultiplier = damageMultiplier;
			saveFile.data.fireRateMultiplier = fireRateMultiplier;
			
			saveFile.data.vitalityUpgrades = vitalityUpgrades;
			saveFile.data.defenseUpgrades = defenseUpgrades;
			saveFile.data.attackUpgrades = attackUpgrades;
			saveFile.data.rateUpgrades = rateUpgrades;
			
			saveFile.flush();
		}
		
		public static function loadData():void // used to continue game, use at start
		{
			cravenMode = saveFile.data.cravenMode;
			
			completionTime = saveFile.data.completionTime;
			
			isBeastManDead = saveFile.data.isBeastManDead;
			
			level = saveFile.data.level;
			diamonds = saveFile.data.diamonds;
			playerHealth = saveFile.data.playerHealth;
			weapon = saveFile.data.weapon;
			
			totalHealth = saveFile.data.totalHealth;
			defenseMultiplier = saveFile.data.defenseMultiplier;
			damageMultiplier = saveFile.data.damageMultiplier;
			fireRateMultiplier = saveFile.data.fireRateMultiplier;
			
			vitalityUpgrades = saveFile.data.vitalityUpgrades
			defenseUpgrades = saveFile.data.defenseUpgrades
			attackUpgrades = saveFile.data.attackUpgrades
			rateUpgrades = saveFile.data.rateUpgrades
		}
		
		public static function checkNewGame():Boolean
		{
			if (saveFile.data.isNewGame != false) return true;
			else return false;
		}
	}
}