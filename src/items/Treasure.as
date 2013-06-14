package items 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Treasure extends Item
	{
		private var win:Function;
		
		public function Treasure(_win:Function) 
		{
			super();
			
			exists = true;
			expireTime = 0;
			win = _win;
			
			loadGraphic(AssetsRegistry.chestPNG, false, false, 40, 40);
			
		}
		
		override public function pickup():void
		{
			win();
		}
	}

}