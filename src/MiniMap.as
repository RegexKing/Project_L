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
		
		private var foggedTiles:FlxGroup;
		
		public function MiniMap(_dungeon:Dungeon, _player:Player) 
		{
			super();
			
			dungeon = _dungeon;
			player = _player;
			
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
				floorBlock.visible = false;
				
				foggedTiles.add(floorBlock);
			}
			
			playerIcon = new FlxSprite();
			playerIcon.makeGraphic(2, 2, 0xffFF0000);
			playerIcon.width = 2;
			playerIcon.height = 2;
			
			add(foggedTiles);
			add(playerIcon);
		}
		
		override public function update():void
		{
			var tempX:int = playerIcon.x;
			var tempY:int = playerIcon.y;
			
			playerIcon.x = Math.round(player.x / Dungeon.TILE_SIZE) * 2;
			playerIcon.y = Math.round(player.y / Dungeon.TILE_SIZE) * 2;
			
			playerIcon.x += GameData.RENDER_WIDTH - DungeonGenerator.TOTAL_ROWS * 2; //shifts playericon to right side of screen
			playerIcon.y += GameData.RENDER_HEIGHT - DungeonGenerator.TOTAL_ROWS * 2;
			
			if (playerIcon.x != tempX || playerIcon.y != tempY) clearFog();
		}	
		
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
	}

}