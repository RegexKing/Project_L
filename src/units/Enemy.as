package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import maps.Dungeon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Enemy extends FlxSprite
	{
		
		protected var player:Player;
		protected var dungeon:Dungeon;
		protected var inSight:Boolean;
		public var aware:Boolean;
		protected var speed:int;
		protected var myPath:FlxPath;
		protected var gibs:FlxEmitter;
		protected var itemEmitter:FlxEmitter
		
		public function Enemy(_player:Player, _dungeon:Dungeon, _gibsGroup:FlxGroup, _itemEmitter:FlxEmitter) 
		{
			super();
			
			player = _player;
			dungeon = _dungeon;
			itemEmitter = _itemEmitter;
			
			inSight = false;
			aware = false;
			
			gibs = new FlxEmitter(0, 0, 50);
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 20, 10, true, 0.5);
			gibs.particleDrag = new FlxPoint(300, 300);
			gibs.setXSpeed(-200,200);
			gibs.setYSpeed(-200,200);
			gibs.setRotation(0, 0);
			gibs.bounce = 0.5;
			
			_gibsGroup.add(gibs);
		}
		
		
		override public function update():void
		{
			
			var enemyCoords:FlxPoint = new FlxPoint(this.x + this.width / 2, this.y + this.height / 2);
			var playerCoords:FlxPoint = new FlxPoint(player.x + player.width / 2, player.y + player.height / 2);
			
			inSight = dungeon.dungeonMap.ray(enemyCoords, playerCoords);
			
			if (aware)
			{
				if (myPath == null) 
				{
					
					myPath = dungeon.dungeonMap.findPath(enemyCoords, playerCoords);
					this.followPath(myPath, speed);
				}
				
				else
				{
					this.path = dungeon.dungeonMap.findPath(enemyCoords, playerCoords);
				}
			}
			
			else if ((!aware && inSight) && this.onScreen(FlxG.camera))
			{
				aware = true;
				
				//signal aware sprite??
			}
		}
		
		override public function kill():void
		{
			super.kill();
			
			if(gibs != null)
			{
				gibs.at(this);
				gibs.start(true, 0, 0, 0);
			}
			
			if(itemEmitter != null)
			{
				itemEmitter.at(this);
				itemEmitter.start(true, 0, 0, 4);
			}
			
			//temp universal sound effect
			FlxG.play(AssetsRegistry.enemyDieMP3);
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			super.hurt(_damagePoints);
			
			//sound effect
			FlxG.play(AssetsRegistry.enemyHurtMP3);
		}
		
		//override public function draw():void
		//{
			//super.draw();
			//if (this.path != null)
			//{
				//this.path.debugColor = 0xffFF0000;
			//	this.path.drawDebug();
			//}
		//}
	}
}