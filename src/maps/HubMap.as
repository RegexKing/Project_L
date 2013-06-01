package maps 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	import units.BeastMan;
	import units.Girl;
	import units.Player;
	 
	public class HubMap extends Map
	{
		
		public function HubMap(_npcGroup:FlxGroup, _player:Player, _gibsGroup:FlxGroup, addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super(addToStage, onAddSpritesCallback);
			
			tileMap.loadMap(new AssetsRegistry.hubCSV, AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 2);
			
			
			var beastMan:BeastMan = new BeastMan(_player, _gibsGroup);
			var girl:Girl = new Girl(beastMan);
			_npcGroup.add(beastMan);
			_npcGroup.add(girl);
			
			girl.x = GameData.RENDER_WIDTH/2 - girl.width/2;
			girl.y = TILE_SIZE;
			
			beastMan.x = GameData.RENDER_WIDTH - (beastMan.width + TILE_SIZE);
			beastMan.y = GameData.RENDER_HEIGHT - (beastMan.height + TILE_SIZE*2);
			
			add(tileMap);
			add(girl);
			add(beastMan);
			
		}
		
	}

}