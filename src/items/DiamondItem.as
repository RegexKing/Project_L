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
			expireTime = 0;
			
			loadGraphic(AssetsRegistry.diamondsPNG, true, false, 32, 32);
			addAnimation("blue", [0]);
			addAnimation("green", [1]);
			addAnimation("red", [2]);
			addAnimation("yellow", [3]);
		}
		
		override public function onEmit():void
		{
			super.onEmit();
			
			//todo add animation to play
			var randomColor:uint = Math.floor(Math.random() * 4);
			
			if (randomColor == 0) play("blue");
			else if (randomColor == 1) play("green");
			else if (randomColor == 2) play("red");
			else play("yellow");
		}
		
		override public function pickup():void
		{
			diamondCounter.changeQuantity(1);
			
			//sound effect
			FlxG.play(AssetsRegistry.diamondPickupMP3);
		}
		
	}

}