package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	import menus.Dialogue;
	import units.BeastMan;
	 
	public class DialogueRegistry 
	{
		//constants
		public static const GIRL_TITLE:String = "Mysterious Woman\n\n";
		public static const BEAST_TITLE:String = "Chivalrous Beast\n\n";
		public static const GUY_TITLE:String = "Patches\n\n";
		
		public static const GIRL:String = "girl";
		public static const BEAST:String = "beast";
		public static const GUY:String = "guy";
		
		// Dialogues ----------------------------------
		
		// guy
		
		public static var angryResponse:String = GUY_TITLE + "Why would I try to pick a fight with such a handsome creature such as yourself?";
		public static var angryResponse2:String = GUY_TITLE + "You just looked like you needed a friendly kick in the arse!";
			
		// girl
		public static var girl_intro1:String = GIRL_TITLE + "Hello this is the best ever I can't even believe it so awesome and good and amazing!";
		public static var girl_outro1:String = GIRL_TITLE + "Goodbye..";
		public static var sad:String = GIRL_TITLE + "Thou hath taken away from me my dearest companion, mayhaps my last."
			+ " Please, just let me be...";
		
		// beast
		public static var beast_intro1:String = BEAST_TITLE + "Aye, it's Patches! You're pretty tough for such a small man.";
		public static var beast_outro1:String = BEAST_TITLE + "You're a jerk with a heart of gold.. Don't let them take it from ye!";
		public static var saveRequest:String = BEAST_TITLE + "Shall I record thine progress?";
		public static var angryReaction:String = BEAST_TITLE + "What was that about last time? Don't pick fights you cannot win.";
		public static var angryReaction2:String = BEAST_TITLE + "You're fortunate that I hold no interest in fighting cowards!";
		
		
		
		
		
		public function DialogueRegistry() 
		{
		}
		
		public static function generateConversation(_npcName:String, _advanceAfterButton:Function):Array
		{
			switch(_npcName)
			{
				case GIRL:
					return generateGirlConversation(_advanceAfterButton);
					break;
				case BEAST:
					return generateBeastConversation(_advanceAfterButton);
					break;
				default:
					throw new Error("Invalid character name was chosen");
					break;
			}
		}
		
		public static function generateGirlConversation(_advanceAfterButton:Function):Array
		{
			var dialogueSet:Array = new Array();
			
			if (GameData.isBeastManDead)
			{
				var sadMessage:Dialogue = new Dialogue();
				
				sadMessage.setMessage(GIRL, sad);
				dialogueSet.push(sadMessage);
			}
			
			else
			{
				var intro:Dialogue = new Dialogue();
				var upgrade:Dialogue = new Dialogue(_advanceAfterButton);
				var outro:Dialogue = new Dialogue();
				
				intro.setMessage(GIRL, girl_intro1);
				upgrade.setInteractive(GIRL);
				outro.setMessage(GIRL, girl_outro1);
				
				dialogueSet.push(intro);
				dialogueSet.push(upgrade);
				dialogueSet.push(outro);
			}
			
			return dialogueSet;
		}
		
		public static function generateBeastConversation(_advanceAfterButton:Function):Array
		{
			var dialogueSet:Array = new Array();
			
			if (BeastMan.isAnnoyed)
			{
				var angryMessage:Dialogue = new Dialogue();
				var angryMessageResponse:Dialogue = new Dialogue();
				var angryMessageResponse2:Dialogue = new Dialogue();
				var angryMessage2:Dialogue = new Dialogue();
				
				angryMessage.setMessage(BEAST, angryReaction);
				angryMessageResponse.setMessage(GUY, angryResponse);
				angryMessageResponse2.setMessage(GUY, angryResponse2);
				angryMessage2.setMessage(BEAST, angryReaction2);
				
				dialogueSet.push(angryMessage);
				dialogueSet.push(angryMessageResponse);
				dialogueSet.push(angryMessageResponse2);
				dialogueSet.push(angryMessage2);
				
				BeastMan.isAnnoyed = false;
			}
			
			var intro:Dialogue = new Dialogue();
			var saveRequestMessage:Dialogue = new Dialogue();
			var saveGame:Dialogue = new Dialogue(_advanceAfterButton);
			var outro:Dialogue = new Dialogue();
			
			intro.setMessage(BEAST, beast_intro1);
			saveRequestMessage.setMessage(BEAST, saveRequest);
			saveGame.setInteractive(BEAST);
			outro.setMessage(BEAST, beast_outro1);
			
			dialogueSet.push(intro);
			dialogueSet.push(saveRequestMessage);
			dialogueSet.push(saveGame);
			dialogueSet.push(outro);
			
			return dialogueSet;
		}
		
	}

}