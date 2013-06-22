package items 
{
	import hud.ChestUi;
	import hud.DiamondCounter;
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
		private var diamondCounter:DiamondCounter;
		private var itemEmitter:FlxEmitter;
		public var found:Boolean = false;
		
		public function Chest(_chestUI:ChestUi, _diamondCounter:DiamondCounter, _itemEmitter:FlxEmitter) 
		{
			super();
			chestUI = _chestUI;
			
			diamondCounter = _diamondCounter
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
				
				//var howManyItems:int = Math.ceil(Math.random() * 2);
				
				itemEmitter.at(this);
				itemEmitter.start(true, 15, 0, 1);
			}
			
			/*
			else 
			{
				play("filled");
			}
			*/
			
			play("empty");
			diamondCounter.changeQuantity(1);
			
		}
	}

}