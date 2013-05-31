package  maps
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Dungeon extends FlxGroup
	{
		
		public var dungeonMap:FlxTilemap;
		public var dungeonGen:DungeonGenerator;
		
		public static var width:uint = 0;
		public static var height:uint = 0;
		public static const TILE_SIZE:uint = 32;
		
		public var emptySpaces:Array;
		
		public function Dungeon(addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super();
			
			dungeonMap = new FlxTilemap();
			
			dungeonGen = new DungeonGenerator();
			
			dungeonMap.loadMap(FlxTilemap.arrayToCSV(dungeonGen.map, DungeonGenerator.TOTAL_ROWS), AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 2);
			
			width = dungeonMap.widthInTiles * TILE_SIZE;
			height = dungeonMap.heightInTiles * TILE_SIZE;
			
			emptySpaceCoords();
			
			add(dungeonMap);
			
		}
		
		public function randomRoom():FlxPoint
		{
			
			var arrayCoords:Array = dungeonGen.getRandomRoomTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
		public function emptySpaceCoords():void
		{
			emptySpaces = new Array();
			
			for (var i:int = 0; i < dungeonGen.map.length; i++)
			{
				if (dungeonGen.map[i] == 1)
				{
					emptySpaces.push(new FlxPoint((i % DungeonGenerator.TOTAL_ROWS)*TILE_SIZE, Math.floor(i / DungeonGenerator.TOTAL_COLS)*TILE_SIZE));
				}
			}
		}
		
	}

}