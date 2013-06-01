package maps 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	 
	public class HubMap extends Map
	{
		
		public function HubMap(addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super(addToStage, onAddSpritesCallback);
			
			tileMap.loadMap(new AssetsRegistry.hubCSV, AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 2);
			
			add(tileMap);
		}
		
	}

}