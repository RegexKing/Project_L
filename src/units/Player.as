package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	import maps.Dungeon;
	/**
	 * 
	 * ...
	 * @author Frank Fazio
	 */
	public class Player extends FlxSprite
	{
		//constants
		private const MOVEMENT_SPEED:Number = 100;
		private const NORMAL_RATE:Number = 500;
		
		public static const NORMAL_GUN:uint = 0;
		
		private var normalGun:FlxWeapon;
		public var playerGibs:FlxEmitter;
		
		public function Player(_gibsGroup:FlxGroup) 
		{
			super();
			
			makeGraphic(20, 20, 0xff00FF00);
			
			width = 20;
			height = 20;
			
			playerGibs = new FlxEmitter();
			playerGibs.particleDrag = new FlxPoint(300, 300);
			playerGibs.setXSpeed(-200,200);
			playerGibs.setYSpeed(-200,200);
			playerGibs.setRotation(0, 0);
			playerGibs.bounce = 0.5;
			playerGibs.makeParticles(AssetsRegistry.playerGibsPNG, 100, 10, true, 0.5);
			
			_gibsGroup.add(playerGibs);
			
			normalGun = new FlxWeapon("normal", this);
			normalGun.makePixelBullet(25, 8, 8, 0xffffffff, 10, 13);
			normalGun.setBulletBounds(new FlxRect(0, 0, Dungeon.width, Dungeon.height));
			normalGun.setBulletSpeed(300);
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * GameData.fireRateMultiplier));
			//var normalGunSND:FlxSound = new FlxSound();
			//normalGunSND.loadEmbedded(AssetsRegistry.shootMP3);
			normalGun.setPreFireCallback(null, AssetsRegistry.shootMP3);
		}
		
		override public function update():void
		{
			if (alive)
			{
				if (FlxG.keys.pressed("A")) velocity.x = -(MOVEMENT_SPEED);
				else if (FlxG.keys.pressed("D")) velocity.x = MOVEMENT_SPEED;
				else velocity.x = 0;
			
				if (FlxG.keys.pressed("W")) velocity.y = -(MOVEMENT_SPEED);
				else if (FlxG.keys.pressed("S")) velocity.y = MOVEMENT_SPEED;
				else velocity.y = 0;
				
				// switch statement to fire correct weapon
				if (FlxG.mouse.pressed())
				{
					switch(GameData.weapon)
					{
						case NORMAL_GUN:
							normalGun.fireAtMouse();
							break;
						default:
							throw new Error("Weapon id number is out acceptable range");
							break;
					}
				}
			}
		}
		
		public function set fireRateMultiplier(_fireRateMultiplier:Number):void //To use at home
		{
			//TODO: update the firerates of all weapons
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * _fireRateMultiplier));
		}
		
		public function get bullets():FlxGroup
		{
			return normalGun.group;
		}
		
		override public function hurt(_damageNumber:Number):void
		{
			this.flicker(1);
			FlxG.camera.shake(0.005, 0.35);
			
			//sound effect
			FlxG.play(AssetsRegistry.playerHurtMP3);
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
				playerGibs.start(true, 0, 0, 50);
			}
			
			//sound effect
			FlxG.play(AssetsRegistry.playerDieMP3);
		}
		
	}

}