package items 
{
	import hud.ChestUi;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Chest extends Item
	{
		private var chestUI:ChestUi;
		private var diamondEmitter:FlxEmitter;
		private var itemEmitter:FlxEmitter;
		public var found:Boolean = false;
		
		public function Chest(_chestUI:ChestUi, _diamondEmitter:FlxEmitter, _itemEmitter:FlxEmitter) 
		{
			super();
			chestUI = _chestUI;
			trace(chestUI);
			diamondEmitter = _diamondEmitter
			itemEmitter = _itemEmitter;
			
			exists = true;
			expireTime = 0;
			
			loadGraphic(AssetsRegistry.chestPNG, true, false, 40, 40);
			addAnimation("closed", [0]);
			addAnimation("empty", [1]);
			addAnimation("filled", [2]);
			play("closed");
			
		}
		
		override public function pickup():void
		{
			this.solid = false;
			found = true;
			
			chestUI.currentValue++;
			
			//play sound
			FlxG.play(AssetsRegistry.openChestMP3);
			
			if (chestUI.currentValue < GameData.CHESTS_PER_LEVEL)
			{
				play("empty");
				
				diamondEmitter.at(this);
				diamondEmitter.start(true, 0, 0, 1);
				
				var howManyItems:int = Math.ceil(Math.random() * 2);
				
				itemEmitter.at(this);
				itemEmitter.start(true, 15, 0, howManyItems);
			}
			
			else play("filled");
			
			
		}
	}

}