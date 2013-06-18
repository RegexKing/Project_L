package items 
{
	import org.flixel.FlxEmitter;
	import hud.DiamondCounter;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class DiamondEmitter extends FlxEmitter
	{
		
		private var diamondCounter:DiamondCounter;
		
		public function DiamondEmitter(_diamondCounter:DiamondCounter) 
		{
			super(0, 0, GameData.CHESTS_PER_LEVEL-1);
			
			diamondCounter = _diamondCounter;
			
			setRotation(0, 0);
			setXSpeed(-400,400);
			setYSpeed( -400, 400);
			
			for (var i:int = 0; i < GameData.CHESTS_PER_LEVEL-1; i++)
			{
				add(new DiamondItem(diamondCounter));
			}
			
		}
		
	}

}