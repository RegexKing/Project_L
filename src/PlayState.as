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
			
			player = new Player(gibsGroup, playerBulletsGroup, alertEnemies);
			cameraFocus = new CameraFocus(player);
			FlxG.camera.target = cameraFocus;
			
			diamondCounter = new DiamondCounter();
			lifeBar = new LifeBar();
			lifeBar.setCallbacks(endGame, null);
			
			// Need to be overwritten
			stageInit();
			bgmInit();
			//-----------------------------------------------------
			
			player.gunSetup(map);
			
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
			add(player);
			add(enemiesGroup);
			add(spriteAddons);
			add(enemyBars);
			add(playerBulletsGroup);
			add(enemyBullets);
			add(lightsGroup);
			add(hudGroup);
			add(cameraFocus);
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
			
				FlxG.collide(collideableGroup, map);
				cameraFocus.updateCamera();
				
				// minimap
				if (FlxG.keys.justPressed("M"))
				{
					miniMap.toggleMiniMap();
				}
				
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
			
			if ((hazzard is Bullet && !(hazzard is CrossbowArrow)) || hazzard is CrossbowParticle) hazzard.kill();
			
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
			for each (var enemy:Enemy in enemiesGroup.members && !(enemy is FlxEmitter))
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