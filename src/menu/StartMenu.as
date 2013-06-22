package menu 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxGradient;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class StartMenu extends FlxGroup
	{
		private var goStory:Function;
		private var goRogue:Function;
		private var background:FlxSprite;
		private var modeImg:FlxSprite;
		private var storyButton:FlxButton;
		private var rogueButton:FlxButton;
		
		public function StartMenu(_goStory:Function, _goRogue:Function) 
		{
			super();
			goStory = _goStory;
			goRogue = _goRogue;
			
			modeImg = new FlxSprite(124, 133, AssetsRegistry.startMenuPNG);
			
			background = FlxGradient.createGradientFlxSprite(292, 214, [0xff0066FF, 0xff000066], 2);
			background.alpha = 0.6
			background.x = modeImg.x;
			background.y = modeImg.y;
			
			storyButton = new FlxButton(modeImg.x + 20, modeImg.y + 20, null, chooseStory);
			rogueButton = new FlxButton(modeImg.x + 20 + 116 +20, modeImg.y + 20, null, chooseRogue);
			storyButton.loadGraphic(AssetsRegistry.modeHighlightPNG, false, false, 116, 174);
			rogueButton.loadGraphic(AssetsRegistry.modeHighlightPNG, false, false, 116, 174);
			
			
			storyButton.onOver = storyButtonOver;
			storyButton.onOut = storyButtonOut;
			rogueButton.onOver = rogueButtonOver;
			rogueButton.onOut = rogueButtonOut;
			
			storyButton.visible = false;
			rogueButton.visible = false;
			
			this.add(background);
			this.add(modeImg);
			this.add(storyButton);
			this.add(rogueButton);
		}
		
		private function chooseStory():void
		{
			kill();
			GameData.resetData();
			GameData.cravenMode = true;
			goStory();
		}
		
		private function chooseRogue():void
		{
			kill();
			GameData.resetData();
			GameData.cravenMode = false;
			goRogue();
		}
		
		private function storyButtonOver():void
		{
			storyButton.visible = true;
		}
		
		private function rogueButtonOver():void
		{
			rogueButton.visible = true;
		}
		
		private function storyButtonOut():void
		{
			storyButton.visible = false;
		}
		
		private function rogueButtonOut():void
		{
			rogueButton.visible = false;
		}
		
		override public function kill():void
		{
			super.kill();
			
			background.kill();
			modeImg.kill();
			storyButton.kill();
			rogueButton.kill();
		}
		
		override public function revive():void
		{
			super.revive();
			
			background.revive();
			modeImg.revive();
			storyButton.revive();
			rogueButton.revive();
			
			this.add(background);
			this.add(modeImg);
			this.add(storyButton);
			this.add(rogueButton);
		}
		
	}

}