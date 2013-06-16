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
		public var treasure:Treasure;
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
		private var healthEmitter:FlxEmitter;
		
		public function DungeonMap(_playerBullets:FlxGroup, _enemiesGroup:FlxGroup, _playerHazzards:FlxGroup, _collideableEnemies:FlxGroup, _enemyBullets:FlxGroup, _items:FlxGroup, _gibs:FlxGroup, _lights:FlxGroup,
			_lifeBar:LifeBar, _diamondCounter:DiamondCounter, _spriteAddons:FlxGroup, _enemyBars:FlxGroup, _alertEnemies:Function, transitionNextState:Function, addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
		{
			super(addToStage, onAddSpritesCallback);
			
			enemiesGroup = _enemiesGroup;
			enemyBullets = _enemyBullets;
			itemsGroup = _items;
			gibs = _gibs;
			lights = _lights;
			lifeBar = _lifeBar;
			diamondCounter = _diamondCounter;
			collideableEnemies = _collideableEnemies;
			spriteAddons = _spriteAddons;
			playerHazzards = _playerHazzards;
			enemyBars = _enemyBars
			
			dungeonGen = new DungeonGenerator();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(dungeonGen.map, DungeonGenerator.TOTAL_ROWS), AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0, 1);
			
			add(tileMap);
			
			treasure = new Treasure(transitionNextState);
			
			var treasureCoords:FlxPoint = randomLastRoom();
			treasure.x = treasureCoords.x;
			treasure.y = treasureCoords.y;
			itemsGroup.add(treasure);
			
			
			var playerStart:FlxPoint = randomFirstRoom();
			
			player = new Player(gibs, _playerBullets, spriteAddons, _alertEnemies, this, playerStart.x, playerStart.y);
			
			generateItems();
			spawnDiamonds();
			spawnChests();
			//so items spawn over chests
			addItems();
			
			//spawn the enemies
			spawnEnemies();
			
		}
		
		private function addItems():void
		{
			itemsGroup.add(healthEmitter);
		}
		
		public function getPlayer():Player
		{
			return player;
		}
		
		public function spawnEnemies():void
		{
			
			// figures out how many enemys to spwan based on level
			var totalEnemies:uint;
			totalEnemies = 6 + 3 * GameData.level;
			
			// spawns a certain range of enemies depending on level
			var enemyRange:uint;
			
			if (GameData.level < 3) enemyRange = 2;
			else if (GameData.level < 6) enemyRange = 3;
			else if (GameData.level < 9) enemyRange = 4;
			else if (GameData.level < 19) enemyRange = 5;
			else if (GameData.level >= 19) enemyRange = 6;
			
			//enemyRange = 7;
			
			for (var j:int = 0; j < totalEnemies; j++)
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
						enemy = new RangedEnemy(player, this, enemyBullets, spriteAddons, gibs, enemyBars, healthEmitter);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 3:
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
					case 4: 
						enemy = new Ghost(player, this, gibs, enemyBars, healthEmitter);
						enemiesGroup.add(enemy);
						break;
					case 5: 
						enemy = new Slime(player, this, gibs, enemiesGroup, collideableEnemies, enemyBars, spriteAddons, healthEmitter);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 6:
						enemy = new Abom(player, this, gibs, enemiesGroup, collideableEnemies, enemyBars, healthEmitter);
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
			if (GameData.level == 3 || GameData.level == 9 || GameData.level == 15 || GameData.level == 27)
			{
				var newWeap:uint = FlxMath.rand(0, 4, GameData.weapon);
				
				var badAssEnemy:RangedEnemy = new RangedEnemy(player, this, enemyBullets, spriteAddons, gibs, enemyBars, healthEmitter, newWeap);
				
				//var badAssPoint:FlxPoint = randomLastRoom();
				
				badAssEnemy.x = treasure.x //badAssPoint.x;
				badAssEnemy.y = treasure.y //badAssPoint.y;
				
				enemiesGroup.add(badAssEnemy);
				collideableEnemies.add(badAssEnemy);
			}
			
		}
		
		private function spawnDiamonds():void
		{
			var diamondCoords:Array = dungeonGen.diamondCoords;
			
			for (var i:int = 0; i < diamondCoords.length; i++)
			{
				var diamond:DiamondItem = new DiamondItem(diamondCounter);
				itemsGroup.add(diamond);
				
				
				diamond.x = diamondCoords[i][0]* TILE_SIZE;
				diamond.y = diamondCoords[i][1] * TILE_SIZE;
			}
		}
		
		
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
		
		private function generateItems():void
		{
			healthEmitter = new FlxEmitter(0, 0, 22);
			healthEmitter.setXSpeed(-300,300);
			healthEmitter.setYSpeed(-300,300);
			healthEmitter.setRotation(0, 0);
			
			for (var i:int = 0; i < healthEmitter.maxSize; i++)
			{
				healthEmitter.add(new HealthItem(lifeBar));
			}
			
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