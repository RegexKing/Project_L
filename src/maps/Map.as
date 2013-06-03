package maps 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	import util.BTNTilemap;
	 
	public class Map extends FlxGroup
	{
		public static const TILE_SIZE:uint = 64;
		public var tileMap:BTNTilemap;
		
		
		public function Map(addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super();
			
			tileMap = new BTNTilemap();
		}
		
		public function randomFirstRoom():FlxPoint {return null}
		public function randomRoom():FlxPoint {return null}
		public function randomAllRooms():FlxPoint {return null}
		public function randomCorridor():FlxPoint {return null}
		
	}

}