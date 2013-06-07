package dialogue
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	import hud.DiamondCounter;
	import hud.LifeBar;
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
		public static var sad:String = GIRL_TITLE + "Thou hath taken away from me my dearest companion, mayhaps my last.";
		public static var sad2:String = GIRL_TITLE + "I beg of thee, just let me be...";
		public static var sadEnding:String = GIRL_TITLE + "I am a fool to have entrusted you to such a task..";
		public static var sadEnding2:String = GIRL_TITLE + "Go, take you and your greed and leave my sight.";
		
		// beast
		public static var beast_intro1:String = BEAST_TITLE + "Aye, it's Patches! You're pretty tough for such a small man.";
		public static var beast_outro1:String = BEAST_TITLE + "You're a jerk with a heart of gold.. Don't let them take it from ye!";
		public static var saveRequest:String = BEAST_TITLE + "Shall I record thine progress?";
		public static var angryReaction:String = BEAST_TITLE + "What was that about last time? Don't pick fights you cannot win.";
		public static var angryReaction2:String = BEAST_TITLE + "You're fortunate that I hold no interest in fighting cowards!";
		
		// ending
		public static var ending1:String = GIRL_TITLE + "At long last, you have found what I have sought for so long!";
		public static var ending2:String = GIRL_TITLE + "Please hand it over to me so that it can be destroyed,";
		public static var ending3:String = GIRL_TITLE + "thus freeing me from this curse of everlasting life.";
		public static var ending4:String = GUY_TITLE + "Wait a moment, are you telling me that this chalice can grant immortality?";
		public static var ending5:String = GIRL_TITLE + "...yes.";
		public static var ending6:String = GUY_TITLE + "Pray tell, what can you give me in return that is more valuable than that?";
		public static var ending7:String = GIRL_TITLE + "Do not take this lightly, graverobber.  I have seen loved ones lost many a time...";
		public static var ending8:String = GIRL_TITLE + "As such I have confined myself here to keep the world at a distance..";
		public static var ending9:String = GIRL_TITLE + "yet without the warmth of others, it pains me even more.";
		public static var ending10:String = GIRL_TITLE + "If I live to see humanity eras’d from the earth,";
		public static var ending11:String = GIRL_TITLE + "mayhaps it is a fate worse than death. I beg of thee to end my suffering.";
		public static var ending12:String = GIRL_TITLE + "In return for the chalice, I shall give you the rest of my life in company.";
		public static var ending13:String = BEAST_TITLE + "Milady, surely you jape! You can't possibly...";
		public static var ending14:String = GIRL_TITLE + "My life is the most precious thing in my possession."; 
		public static var ending15:String = GIRL_TITLE + "The one who deserves it most is the only man who has came to my aid.";
		public static var ending16:String = GIRL_TITLE + "The only man that would face the deepest, darkest pits of hell for my sake.";
		public static var ending17:String = GIRL_TITLE + "I have fallen for you Patches.";
		public static var ending18:String = GUY_TITLE + "...";
		public static var ending19:String = GUY_TITLE + "HAHAHAHAHAHAAAAA!!!\nAnd I thought I was vain.";
		public static var ending20:String = GUY_TITLE + "In honesty, your life would be more of an investment than a treasure."
		public static var ending21:String = GUY_TITLE + "And for your sake? You give me too much credit for a simple thief like me.";
		public static var ending22:String = GUY_TITLE + "No, I think I shall take this chalice along with the world in the palm of my hand.";
		public static var ending23:String = BEAST_TITLE + "How dare you Patches, you are lower than scum! This is unforgivable.";
		public static var ending24:String = BEAST_TITLE + "Killing you a thousand times over wouldn't be enough to satisfy me!";
		public static var ending25:String = GUY_TITLE + "And I can't stand to see your ugly face for another second!";
		public static var ending26:String = BEAST_TITLE + "Enough talk, have at you!";
		
		
		
		
		public function DialogueRegistry() 
		{
		}
		
		public static function generateConversation(_npcName:String, _advanceAfterButton:Function, _lifeBar:LifeBar, _setFireRate:Function, _diamondCounter:DiamondCounter):Array
		{
			switch(_npcName)
			{
				case GIRL:
					return generateGirlConversation(_advanceAfterButton, _lifeBar, _setFireRate, _diamondCounter);
					break;
				case BEAST:
					return generateBeastConversation(_advanceAfterButton);
					break;
				default:
					throw new Error("Invalid character name was chosen");
					break;
			}
		}
		
		public static function generateGirlConversation(_advanceAfterButton:Function, _lifeBar:LifeBar, _setFireRate:Function, _diamondCounter:DiamondCounter):Array
		{
			var dialogueSet:Array = new Array();
			
			if (GameData.isBeastManDead)
			{
				
				if (GameData.level == GameData.LAST_LEVEL)
				{
					var sadEndingMessage:Dialogue = new Dialogue();
					var sadEndingMessage2:Dialogue = new Dialogue();
					
					sadEndingMessage.setMessage(GIRL, sadEnding);
					sadEndingMessage2.setMessage(GIRL, sadEnding2);
					
					dialogueSet.push(sadEndingMessage);
					dialogueSet.push(sadEndingMessage2);
				}
				
				else 
				{
					var sadMessage:Dialogue = new Dialogue();
					var sadMessage2:Dialogue = new Dialogue();
				
					sadMessage.setMessage(GIRL, sad);
					sadMessage2.setMessage(GIRL, sad2);
				
					dialogueSet.push(sadMessage);
					dialogueSet.push(sadMessage2);
				}
			}
			
			else if (GameData.level == GameData.LAST_LEVEL)
			{
				BeastMan.angry = true;
				
				var endingMessage1:Dialogue = new Dialogue();
				var endingMessage2:Dialogue = new Dialogue();
				var endingMessage3:Dialogue = new Dialogue();
				var endingMessage4:Dialogue = new Dialogue();
				var endingMessage5:Dialogue = new Dialogue();
				var endingMessage6:Dialogue = new Dialogue();
				var endingMessage7:Dialogue = new Dialogue();
				var endingMessage8:Dialogue = new Dialogue();
				var endingMessage9:Dialogue = new Dialogue();
				var endingMessage10:Dialogue = new Dialogue();
				var endingMessage11:Dialogue = new Dialogue();
				var endingMessage12:Dialogue = new Dialogue();
				var endingMessage13:Dialogue = new Dialogue();
				var endingMessage14:Dialogue = new Dialogue();
				var endingMessage15:Dialogue = new Dialogue();
				var endingMessage16:Dialogue = new Dialogue();
				var endingMessage17:Dialogue = new Dialogue();
				var endingMessage18:Dialogue = new Dialogue();
				var endingMessage19:Dialogue = new Dialogue();
				var endingMessage20:Dialogue = new Dialogue();
				var endingMessage21:Dialogue = new Dialogue();
				var endingMessage22:Dialogue = new Dialogue();
				var endingMessage23:Dialogue = new Dialogue();
				var endingMessage24:Dialogue = new Dialogue();
				var endingMessage25:Dialogue = new Dialogue();
				var endingMessage26:Dialogue = new Dialogue();
				
				endingMessage1.setMessage(GIRL, ending1);
				endingMessage2.setMessage(GIRL, ending2);
				endingMessage3.setMessage(GIRL, ending3);
				endingMessage4.setMessage(GUY, ending4);
				endingMessage5.setMessage(GIRL, ending5);
				endingMessage6.setMessage(GUY, ending6);
				endingMessage7.setMessage(GIRL, ending7);
				endingMessage8.setMessage(GIRL, ending8);
				endingMessage9.setMessage(GIRL, ending9);
				endingMessage10.setMessage(GIRL, ending10);
				endingMessage11.setMessage(GIRL, ending11);
				endingMessage12.setMessage(GIRL, ending12);
				endingMessage13.setMessage(BEAST, ending13);
				endingMessage14.setMessage(GIRL, ending14);
				endingMessage15.setMessage(GIRL, ending15);
				endingMessage16.setMessage(GIRL, ending16);
				endingMessage17.setMessage(GIRL, ending17);
				endingMessage18.setMessage(GUY, ending18);
				endingMessage19.setMessage(GUY, ending19);
				endingMessage20.setMessage(GUY, ending20);
				endingMessage21.setMessage(GUY, ending21);
				endingMessage22.setMessage(GUY, ending22);
				endingMessage23.setMessage(BEAST, ending23);
				endingMessage24.setMessage(BEAST, ending24);
				endingMessage25.setMessage(GUY, ending25);
				endingMessage26.setMessage(BEAST, ending26);
				
				dialogueSet.push(endingMessage1);
				dialogueSet.push(endingMessage2);
				dialogueSet.push(endingMessage3);
				dialogueSet.push(endingMessage4);
				dialogueSet.push(endingMessage5);
				dialogueSet.push(endingMessage6);
				dialogueSet.push(endingMessage7);
				dialogueSet.push(endingMessage8);
				dialogueSet.push(endingMessage9);
				dialogueSet.push(endingMessage10);
				dialogueSet.push(endingMessage11);
				dialogueSet.push(endingMessage12);
				dialogueSet.push(endingMessage13);
				dialogueSet.push(endingMessage14);
				dialogueSet.push(endingMessage15);
				dialogueSet.push(endingMessage16);
				dialogueSet.push(endingMessage17);
				dialogueSet.push(endingMessage18);
				dialogueSet.push(endingMessage19);
				dialogueSet.push(endingMessage20);
				dialogueSet.push(endingMessage21);
				dialogueSet.push(endingMessage22);
				dialogueSet.push(endingMessage23);
				dialogueSet.push(endingMessage24);
				dialogueSet.push(endingMessage25);
				dialogueSet.push(endingMessage26);
			}
			
			else
			{
				var intro:Dialogue = new Dialogue();
				var upgrade:Dialogue = new Dialogue(_advanceAfterButton, _lifeBar, _setFireRate, _diamondCounter);
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
			}
			
			var intro:Dialogue = new Dialogue();
			var saveRequestMessage:Dialogue = new Dialogue();
			var saveGame:Dialogue = new Dialogue(_advanceAfterButton);
			var outro:Dialogue = new Dialogue();
			
			intro.setMessage(BEAST, beast_intro1);
			saveRequestMessage.setMessage(BEAST, saveRequest);
			saveGame.setInteractive(BEAST);
			outro.setMessage(BEAST, beast_outro1);
			
			if (!BeastMan.isAnnoyed) dialogueSet.push(intro);
			dialogueSet.push(saveRequestMessage);
			dialogueSet.push(saveGame);
			dialogueSet.push(outro);
			
			
			BeastMan.isAnnoyed = false;
			return dialogueSet;
		}
		
	}

}