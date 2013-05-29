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
		private var playerIcon:FlxSprite;
		private var mapArray:Array;
		private var miniMap:FlxTilemap;
		
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
			
			playerIcon = new FlxSprite();
			playerIcon.loadGraphic(AssetsRegistry.playerMiniMapIconPNG, false, false, 6, 6);
			//playerIcon.addAnimation("blink", [0, 1], 2);
			
			add(playerIcon);
			
			toggleMiniMap();
		}
		
		override public function update():void
		{
			playerIcon.x = Math.round(player.x / Dungeon.TILE_SIZE) * 6 + miniMap.x;
			playerIcon.y = Math.round(player.y / Dungeon.TILE_SIZE) * 6 + miniMap.y;
		}
		
		public function toggleMiniMap():void
		{
			miniMap.visible = !miniMap.visible;
			playerIcon.visible = !playerIcon.visible;
		}
	}

}