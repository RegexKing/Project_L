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
		private var player:Player;
		public var playerIcon:FlxSprite;
		public var tileMap:FlxTilemap;
		
		public function MiniMap(_map:Map, _player:Player) 
		{
			super();
			
			player = _player;
			
			
			var mapArray:Array = _map.tileMap.getData(true);
			
			tileMap = new FlxTilemap();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(mapArray, DungeonGenerator.TOTAL_ROWS, true), FlxTilemap.ImgAuto, 12, 12, FlxTilemap.AUTO);
			mapArray = null; // destroy unused map
			
			playerIcon = new FlxSprite();
			playerIcon.loadGraphic(AssetsRegistry.playerMiniMapIconPNG, true, false, 12, 12);
			playerIcon.addAnimation("blink", [0, 1], 4);
			playerIcon.play("blink");
			
			playerIcon.x = GameData.RENDER_WIDTH / 2 - playerIcon.width / 2;
			playerIcon.y = GameData.RENDER_HEIGHT / 2 - playerIcon.height / 2;
			
			add(tileMap);
			add(playerIcon);
			
			toggleMiniMap();
		}
		
		override public function update():void
		{
			tileMap.x = playerIcon.x - (Math.round(player.x / Map.TILE_SIZE) * 12);
			tileMap.y = playerIcon.y - (Math.round(player.y / Map.TILE_SIZE) * 12);
		}
		
		public function toggleMiniMap():void
		{
			tileMap.visible = !tileMap.visible;
			playerIcon.visible = !playerIcon.visible;
		}
	}

}