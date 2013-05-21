package  
{	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	 
	public class PlayState extends FlxState
	{
		private var player:Player;
		private var dungeonMap:Dungeon;
		private var miniMap:MiniMap;
		
		public function PlayState(){}
		
		override public function create():void
		{
			FlxG.bgColor = 0xffFF0000;
			
			dungeonMap = new Dungeon();
			
			player = new Player();
			miniMap = new MiniMap(dungeonMap, player);
			miniMap.setAll("scrollFactor",new FlxPoint(0,0));
			
			FlxG.worldBounds = new FlxRect(0, 0, dungeonMap.width, dungeonMap.height);
			trace(FlxG.worldBounds.width + " " + FlxG.worldBounds.height);
			FlxG.camera.setBounds(0,0, dungeonMap.width, dungeonMap.height, true);
			FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN_TIGHT);
			
			add(dungeonMap);
			add(player);
			add(player.bullets);
			add(miniMap);
			
			player.x = dungeonMap.emptySpaces[0].x;
			player.y = dungeonMap.emptySpaces[0].y;	
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(player, dungeonMap);
			FlxG.collide(player.bullets, dungeonMap);
		}
		
	}

}