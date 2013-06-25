package hud 
{
	import org.flixel.plugin.photonstorm.FlxBar;
	import com.newgrounds.API;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class ChestUi extends FlxBar
	{
		
		public function ChestUi() 
		{
			super(0, 0, FlxBar.FILL_BOTTOM_TO_TOP, 32, 96);
			scrollFactor.x = scrollFactor.y = 0;
			this.x = GameData.RENDER_WIDTH - this.width - 5;
			this.y = GameData.RENDER_HEIGHT - this.height - 10;
			setRange(0, 3);
			
			createImageBar(AssetsRegistry.chestUIBorderPNG, AssetsRegistry.chestUIFillPNG, 0x0, 0x0);
			
			currentValue = 0;
		}
		
		override protected function updateValue(newValue:Number):void
		{
			super.updateValue(newValue);
			
			if (value == max && filledCallback is Function)
			{
				API.unlockMedal("Treasure Hunt");
			}
		}
		
	}

}