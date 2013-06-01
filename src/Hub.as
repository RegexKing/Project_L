package
{
	 import maps.HubMap;
	 import org.flixel.*;
	 import maps.*;
	 import units.*;
	 import hud.*;
	 import items.*;
	 import weapons.*;
	 
	 import org.flixel.plugin.photonstorm.*;
	 import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	 
	public class Hub extends PlayState
	{
		protected var npcGroup:FlxGroup;
		
		public function Hub() 
		{
		}
		
		override public function create():void
		{
			npcGroup = new FlxGroup();
			
			super.create();
		}
		
		override public function update():void
		{
			super.update();
			
			if (player.y > GameData.RENDER_HEIGHT) goNextState();
		}
		
		override public function stageInit():void
		{
			map = new HubMap(npcGroup, player, gibsGroup);
			
			FlxG.camera.setBounds(0, 0, map.tileMap.width, map.tileMap.height);
			FlxG.camera.follow(null);
			
			player.x = 100;
			player.y = 100;
		}
		
		override public function bgmInit():void
		{
			
			FlxG.playMusic(AssetsRegistry.BGM_dungeonMP3);
			FlxG.music.survive = false;

		}
		
		override public function hurtObject(unit:FlxObject, hazzard:FlxObject):void
		{
			if (unit.flickering) return
			
			else 
			{
				if (unit is Player) 
				{
					lifeBar.currentValue -= (hazzard as FlxSprite).attackValue - ((hazzard as FlxSprite).attackValue*GameData.defenseMultiplier); 
					unit.hurt(0);
				}
				
				else unit.hurt(0);
			}
			
			if (hazzard is Bullet) hazzard.kill();
		}
		
		override public function goNextState():void
		{
			FlxG.switchState(new DungeonCrawl());
		}
		
	}

}