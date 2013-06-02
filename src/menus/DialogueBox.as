package menus 
{
	import org.flixel.*;
	import units.Player;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class DialogueBox extends FlxGroup
	{
		protected const girlTitle:String = "Mysterious Woman\n\n";
		protected const beastTitle:String = "Chivalrous Beast\n\n";
		protected const guyTitle:String = "Patches\n\n";
		
		protected var portrait:FlxSprite;
		protected var background:FlxSprite;
		protected var textField:FlxText;
		protected var isClickable:Boolean;
		protected var conversationActive:Boolean;
		
		protected var dialogueSet:Array;
		protected var counter:int = 0;
		
		protected var player:Player;
		
		public function DialogueBox(_player:Player) 
		{
			player = _player;
			
			background = new FlxSprite();
			background.makeGraphic(468, 136, 0xff0000FF);
			background.alpha = 0.5;
			
			textField = new FlxText(0, 0, 322, "");
			textField.setFormat("NES", 16, 0xffFFFFFF);
			
			portrait = new FlxSprite();
			
			background.x = 22;
			background.y = 322;
			
			textField.x = 153;
			textField.y = 332;
			
			portrait.x = 22;
			portrait.y = 284;
			
			add(background);
			add(portrait);
			add(textField);
			
			conversationActive = false;
			isClickable = true;
			
			toggle();
		}
		
		override public function update():void
		{
			if (conversationActive && isClickable)
			{
				if (FlxG.mouse.justPressed())
				{	
					counter++;
					
					if (counter == dialogueSet.length)
					{
						counter = 0;
						toggle();
						conversationActive = false;
						isClickable = true;
						dialogueSet = null;
						player.active = true;
						return;
					}
					
					textField.text = dialogueSet[counter].message;
					changeCharPortrait(dialogueSet[counter].characterName);
					
					if (dialogueSet[counter].buttonsGroup != null)
					{
						isClickable = false;
						add(dialogueSet[counter].buttonsGroup);
					}
				}
			}
		}
		
		public function initConversation(_npcName:String):void
		{
			player.active = false;
			changeCharPortrait(_npcName);
			toggle();
			
			generateConversation(_npcName);
			
			textField.text = dialogueSet[counter].message;
			changeCharPortrait(dialogueSet[counter].characterName);
			conversationActive = true;
			
		}
		
		protected function generateConversation(_npcName:String):void
		{
			switch(_npcName)
			{
				case "girl":
					generateGirlConversation();
					break;
				case "beast":
					generateBeastConversation();
					break;
				default:
					throw new Error("Invalid character name was chosen");
					break;
			}
		}
		
		protected function generateGirlConversation():void
		{
			dialogueSet = new Array();
			
			var intro:Dialogue = new Dialogue();
			var guyMessage:Dialogue = new Dialogue();
			var outro:Dialogue = new Dialogue();
			
			intro.setMessage("girl", girlTitle + "Hello");
			guyMessage.setMessage("guy", guyTitle + "Yea whatever");
			outro.setMessage("girl", girlTitle + "Goodbye");
			
			dialogueSet.push(intro);
			dialogueSet.push(guyMessage);
			dialogueSet.push(outro);
		}
		
		protected function generateBeastConversation():void
		{
			dialogueSet = new Array();
			
			var intro:Dialogue = new Dialogue();
			var guyMessage:Dialogue = new Dialogue();
			var outro:Dialogue = new Dialogue();
			
			intro.setMessage("beast", beastTitle + "Whattup nigga?");
			guyMessage.setMessage("guy", guyTitle + "Sup bitches?");
			outro.setMessage("beast", beastTitle + "Ah hell no dawg.");
			
			dialogueSet.push(intro);
			dialogueSet.push(guyMessage);
			dialogueSet.push(outro);
		}
		
		public function advanceAfterButton():void
		{
			counter++;
			isClickable = true;
			textField.text = dialogueSet[counter].message;
			changeCharPortrait(dialogueSet[counter].characterName);
			
		}
		
		public function changeCharPortrait(_characterName:String):void
		{
			switch(_characterName)
			{
				case "girl":
					portrait.loadGraphic(AssetsRegistry.girlPortraitPNG, false, false, 116, 174);
					break;
				case "beast":
					portrait.loadGraphic(AssetsRegistry.beastPortraitPNG, false, false, 116, 174);
					break;
				case "guy":
					portrait.loadGraphic(AssetsRegistry.guyPortraitPNG, false, false, 116, 174);
					break;
				default:
					throw new Error("Invalid character name was chosen");
					break;
			}
		}
		
		protected function toggle():void
		{
			background.visible = !background.visible;
			portrait.visible  = !portrait.visible;
			textField.visible = !textField.visible;
		}
		
	}

}