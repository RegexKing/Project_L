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
		[Embed(source = "../assets/sprites/healthItem.png")] public static var HealthItemPNG:Class;
		[Embed(source = "../assets/sprites/lifeBar-3.png")] public static var lifeBar_3PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar-4.png")] public static var lifeBar_4PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar-5.png")] public static var lifeBar_5PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar-6.png")] public static var lifeBar_6PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar-7.png")] public static var lifeBar_7PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar-8.png")] public static var lifeBar_8PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar_border-3.png")] public static var lifeBar_border_3PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar_border-4.png")] public static var lifeBar_border_4PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar_border-5.png")] public static var lifeBar_border_5PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar_border-6.png")] public static var lifeBar_border_6PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar_border-7.png")] public static var lifeBar_border_7PNG:Class;
		[Embed(source = "../assets/sprites/lifeBar_border-8.png")] public static var lifeBar_border_8PNG:Class;
		
		//Tiles
		[Embed(source = "../assets/tiles/dun.png")] public static var randDunTilesPNG:Class;
		
		//Fonts
		[Embed(source="../assets/fonts/megaman.ttf", fontFamily="NES", embedAsCFF="false")] public static var fontNES:String;
		
		
		public function AssetsRegistry() {}
		
	}

}