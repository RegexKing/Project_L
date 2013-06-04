package 
{
	import menu.PauseMenu;
	import org.flixel.FlxGame;
	import flash.events.Event;

	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	[SWF(width="512", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
	
	public class Main extends FlxGame 
	{
		
		public function Main():void 
		{
			super(GameData.RENDER_WIDTH, GameData.RENDER_HEIGHT, DungeonCrawl, 1, 60, 60, true);
			
			forceDebugger = true;
		}
		
		
		override protected function create(FlashEvent:Event):void
		{
			super.create(FlashEvent);
			stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
			stage.removeEventListener(Event.ACTIVATE, onFocus);
		}
		

	}

}