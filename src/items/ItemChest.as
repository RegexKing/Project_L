package items 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class ItemChest extends Item
	{
		
		private var itemEmitter:FlxEmitter;
		
		public function ItemChest(_itemEmitter:FlxEmitter) 
		{
			super();
			itemEmitter = _itemEmitter;
			
			exists = true;
			expireTime = 0;
			
			loadGraphic(AssetsRegistry.emptyChestPNG, true, false, 40, 40);
			addAnimation("closed", [0]);
			addAnimation("open", [1]);
			play("closed");
			
		}
		
		override public function pickup():void
		{
			this.solid = false;
			play("open");
			
			var howManyItems:int = Math.ceil(Math.random() * 3);
			
			itemEmitter.at(this);
			itemEmitter.start(true, 15, 0, howManyItems);
			
			//play sound
			FlxG.play(AssetsRegistry.openChestMP3);
		}
	}

}