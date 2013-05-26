package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class AssetsRegistry 
	{
		
		//Sprites
		[Embed(source = "../assets/sprites/playerGibs.png")] public static var playerGibsPNG:Class;
		[Embed(source = "../assets/sprites/zelda-hearts.png")] public static var lifeHeartsPNG:Class;
		
		//Tiles
		[Embed(source = '../assets/tiles/dun.png')] public static var randDunTilesPNG:Class;
		
		
		public function AssetsRegistry() {}
		
	}

}