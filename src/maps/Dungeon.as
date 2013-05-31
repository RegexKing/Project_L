package  maps
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Dungeon extends Map
	{
		
		public var dungeonGen:DungeonGenerator;
		
		public function Dungeon(addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super(addToStage, onAddSpritesCallback);
			
			
			dungeonGen = new DungeonGenerator();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(dungeonGen.map, DungeonGenerator.TOTAL_ROWS), AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 2);
			
			add(tileMap);
			
		}
		
		override public function randomFirstRoom():FlxPoint
		{
			var arrayCoords:Array = dungeonGen.getRandomFirstRoomTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
		override public function randomRoom():FlxPoint
		{
			
			var arrayCoords:Array = dungeonGen.getRandomRoomTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
		override public function randomAllRooms():FlxPoint
		{
			var arrayCoords:Array = dungeonGen.getRandomAllRoomTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
		 override public function randomCorridor():FlxPoint
		{
			
			var arrayCoords:Array = dungeonGen.getRandomCorridorTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
	}

}