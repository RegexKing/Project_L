package  units
{
	import maps.Map;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import weapons.*;
	
	/**
	 * 
	 * ...
	 * @author Frank Fazio
	 */
	public class Player extends FlxSprite
	{
		//constants
		private const MOVEMENT_SPEED:Number = 100;
		//
		
		public var playerGibs:FlxEmitter;
		protected var playerBulletsGroup:FlxGroup;
		protected var spriteAddons:FlxGroup;
		protected var alertEnemies:Function;
		
		public var fireable:Boolean;
		
		//Gun Vars
		protected const NORMAL_RATE:Number = 500;
		protected const BOUNCE_RATE:Number = 400;
		protected const CROSSBOW_RATE:Number = 1100;
		
		public static const NORMAL_GUN:uint = 0;
		public static const BOUNCE_GUN:uint = 1;
		public static const CROSSBOW:uint = 2;
		
		protected var normalGun:FlxWeapon;
		protected var bounceGun:BounceGun;
		protected var crossbow:Crossbow;
		
		public function Player(_gibsGroup:FlxGroup, _playerBulletsGroup:FlxGroup, _spriteAddons:FlxGroup, _alertEnemies:Function) 
		{
			super();
			
			playerBulletsGroup = _playerBulletsGroup;
			spriteAddons = _spriteAddons;
			alertEnemies = _alertEnemies;
			fireable = true;
			
			makeGraphic(40, 40, 0xffFF9900);
			
			width = 40;
			height = 40;
			
			playerGibs = new FlxEmitter(0, 0, 50);
			playerGibs.particleDrag = new FlxPoint(600, 600);
			playerGibs.setXSpeed(-400,400);
			playerGibs.setYSpeed(-400,400);
			playerGibs.setRotation(0, 0);
			playerGibs.bounce = 0.5;
			playerGibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true, 0.5);
			
			_gibsGroup.add(playerGibs);
			
			if (FlxG.getPlugin(FlxControl) == null) FlxG.addPlugin(new FlxControl);
			
			FlxControl.create(this, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, false);
			FlxControl.player1.setWASDControl();
			FlxControl.player1.setStandardSpeed(200);
			
		}
		
		public function gunSetup(map:Map):void
		{
			// Guns
			
			normalGun = new BaseGun("normal", this);
			normalGun.makePixelBullet(25, 12, 12, 0xffffffff, 14, 14)
			normalGun.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			normalGun.setBulletSpeed(600);
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * GameData.fireRateMultiplier));
			normalGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3); 
			
			bounceGun = new BounceGun("bounce", spriteAddons, this);
			bounceGun.makePixelBullet(25, 12, 12, 0xffffffff)
			bounceGun.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			bounceGun.setBulletSpeed(600);
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * GameData.fireRateMultiplier));
			bounceGun.setBulletElasticity(0.8);
			bounceGun.setBulletLifeSpan(2000);
			bounceGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3);
			
			crossbow = new Crossbow("crossbow", playerBulletsGroup, this);
			crossbow.makePixelBullet(10, 12, 12, 0xffffffff, 14, 14);
			crossbow.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			crossbow.setBulletSpeed(600);
			crossbow.setFireRate(CROSSBOW_RATE - (CROSSBOW_RATE * GameData.fireRateMultiplier));
			crossbow.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3); 
			
			playerBulletsGroup.add(normalGun.group);
			playerBulletsGroup.add(bounceGun.group);
			playerBulletsGroup.add(crossbow.group);
			//
		}
		
		override public function update():void
		{	
			super.update();
			
			if (this.alive && this.fireable)
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
						case CROSSBOW:
							crossbow.fireAtMouse();
							break;
							
						default:
							throw new Error("Weapon id number is out acceptable range");
							break;
					}
				}
			}
		
		}
		
		public function setFireRate():void
		{
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * GameData.fireRateMultiplier));
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * GameData.fireRateMultiplier));
			crossbow.setFireRate(CROSSBOW_RATE - (CROSSBOW_RATE * GameData.fireRateMultiplier));
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
			if (!alive) return;
			
			
			solid = false;
			super.kill();
			exists = true;
			visible = false;
			velocity.make()
			acceleration.make();
			
			FlxControl.clear();
			
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
		
		override public function destroy():void
		{
			super.destroy();
			
			normalGun = null;
			bounceGun = null;
			crossbow = null;
		}
		
	}

}