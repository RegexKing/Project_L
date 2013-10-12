package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.FloodFillFX;
	import menu.*;
	 
	public class TitleScreen extends FlxState
	{
		protected var pauseMenu:PauseMenu;
		private var modeMenu:StartMenu;
		private var introActive:Boolean;
		private var flood:FloodFillFX;
		private var effectContainer:FlxSprite;
		private var mainMenuButtons:FlxGroup;
		private var titleScreen:FlxSprite;
		private var continueButton:FlxButton;
		private var playButton:FlxButton;
		private var optionsButton:FlxButton;
		private var extrasButton:FlxButton;
		private var credit:FlxText;
	
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
			
			pauseMenu = new PauseMenu();
			pauseMenu.setAll("scrollFactor", new FlxPoint());
			pauseMenu.kill();
			
			FlxG.playMusic(AssetsRegistry.BGM_titleScreenMP3);
			FlxG.music.survive = false;
			
			mainMenuButtons = new FlxGroup(4);
			
			titleScreen = new FlxSprite();
			if (GameData.checkNewGame() == true) titleScreen.loadGraphic(AssetsRegistry.disableContinuePNG, false, false, GameData
			.RENDER_WIDTH, GameData.RENDER_HEIGHT);
			else titleScreen.loadGraphic(AssetsRegistry.titleScreenPNG, false, false, GameData.RENDER_WIDTH, GameData.RENDER_HEIGHT);
			
			titleScreen.visible = false;
			flood = FlxSpecialFX.floodFill();
			effectContainer = flood.create(titleScreen, 0, 0, titleScreen.width, titleScreen.height, 0, 1, false, 0x0, activateMenu);
			
			add(titleScreen);
			add(effectContainer);
			add(mainMenuButtons);
			
			credit = new FlxText(0, GameData.RENDER_HEIGHT - 45, 160);
			credit.scrollFactor.x = credit.scrollFactor.y = 0;
			credit.setFormat("NES", 16, 0xffFFFFFF);
			credit.text = "Snakebee 2013";
			
			add(credit);
			
			flood.start(0);
		}
		
		override public function update():void
		{
			//The pause menu is popped up here
			if (!pauseMenu.alive)
			{
				super.update();
			
				if (FlxG.mouse.justPressed() && introActive)
				{
					flood.stop();
					FlxSpecialFX.clear();
				
					initScreen();
				}
				
			}
			
			else
			{
				pauseMenu.update();	
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
			
			var modeMenu:StartMenu = new StartMenu(goStory, goRogue);
			this.add(modeMenu);
		}
		
		private function goOptions():void
		{
			if (!pauseMenu.alive)
			{
				pauseMenu = null;
				pauseMenu = new PauseMenu();
				add(pauseMenu);
			}
		}
		
		private function goExtras():void
		{
			FlxG.play(AssetsRegistry.rejectedMP3);
		}
		
		private function goStory():void
		{
			FlxG.music.fadeOut(2);
			FlxG.camera.fade(0xff000000, 2, goStartArea);
		}
		
		private function goRogue():void
		{
			FlxG.music.fadeOut(2);
			FlxG.camera.fade(0xff000000, 2, goHub);
		}
		
		private function goHub():void
		{
			FlxG.switchState(new Hub());
		}
		
		private function goStartArea():void
		{
			FlxG.switchState(new Hub()); //to do switch state to tutorial
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
			if (GameData.checkNewGame() == false)
			{
				continueButton = new FlxButton(357, 273, null, continueGame);
				continueButton.onOver = continueButtonOver;
				continueButton.onOut = continueButtonOut;
				continueButton.loadGraphic(AssetsRegistry.continueButtonPNG, false, false, 154, 45);
				continueButton.visible = false;
				mainMenuButtons.add(continueButton);
			}
			
			playButton = new FlxButton(357, 318, null, playGame);
			optionsButton = new FlxButton(357, 363, null, goOptions);
			extrasButton = new FlxButton(357, 408, null, goExtras);
			
			playButton.onOver = playButtonOver;
			optionsButton.onOver = optionsButtonOver;
			extrasButton.onOver = extrasButtonOver;
			
			playButton.onOut = playButtonOut;
			optionsButton.onOut = optionsButtonOut;
			extrasButton.onOut = extrasButtonOut;
			
			playButton.loadGraphic(AssetsRegistry.playButtonPNG, false, false, 154, 45);
			optionsButton.loadGraphic(AssetsRegistry.optionsButtonPNG, false, false, 154, 45);
			extrasButton.loadGraphic(AssetsRegistry.extrasButtonPNG, false, false, 154, 45);
			
			playButton.visible = false;
			optionsButton.visible = false;
			extrasButton.visible = false;
			
			mainMenuButtons.add(playButton);
			mainMenuButtons.add(optionsButton);
			mainMenuButtons.add(extrasButton);
		}
		
		private function initScreen():void
		{
			introActive = false;
			titleScreen.visible = true;
			createMenuButtons();
		}
		
		private function activateMenu():void
		{
			if (introActive)
			{
				initScreen();
			}
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin, otherwise resources will get messed right up after a while
			FlxSpecialFX.clear();

			super.destroy();
		}
		
		private function continueButtonOver():void
		{
			continueButton.visible = true;
		}
		
		private function playButtonOver():void
		{
			playButton.visible = true;
		}
		
		private function optionsButtonOver():void
		{
			optionsButton.visible = true;
		}
		
		private function extrasButtonOver():void
		{
			extrasButton.visible = true;
		}
		
		private function continueButtonOut():void
		{
			continueButton.visible = false;
		}
		
		private function playButtonOut():void
		{
			playButton.visible = false;
		}
		
		private function optionsButtonOut():void
		{
			optionsButton.visible = false;
		}
		
		private function extrasButtonOut():void
		{
			extrasButton.visible = false;
		}
		
	}

}