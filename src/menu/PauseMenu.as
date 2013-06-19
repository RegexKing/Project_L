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
			background.x = 186;
			background.y = 140;
			
			resume = new FlxButton(206, 160, "Resume", resumeGame);
			
			toggleMusic = new FlxButton(206, 180, "Toggle BGM", toggleBgm);
			toggleSounds = new FlxButton(206, 200, "Toggle Sound", toggleSound);
			
			bestQuality = new FlxButton(206, 240, "Best", setBest);
			highQuality = new FlxButton(206, 260, "High", setHigh);
			mediumQuality = new FlxButton(206, 280, "Medium", setMedium);
			lowQuality = new FlxButton(206, 300, "Low", setLow);
			
			returnToTitle = new FlxButton(206, 340, "Return to Title", goTitleScreen);
			
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