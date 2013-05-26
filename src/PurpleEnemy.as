package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	 
	public class PurpleEnemy extends Enemy
	{
		
		public function PurpleEnemy(_player:Player, _dungeon:Dungeon, _gibsGroup:FlxGroup) 
		{
			super(_player, _dungeon, _gibsGroup);
			
			makeGraphic(20, 20, 0xff00FF00);
			width = 20;
			height = 20;
			
			speed = 50;
			health = 8
			aware = true;
		}	
		
	}

}