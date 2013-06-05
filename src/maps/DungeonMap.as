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
		
		public function DungeonMap(_player:Player, _enemiesGroup:FlxGroup, _collideableEnemies:FlxGroup, _enemyBullets:FlxGroup, _items:FlxGroup, _gibs:FlxGroup, _lights:FlxGroup,
			_lifeBar:LifeBar, _diamondCounter:DiamondCounter, _spriteAddons:FlxGroup, transitionNextState:Function, addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
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
			
			dungeonGen = new DungeonGenerator();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(dungeonGen.map, DungeonGenerator.TOTAL_ROWS), AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 2);
			
			add(tileMap);
			
			var treasure:Treasure = new Treasure(transitionNextState);
			itemsGroup.add(treasure);
			
			var treasureCoords:FlxPoint = randomLastRoom();
			treasure.x = treasureCoords.x;
			treasure.y = treasureCoords.y;
			
			var playerStart:FlxPoint = randomFirstRoom();
			
			player.x = playerStart.x;
			player.y = playerStart.y;
			
			generateContent();
			spawnDiamonds();
			
		}
		
		public function generateContent():void
		{
			for (var j:int = 1; j < 5; j++)
			{
				var enemy:Enemy;
				
				switch(int(Math.ceil(Math.random() * 2)))
				{
					case 1:
						enemy = new Ghost(player, this, gibs);
						enemiesGroup.add(enemy);
						spriteAddons.add((enemy as Ghost).trail);
						break;
					case 2:
						enemy = new RangedEnemy(player, this, enemyBullets, gibs);
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
			
				//--testing area--//
			/*
			var itemEmitter:FlxEmitter = new FlxEmitter(0, 0, 300);
			itemsGroup.add(itemEmitter);
			itemEmitter.setRotation(0, 0);
			itemEmitter.setXSpeed(-400,400);
			itemEmitter.setYSpeed( -400, 400);
			
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
			*/
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
				
				FlxG.log(diamond.x + ", " + diamond.y);
			}
		}
		
		override public function update():void
		{
			super.update();
			if (FlxG.keys.C)
			FlxG.log(Math.round(player.x) + ", " + Math.round(player.y));
			
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