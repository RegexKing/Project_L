package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;  
	 
	public class LifeBar extends FlxBar
	{
		
		public function LifeBar() 
		{
			super(5, 5, FlxBar.FILL_LEFT_TO_RIGHT, 100, 7);
			
			updateBarRange();
			currentValue = GameData.health;
			
		}
		
		public function increaseBarRange():void
		{
			if (GameData.totalHealth < 8)
			{
				GameData.totalHealth++;
				updateBarRange();
				currentValue = GameData.totalHealth;
			}
		}
		
		private function updateBarRange():void
		{
			var totalHealth:int = GameData.totalHealth;
			
			switch(totalHealth)
			{
				case 3:
					width = 23;
					createImageBar(AssetsRegistry.lifeBar_border_3PNG, AssetsRegistry.lifeBar_3PNG, 0x0);
					setRange(0, totalHealth);
					break;
				case 4:
					width = 31;
					setRange(0, totalHealth);
					createImageBar(AssetsRegistry.lifeBar_border_4PNG, AssetsRegistry.lifeBar_4PNG, 0x0);
					break;
				case 5:
					width = 39;
					createImageBar(AssetsRegistry.lifeBar_border_5PNG, AssetsRegistry.lifeBar_5PNG, 0x0);
					setRange(0, totalHealth);
					break;
				case 6:
					width = 47;
					createImageBar(AssetsRegistry.lifeBar_border_6PNG, AssetsRegistry.lifeBar_6PNG, 0x0);
					setRange(0, totalHealth);
					break;
				case 7:
					width = 55;
					createImageBar(AssetsRegistry.lifeBar_border_7PNG, AssetsRegistry.lifeBar_7PNG, 0x0);
					setRange(0, totalHealth);
					break;
				case 8:
					width = 63;
					createImageBar(AssetsRegistry.lifeBar_border_8PNG, AssetsRegistry.lifeBar_8PNG, 0x0);
					setRange(0, totalHealth);
					break;
				default:
 					throw new Error("Health bar is outside range 0-8");
					break;
			}
		}
		
	}

}