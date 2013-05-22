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
		
		public function Enemy(_player:Player, _dungeon:Dungeon) 
		{
			super();
			
			player = _player;
			dungeon = _dungeon;
			
			inSight = false;
		}
		
		/*
		override public function update():void
		{
			var enemyCoords:FlxPoint = this.getMidpoint();
			var playerCoords:FlxPoint = player.getMidpoint();
			
			//inSight = dungeon.dungeonMap.ray(enemyCoords, playerCoords);
			
		
			if (inSight || (dungeon.dungeonMap.ray(enemyCoords, playerCoords) && onScreen))
			{
				if (!inSight) inSight = true;
				
				followPath(dungeon.dungeonMap.findPath(enemyCoords, playerCoords), 100);
			}
			
			
			if (!inSight)
			{
				if (dungeon.dungeonMap.ray(enemyCoords, playerCoords) && onScreen(FlxG.camera))
				{
					inSight = true;
					this.followPath(dungeon.dungeonMap.findPath(enemyCoords, playerCoords));
				}
			}
			
			else
			{
				//this.followPath(dungeon.dungeonMap.findPath(enemyCoords, playerCoords));
			}
		}
		*/
		
	}

}