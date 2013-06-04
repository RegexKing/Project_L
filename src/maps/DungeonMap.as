package  maps
{
	import org.flixel.*;
	import items.*;
	import units.*;
	 import hud.*;
	 import items.*;
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
		
		public function DungeonMap(_player:Player, _enemiesGroup:FlxGroup, _enemyBullets:FlxGroup, _items:FlxGroup, _gibs:FlxGroup, _lights:FlxGroup,
			_lifeBar:LifeBar, _diamondCounter:DiamondCounter, transitionNextState:Function, addToStage:Boolean = true, onAddSpritesCallback:Function = null) 
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
			
			dungeonGen = new DungeonGenerator();
			
			tileMap.loadMap(FlxTilemap.arrayToCSV(dungeonGen.map, DungeonGenerator.TOTAL_ROWS), AssetsRegistry.randDunTilesPNG, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 2);
			
			add(tileMap);
			
			var treasure:Treasure = new Treasure(transitionNextState);
			itemsGroup.add(treasure);
			
			var playerStart:FlxPoint = randomFirstRoom();
			
			player.x = playerStart.x;
			player.y = playerStart.y;
			
			treasure.x = player.x+ 50;
			treasure.y = player.y;
			
			generateContent();
			
		}
		
		public function generateContent():void
		{
			for (var j:int = 1; j < 21; j++)
			{
				var enemy:Enemy;
				
				switch(int(Math.ceil(Math.random() * 2)))
				{
					case 1:
						enemy = new PurpleEnemy(player, this, gibs);
						break;
					case 2:
						enemy = new RangedEnemy(player, this, enemyBullets, gibs);
						break;
					default:
						throw new Error("enemy id is ouside acceptable range");
						break;
				}
				
				var randomPoint:FlxPoint = randomRoom();
				
				enemy.x = randomPoint.x
				enemy.y = randomPoint.y;
				
				enemiesGroup.add(enemy);
				
				//enemiesGroup.getRandom(
				
			}
			
			//save
			var diamondEmitter:DiamondEmitter = new DiamondEmitter(diamondCounter);
			itemsGroup.add(diamondEmitter);
			
			for (var k:int = 0; k < GameData.DIAMONDS_PER_LEVEL; k++)
			{
				var diamondCarrier:Enemy = enemiesGroup.getRandom() as Enemy;
				
				while (diamondCarrier.itemEmitter != null)
				{
					diamondCarrier = enemiesGroup.getRandom() as Enemy;
				}
				
				diamondCarrier.setItemEmitter(diamondEmitter);
				FlxG.log("diamondAdded");
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
		
	}

}