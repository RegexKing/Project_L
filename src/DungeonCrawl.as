package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	 import org.flixel.*;
	 
	 import maps.*;
	 import units.Player;
	 import hud.*;
	 import items.*;
	 
	 
	public class DungeonCrawl extends PlayState
	{
		
		public function DungeonCrawl() 
		{
			super();
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.overlap(player, itemEmitter, itemPickup);
			
			//test key
			if (FlxG.keys.justPressed("SPACE"))
			{
				//diamondCounter.changeQuantity(1);
				lifeBar.increaseBarRange();
				//FlxG.mute = !FlxG.mute;
				//trace(FlxG.mute);
			}
			
			if (FlxG.keys.justPressed("M"))
			{
				miniMap.toggleMiniMap();
			}
		}
		
		override public function stageInit():void
		{
			map = new Dungeon();
			player = new Player(map, playerBulletsGroup, gibsGroup, enemiesGroup);
			
			var start:FlxPoint = map.randomFirstRoom();
			
			player.x = start.x;
			player.y = start.y;
		}
		
		override public function bgmInit():void
		{
			
			FlxG.playMusic(AssetsRegistry.BGM_dungeonMP3);
			FlxG.music.fadeIn(1);
			FlxG.music.survive = false;

		}
		
		override public function goNextState():void
		{
			FlxG.switchState(new DungeonCrawl());
		}
		
		private function completeLevel():void
		{
			GameData.playerHealth = lifeBar.currentValue;
			GameData.level++;
			goNextState();
			
		}
		
		private function itemPickup(player:FlxObject, item:FlxObject):void
		{
			(item as Item).pickup();
			item.kill();
		}
		
	}

}