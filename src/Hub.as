package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	import hud.*;
	import items.*;
	import maps.*;
	import units.*;
	
	import maps.Dungeon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Hub extends PlayState
	{
		
		public function Hub() 
		{
		}
		
		override public function create():void
		{
			super.create();
			
			hudGroup.setAll("scrollFactor", new FlxPoint(0, 0));
			
			add(map);
			add(gibsGroup);
			add(trapsGroup);
			//add(itemsGroup);
			add(itemEmitter);
			add(player);
			add(enemiesGroup);
			add(enemyBullets);
			add(player.bullets);
			add(hudGroup);
		}
		
	}

}