package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * 
	 * ...
	 * @author Frank Fazio
	 */
	public class Player extends FlxSprite
	{
		
		private const SPEED:int = 100;
		private var normalGun:FlxWeapon;
		public var playerGibs:FlxEmitter;
		
		public function Player(_gibsGroup:FlxGroup) 
		{
			super();
			
			makeGraphic(20, 20, 0xff00FF00);
			
			width = 20;
			height = 20;
			
			playerGibs = new FlxEmitter();
			playerGibs.particleDrag = new FlxPoint(150, 150);
			playerGibs.setXSpeed(-150,150);
			playerGibs.setYSpeed(-150,150);
			playerGibs.setRotation(0, 0);
			playerGibs.bounce = 0.5;
			playerGibs.makeParticles(AssetsRegistry.playerGibsPNG, 100, 10, true, 0.5);
			
			_gibsGroup.add(playerGibs);
			
			normalGun = new FlxWeapon("normal", this);
			normalGun.makePixelBullet(25, 8, 8, 0xffffffff, 10, 13);
			normalGun.setBulletBounds(new FlxRect(0, 0, Dungeon.width, Dungeon.height));
			normalGun.setBulletSpeed(300);
			normalGun.setFireRate(500);
			
		}
		
		override public function update():void
		{
			if (alive)
			{
				if (FlxG.keys.pressed("A")) velocity.x = -(SPEED);
				else if (FlxG.keys.pressed("D")) velocity.x = SPEED;
				else velocity.x = 0;
			
				if (FlxG.keys.pressed("W")) velocity.y = -(SPEED);
				else if (FlxG.keys.pressed("S")) velocity.y = SPEED;
				else velocity.y = 0;
			
				if (FlxG.mouse.pressed()) normalGun.fireAtMouse();
			}
		}
		
		public function get bullets():FlxGroup
		{
			return normalGun.group;
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			this.flicker(_damagePoints);
			FlxG.camera.shake(0.005,0.35);
		}
		
		override public function kill():void
		{
			if(!alive) return;
			solid = false;
			// TODO add death sound
			super.kill();
			exists = true;
			visible = false;
			velocity.make()
			acceleration.make();
			FlxG.camera.shake(0.01,0.35);
			FlxG.camera.flash(0xffFF0000, 0.35);
			
			if(playerGibs != null)
			{
				playerGibs.at(this);
				playerGibs.start(true, 10, 0, 50);
			}
		}
		
	}

}