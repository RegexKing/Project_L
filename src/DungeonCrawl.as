package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	 import org.flixel.*;
	 import org.flixel.plugin.photonstorm.*;
	 import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	 
	 import maps.*;
	 import units.*;
	 import hud.*;
	 import items.*;
	 import weapons.*;
	 
	public class DungeonCrawl extends PlayState
	{
		
		private const NORMAL_RATE:Number = 500;
		private const BOUNCE_RATE:Number = 400;
		
		public static const NORMAL_GUN:uint = 0;
		public static const BOUNCE_GUN:uint = 1;
		
		private var normalGun:BaseGun;
		private var bounceGun:BounceGun;
		
		public function DungeonCrawl() 
		{
		}
		
		override public function create():void
		{
			super.create();
			
			normalGun = new BaseGun("normal", player);
			normalGun.makePixelBullet(25, 8, 8, 0xffffffff, 10, 13);
			normalGun.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			normalGun.setBulletSpeed(300);
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * GameData.fireRateMultiplier));
			normalGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3); 
			
			bounceGun = new BounceGun("bounce", player);
			bounceGun.makePixelBullet(25, 8, 8, 0xffffffff, 10, 13);
			bounceGun.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			bounceGun.setBulletSpeed(300);
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * GameData.fireRateMultiplier));
			bounceGun.setBulletElasticity(0.8);
			bounceGun.setBulletLifeSpan(2000);
			bounceGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3);
			
			playerBulletsGroup.add(normalGun.group);
			playerBulletsGroup.add(bounceGun.group);
			
			//--testing area--//
			var itemEmitter:FlxEmitter = new FlxEmitter(0, 0, 300);
			itemsGroup.add(itemEmitter);
			itemEmitter.setRotation(0, 0);
			itemEmitter.setXSpeed(-200,200);
			itemEmitter.setYSpeed( -200, 200);
			
			for (var i:int = 0; i < itemEmitter.maxSize; i++)
			{
				switch (int(Math.ceil(Math.random() * 2)))
				{
					case 1:
						itemEmitter.add(new DiamondItem(diamondCounter));
						break;
					case 2:
						itemEmitter.add(new HealthItem(lifeBar));
						break;	
				}
			}
			
			for (var j:int = 1; j < 31; j++)
			{
				var enemy:Enemy;
				
				switch(int(Math.ceil(Math.random() * 2)))
				{
					case 1:
						enemy = new PurpleEnemy(player, map, gibsGroup, itemEmitter);
						break;
					case 2:
						enemy = new RangedEnemy(player, map, enemyBullets, gibsGroup, itemEmitter);
						break;
					default:
						throw new Error("enemy id is ouside acceptable range");
						break;
				}
				
				var randomPoint:FlxPoint = map.randomRoom();
				
				enemy.x = randomPoint.x
				enemy.y = randomPoint.y;
				
				enemiesGroup.add(enemy);
				
			}
		}
		
		override public function update():void
		{
			super.update();
			
			weaponsFire();
			
			FlxG.overlap(player, itemsGroup, itemPickup);
			
			//test key
			if (FlxG.keys.justPressed("SPACE"))
			{
				//diamondCounter.changeQuantity(1);
				lifeBar.increaseBarRange();
				//FlxG.mute = !FlxG.mute;
				//trace(FlxG.mute);
			}
			
			if (FlxG.keys.justPressed("M"))
			{
				miniMap.toggleMiniMap();
			}
		}
		
		override public function hurtObject(unit:FlxObject, hazzard:FlxObject):void
		{
			if (unit.flickering) return
			
			else 
			{
				if (unit is Player) 
				{
					lifeBar.currentValue -= (hazzard as FlxSprite).attackValue - ((hazzard as FlxSprite).attackValue*GameData.defenseMultiplier); 
					unit.hurt(0);
				}
				
				else unit.hurt((hazzard as FlxSprite).attackValue + ((hazzard as FlxSprite).attackValue*GameData.damageMultiplier));
			}
			
			if (hazzard is Bullet) hazzard.kill();
		}
		
		override public function stageInit():void
		{
			map = new DungeonMap();
			
			var start:FlxPoint = map.randomFirstRoom();
			
			player.x = start.x;
			player.y = start.y;
		}
		
		override public function bgmInit():void
		{
			
			FlxG.playMusic(AssetsRegistry.BGM_dungeonMP3);
			FlxG.music.survive = false;

		}
		
		override public function goNextState():void
		{
			FlxG.switchState(new Hub());
		}
		
		private function completeLevel():void
		{
			GameData.playerHealth = lifeBar.currentValue;
			GameData.level++;
			goNextState();
			
		}
		
		private function itemPickup(player:FlxObject, item:FlxObject):void
		{
			(item as Item).pickup();
			item.kill();
		}
		
		private function weaponsFire():void
		{
			if (player.alive)
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
		
	}

}