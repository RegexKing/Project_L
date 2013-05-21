package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import mx.core.FlexSprite;
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
				
				floorBlock.alpha = 0.5;
				floorBlock.visible = false;
				
				foggedTiles.add(floorBlock);
			}
			
			add(foggedTiles);
			
			playerIcon = new FlxSprite();
			playerIcon.makeGraphic(2, 2, 0xffFF0000);
			playerIcon.width = 2;
			playerIcon.height = 2;
			add(playerIcon);
		}
		
		override public function update():void
		{
			var tempX:int = playerIcon.x;
			var tempY:int = playerIcon.y;
			
			playerIcon.x = Math.round(player.x / Dungeon.TILE_SIZE) * 2;
			playerIcon.y = Math.round(player.y / Dungeon.TILE_SIZE) * 2;
			playerIcon.x += 256 - 80;
			
			if (playerIcon.x != tempX || playerIcon.y != tempY) updatePlayerLocation();
		}	
		
		private function updatePlayerLocation():void
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