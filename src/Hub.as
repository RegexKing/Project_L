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
		
		protected var girl:Girl;
		protected var beastMan:BeastMan;
		
		public function Hub() 
		{
		}
		
		override public function create():void
		{
			npcGroup = new FlxGroup();
			
			
			super.create();
			
			if (!GameData.isBeastManDead) 
			{
				beastMan = new BeastMan(player, gibsGroup);
				enemiesGroup.add(beastMan);
				
				beastMan.x = GameData.RENDER_WIDTH - (beastMan.width + Map.TILE_SIZE);
				beastMan.y = GameData.RENDER_HEIGHT - (beastMan.height + Map.TILE_SIZE*2);
			}
			
			girl = new Girl(player, beastMan);
			enemiesGroup.add(girl);
			
			girl.x = GameData.RENDER_WIDTH/2 - girl.width/2;
			girl.y = Map.TILE_SIZE;
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.overlap(player, enemiesGroup, hurtObject);
			FlxG.overlap(enemiesGroup, playerBulletsGroup, hurtObject);
			
			FlxG.collide(player, girl);
			
			if (!beastMan.angry && beastMan != null) FlxG.collide(player, beastMan);
			
			if (player.y > GameData.RENDER_HEIGHT) goNextState();
		}
		
		override public function controlGun():void
		{
			if (player.alive)
			{
				fireGun();
			}
		}
		
		override public function stageInit():void
		{
			map = new HubMap();
			
			FlxG.camera.setBounds(0, 0, map.tileMap.width, map.tileMap.height);
			FlxG.camera.follow(null);
			
			player.x = 100;
			player.y = 100;
		}
		
		override public function bgmInit():void
		{
			
			FlxG.playMusic(AssetsRegistry.BGM_hubMP3);
			FlxG.music.survive = false;

		}
		
		override public function hurtObject(unit:FlxObject, hazzard:FlxObject):void
		{
			if (unit.flickering) return
			
			else 
			{
				if (unit is Player) 
				{
					if (hazzard is BeastMan && (hazzard as BeastMan).angry && hazzard != null)
					{
						lifeBar.currentValue -= (hazzard as FlxSprite).attackValue - ((hazzard as FlxSprite).attackValue*GameData.defenseMultiplier); 
						unit.hurt(0);
					}
				}
				
				else if (unit is BeastMan && unit != null)
				{
					unit.hurt((hazzard as FlxSprite).attackValue + ((hazzard as FlxSprite).attackValue * GameData.damageMultiplier));
				}
				
				else unit.hurt(0);
			}
			
			if (hazzard is Bullet) hazzard.kill();
		}
		
		override public function goNextState():void
		{
			GameData.playerHealth = lifeBar.currentValue;
			FlxG.switchState(new DungeonCrawl());
		}
		
		override public function alertEnemies():void {} // erases super class alert enemies 
		
	}

}