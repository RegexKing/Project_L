package dialogue 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	import hud.*;
	 
	public class Dialogue
	{
		
		public var buttonsGroup:FlxGroup;
		public var message:String;
		public var isClickable:Boolean;
		public var characterName:String;
		protected var advanceConversation:Function;
		protected var lifeBar:LifeBar;
		protected var setFireRate:Function;
		protected var diamondCounter:DiamondCounter;
		
		public function Dialogue(_advanceConversation:Function = null, _lifeBar:LifeBar=null, _setFireRate:Function=null, _diamondCounter:DiamondCounter=null) 
		{
			advanceConversation = _advanceConversation;
			lifeBar = _lifeBar;
			setFireRate = _setFireRate;
			diamondCounter = _diamondCounter;
		}
		
		public function setMessage(_characterName:String, _message:String):void
		{
			characterName = _characterName
			message = _message;
		}
		
		public function setInteractive(_characterName:String):void
		{
			switch(_characterName)
			{
				case "girl":
					characterName = "girl";
					message = "Use gems to upgrade?"
					createGirlSet();
					break;
				case "beast":
					characterName = "beast";
					message = "Save Game?";
					createBeastSet();
					break;
				default:
					throw new Error("Invalid character name was chosen");
					break;
			}
		}
		
		protected function createGirlSet():void
		{
			buttonsGroup = new FlxGroup();
			
			var upgradeButton:FlxButtonPlus = new FlxButtonPlus(153+16, 382, upgrade, null, "Upgrade");
			var dontUpgradeButton:FlxButtonPlus = new FlxButtonPlus(153+16, 412, advanceConversation, null, "Cancel");
			
			buttonsGroup.add(upgradeButton);
			buttonsGroup.add(dontUpgradeButton);
		}
		
		protected function createBeastSet():void
		{
			buttonsGroup = new FlxGroup();
			
			var saveButton:FlxButtonPlus = new FlxButtonPlus(153+16, 382, saveGame, null, "Save");
			var dontSaveButton:FlxButtonPlus = new FlxButtonPlus(153+16, 412, advanceConversation, null, "Cancel");
			
			buttonsGroup.add(saveButton);
			buttonsGroup.add(dontSaveButton);
			
		}
		
		public function upgrade():void
		{
			// clear flx group
			buttonsGroup.kill();
			buttonsGroup.clear();
			// make flx group usable
			buttonsGroup.revive();
			
			var upgrade:Upgrade = new Upgrade(advanceConversation, lifeBar, setFireRate, diamondCounter);
			buttonsGroup.add(upgrade);
		}
		
		public function saveGame():void
		{
			GameData.saveData();
			
			advanceConversation();
		}
		
	}

}