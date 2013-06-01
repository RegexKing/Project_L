package  
{	
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
			
			// Need to be overwritten
			stageInit();
			bgmInit();
			//-----------------------------------------------------
			
			cameraFocus = new CameraFocus(player);
			FlxG.worldBounds = new FlxRect(0, 0, map.tileMap.width, map.tileMap.height);
			FlxG.camera.target = cameraFocus;
			
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
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(collideableGroup, map);
			cameraFocus.updateCamera();	
			
			//FlxG.collide(enemiesGroup, enemiesGroup);
			
			FlxG.overlap(player, playerHazzardsGroup, hurtObject);
			FlxG.overlap(enemiesGroup, playerBulletsGroup, hurtObject);
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
			FlxG.switchState(new DungeonCrawl());
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