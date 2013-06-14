package  units
{
	import items.DiamondEmitter;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import maps.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Enemy extends FlxParticle
	{
		public static var totalEnemies:uint=0;
		
		protected var player:Player;
		protected var map:Map;
		protected var inSight:Boolean;
		public var aware:Boolean;
		protected var patrolSpeed:int;
		protected var alertSpeed:int;
		protected var myPath:FlxPath;
		protected var patrolPath:FlxPath;
		protected var gibs:FlxEmitter;
		public var itemEmitter:FlxEmitter
		protected var enemyCoords:FlxPoint;
		protected var playerCoords:FlxPoint;
		
		protected var lifeBar:FlxBar;
		protected var lifeBarHeight:uint = 5;
		protected var lifeBarOffset:int = -15;
		
		public function Enemy(_player:Player, _map:Map = null, _itemEmitter:FlxEmitter=null) 
		{
			super();
			
			player = _player;
			itemEmitter = _itemEmitter;
			map = _map;
			
			elasticity = 1;
			
			inSight = false;
			aware = false;
			
			patrolSpeed = 100;
			alertSpeed = 100;
			
			gibs = new FlxEmitter(0, 0, 50);
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 20, 10, true, 0.5);
			gibs.particleDrag = new FlxPoint(600, 600);
			gibs.setXSpeed(-400,400);
			gibs.setYSpeed(-400,400);
			gibs.setRotation(0, 0);
			gibs.bounce = 0.5;
		}
		
		
		override public function update():void
		{
			
			enemyCoords = new FlxPoint(this.x + this.width / 2, this.y + this.height / 2);
			playerCoords = new FlxPoint(player.x + player.width / 2, player.y + player.height / 2);
			
			inSight = map.tileMap.ray(enemyCoords, playerCoords);
			
			if (aware)
			{
				if ((myPath == null || this.path == patrolPath || this.pathSpeed == 0) && player.alive) 
				{
					destroyPath();
					
					myPath = calculatePath(enemyCoords, playerCoords);
					this.followPath(myPath, alertSpeed);
				}
				
				else this.path = map.tileMap.findPath(enemyCoords, playerCoords);
			}
			
			else if ((!aware && inSight) && isEnemyNear())
			{
				aware = true;
				
				// Todo: signal aware sprite??
			}
			
			else
			{
				if (this.path == null || this.pathSpeed == 0)
				{
					if (this.pathSpeed == 0) destroyPath();
					
					patrolPath = calculatePath(enemyCoords, findRandEmptyTile());
					this.followPath(patrolPath, patrolSpeed);
				}
				
			}
			
			// change facing
			if (velocity.x < 0) _facing = LEFT;
			else _facing = RIGHT;
		}
		
		public function isEnemyNear():Boolean
		{
			return  (FlxVelocity.distanceBetween(this, player) < (GameData.RENDER_HEIGHT/2 )) ? true : false;
		}
		
		protected function findRandEmptyTile():FlxPoint
		{
			var randEmptyTile:FlxPoint = map.randomAllRooms();
			
			return new FlxPoint(randEmptyTile.x + Map.TILE_SIZE / 2, randEmptyTile.y + Map.TILE_SIZE / 2);
			
		}
		
		protected function calculatePath(start:FlxPoint, end:FlxPoint):FlxPath
		{
			return map.tileMap.findPath(start, end)
		}
		
		protected function destroyPath():void
		{
			this.stopFollowingPath(true);
            this.velocity.x = this.velocity.y = 0;
			this.path = null;
			myPath = null
			patrolPath = null;
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			super.hurt(_damagePoints);
			
			aware = true;
			
			if (lifeBar != null && !lifeBar.visible) lifeBar.visible = true;
			
			//sound effect
			 if (_damagePoints > 0) FlxG.play(AssetsRegistry.enemyHurtMP3);
		}
		
		public function setItemEmitter(_itemEmitter:FlxEmitter = null):void
		{
			itemEmitter = _itemEmitter;
		}
		
		override public function kill():void
		{
			super.kill();
			
			if (lifeBar != null) lifeBar.kill();
			
			if(gibs != null)
			{
				gibs.at(this);
				gibs.start(true, 10, 0);
			}
			
			//increment total enemies killed counter
			addKillCount();
			
			if(itemEmitter != null)
			{
			
				if (totalEnemies >= GameData.LUCKY_NUMBER)
				{
					spawnItem();
					totalEnemies = 0;
				}
				
				else
				{
					var diceRoll:Number = Math.ceil(Math.random() * GameData.LUCKY_NUMBER);
					
					if (diceRoll == GameData.LUCKY_NUMBER) spawnItem();
				}
			}
		}
		
		
		protected function addKillCount():void
		{
			totalEnemies++;
		}
		
		protected function spawnItem():void
		{	
			itemEmitter.at(this);
			itemEmitter.start(true, 15, 0, 1);
		}
		
		/*
		override public function draw():void
		{
			super.draw();
			if (this.path != null)
			{
				this.path.debugColor = 0xffFF0000;
				this.path.drawDebug();
			}
		}
		*/
		
		
	}
}