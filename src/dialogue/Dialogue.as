package dialogue 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	import org.flixel.plugin.photonstorm.FlxButtonPlus;
	 
	public class Dialogue
	{
		
		public var buttonsGroup:FlxGroup;
		public var message:String;
		public var isClickable:Boolean;
		public var characterName:String;
		protected var advanceConversation:Function;
		protected var setHealthUpgrade:Function;
		
		public function Dialogue(_advanceConversation:Function = null, _setHealthUpgrade:Function=null) 
		{
			advanceConversation = _advanceConversation;
			setHealthUpgrade = _setHealthUpgrade;
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
			
			var upgradeButton:FlxButtonPlus = new FlxButtonPlus(153, 382, upgrade, null, "Upgrade");
			var dontUpgradeButton:FlxButtonPlus = new FlxButtonPlus(153, 412, advanceConversation, null, "Cancel");
			
			buttonsGroup.add(upgradeButton);
			buttonsGroup.add(dontUpgradeButton);
		}
		
		protected function createBeastSet():void
		{
			buttonsGroup = new FlxGroup();
			
			var saveButton:FlxButtonPlus = new FlxButtonPlus(153, 382, saveGame, null, "Save");
			var dontSaveButton:FlxButtonPlus = new FlxButtonPlus(153, 412, advanceConversation, null, "Cancel");
			
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
			
			var upgrade:Upgrade = new Upgrade(advanceConversation, setHealthUpgrade);
			buttonsGroup.add(upgrade);
		}
		
		public function saveGame():void
		{
			GameData.saveData();
			
			advanceConversation();
		}
		
	}

}