package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class DiamondItem extends Item
	{
		
		private var diamondCounter:DiamondCounter;
		
		public function DiamondHud(_diamondCounter:DiamondCounter) 
		{
			diamondCounter = _diamondCounter;
			
			super();
			
			makeGraphic(15, 15, 0xffFF0000);
			width = 15;
			height = 15;
			
			
		}
		
		override public function pickup():void
		{
			diamondCounter.changeQuantity(1);
			
			//Todo: add sound effect
		}
		
	}

}