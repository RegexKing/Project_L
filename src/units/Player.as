package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import weapons.BaseGun;
	import weapons.BounceGun;
	
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
		private const BOUNCE_RATE:Number = 400;
		
		public static const NORMAL_GUN:uint = 0;
		public static const BOUNCE_GUN:uint = 1;
		
		private var normalGun:BaseGun;
		private var bounceGun:BounceGun;
		public var playerGibs:FlxEmitter;
		
		private var playerBullets:FlxGroup;
		private var enemiesGroup:FlxGroup;
		
		public function Player(_gibsGroup:FlxGroup, _enemiesGroup:FlxGroup) 
		{
			super();
			
			enemiesGroup = _enemiesGroup;
			
			makeGraphic(20, 20, 0xff00FF00);
			
			width = 20;
			height = 20;
			
			playerGibs = new FlxEmitter(0, 0, 50);
			playerGibs.particleDrag = new FlxPoint(300, 300);
			playerGibs.setXSpeed(-200,200);
			playerGibs.setYSpeed(-200,200);
			playerGibs.setRotation(0, 0);
			playerGibs.bounce = 0.5;
			playerGibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true, 0.5);
			
			_gibsGroup.add(playerGibs);
			
			playerBullets = new FlxGroup();
			
			normalGun = new BaseGun("normal", this);
			normalGun.makePixelBullet(25, 8, 8, 0xffffffff, 10, 13);
			normalGun.setBulletBounds(new FlxRect(0, 0, Dungeon.width, Dungeon.height));
			normalGun.setBulletSpeed(300);
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * GameData.fireRateMultiplier));
			normalGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3); 
			
			bounceGun = new BounceGun("bounce", this);
			bounceGun.makePixelBullet(25, 8, 8, 0xffffffff, 10, 13);
			bounceGun.setBulletBounds(new FlxRect(0, 0, Dungeon.width, Dungeon.height));
			bounceGun.setBulletSpeed(300);
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * GameData.fireRateMultiplier));
			bounceGun.setBulletElasticity(0.8);
			bounceGun.setBulletLifeSpan(1000);
			bounceGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3);
			
			playerBullets.add(normalGun.group);
			playerBullets.add(bounceGun.group);
			
			if (FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
			
			FlxControl.create(this, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, false);
			FlxControl.player1.setWASDControl();
			FlxControl.player1.setStandardSpeed(100);
		}
		
		override public function update():void
		{	
			if (alive)
			{
				// switch statement to fire correct weapon
				if (FlxG.mouse.pressed())
				{
					switch(GameData.weapon)
					{
						case NORMAL_GUN:
							normalGun.fireAtMouse();
							break;
							
						case BOUNCE_GUN:
							bounceGun.fireAtMouse();
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
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * _fireRateMultiplier));
		}
		
		public function get bullets():FlxGroup
		{
			return playerBullets;
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
				playerGibs.start(true, 0, 0, 0);
			}
			
			//sound effect
			FlxG.play(AssetsRegistry.playerDieMP3);
		}
		
		private function alertEnemies():void
		{
			for each (var enemy:Enemy in enemiesGroup.members)
			{
				if (enemy.alive && enemy.isEnemyNear())
				{
					enemy.aware = true;
				}
			}
		}
		
		override public function destroy():void
		{
			FlxControl.clear();
			
			super.destroy();
		}
		
	}

}