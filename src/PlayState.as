package  
{	
	import menu.PauseMenu;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	import org.flixel.plugin.photonstorm.FX.CenterSlideFX;
	
	import hud.*;
	import items.*;
	import maps.*;
	import units.*;
	import util.*;
	import weapons.*;
	 
	public class PlayState extends FlxState
	{
		protected var stateDone:Boolean = false;
		
		protected var pauseMenu:PauseMenu;
		
		protected var darkness:Darkness;
		
		protected var player:Player;
		protected var map:Map;
		protected var miniMap:MiniMap;
		protected var lifeBar:LifeBar;
		protected var diamondCounter:DiamondCounter;
		protected var playerLight:PlayerLight;
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
		protected var collideableEnemies:FlxGroup;
		protected var spriteAddons:FlxGroup;
		protected var areaHeader:FlxText;
		
		protected var slide:CenterSlideFX;
		protected var slidePic:FlxSprite;
		protected var slideContainer:FlxSprite;
		
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
			
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			
			hudGroup = new FlxGroup();
			collideableGroup = new FlxGroup();
			playerBulletsGroup = new FlxGroup();
			playerHazzardsGroup = new FlxGroup();
			itemsGroup = new FlxGroup();
			enemiesGroup = new FlxGroup();
			collideableEnemies= new FlxGroup();
			trapsGroup = new FlxGroup();
			enemyBullets = new FlxGroup();
			gibsGroup = new FlxGroup();
			lightsGroup = new FlxGroup();
			spriteAddons = new FlxGroup();
			
			pauseMenu = new PauseMenu();
			pauseMenu.setAll("scrollFactor", new FlxPoint());
			pauseMenu.kill();
			
			player = new Player(gibsGroup);
			cameraFocus = new CameraFocus(player);
			FlxG.camera.target = cameraFocus;
			
			diamondCounter = new DiamondCounter();
			lifeBar = new LifeBar();
			lifeBar.setCallbacks(endGame, null);
			
			// Need to be overwritten
			stageInit();
			bgmInit();
			//-----------------------------------------------------
			
			
			FlxG.worldBounds = new FlxRect(0, 0, map.tileMap.width, map.tileMap.height);
			
			miniMap = new MiniMap(map, player);
			
			darkness = new Darkness();
			
			lightsGroup.add(new PlayerLight(darkness, player));
			
			hudGroup.add(darkness);
			hudGroup.add(miniMap);
			hudGroup.add(lifeBar);
			hudGroup.add(diamondCounter);
			hudGroup.setAll("scrollFactor", new FlxPoint(0, 0));
			
			collideableGroup.add(gibsGroup);
			collideableGroup.add(player);
			//collideableGroup.add(playerBulletsGroup);
			//collideableGroup.add(enemyBullets);
			collideableGroup.add(itemsGroup);
			collideableGroup.add(collideableEnemies);
			
			playerHazzardsGroup.add(enemiesGroup);
			playerHazzardsGroup.add(enemyBullets);
			playerHazzardsGroup.add(trapsGroup);
			
			add(map);
			add(gibsGroup);
			add(trapsGroup);
			add(itemsGroup);
			add(enemiesGroup);
			add(player);
			add(spriteAddons);
			add(playerBulletsGroup);
			add(enemyBullets);
			add(lightsGroup);
			add(hudGroup);
			add(cameraFocus);
			
			// Guns
			normalGun = new BaseGun("normal", player);
			normalGun.makePixelBullet(25, 12, 12, 0xffffffff, 14, 14)
			normalGun.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			normalGun.setBulletSpeed(600);
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * GameData.fireRateMultiplier));
			normalGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3); 
			
			bounceGun = new BounceGun("bounce", player);
			bounceGun.makePixelBullet(25, 12, 12, 0xffffffff)
			bounceGun.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			bounceGun.setBulletSpeed(600);
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * GameData.fireRateMultiplier));
			bounceGun.setBulletElasticity(0.8);
			bounceGun.setBulletLifeSpan(2000);
			bounceGun.setPreFireCallback(alertEnemies, AssetsRegistry.shootMP3);
			
			playerBulletsGroup.add(normalGun.group);
			playerBulletsGroup.add(bounceGun.group);
			//
			
			
			slide = FlxSpecialFX.centerSlide();
			slide.completeCallback = slideComplete;
			slidePic = new FlxSprite();
			slidePic.makeGraphic(GameData.RENDER_WIDTH, GameData.RENDER_HEIGHT, 0xff000000);
			
			slideContainer = slide.createFromFlxSprite(slidePic, CenterSlideFX.HIDE_VERTICAL, 5);
			slidePic.scrollFactor.x = 0;
			slidePic.scrollFactor.y = 0;
			slideContainer.scrollFactor.x = 0;
			slideContainer.scrollFactor.y  = 0;
			
			areaHeader = new FlxText(GameData.RENDER_WIDTH / 2 -30, GameData.RENDER_HEIGHT / 2-10, 60);
			areaHeader.scrollFactor.x = areaHeader.scrollFactor.y = 0;
			areaHeader.setFormat("NES", 16, 0xffFFFFFF);
			
			add(slideContainer);
			add(areaHeader);
			
			slide.start();
		}
		
		override public function update():void
		{
			//The pause menu is popped up here
			if (!pauseMenu.alive)
			{
				super.update();
				controlGun();
			
				FlxG.collide(collideableGroup, map);
				FlxG.collide(playerBulletsGroup, map, destroyBullet);
				FlxG.collide(enemyBullets, map, destroyBullet);
				cameraFocus.updateCamera();
				
				// Pause game
				if (FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("P"))
				{
					pauseMenu.revive();	
					add(pauseMenu);
				}
				
			}
			
			else
			{
				pauseMenu.update();	
			}
		
		}
		
		protected function destroyBullet(b:FlxObject, m:FlxObject):void
		{
			b.kill();
		}
		
		protected function setFireRate():void
		{
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * GameData.fireRateMultiplier));
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * GameData.fireRateMultiplier));
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
		
		public function controlGun():void
		{
			if (player.alive && player.active)
			{
				fireGun();
			}
		}
		
		public function stageInit():void
		{
		}
		
		public function bgmInit():void
		{
		}
		
		public function transitionNextState():void
		{
			player.active = false;
			
			FlxG.music.fadeOut(1);
			FlxG.camera.fade(0xff000000, 1, goNextState);
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
			FlxG.fade(0xff000000, 1, gameOverState);
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
		
		protected function slideComplete():void
		{
			slideContainer.kill();
			slidePic.kill();
			areaHeader.kill();
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin, otherwise resources will get messed right up after a while
			FlxSpecialFX.clear();
			
			Enemy.totalEnemies = 0;

			super.destroy();
		}
	}

}