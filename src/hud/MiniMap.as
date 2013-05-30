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
		private var dungeon:Dungeon;
		private var player:Player;
		public var playerIcon:FlxSprite;
		public var tileMap:FlxTilemap;
		
		public function MiniMap(_dungeon:Dungeon, _player:Player) 
		{
			super();
			
			dungeon = _dungeon;
			player = _player;
			
			
			var mapArray:Array = dungeon.dungeonMap.getData(true);
			
			tileMap = new FlxTilemap();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(mapArray, DungeonGenerator.TOTAL_ROWS, true), FlxTilemap.ImgAuto, 6, 6, FlxTilemap.AUTO);
			
			playerIcon = new FlxSprite();
			playerIcon.loadGraphic(AssetsRegistry.playerMiniMapIconPNG, false, false, 6, 6);
			//playerIcon.addAnimation("blink", [0, 1], 2);
			
			playerIcon.x = GameData.RENDER_WIDTH / 2 - playerIcon.width / 2;
			playerIcon.y = GameData.RENDER_HEIGHT / 2 - playerIcon.height / 2;
			
			add(tileMap);
			add(playerIcon);
			
			toggleMiniMap();
		}
		
		override public function update():void
		{
			tileMap.x = playerIcon.x - (Math.round(player.x / Dungeon.TILE_SIZE) * 6);
			tileMap.y = playerIcon.y - (Math.round(player.y / Dungeon.TILE_SIZE) * 6);
		}
		
		public function toggleMiniMap():void
		{
			tileMap.visible = !tileMap.visible;
			playerIcon.visible = !playerIcon.visible;
		}
	}

}