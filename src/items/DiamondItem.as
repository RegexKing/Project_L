package  items
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	
	import hud.DiamondCounter;
	 
	public class DiamondItem extends Item
	{
		
		private var diamondCounter:DiamondCounter;
		
		public function DiamondItem(_diamondCounter:DiamondCounter) 
		{
			diamondCounter = _diamondCounter;
			
			super();
			
			makeGraphic(16, 16, 0xffFF0000);
			width = 16;
			height = 16;
		}
		
		override public function onEmit():void
		{
			super.onEmit();
			
			//todo add animation to play
		}
		
		override public function pickup():void
		{
			diamondCounter.changeQuantity(1);
			
			//sound effect
			FlxG.play(AssetsRegistry.diamondPickupMP3);
		}
		
	}

}