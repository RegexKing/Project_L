package  
{	
	import menu.PauseMenu;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import org.flixel.plugin.photonstorm.FX.CenterSlideFX;
	
	import hud.*;
	import items.*;
	import maps.*;
	import units.*;
	import util.*;
	import weapons.*;
	import com.newgrounds.API;
	 
	public class PlayState extends FlxState
	{
		//stored vars
		protected var startDiamonds:int = GameData.diamonds;
		protected var startWeapons:Array = GameUtil.cloneArray(GameData.weapon);
		protected var startVitUpgrades:uint = GameData.vitalityUpgrades;
		protected var startDefUpgrades:uint = GameData.defenseUpgrades;
		protected var startattackUpgrades:uint = GameData.attackUpgrades;
		protected var rateUpgrades:uint = GameData.rateUpgrades;
		protected var startTotalHealth:Number = GameData.totalHealth;
		protected var startDamageMultiplier:Number = GameData.damageMultiplier;
		protected var startDefenseMultiplier:Number = GameData.defenseMultiplier;
		protected var startRateMultiplier:Number = GameData.fireRateMultiplier;
		protected var startWeaponID:uint = GameData.weaponID;
		
		protected var time:Number = 0;
		protected var stateDone:Boolean = false;
		
		protected var pauseMenu:PauseMenu;
		
		protected var darkness:Darkness;
		
		protected var player:Player;
		protected var map:Map;
		protected var miniMap:MiniMap;
		protected var lifeBar:LifeBar;
		protected var diamondCounter:DiamondCounter;
		protected var weaponUI:WeaponUI;
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
		protected var enemyBars:FlxGroup;
		
		protected var slide:CenterSlideFX;
		protected var slidePic:FlxSprite;
		protected var slideContainer:FlxSprite;
		
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
			enemyBars = new FlxGroup();
			
			pauseMenu = new PauseMenu();
			pauseMenu.setAll("scrollFactor", new FlxPoint());
			pauseMenu.kill();
			
			diamondCounter = new DiamondCounter();
			lifeBar = new LifeBar();
			lifeBar.setCallbacks(endGame, null);
			weaponUI = new WeaponUI();
			
			
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
			hudGroup.add(weaponUI);
			hudGroup.setAll("scrollFactor", new FlxPoint(0, 0));
			
			collideableGroup.add(gibsGroup);
			collideableGroup.add(player);
			collideableGroup.add(itemsGroup);
			collideableGroup.add(collideableEnemies);
			collideableGroup.add(playerBulletsGroup);
			collideableGroup.add(enemyBullets);
			
			playerHazzardsGroup.add(enemiesGroup);
			playerHazzardsGroup.add(enemyBullets);
			playerHazzardsGroup.add(trapsGroup);
			
			
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
			
			add(map);
			add(gibsGroup);
			add(trapsGroup);
			add(itemsGroup);
			add(enemiesGroup);
			add(player);
			add(spriteAddons);
			add(enemyBars);
			add(playerBulletsGroup);
			add(enemyBullets);
			add(lightsGroup);
			add(hudGroup);
			add(cameraFocus);
			add(slideContainer);
			add(areaHeader);
			
			player.active = false;
			player.solid = false;
			enemiesGroup.setAll("active", false);
			
			slide.start();
		}
		
		override public function update():void
		{
			//The pause menu is popped up here
			if (!pauseMenu.alive && !miniMap.isToggled)
			{
				super.update();
			
				FlxG.collide(collideableGroup, map);
				
				// Pause game
				if (FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("P"))
				{
					pauseMenu.revive();	
					add(pauseMenu);
				}
				
				time += FlxG.elapsed;
				
			}
			
			else
			{
				pauseMenu.update();
				miniMap.update();
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
			player.solid = false;
			player.alive = false;
			player.velocity.x = player.velocity.y = 0;
			
			FlxControl.clear();
			
			FlxG.music.fadeOut(1);
			FlxG.camera.fade(0xff000000, 1, goNextState);
		}
		
		public function goNextState():void
		{
			GameData.playerHealth = lifeBar.currentValue;
			
			FlxG.camera.stopFX();
			
			var loadingScreen:FlxSprite = new FlxSprite(0, 0, AssetsRegistry.loadingScreenPNG);
			loadingScreen.scrollFactor.x = loadingScreen.scrollFactor.y = 0;
			add(loadingScreen);
		}
		
		public function hurtObject(unit:FlxObject, hazzard:FlxObject):void
		{
			if (unit.flickering) return
			
			else 
			{
				if (unit is Player) 
				{
					if ((hazzard is BeastMan && BeastMan.angry) || ((!(hazzard is BeastMan) && !(hazzard is Girl))))
					{
						lifeBar.currentValue -= (hazzard as FlxSprite).attackValue - ((hazzard as FlxSprite).attackValue * GameData.defenseMultiplier);
						unit.hurt(0);
					}
					
				}
				
				else if (!(hazzard is Acid))
					unit.hurt((hazzard as FlxSprite).attackValue + ((hazzard as FlxSprite).attackValue*GameData.damageMultiplier));
			}
			
			if ((hazzard is Bullet && !(hazzard is CrossbowArrow) && !(hazzard is SniperBullet)) || hazzard is CrossbowParticle) hazzard.kill();
			
			else if (hazzard is CrossbowArrow && !(hazzard as CrossbowArrow).isTracking)
			{
				(hazzard as CrossbowArrow).trackTarget(unit);
			}
		}
		
		override public function draw():void
		{
			darkness.fill(0xff000000);
			
			super.draw();
		}
		
		protected function endGame():void
		{
			player.kill();
			
			if (GameData.cravenMode)
			{
				GameData.playerHealth = 3;
				GameData.diamonds = startDiamonds;
				GameData.weapon = startWeapons;
				GameData.weaponID = startWeaponID;
				
				GameData.vitalityUpgrades = startVitUpgrades;
				GameData.defenseUpgrades = startDefUpgrades;
				GameData.attackUpgrades = startattackUpgrades;
				GameData.rateUpgrades = rateUpgrades;
				GameData.totalHealth = startTotalHealth;
				GameData.damageMultiplier = startDamageMultiplier;
				GameData.defenseMultiplier = startDefenseMultiplier;
				GameData.fireRateMultiplier = startRateMultiplier;
					
				if(this is DungeonCrawl) GameData.completionTime += time;
			}
			
			else
			{
				API.postScore("Rogue Mode", GameData.level);
				
				GameData.resetData();
			}
			
			hudGroup.add(new TransitionScreen("gameover", gameOverState));
			
		}
		
		private function gameOverState():void
		{
			FlxG.camera.stopFX();
			
			var loadingScreen:FlxSprite = new FlxSprite(0, 0, AssetsRegistry.loadingScreenPNG);
			loadingScreen.scrollFactor.x = loadingScreen.scrollFactor.y = 0;
			add(loadingScreen);
			
			FlxG.switchState(new Hub());
		}
		
		
		protected function itemPickup(player:FlxObject, item:FlxObject):void
		{
			(item as Item).pickup();
			if (!((item as Item) is Chest)) item.kill();
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
			
			player.active = true;
			player.solid = true;
			enemiesGroup.setAll("active", true);
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