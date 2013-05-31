package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import maps.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Enemy extends FlxSprite
	{
		
		protected var player:Player;
		protected var map:Map;
		protected var inSight:Boolean;
		public var aware:Boolean;
		protected var patrolSpeed:int;
		protected var alertSpeed:int;
		protected var myPath:FlxPath;
		protected var patrolPath:FlxPath;
		protected var gibs:FlxEmitter;
		protected var itemEmitter:FlxEmitter
		private var enemyCoords:FlxPoint;
		private var playerCoords:FlxPoint;
		
		public function Enemy(_player:Player, _map:Map, _itemEmitter:FlxEmitter) 
		{
			super();
			
			player = _player;
			map = _map;
			itemEmitter = _itemEmitter;
			
			elasticity = 1;
			
			inSight = false;
			aware = false;
			
			patrolSpeed = 50;
			alertSpeed = 50;
			
			gibs = new FlxEmitter(0, 0, 50);
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 20, 10, true, 0.5);
			gibs.particleDrag = new FlxPoint(300, 300);
			gibs.setXSpeed(-200,200);
			gibs.setYSpeed(-200,200);
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
		}
		
		public function isEnemyNear():Boolean
		{
			return  (FlxVelocity.distanceBetween(this, player) < (GameData.RENDER_HEIGHT/2 )) ? true : false;
		}
		
		private function findRandEmptyTile():FlxPoint
		{
			var randEmptyTile:FlxPoint = map.randomRoom();
			
			return new FlxPoint(randEmptyTile.x + Map.TILE_SIZE / 2, randEmptyTile.y + Map.TILE_SIZE / 2);
			
		}
		
		private function calculatePath(start:FlxPoint, end:FlxPoint):FlxPath
		{
			return map.tileMap.findPath(start, end)
		}
		
		private function destroyPath():void
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
			
			//sound effect
			FlxG.play(AssetsRegistry.enemyHurtMP3);
		}
		
		override public function kill():void
		{
			super.kill();
			
			if(gibs != null)
			{
				gibs.at(this);
				gibs.start(true, 10, 0);
			}
			
			if(itemEmitter != null)
			{
				itemEmitter.at(this);
				itemEmitter.start(true, 0, 0, Math.ceil(Math.random()*3));
			}
			
			//temp universal sound effect
			FlxG.play(AssetsRegistry.enemyDieMP3);
		}
		
		
		override public function draw():void
		{
			super.draw();
			if (this.path != null)
			{
				this.path.debugColor = 0xffFF0000;
				this.path.drawDebug();
			}
		}
		
	}
}