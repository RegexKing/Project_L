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
			diamondIcon.makeGraphic(10, 10, 0xffCCCCCC);
			diamondIcon.width = 10;
			diamondIcon.height = 10;
			
			counter = new FlxText(0, 0, 24, String(GameData.diamonds));
			counter.setFormat("NES", 10, 0xffFFFFFF, "left");
			
			add(diamondIcon);
			add(counter);
			
			diamondIcon.x = GameData.RENDER_WIDTH - diamondIcon.width - counter.width - 5;
			diamondIcon.y = 5;
			
			counter.x = GameData.RENDER_WIDTH - counter.width - 5;
			counter.y = 3;
			
		}
		
		public function changeQuantity(_changeInValue:int):void
		{
			GameData.diamonds += _changeInValue;
			
			counter.text = String(GameData.diamonds);
		}
		
	}

}