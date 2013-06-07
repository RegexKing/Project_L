package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class AssetsRegistry 
	{
		
		//Sprites
		
		[Embed(source = "../assets/sprites/disableContinue.png")] public static var disableContinuePNG:Class;
		[Embed(source = "../assets/sprites/titleScreen.png")] public static var titleScreenPNG:Class;
		[Embed(source = "../assets/sprites/beastPortrait.png")] public static var beastPortraitPNG:Class;
		[Embed(source = "../assets/sprites/guyPortrait.png")] public static var guyPortraitPNG:Class;
		[Embed(source = "../assets/sprites/girlPortrait.png")] public static var girlPortraitPNG:Class;
		[Embed(source = "../assets/sprites/crystalLight.png")] public static var crystalLightPNG:Class;
		[Embed(source = "../assets/sprites/playerMiniMapIcon.png")] public static var playerMiniMapIconPNG:Class;
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
		
		// Maps
		[Embed(source = "../assets/maps/hub.csv", mimeType = "application/octet-stream")] public static var hubCSV:Class;
		
		//Bgms
		// yearning
		[Embed(source = "../assets/sounds/titleScreenBGM.mp3")] public static var BGM_titleScreenMP3:Class;
		[Embed(source = "../assets/sounds/dungeonBGM.mp3")] public static var BGM_dungeonMP3:Class;
		// Khuskan - Allegro (ID: 53103)
		[Embed(source = "../assets/sounds/hubBGM.mp3")] public static var BGM_hubMP3:Class;
		//danosongs.com-origo-vitae
		[Embed(source = "../assets/sounds/beastBGM.mp3")] public static var BGM_beastMP3:Class;
		
		//Sounds
		[Embed(source = "../assets/sounds/shoot.mp3")] public static var shootMP3:Class;
		[Embed(source = "../assets/sounds/healthPickup.mp3")] public static var healthPickupMP3:Class;
		[Embed(source = "../assets/sounds/diamondPickup.mp3")] public static var diamondPickupMP3:Class;
		[Embed(source = "../assets/sounds/playerDie.mp3")] public static var playerDieMP3:Class;
		[Embed(source = "../assets/sounds/playerHurt.mp3")] public static var playerHurtMP3:Class;
		[Embed(source = "../assets/sounds/enemyHurt.mp3")] public static var enemyHurtMP3:Class;
		[Embed(source = "../assets/sounds/enemyDie.mp3")] public static var enemyDieMP3:Class;
		
		//Fonts
		[Embed(source="../assets/fonts/megaman.ttf", fontFamily="NES", embedAsCFF="false")] public static var fontNES:String;
		
		
		public function AssetsRegistry() {}
		
	}

}