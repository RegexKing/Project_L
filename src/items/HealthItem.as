package   items
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	
	import hud.LifeBar;
	 
	public class HealthItem extends Item
	{
		
		private var lifeBar:LifeBar;
		
		public function HealthItem(_lifeBar:LifeBar) 
		{
			expireTime = 10000;
			
			super();
			
			lifeBar = _lifeBar;
			
			loadGraphic(AssetsRegistry.HealthItemPNG, false, false, 10, 10);
			width = 10;
			height = 10;	
		}
		
		override public function onEmit():void
		{
			super.onEmit();
			
			//todo add animation to play
		}
		
		override public function pickup():void
		{
			lifeBar.currentValue++;
			
			//sound effect
			FlxG.play(AssetsRegistry.healthPickupMP3);
		}
		
	}

}