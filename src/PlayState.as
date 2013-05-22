package  
{	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	 
	public class PlayState extends FlxState
	{
		private var player:Player;
		private var dungeon:Dungeon;
		private var miniMap:MiniMap;
		
		private var enemy:PurpleEnemy;
		
		public function PlayState(){}
		
		override public function create():void
		{
			FlxG.bgColor = 0xffFF0000;
			dungeon = new Dungeon();
			player = new Player();
			
			FlxG.worldBounds = new FlxRect(0, 0, Dungeon.width, Dungeon.height);
			FlxG.camera.setBounds(0,0, Dungeon.width, Dungeon.height, true);
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			miniMap = new MiniMap(dungeon, player);
			
			enemy = new PurpleEnemy(player, dungeon);
			
			add(dungeon);
			add(player);
			add(enemy);
			add(player.bullets);
			add(miniMap);
			
			miniMap.setAll("scrollFactor", new FlxPoint(0, 0));
			miniMap.x = GameData.RENDER_WIDTH - DungeonGenerator.TOTAL_ROWS*2;
			
			player.x = dungeon.emptySpaces[0].x;
			player.y = dungeon.emptySpaces[0].y;	
			
			enemy.x = dungeon.emptySpaces[dungeon.emptySpaces.length-1].x;
			enemy.y = dungeon.emptySpaces[dungeon.emptySpaces.length - 1].y;	
			
			var path:FlxPath = dungeon.dungeonMap.findPath(new FlxPoint(enemy.x + enemy.width / 2, enemy.y + enemy.height / 2), new FlxPoint(player.x + player.width / 2, player.y + player.height / 2));
			enemy.followPath(path, 200);
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(player, dungeon);
			FlxG.collide(player.bullets, dungeon);
			FlxG.collide(enemy, dungeon);
		}
		
	}

}