package  
{	
	import flash.display.Sprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	import hud.*;
	import items.*;
	import maps.*;
	import units.*;
	import util.*;
	 
	public class PlayState extends FlxState
	{
		protected var darkness:Darkness;
		
		protected var player:Player;
		protected var dungeon:Dungeon;
		protected var miniMap:MiniMap;
		protected var lifeBar:LifeBar;
		protected var diamondCounter:DiamondCounter;
		protected var itemEmitter:FlxEmitter;
		protected var cameraFocus:CameraFocus;
		protected var playerLight:Light;
		
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
			
			
			//Things in order that need to be set up, inheritted---
			
			dungeon = new Dungeon();
			player = new Player(playerBulletsGroup, gibsGroup, enemiesGroup);
			miniMap = new MiniMap(dungeon, player);
			darkness = new Darkness();
			playerLight = new Light(darkness, player);
			cameraFocus = new CameraFocus(player);
			
			FlxG.worldBounds = new FlxRect(0, 0, Dungeon.width, Dungeon.height);
			FlxG.camera.target = cameraFocus;
			
			FlxG.playMusic(AssetsRegistry.BGM_dungeonMP3);
			FlxG.music.fadeIn(1);
			FlxG.music.survive = false;
			
			player.x = dungeon.emptySpaces[0].x;
			player.y = dungeon.emptySpaces[0].y;
			
			//-----------------------------------------------------
			
			
			diamondCounter = new DiamondCounter();
			lifeBar = new LifeBar();
			lifeBar.setCallbacks(endGame, null);
			itemEmitter = new FlxEmitter(0, 0, 300);
			
			lightsGroup.add(playerLight);
			
			hudGroup.add(darkness);
			hudGroup.add(miniMap);
			hudGroup.add(lifeBar);
			hudGroup.add(diamondCounter);
			hudGroup.setAll("scrollFactor", new FlxPoint(0, 0));
			
			collideableGroup.add(gibsGroup);
			collideableGroup.add(player);
			collideableGroup.add(playerBulletsGroup);
			collideableGroup.add(enemyBullets);
			collideableGroup.add(itemEmitter);
			collideableGroup.add(enemiesGroup);
			
			playerHazzardsGroup.add(enemiesGroup);
			playerHazzardsGroup.add(enemyBullets);
			playerHazzardsGroup.add(trapsGroup);
			
			add(dungeon);
			add(gibsGroup);
			add(trapsGroup);
			add(itemsGroup);
			add(itemEmitter);
			add(player);
			add(enemiesGroup);
			add(enemyBullets);
			add(playerBulletsGroup);
			add(lightsGroup);
			add(hudGroup);
			add(cameraFocus);
			
			
			//--testing area--//
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
			
			for (var j:int = 1; j < 11; j++)
			{
				var enemy:Enemy;
				
				switch(int(Math.ceil(Math.random() * 2)))
				{
					case 1:
						enemy = new PurpleEnemy(player, dungeon, gibsGroup, itemEmitter);
						break;
					case 2:
						enemy = new RangedEnemy(player, dungeon, enemyBullets, gibsGroup, itemEmitter);
						break;
					default:
						throw new Error("enemy id is ouside acceptable range");
						break;
				}
				
				enemy.x = dungeon.emptySpaces[dungeon.emptySpaces.length - j].x;
				enemy.y = dungeon.emptySpaces[dungeon.emptySpaces.length - j].y;
				
				enemiesGroup.add(enemy);
				
			}
			
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(collideableGroup, dungeon);
			cameraFocus.updateCamera();	
			
			playerLight.x = player.x + 10;
			playerLight.y = player.y +10;
			//FlxG.collide(enemiesGroup, enemiesGroup);
			
			FlxG.overlap(player, playerHazzardsGroup, hurtObject);
			FlxG.overlap(enemiesGroup, playerBulletsGroup, hurtObject);
			FlxG.overlap(player, itemEmitter, itemPickup);
			
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
		
		public function goNextState():void
		{
			FlxG.switchState(new PlayState());
		}
		
		override public function draw():void
		{
			darkness.fill(0xff000000);
			
			super.draw();
		}
		
		private function completeLevel():void
		{
			GameData.playerHealth = lifeBar.currentValue;
			GameData.level++;
			goNextState();
			
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
			FlxG.switchState(new PlayState());
		}
		
		private function hurtObject(unit:FlxObject, hazzard:FlxObject):void
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
		
		private function itemPickup(player:FlxObject, item:FlxObject):void
		{
			(item as Item).pickup();
			item.kill();
		}
		
	}

}