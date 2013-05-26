package  
{	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	 
	public class PlayState extends FlxState
	{
		private var player:Player;
		private var dungeon:Dungeon;
		private var miniMap:MiniMap;
		private var lifeBar:FlxBar;
		
		private var enemyBullets:FlxGroup;
		private var gibsGroup:FlxGroup;
		
		private var enemy:PurpleEnemy;
		private var enemy2:RangedEnemy;
		
		public function PlayState(){}
		
		override public function create():void
		{
			FlxG.bgColor = 0xffFF0000;
			enemyBullets = new FlxGroup();
			gibsGroup = new FlxGroup();
			dungeon = new Dungeon();
			player = new Player(gibsGroup);
			lifeBar = new FlxBar(5, 5, FlxBar.FILL_LEFT_TO_RIGHT, 158, 14);
			createLifeBar();
			
			FlxG.worldBounds = new FlxRect(0, 0, Dungeon.width, Dungeon.height);
			FlxG.camera.setBounds(0,0, Dungeon.width, Dungeon.height, true);
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			miniMap = new MiniMap(dungeon, player);
			
			enemy = new PurpleEnemy(player, dungeon, gibsGroup);
			enemy2 = new RangedEnemy(player, dungeon, enemyBullets, gibsGroup);
			
			
			add(dungeon);
			add(gibsGroup);
			add(player);
			add(enemy);
			add(enemy2);
			add(enemyBullets);
			add(player.bullets);
			add(lifeBar);
			add(miniMap);
			
			miniMap.setAll("scrollFactor", new FlxPoint(0, 0));
			//miniMap.groupX = GameData.RENDER_WIDTH - DungeonGenerator.TOTAL_ROWS*2;
			
			player.x = dungeon.emptySpaces[0].x;
			player.y = dungeon.emptySpaces[0].y;	
			
			enemy.x = dungeon.emptySpaces[dungeon.emptySpaces.length-1].x;
			enemy.y = dungeon.emptySpaces[dungeon.emptySpaces.length - 1].y;
			
			enemy2.x = dungeon.emptySpaces[dungeon.emptySpaces.length-2].x;
			enemy2.y = dungeon.emptySpaces[dungeon.emptySpaces.length - 2].y;
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(player, dungeon);
			FlxG.collide(player.bullets, dungeon);
			FlxG.collide(gibsGroup, dungeon);
			FlxG.collide(enemyBullets, dungeon);
			
			FlxG.overlap(player, enemyBullets, hurtObject);
			FlxG.overlap(player, enemy2, hurtObject);
			FlxG.overlap(enemy2, player.bullets, hurtObject);
			//trace(enemy2.alive);
		}
		
		private function endGame():void
		{
			player.kill();
			trace("Game ended");
		}
		
		private function hurtObject(unit:FlxObject, hazzard:FlxObject):void
		{
			if (unit.flickering) return
			
			else 
			{
				unit.hurt(1);
				if(unit is Player) lifeBar.currentValue--;
			}
			
			hazzard.kill();
		}
		
		private function createLifeBar():void
		{
			lifeBar.scrollFactor.x = lifeBar.scrollFactor.y = 0;
			
			lifeBar.createImageBar(null, AssetsRegistry.lifeHeartsPNG, 0x0);
			lifeBar.setRange(0, 10);
			
			//	The starting value
			lifeBar.currentValue = 3;
			lifeBar.setCallbacks(endGame, null);
		}
		
	}

}