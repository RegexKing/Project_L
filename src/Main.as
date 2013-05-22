package 
{
	import org.flixel.FlxGame;

	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
	
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{
			super(GameData.RENDER_WIDTH, GameData.RENDER_HEIGHT, PlayState, 2, 60, 60, true);
			
			forceDebugger = true;
		}

	}

}