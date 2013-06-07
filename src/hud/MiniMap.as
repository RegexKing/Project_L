package  hud
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import maps.*;
	import units.*;
	import items.*;
	 
	public class MiniMap extends FlxGroup
	{
		private var isTreasure:Boolean = false; // allows treasure to spawn once
		
		private var player:Player;
		public var playerIcon:FlxSprite;
		public var treasureIcon:FlxSprite;
		public var tileMap:FlxTilemap;
		public var map:Map;
		
		public function MiniMap(_map:Map, _player:Player) 
		{
			super();
			
			player = _player;
			map = _map;
			
			var mapArray:Array = _map.tileMap.getData(true);
			
			tileMap = new FlxTilemap();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(mapArray, map.tileMap.widthInTiles, true), FlxTilemap.ImgAuto, 12, 12, FlxTilemap.AUTO);
			mapArray = null; // destroy unused map
			
			playerIcon = new FlxSprite();
			playerIcon.loadGraphic(AssetsRegistry.playerMiniMapIconPNG, true, false, 12, 12);
			playerIcon.addAnimation("blink", [0, 1], 2);
			playerIcon.play("blink");
			
			playerIcon.x = GameData.RENDER_WIDTH / 2 - playerIcon.width / 2;
			playerIcon.y = GameData.RENDER_HEIGHT / 2 - playerIcon.height / 2;
			
			if (map is DungeonMap)
			{
				treasureIcon = new FlxSprite();
				treasureIcon.makeGraphic(12, 12,  0xffFFFF00);
				treasureIcon.alpha = 0;
			
				treasureIcon.x = Math.round((_map as DungeonMap).treasure.x / Map.TILE_SIZE) * 12;
				treasureIcon.y = Math.round((_map as DungeonMap).treasure.y / Map.TILE_SIZE) * 12;
			}
			
			add(tileMap);
			add(playerIcon);
			add(treasureIcon);
			
			
			toggleMiniMap();
		}
		
		override public function update():void
		{
			super.update();
			
			tileMap.x = playerIcon.x - (Math.round(player.x / Map.TILE_SIZE) * 12);
			tileMap.y = playerIcon.y - (Math.round(player.y / Map.TILE_SIZE) * 12);
			
			
			if (map is DungeonMap)
			{
				//fuck this
				treasureIcon.x = tileMap.x +  Math.round((map as DungeonMap).treasure.x / Map.TILE_SIZE) * 12;
				treasureIcon.y = tileMap.y + Math.round((map as DungeonMap).treasure.y / Map.TILE_SIZE) * 12;
			
				if (Enemy.totalEnemies <= 0 && !isTreasure)
				{
					isTreasure = true;
					treasureAppear();
				}
			}
		}
		
		public function toggleMiniMap():void
		{
			tileMap.visible = !tileMap.visible;
			playerIcon.visible = !playerIcon.visible;
			if (map is DungeonMap) treasureIcon.visible = !treasureIcon.visible;
		}
		
		private function treasureAppear():void
		{
			(map as DungeonMap).spawnTeasure();
			
			treasureIcon.alpha = 1;
		}
	}

}