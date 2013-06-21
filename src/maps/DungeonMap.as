package  maps
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxMath;
	import items.*;
	import units.*;
	 import hud.*;
	 import items.*;
	 import util.FlxTrail;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class DungeonMap extends Map
	{
		public var treasures:Array;
		public var dungeonGen:DungeonGenerator;
		
		private var player:Player;
		private var enemiesGroup:FlxGroup;
		private var enemyBullets:FlxGroup;
		private var itemsGroup:FlxGroup;
		private var gibs:FlxGroup;
		private var lights:FlxGroup;
		private var lifeBar:LifeBar;
		private var diamondCounter:DiamondCounter;
		private var collideableEnemies:FlxGroup;
		private var spriteAddons:FlxGroup;
		private var playerHazzards:FlxGroup;
		private var enemyBars:FlxGroup;
		private var chestUI:ChestUi;
		private var healthEmitter:FlxEmitter;
		private var diamondEmitter:DiamondEmitter;
		private var totalEnemies:uint;
		
		public function DungeonMap(_player:Player, _enemiesGroup:FlxGroup, _playerHazzards:FlxGroup, _collideableEnemies:FlxGroup, _enemyBullets:FlxGroup, _items:FlxGroup, _gibs:FlxGroup, _lights:FlxGroup,
			_lifeBar:LifeBar, _diamondCounter:DiamondCounter, _chestUI:ChestUi, _spriteAddons:FlxGroup, _enemyBars:FlxGroup, transitionNextState:Function, addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super(addToStage, onAddSpritesCallback);
			
			player = _player;
			enemiesGroup = _enemiesGroup;
			enemyBullets = _enemyBullets;
			itemsGroup = _items;
			gibs = _gibs;
			lights = _lights;
			lifeBar = _lifeBar;
			diamondCounter = _diamondCounter;
			chestUI = _chestUI;
			collideableEnemies = _collideableEnemies;
			spriteAddons = _spriteAddons;
			playerHazzards = _playerHazzards;
			enemyBars = _enemyBars
			
			treasures = new Array();
			
			dungeonGen = new DungeonGenerator();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(dungeonGen.map, DungeonGenerator.TOTAL_ROWS), AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0, 1);
			
			add(tileMap);
			
			
			// figures out how many enemys to spwan based on level
			totalEnemies = 6 + 3 * GameData.level;
			
			generateItems();
			//spawnDiamonds();
			spawnChests();
			//so items spawn over chests
			addItems();
			
			var treasure:Chest = new Chest(chestUI, diamondEmitter, healthEmitter);
			
			var treasureCoords:FlxPoint = randomLastRoom();
			treasure.x = treasureCoords.x;
			treasure.y = treasureCoords.y;
			itemsGroup.add(treasure);
			treasures.push(treasure);
			
			//spawn the enemies
			spawnEnemies();
			//lastRoomMap();
			
		}
		
		private function addItems():void
		{
			itemsGroup.add(healthEmitter);
			itemsGroup.add(diamondEmitter);
		}
		
		public function getPlayer():Player
		{
			return player;
		}
		
		public function spawnEnemies():void
		{
			var rangedEnemyNum:uint = Math.ceil(totalEnemies * 0.4);
			var otherEnemies:uint = totalEnemies - rangedEnemyNum;
			
			// spawns a certain range of enemies depending on level
			var enemyRange:uint;
			
			if (GameData.level < 3) enemyRange = 1;
			else if (GameData.level < 6) enemyRange = 2;
			else if (GameData.level < 9) enemyRange = 3;
			else if (GameData.level < 15) enemyRange = 4;
			else if (GameData.level >= 15) enemyRange = 5;
			
			//enemyRange = 7;
			
			for (var i:int = 0; i < rangedEnemyNum; i++)
			{
				var rangedEnemy:Enemy;
				var diceRoll:Number = Math.round(Math.random());
				var patrol:Boolean = Boolean(diceRoll);
				
				rangedEnemy = new RangedEnemy(player, this, enemyBullets, spriteAddons, gibs, enemyBars, healthEmitter, -1, patrol);
				enemiesGroup.add(rangedEnemy);
				collideableEnemies.add(rangedEnemy);
				
				var rangedRandomPoint:FlxPoint = randomRoom();
				
				rangedEnemy.x = rangedRandomPoint.x
				rangedEnemy.y = rangedRandomPoint.y;
			}
			
			for (var j:int = 0; j < otherEnemies; j++)
			{
				var enemy:Enemy;
				
				
				switch(int(Math.ceil(Math.random() * enemyRange)))
				{
					case 1:
						enemy = new Bat(player, this, gibs, enemyBars, healthEmitter);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 2:
						if (GameData.level > 9)
						{
							enemy = new SkeletonArcher(player, this, gibs, enemyBullets, enemyBars, healthEmitter);
							enemiesGroup.add(enemy);
							collideableEnemies.add(enemy);
							break;
						}
						
						else 
						{
							enemy = new Skeleton(player, this, gibs, enemyBars, healthEmitter);
							enemiesGroup.add(enemy);
							collideableEnemies.add(enemy);
							break;
						}
					case 3: 
						enemy = new Ghost(player, this, gibs, enemyBars, healthEmitter);
						enemiesGroup.add(enemy);
						break;
					case 4: 
						enemy = new Slime(player, this, gibs, enemiesGroup, collideableEnemies, enemyBars, spriteAddons, healthEmitter);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 5:
						enemy = new Abom(player, this, gibs, enemiesGroup, collideableEnemies, enemyBars, spriteAddons, healthEmitter);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					default:
						throw new Error("enemy id is ouside acceptable range");
						break;
				}
				
				var randomPoint:FlxPoint = randomRoom();
				
				enemy.x = randomPoint.x
				enemy.y = randomPoint.y;
			}
			
			//check for bad ass enemy
			if (GameData.level == 3 || GameData.level == 6 || GameData.level == 10 || GameData.level == 14)
			{
				var newWeap:uint = FlxMath.rand(0, 5, GameData.weapon);
				
				var badAssEnemy:RangedEnemy = new RangedEnemy(player, this, enemyBullets, spriteAddons, gibs, enemyBars, healthEmitter, newWeap, false);
				
				//var badAssPoint:FlxPoint = randomLastRoom();
				
				badAssEnemy.x = treasures[1].x //badAssPoint.x;
				badAssEnemy.y = treasures[1].y //badAssPoint.y;
				
				enemiesGroup.add(badAssEnemy);
				collideableEnemies.add(badAssEnemy);
			}
			
		}
		
		private function lastRoomMap():void
		{
			var lastMap:Array = dungeonGen.rooms;
			
			for (var i:int = 0; i < lastMap.length; i++)
			{
					var block:FlxSprite = new FlxSprite(lastMap[i][0]*TILE_SIZE, lastMap[i][1]*TILE_SIZE);
					block.makeGraphic(TILE_SIZE, TILE_SIZE);
					block.alpha = 0.25;
					spriteAddons.add(block);
			}
		}
		
		private function spawnChests():void
		{
			var chestCoords:Array = dungeonGen.chestCoords;
			
			for (var i:int = 0; i < chestCoords.length; i++)
			{
				var chest:Chest = new Chest(chestUI, diamondEmitter, healthEmitter);
				itemsGroup.add(chest);
				
				
				chest.x =chestCoords[i][0]* TILE_SIZE;
				chest.y = chestCoords[i][1] * TILE_SIZE;
				
				treasures.push(chest);
			}
		}
		
		/*
		private function spawnChests():void
		{
			var chestCoords:Array = dungeonGen.chestCoords;
			
			for (var i:int = 0; i < chestCoords.length; i++)
			{
				var chest:ItemChest = new ItemChest(healthEmitter);
				itemsGroup.add(chest);
				
				
				chest.x = chestCoords[i][0]* TILE_SIZE;
				chest.y = chestCoords[i][1] * TILE_SIZE;
			}
		}
		*/
		
		private function generateItems():void
		{
			healthEmitter = new FlxEmitter(0, 0, totalEnemies);
			healthEmitter.setXSpeed(-300,300);
			healthEmitter.setYSpeed(-300,300);
			healthEmitter.setRotation(0, 0);
			
			for (var i:int = 0; i < healthEmitter.maxSize; i++)
			{
				healthEmitter.add(new HealthItem(lifeBar));
			}
			
			diamondEmitter = new DiamondEmitter(diamondCounter);
		}
		
		override public function randomFirstRoom():FlxPoint
		{
			var arrayCoords:Array = dungeonGen.getRandomFirstRoomTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
		override public function randomRoom():FlxPoint
		{
			
			var arrayCoords:Array = dungeonGen.getRandomRoomTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
		override public function randomAllRooms():FlxPoint
		{
			var arrayCoords:Array = dungeonGen.getRandomAllRoomTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
		 override public function randomCorridor():FlxPoint
		{
			
			var arrayCoords:Array = dungeonGen.getRandomCorridorTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
		override public function randomLastRoom():FlxPoint
		{
			var arrayCoords:Array = dungeonGen.getRandomLastRoomTile();
			
			return new FlxPoint(arrayCoords[0] * TILE_SIZE, arrayCoords[1] * TILE_SIZE);
		}
		
	}

}