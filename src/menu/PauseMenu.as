package menu 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FlxGradient;
	 
	public class PauseMenu extends FlxGroup
	{
		
		public function PauseMenu() 
		{
			super();
			
			var resume:FlxButtonPlus = new FlxButtonPlus(200, 100, null, null, "Resume Game");
			var toggleMusic:FlxButtonPlus = new FlxButtonPlus(200, 150, null, null, "Toggle BGM");
			var toggleSounds:FlxButtonPlus = new FlxButtonPlus(200, 200, null, null, "ToggleSound");
			
			add(resume);
			add(toggleMusic);
			add(toggleSounds);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("P") || FlxG.keys.justPressed("ESCAPE"))
			{
				FlxG.paused = !FlxG.paused;
			}
		}
		
		private function resumeGame():void
		{
			FlxG.paused = !FlxG.paused;
		}
		
	}

}