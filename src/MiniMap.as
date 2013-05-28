package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	 
	public class MiniMap extends FlxGroup
	{
		private var dungeon:Dungeon;
		private var player:Player;
		private var playerIcon:FlxSprite;
		private var mapArray:Array;
		private var miniMap:FlxTilemap;
		
		private var foggedTiles:FlxGroup;
		
		public function MiniMap(_dungeon:Dungeon, _player:Player) 
		{
			super();
			
			dungeon = _dungeon;
			player = _player;
			
			mapArray = dungeon.dungeonMap.getData(true);
			
			miniMap = new FlxTilemap();
			
			miniMap.loadMap(FlxTilemap.arrayToCSV(mapArray, DungeonGenerator.TOTAL_ROWS, true), FlxTilemap.ImgAuto, 6, 6, FlxTilemap.AUTO);
			add(miniMap);
			miniMap.x = GameData.RENDER_WIDTH / 2 - miniMap.width / 2;
			miniMap.y = GameData.RENDER_HEIGHT / 2 - miniMap.height / 2;
			
			/*
			foggedTiles = new FlxGroup();
			
			for each(var item:FlxPoint in dungeon.emptySpaces)
			{
				var floorBlock:FlxSprite = new FlxSprite();
				floorBlock.makeGraphic(2, 2, 0xff00CC00);
				floorBlock.width = 2;
				floorBlock.height = 2;
				
				floorBlock.x = item.x / Dungeon.TILE_SIZE * 2;
				floorBlock.y = item.y / Dungeon.TILE_SIZE * 2;
				
				floorBlock.x += GameData.RENDER_WIDTH - DungeonGenerator.TOTAL_ROWS * 2; //shifts minimap to right side of screen
				floorBlock.y += GameData.RENDER_HEIGHT - DungeonGenerator.TOTAL_ROWS * 2; 
				
				floorBlock.alpha = 0.5;
				floorBlock.visible = true;
				
				foggedTiles.add(floorBlock);
			}
			*/
			
			playerIcon = new FlxSprite();
			playerIcon.loadGraphic(AssetsRegistry.playerMiniMapIconPNG, false, false, 6, 6);
			//playerIcon.addAnimation("blink", [0, 1], 2);
			
			//add(foggedTiles);
			add(playerIcon);
			
			toggleMiniMap();
		}
		
		override public function update():void
		{
			//var tempX:int = playerIcon.x;
			//var tempY:int = playerIcon.y;
			
			playerIcon.x = Math.round(player.x / Dungeon.TILE_SIZE) * 6 + miniMap.x;
			playerIcon.y = Math.round(player.y / Dungeon.TILE_SIZE) * 6 + miniMap.y;
			
			//playerIcon.x += GameData.RENDER_WIDTH - DungeonGenerator.TOTAL_ROWS * 2; //shifts playericon to right side of screen
			//playerIcon.y += GameData.RENDER_HEIGHT - DungeonGenerator.TOTAL_ROWS * 2;
			
			//playerIcon.x += GameData.RENDER_WIDTH - DungeonGenerator.TOTAL_ROWS * 6;
			//playerIcon.y += GameData.RENDER_HEIGHT - DungeonGenerator.TOTAL_ROWS * 6;
			
			//if (playerIcon.x != tempX || playerIcon.y != tempY) clearFog();
		}
		
		public function toggleMiniMap():void
		{
			miniMap.visible = !miniMap.visible;
			playerIcon.visible = !playerIcon.visible;
		}
		
		/*
		private function clearFog():void
		{
			for each(var tile:FlxSprite in foggedTiles.members)
			{
				if (playerIcon.x == tile.x && playerIcon.y == tile.y) 
				{
					tile.visible = true;
					break;
				}
			}
		}
		*/
	}

}