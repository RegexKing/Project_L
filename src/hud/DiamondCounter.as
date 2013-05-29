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
			diamondIcon.makeGraphic(8, 8, 0xffCCCCCC);
			diamondIcon.width = 8;
			diamondIcon.height = 8;
			
			counter = new FlxText(0, 0, 20, String(GameData.diamonds));
			counter.setFormat("NES", 8, 0xffFFFFFF, "left");
			
			add(diamondIcon);
			add(counter);
			
			diamondIcon.x = GameData.RENDER_WIDTH - diamondIcon.width - counter.width - 2;
			diamondIcon.y = 4.1;
			
			counter.x = GameData.RENDER_WIDTH - counter.width-1;
			counter.y = 2.8;
			
		}
		
		public function changeQuantity(_changeInValue:int):void
		{
			GameData.diamonds += _changeInValue;
			
			counter.text = String(GameData.diamonds);
		}
		
	}

}