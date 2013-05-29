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
	 
	public class PlayState extends FlxState
	{
		private var player:Player;
		private var dungeon:Dungeon;
		private var miniMap:MiniMap;
		private var lifeBar:LifeBar;
		private var diamondCounter:DiamondCounter;
		private var itemEmitter:FlxEmitter;
		
		private var hudGroup:FlxGroup;
		private var itemsGroup:FlxGroup;
		private var collideableGroup:FlxGroup;
		private var playerHazzardsGroup:FlxGroup;
		private var enemiesGroup:FlxGroup;
		private var trapsGroup:FlxGroup;
		private var enemyBullets:FlxGroup;
		private var gibsGroup:FlxGroup;
		
		public function PlayState() 
		{ 
		}
		
		override public function create():void
		{
			hudGroup = new FlxGroup();
			collideableGroup = new FlxGroup();
			playerHazzardsGroup = new FlxGroup();
			
			itemEmitter = new FlxEmitter(0, 0, 300);
			
			itemsGroup = new FlxGroup();
			enemiesGroup = new FlxGroup();
			trapsGroup = new FlxGroup();
			enemyBullets = new FlxGroup();
			gibsGroup = new FlxGroup();
			
			dungeon = new Dungeon();
			player = new Player(gibsGroup, enemiesGroup);
			
			diamondCounter = new DiamondCounter();
			miniMap = new MiniMap(dungeon, player);
			lifeBar = new LifeBar();
			lifeBar.setCallbacks(endGame, null);
			
			hudGroup.add(lifeBar);
			hudGroup.add(diamondCounter);
			hudGroup.add(miniMap);
			hudGroup.setAll("scrollFactor", new FlxPoint(0, 0));
			
			collideableGroup.add(gibsGroup);
			collideableGroup.add(player);
			collideableGroup.add(player.bullets);
			collideableGroup.add(enemyBullets);
			collideableGroup.add(itemEmitter);
			collideableGroup.add(enemiesGroup);
			
			playerHazzardsGroup.add(enemiesGroup);
			playerHazzardsGroup.add(enemyBullets);
			playerHazzardsGroup.add(trapsGroup);
			
			FlxG.worldBounds = new FlxRect(0, 0, Dungeon.width, Dungeon.height);
			FlxG.camera.setBounds(0,0, Dungeon.width, Dungeon.height, true);
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			
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
			
			
			//var diamond:DiamondItem = new DiamondItem(diamondCounter);
			//var heart:HealthItem = new HealthItem(lifeBar);
			
			
			//itemEmitter.add(diamond);
			//itemEmitter.add(heart);
			
			for (var j:int = 1; j < 6; j++)
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
			
			
			//itemsGroup.add(diamond);
			//itemsGroup.add(heart);
			
			
			add(dungeon);
			add(gibsGroup);
			add(trapsGroup);
			//add(itemsGroup);
			add(itemEmitter);
			add(player);
			add(enemiesGroup);
			add(enemyBullets);
			add(player.bullets);
			add(hudGroup);
			
			player.x = dungeon.emptySpaces[0].x;
			player.y = dungeon.emptySpaces[0].y;
			
			//diamond.x = dungeon.emptySpaces[dungeon.emptySpaces.length-1].x;
			//diamond.y = dungeon.emptySpaces[dungeon.emptySpaces.length - 1].y;
			
			//heart.x = dungeon.emptySpaces[dungeon.emptySpaces.length-2].x;
			//heart.y = dungeon.emptySpaces[dungeon.emptySpaces.length - 2].y;
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(collideableGroup, dungeon);
			FlxG.collide(enemiesGroup, enemiesGroup);
			
			FlxG.overlap(player, playerHazzardsGroup, hurtObject);
			FlxG.overlap(enemiesGroup, player.bullets, hurtObject);
			FlxG.overlap(player, itemEmitter, itemPickup);
			
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
		
		private function goHome():void
		{
			FlxG.switchState(new PlayState());
		}
		
		private function completeLevel():void
		{
			GameData.playerHealth = lifeBar.currentValue;
			GameData.level++;
			goHome();
			
		}
		
		private function endGame():void
		{
			player.kill();
			GameData.resetData();
			trace("Game ended");
			
			FlxG.fade(0xff000000, 2, goHome);
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