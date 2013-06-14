package hud
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	 
	public class DiamondCounter extends FlxGroup
	{
		
		private var counter:FlxText;
		
		public function DiamondCounter()
		{
			super();
			
			var diamondIcon:FlxSprite = new FlxSprite(0, 0, AssetsRegistry.diamondIconPNG);
			
			counter = new FlxText(0, 0, 60, String(GameData.diamonds));
			counter.setFormat("NES", 16, 0xffFFFFFF, "center");
			
			add(diamondIcon);
			add(counter);
			
			counter.x = GameData.RENDER_WIDTH - counter.width-1;
			counter.y = 5.6;
			
			diamondIcon.x = counter.x - diamondIcon.width;
			diamondIcon.y = counter.y + 2.6;
			
		}
		
		public function changeQuantity(_changeInValue:int):void
		{
			GameData.diamonds += _changeInValue;
			
			counter.text = String(GameData.diamonds);
		}
		
	}

}