package  
{	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import hud.*;
	import items.*;
	import maps.*;
	import units.*;
	import util.*;
	import weapons.*;
	 
	public class PlayState extends FlxState
	{
		protected var darkness:Darkness;
		
		protected var player:Player;
		protected var map:Map;
		protected var miniMap:MiniMap;
		protected var lifeBar:LifeBar;
		protected var diamondCounter:DiamondCounter;
		protected var cameraFocus:CameraFocus;
		
		protected var hudGroup:FlxGroup;
		protected var lightsGroup:FlxGroup;
		protected var itemsGroup:FlxGroup;
		protected var collideableGroup:FlxGroup;
		protected var playerBulletsGroup:FlxGroup;
		protected var playerHazzardsGroup:FlxGroup;
		protected var enemiesGroup:FlxGroup;
		protected var trapsGroup:FlxGroup;
		protected var enemyBullets:FlxGroup;
		protected var gibsGroup:FlxGroup;
		
		//Gun Vars
		protected const NORMAL_RATE:Number = 500;
		protected const BOUNCE_RATE:Number = 400;
		
		public static const NORMAL_GUN:uint = 0;
		public static const BOUNCE_GUN:uint = 1;
		
		protected var normalGun:BaseGun;
		protected var bounceGun:BounceGun;
		
		public function PlayState() 
		{ 
		}
		
		override public function create():void
		{
			FlxG.bgColor = 0xff191200;
			
			hudGroup = new FlxGroup();
			collideableGroup = new FlxGroup();
			playerBulletsGroup = new FlxGroup();
			playerHazzardsGroup = new FlxGroup();
			itemsGroup = new FlxGroup();
			enemiesGroup = new FlxGroup();
			trapsGroup = new FlxGroup();
			enemyBullets = new FlxGroup();
			gibsGroup = new FlxGroup();
			lightsGroup = new FlxGroup();
			
			player = new Player(gibsGroup);
			cameraFocus = new CameraFocus(player);
			FlxG.camera.target = cameraFocus;
			
			// Need to be overwritten
			stageInit();
			bgmInit();
			//-----------------------------------------------------
			
			FlxG.worldBounds = new FlxRect(0, 0, map.tileMap.width, map.tileMap.height);
			
			miniMap = new MiniMap(map, player);
			diamondCounter = new DiamondCounter();
			lifeBar = new LifeBar();
			lifeBar.setCallbacks(endGame, null);
			
			darkness = new Darkness();
			
			lightsGroup.add(new PlayerLight(darkness, player));
			
			hudGroup.add(darkness);
			hudGroup.add(miniMap);
			hudGroup.add(lifeBar);
			hudGroup.add(diamondCounter);
			hudGroup.setAll("scrollFactor", new FlxPoint(0, 0));
			
			collideableGroup.add(gibsGroup);
			collideableGroup.add(player);
			collideableGroup.add(playerBulletsGroup);
			collideableGroup.add(enemyBullets);
			collideableGroup.add(itemsGroup);
			collideableGroup.add(enemiesGroup);
			
			playerHazzardsGroup.add(enemiesGroup);
			playerHazzardsGroup.add(enemyBullets);
			playerHazzardsGroup.add(trapsGroup);
			
			add(map);
			add(gibsGroup);
			add(trapsGroup);
			add(itemsGroup);
			add(player);
			add(enemiesGroup);
			add(enemyBullets);
			add(playerBulletsGroup);
			add(lightsGroup);
			add(hudGroup);
			add(cameraFocus);
			
			// Guns
			normalGun = new BaseGun("normal", player);
			normalGun.makePixelBullet(25, 16, 16, 0xffffffff, 12, 12);
			normalGun.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			normalGun.setBulletSpeed(600);
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * GameData.fireRateMultiplier));
			normalGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3); 
			
			bounceGun = new BounceGun("bounce", player);
			bounceGun.makePixelBullet(25, 16, 16, 0xffffffff, 12, 12);
			bounceGun.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			bounceGun.setBulletSpeed(600);
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * GameData.fireRateMultiplier));
			bounceGun.setBulletElasticity(0.8);
			bounceGun.setBulletLifeSpan(2000);
			bounceGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3);
			
			playerBulletsGroup.add(normalGun.group);
			playerBulletsGroup.add(bounceGun.group);
			
		}
		
		override public function update():void
		{
			super.update();
			
			controlGun();
			
			FlxG.collide(collideableGroup, map);
			cameraFocus.updateCamera();	
			
			//FlxG.collide(enemiesGroup, enemiesGroup);
		}
		
		public function controlGun():void
		{
			fireGun();
		}
		
		protected function fireGun():void
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
		
		public function stageInit():void
		{
		}
		
		public function bgmInit():void
		{
		}
		
		
		public function goNextState():void
		{
		}
		
		public function hurtObject(unit:FlxObject, hazzard:FlxObject):void
		{
		}
		
		override public function draw():void
		{
			darkness.fill(0xff000000);
			
			super.draw();
		}
		
		private function endGame():void
		{
			player.kill();
			GameData.resetData();
			trace("Game ended");
			
			FlxG.music.fadeOut(1);
			FlxG.fade(0xff000000, 2, gameOverState);
		}
		
		private function gameOverState():void
		{
			FlxG.switchState(new Hub());
		}
		
		
		private function itemPickup(player:FlxObject, item:FlxObject):void
		{
			(item as Item).pickup();
			item.kill();
		}
		
		public function alertEnemies():void
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