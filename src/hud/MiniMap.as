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
		public var treasureIcons:Array;
		public var tileMap:FlxTilemap;
		public var map:Map;
		public var isToggled:Boolean;
		
		public function MiniMap(_map:Map, _player:Player) 
		{
			super();
			isToggled = true;
			
			player = _player;
			map = _map;
			treasureIcons = new Array();
			
			
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
			
			
			add(tileMap);
			
			if (map is DungeonMap)
			{
				for (var i:int = 0; i < GameData.CHESTS_PER_LEVEL; i++)
				{
					var treasureIcon:FlxSprite = new FlxSprite();
					treasureIcon.loadGraphic(AssetsRegistry.treasureMiniMapIconPNG);
					treasureIcon.alpha = 0;
			
					treasureIcon.x = Math.round((_map as DungeonMap).treasures[i].x / Map.TILE_SIZE) * 12;
					treasureIcon.y = Math.round((_map as DungeonMap).treasures[i].y / Map.TILE_SIZE) * 12;
					
					treasureIcons.push(treasureIcon);
					add(treasureIcon);
				}
			}
			
			add(playerIcon);	
			
			toggleMiniMap();
		}
		
		override public function update():void
		{
			super.update();
			
			
			if (FlxG.keys.justPressed("M") || FlxG.keys.justPressed("TAB"))
				{
					toggleMiniMap();
				}
			
			tileMap.x = playerIcon.x - (Math.round(player.x / Map.TILE_SIZE) * 12);
			tileMap.y = playerIcon.y - (Math.round(player.y / Map.TILE_SIZE) * 12);
			
			
			if (map is DungeonMap)
			{
				for (var i:int = 0; i < treasureIcons.length; i++)
				{
				
					//fuck this
					treasureIcons[i].x = tileMap.x +  Math.round((map as DungeonMap).treasures[i].x / Map.TILE_SIZE) * 12;
					treasureIcons[i].y = tileMap.y + Math.round((map as DungeonMap).treasures[i].y / Map.TILE_SIZE) * 12;
					
					if ((map as DungeonMap).treasures[i].onScreen() && player.onScreen())
					{
						treasureIcons[i].alpha = 1;
					}
				}
			}
		}
		
		public function toggleMiniMap():void
		{
			isToggled = !isToggled;
			tileMap.visible = !tileMap.visible;
			playerIcon.visible = !playerIcon.visible;
			if (map is DungeonMap)
			{
				for (var i:int = 0; i < GameData.CHESTS_PER_LEVEL; i++)
				{
					treasureIcons[i].visible = !treasureIcons[i].visible;
				}
			}
		}
	}

}