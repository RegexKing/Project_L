package menus 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	 
	public class Dialogue extends FlxGroup
	{
		
		public var buttonsGroup:FlxGroup;
		public var message:String;
		public var isClickable:Boolean;
		public var characterName:String;
		protected var advanceConversation:Function;
		
		public function Dialogue() 
		{
			
		}
		
		public function setMessage(_characterName:String, _message:String):void
		{
			characterName = _characterName
			message = _message;
		}
		
		public function setInteractive(_characterName:String, _advanceConversation:Function):void
		{
			switch(_characterName)
			{
				case "girl":
					createGirlSet(_advanceConversation);
					break;
				case "beast":
					createBeastSet(_advanceConversation);
					break;
				default:
					throw new Error("Invalid character name was chosen");
					break;
			}
		}
		
		protected function createGirlSet(_advanceConversation:Function):void
		{
			
		}
		
		protected function createBeastSet(_advanceConversation:Function):void
		{
			
			characterName = "beast";
			buttonsGroup = new FlxGroup(2);
			
			//var saveButton:FlxButton = new FlxButton(
		}
		
	}

}