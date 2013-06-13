package  maps
{
	import org.flixel.*;
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
		
		public function DungeonMap(_player:Player, _enemiesGroup:FlxGroup, _playerHazzards:FlxGroup, _collideableEnemies:FlxGroup, _enemyBullets:FlxGroup, _items:FlxGroup, _gibs:FlxGroup, _lights:FlxGroup,
			_lifeBar:LifeBar, _diamondCounter:DiamondCounter, _spriteAddons:FlxGroup, _enemyBars:FlxGroup, transitionNextState:Function, addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
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
			collideableEnemies = _collideableEnemies;
			spriteAddons = _spriteAddons;
			playerHazzards = _playerHazzards;
			enemyBars = _enemyBars
			
			dungeonGen = new DungeonGenerator();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(dungeonGen.map, DungeonGenerator.TOTAL_ROWS), AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 2);
			
			add(tileMap);
			
			treasure = new Treasure(transitionNextState);
			
			var treasureCoords:FlxPoint = randomLastRoom();
			treasure.x = treasureCoords.x;
			treasure.y = treasureCoords.y;
			spawnTeasure();
			
			var playerStart:FlxPoint = randomFirstRoom();
			
			player.x = playerStart.x;
			player.y = playerStart.y;
			
			spawnEnemies();
			spawnDiamonds();
			
		}
		
		public function spawnEnemies():void
		{
			
			// figures out how many enemys to spwan based on level
			var totalEnemies:uint;
			totalEnemies = 6 + GameData.level * 4;
			
			// spawns a certain range of enemies depending on level
			var enemyRange:uint;
			
			if (GameData.level < 3) enemyRange = 2;
			else if (GameData.level < 6) enemyRange = 4;
			else if (GameData.level < 10) enemyRange = 5;
			else if (GameData.level < 19) enemyRange = 6;
			else enemyRange = 7;
			
			//enemyRange = 7;
			
			for (var j:int = 0; j < totalEnemies; j++)
			{
				var enemy:Enemy;
				
				switch(int(Math.ceil(Math.random() * enemyRange)))
				{
					case 1:
						enemy = new Bat(player, this, gibs, enemyBars);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 2:
						enemy = new RangedEnemy(player, this, enemyBullets, gibs, enemyBars);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 3:
						enemy = new Skeleton(player, this, gibs, enemyBars);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 4: 
						enemy = new Ghost(player, this, gibs, enemyBars);
						enemiesGroup.add(enemy);
						spriteAddons.add((enemy as Ghost).trail);
						break;
					case 5: 
						enemy = new Slime(player, this, gibs, enemiesGroup, collideableEnemies, enemyBars, spriteAddons);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 6:
						enemy = new SkeletonArcher(player, this, gibs, enemyBullets, enemyBars);
						enemiesGroup.add(enemy);
						collideableEnemies.add(enemy);
						break;
					case 7:
						enemy = new Abom(player, this, gibs, enemiesGroup, collideableEnemies, enemyBars);
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
			
		}
		
		public function spawnTeasure():void
		{
			itemsGroup.add(treasure);
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