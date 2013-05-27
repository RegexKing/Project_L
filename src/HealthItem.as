package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class HealthItem extends Item
	{
		
		private var lifeBar:LifeBar;
		
		public function HealthItem(_lifeBar:LifeBar) 
		{
			super();
			
			lifeBar = _lifeBar;
			
			loadGraphic(AssetsRegistry.HealthItemPNG, false, false, 10, 10);
			width = 10;
			height = 10;
			
			
		}
		
		override public function pickup():void
		{
			lifeBar.currentValue++;
			
			//Todo: add sound effect
		}
		
	}

}