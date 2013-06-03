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
		private var introActive:Boolean;
		private var flood:FloodFillFX;
		private var effectContainer:FlxSprite;
		private var mainMenuButtons:FlxGroup;
		private var titleScreen:FlxSprite;
	
		public function TitleScreen() 
		{
		}
		
		override public function create():void
		{
			introActive = true;
			
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			
			FlxG.playMusic(AssetsRegistry.BGM_titleScreenMP3);
			FlxG.music.survive = false;
			
			mainMenuButtons = new FlxGroup(4);
			
			titleScreen = new FlxSprite();
			titleScreen.loadGraphic(AssetsRegistry.titleScreenPNG, false, false, 512, 480);
			titleScreen.visible = false;
			flood = FlxSpecialFX.floodFill();
			effectContainer = flood.create(titleScreen, 0, 0, titleScreen.width, titleScreen.height, 0);
			
			add(titleScreen);
			add(effectContainer);
			add(mainMenuButtons);
			
			flood.start(0);
			var introTimer:FlxDelay = new FlxDelay(8500); //this is used to activate menu after flood effect
			introTimer.callback = timerHandler;
			introTimer.start();
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justPressed() && introActive)
			{
				introActive = false;
				flood.stop();
				FlxSpecialFX.clear();
				initScreen();
			}
		}
		
		private function continueGame():void
		{
			if (GameData.checkNewGame() == false)
			{
				disableMenuButtons();
				GameData.loadData();
				
				FlxG.music.fadeOut(2);
				FlxG.camera.fade(0xff000000, 2, goHub);
			}
		}
		
		private function playGame():void
		{
			disableMenuButtons();
			FlxG.music.fadeOut(2);
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
		
		public function disableMenuButtons():void
		{
			mainMenuButtons.setAll("active", false);
		}
		
		public function enableMenuButtons():void
		{
			mainMenuButtons.setAll("active", true);
		}
		
		private function createMenuButtons():void
		{
			var continueButton:FlxButton = new FlxButton(330, 278, null, continueGame);
			var playButton:FlxButton = new FlxButton(330, 323, null, playGame);
			var optionsButton:FlxButton = new FlxButton(330, 368, null, goOptions);
			var extrasButton:FlxButton = new FlxButton(330, 413, null, goExtras);
			
			continueButton.makeGraphic(154, 45, 0x0);
			playButton.makeGraphic(154, 45, 0x0);
			optionsButton.makeGraphic(154, 45, 0x0);
			extrasButton.makeGraphic(154, 45, 0x0);
			
			if (GameData.checkNewGame() != false) 
			{
				var disableContinue:FlxSprite = new FlxSprite(332, 280, AssetsRegistry.disableContinuePNG);
				add(disableContinue);
			}
			
			mainMenuButtons.add(continueButton);
			mainMenuButtons.add(playButton);
			mainMenuButtons.add(optionsButton);
			mainMenuButtons.add(extrasButton);
		}
		
		private function initScreen():void
		{
			titleScreen.visible = true;
			createMenuButtons();
		}
		
		private function timerHandler():void
		{
			FlxG.log("hit");
			if (introActive)
			{
				introActive = false;
				initScreen();
			}
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin, otherwise resources will get messed right up after a while
			FlxSpecialFX.clear();

			super.destroy();
		}
		
	}

}