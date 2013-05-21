package 
{
	import org.flixel.FlxGame;

	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	[SWF(width="512", height="448", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
	
	public class Main extends FlxGame 
	{

		public function Main():void 
		{
			super(256, 224, PlayState, 2, 60, 60, true);
			
			forceDebugger = true;
		}

	}

}