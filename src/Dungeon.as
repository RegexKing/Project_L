package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Dungeon extends FlxGroup
	{
		
		[Embed(source = '../lib/images/dun.png')] private var dunPNG:Class;
		
		public static const TILE_SIZE:uint = 32;
		
		public var dungeon:FlxTilemap;
		public var dungeonGen:DungeonGenerator;
		public var width:uint;
		public var height:uint;
		
		public var emptySpaces:Array;
		
		public function Dungeon(addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super();
			
			dungeon = new FlxTilemap();
			
			dungeonGen = new DungeonGenerator();
			
			dungeon.loadMap(FlxTilemap.arrayToCSV(dungeonGen.map, 40), dunPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 2);
			
			width = dungeon.widthInTiles * TILE_SIZE;
			height = dungeon.heightInTiles * TILE_SIZE;
			
			emptySpaceCoords();
			
			add(dungeon);
			
		}
		
		public function emptySpaceCoords():void
		{
			emptySpaces = new Array();
			
			for (var i:int = 0; i < dungeonGen.map.length; i++)
			{
				if (dungeonGen.map[i] == 1)
				{
					emptySpaces.push(new FlxPoint((i % 40)*TILE_SIZE, Math.floor(i / 40)*TILE_SIZE));
				}
			}
		}
		
	}

}