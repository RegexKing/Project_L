package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Player extends FlxSprite
	{
		
		private const SPEED:int = 100;
		private var normalGun:FlxWeapon;
		
		public function Player() 
		{
			super();
			
			makeGraphic(21, 26, 0xff00FF00);
			
			width = 21;
			height = 26;
			
			normalGun = new FlxWeapon("normal", this);
			normalGun.makePixelBullet(25, 8, 8, 0xffffffff, 10, 13);
			normalGun.setBulletBounds(new FlxRect(0, 0, 1280, 1280));
			normalGun.setBulletSpeed(200);
			normalGun.setFireRate(250);
			
		}
		
		override public function update():void
		{
			if (FlxG.keys.pressed("A")) velocity.x = -(SPEED);
			else if (FlxG.keys.pressed("D")) velocity.x = SPEED;
			else velocity.x = 0;
			
			if (FlxG.keys.pressed("W")) velocity.y = -(SPEED);
			else if (FlxG.keys.pressed("S")) velocity.y = SPEED;
			else velocity.y = 0;
			
			if (FlxG.mouse.pressed()) normalGun.fireAtMouse();
		}
		
		override public function kill():void
		{
			super.kill();
			normalGun.group.kill();
		}
		
		public function get bullets():FlxGroup
		{
			return normalGun.group;
		}
		
	}

}