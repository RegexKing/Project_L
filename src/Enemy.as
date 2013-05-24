package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
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
		
		public function Enemy(_player:Player, _dungeon:Dungeon) 
		{
			super();
			
			player = _player;
			dungeon = _dungeon;
			
			inSight = false;
			aware = false;
			speed = 50;
		}
		
		
		override public function update():void
		{
			/*
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
				
				this.stopFollowingPath();
				myPath = dungeon.dungeonMap.findPath(enemyCoords, playerCoords);
				this.followPath(myPath);
			}
			
			else if ((!aware && inSight) && this.onScreen(FlxG.camera))
			{
				aware = true;
				
				myPath = dungeon.dungeonMap.findPath(enemyCoords, playerCoords);
				this.followPath(myPath, speed);
			}
			*/

		}
		
		
	}

}