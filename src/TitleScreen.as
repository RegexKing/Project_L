package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.FloodFillFX;
	 
	public class TitleScreen extends FlxState
	{
		private var flood:FloodFillFX;
		private var effectContainer:FlxSprite;
		private var mainMenuButtons:FlxGroup;
	
		public function TitleScreen() 
		{
		}
		
		override public function create():void
		{
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			
			mainMenuButtons = new FlxGroup(4);
			
			var titleScreen:FlxSprite = new FlxSprite();
			titleScreen.loadGraphic(AssetsRegistry.titleScreenPNG, false, false, 512, 480);
			flood = FlxSpecialFX.floodFill();
			effectContainer = flood.create(titleScreen, 0, 0, titleScreen.width, titleScreen.height, 0);
			
			var continueButton:FlxButton = new FlxButton(330, 278, null, continueGame);
			var playButton:FlxButton = new FlxButton(330, 323, null, playGame);
			var optionsButton:FlxButton = new FlxButton(330, 368, null, goOptions);
			var extrasButton:FlxButton = new FlxButton(330, 413, null, goExtras);
			
			continueButton.makeGraphic(154, 45, 0xff666666);
			continueButton.alpha = 0.5;
			if (GameData.checkNewGame() == false) continueButton.alpha = 0;
			playButton.makeGraphic(154, 45, 0x0);
			optionsButton.makeGraphic(154, 45, 0x0);
			extrasButton.makeGraphic(154, 45, 0x0);
			
			mainMenuButtons.add(continueButton);
			mainMenuButtons.add(playButton);
			mainMenuButtons.add(optionsButton);
			mainMenuButtons.add(extrasButton);
			
			add(effectContainer);
			add(mainMenuButtons);
			
			flood.start(0);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justPressed())
			{
				flood.stop();
			}
		}
		
		private function continueGame():void
		{
			if (GameData.checkNewGame() == false)
			{
				disableMenuButtons();
				GameData.loadData();
			
				FlxG.camera.fade(0xff000000, 2, goHub);
			}
		}
		
		private function playGame():void
		{
			disableMenuButtons();
			FlxG.camera.fade(0xff000000, 2, goHub);
		}
		
		private function goOptions():void
		{
			
		}
		
		private function goExtras():void
		{
			
		}
		
		private function goStartArea():void
		{
			
		}
		
		private function goHub():void
		{
			FlxG.switchState(new Hub());
		}
		
		private function disableMenuButtons():void
		{
			mainMenuButtons.setAll("active", false);
		}
		
		private function enableMenuButtons():void
		{
			mainMenuButtons.setAll("active", true);
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin, otherwise resources will get messed right up after a while
			FlxSpecialFX.clear();

			super.destroy();
		}
		
	}

}