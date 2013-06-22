package menu 
{
	
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FlxGradient;
	import flash.display.Sprite;
    import flash.display.StageQuality;
        
	 
	public class PauseMenu extends FlxGroup
	{
		public static var isMusicOn:Boolean = true;
		
		private var resume:FlxButton;
		private var toggleMusic:FlxButton;
		private var toggleSounds:FlxButton;
		private var lowQuality:FlxButton;
		private var mediumQuality:FlxButton;
		private var highQuality:FlxButton;
		private var bestQuality:FlxButton;
		private var returnToTitle:FlxButton;
		private var background:FlxSprite;
		
		public function PauseMenu() 
		{
			super();
			
			background = FlxGradient.createGradientFlxSprite(120, 240, [0xff0066FF, 0xff000066], 20);
			background.alpha = 0.6
			background.x = 210;
			background.y = 132;
			
			resume = new FlxButton(230, 152, "Resume", resumeGame);
			
			toggleMusic = new FlxButton(230, 172, "Toggle Music", toggleBgm);
			toggleSounds = new FlxButton(230, 192, "Toggle Sound", toggleSound);
			
			bestQuality = new FlxButton(230, 232, "Best", setBest);
			highQuality = new FlxButton(230, 252, "High", setHigh);
			mediumQuality = new FlxButton(230, 272, "Medium", setMedium);
			lowQuality = new FlxButton(230, 292, "Low", setLow);
			
			returnToTitle = new FlxButton(230, 332, "Return to Title", goTitleScreen);
			
			add(background);
			add(resume);
			add(toggleMusic);
			add(toggleSounds);
			add(bestQuality);
			add(highQuality);
			add(mediumQuality);
			add(lowQuality);
			add(returnToTitle);
		}
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("P"))
			{
				leaveMenu();
			} 
			
			super.update();	
		}
		
		private function resumeGame():void
		{
			leaveMenu();
		}
		
		private function toggleBgm():void
		{
			if (isMusicOn) 
			{
				FlxG.music.pause();
				isMusicOn = false;
			}
			
			else 
			{
				FlxG.music.resume();
				isMusicOn = true;
			}
		}
		
		private function toggleSound():void
		{
			FlxG.mute = !FlxG.mute;
		}
		
		private function setBest():void
		{
			FlxG.stage.quality = StageQuality.BEST;
		}
		
		private function setHigh():void
		{
			FlxG.stage.quality = StageQuality.HIGH;
		}
		
		private function setMedium():void
		{
			FlxG.stage.quality = StageQuality.MEDIUM;
		}
		
		private function setLow():void
		{
			FlxG.stage.quality = StageQuality.LOW;
		}
		
		private function goTitleScreen():void
		{
			FlxG.switchState(new TitleScreen());
		}
		
		private function leaveMenu():void
		{
			this.kill();
			this.exists = false;
		}
		
		override public function revive():void
		{
			super.revive();
			
			background.revive();
			resume.revive();
			toggleMusic.revive();
			toggleSounds.revive();
			bestQuality.revive();
			highQuality.revive();
			mediumQuality.revive();
			lowQuality.revive();
			returnToTitle.revive();
			
			add(background);
			add(resume);
			add(toggleMusic);
			add(toggleSounds);
			add(bestQuality);
			add(highQuality);
			add(mediumQuality);
			add(lowQuality);
			add(returnToTitle);
		}
		
	}

}