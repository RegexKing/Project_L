package util 
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import units.Player;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class NewWeapon extends FlxSprite
	{
		
		private var timer:FlxDelay;
		private var timerStarted:Boolean = false;
		
		public function NewWeapon(_player:Player) 
		{
			super(_player.x + _player.width/2, _player.y + _player.height/2);
			
			loadGraphic(AssetsRegistry.newWeaponPNG, true, false, 148, 14);
			this.x -= this.width / 2;
			this.y -= this.height / 2;
			this.addAnimation("flash", [0, 1, 2], 30);
			this.play("flash");
			
			timer = new FlxDelay(3000);
			timer.callback = kill;
			timer.start();
		}
		
		override public function update():void
		{
			super.update();
			
			this.y -= 0.5;
			
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			if (timer != null)
			{
				timer.abort();
				timer  =  null;
			}
		}
		
	}

}