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
			
			var diamondIcon:FlxSprite = new FlxSprite();
			diamondIcon.makeGraphic(16, 16, 0xffCCCCCC);
			
			counter = new FlxText(0, 0, 40, String(GameData.diamonds));
			counter.setFormat("NES", 16, 0xffFFFFFF, "left");
			
			add(diamondIcon);
			add(counter);
			
			diamondIcon.x = GameData.RENDER_WIDTH - diamondIcon.width - counter.width - 2;
			diamondIcon.y = 8.2;
			
			counter.x = GameData.RENDER_WIDTH - counter.width-1;
			counter.y = 5.6;
			
		}
		
		public function changeQuantity(_changeInValue:int):void
		{
			GameData.diamonds += _changeInValue;
			
			counter.text = String(GameData.diamonds);
		}
		
	}

}