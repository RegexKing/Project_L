package maps 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	 
	public class Map extends FlxGroup
	{
		public static const TILE_SIZE:uint = 32;
		public var tileMap:FlxTilemap;
		
		
		public function Map(addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super();
			
			tileMap = new FlxTilemap();
		}
		
		public function randomFirstRoom():FlxPoint {return null}
		public function randomRoom():FlxPoint {return null}
		public function randomCorridor():FlxPoint {return null}
		
	}

}