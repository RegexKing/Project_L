package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	
	import hud.*;
	import items.*;
	import maps.*;
	import units.*; 
	 
	public class DungeonCrawl extends PlayState
	{
		
		public function DungeonCrawl() 
		{
			
		}
		
		override public function create():void
		{
			super.create();
			
			dungeon = new Dungeon();
			map.add(dungeon);
			
			miniMap = new MiniMap(dungeon, player);
			hudGroup.add(miniMap);
			hudGroup.setAll("scrollFactor", new FlxPoint(0, 0));
			
			
			
			//--testing area--//
			itemEmitter.setRotation(0, 0);
			itemEmitter.setXSpeed(-200,200);
			itemEmitter.setYSpeed( -200, 200);
			
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
			
			for (var j:int = 1; j < 6; j++)
			{
				var enemy:Enemy;
				
				switch(int(Math.ceil(Math.random() * 2)))
				{
					case 1:
						enemy = new PurpleEnemy(player, dungeon, gibsGroup, itemEmitter);
						break;
					case 2:
						enemy = new RangedEnemy(player, dungeon, enemyBullets, gibsGroup, itemEmitter);
						break;
					default:
						throw new Error("enemy id is ouside acceptable range");
						break;
				}
				
				enemy.x = dungeon.emptySpaces[dungeon.emptySpaces.length - j].x;
				enemy.y = dungeon.emptySpaces[dungeon.emptySpaces.length - j].y;
				
				enemiesGroup.add(enemy);
				
			}
			
			player.x = dungeon.emptySpaces[0].x;
			player.y = dungeon.emptySpaces[0].y;
			
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
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("M"))
			{
				
				miniMap.toggleMiniMap();
			}
		}
		
	}

}