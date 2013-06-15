package
{
	 import maps.HubMap;
	 import dialogue.DialogueBox;
	 import org.flixel.*;
	 import maps.*;
	 import units.*;
	 import hud.*;
	 import items.*;
	 import weapons.*;
	 import menu.PauseMenu;
	 import com.newgrounds.API;
	 
	 import org.flixel.plugin.photonstorm.*;
	 import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	 
	public class Hub extends PlayState
	{
		protected var npcGroup:FlxGroup;
		protected var dialogueBox:DialogueBox;
		
		protected var girl:Girl;
		protected var beastMan:BeastMan;
		
		public function Hub() 
		{
		}
		
		override public function create():void
		{
			npcGroup = new FlxGroup();
			
			super.create();
			
			areaHeader.text = "HUB";
			
			if (!GameData.isBeastManDead) 
			{
				beastMan = new BeastMan(player, gibsGroup, activateDialogue, enemyBars);
				enemiesGroup.add(beastMan);
				
				if (GameData.level == GameData.LAST_LEVEL)
				{
					beastMan.x = GameData.RENDER_WIDTH/2 - beastMan.width/2;
					beastMan.y = GameData.RENDER_HEIGHT - Map.TILE_SIZE - beastMan.height;
				}
				
				else
				{
					beastMan.x = GameData.RENDER_WIDTH - (beastMan.width + Map.TILE_SIZE + beastMan.offset.x);
					beastMan.y = GameData.RENDER_HEIGHT - (beastMan.height + Map.TILE_SIZE * 2);
				}
			}
			
			girl = new Girl(player, activateDialogue, beastMan);
			enemiesGroup.add(girl);
			
			girl.x = GameData.RENDER_WIDTH/2 - girl.width/2;
			girl.y = Map.TILE_SIZE + girl.height;
			
			dialogueBox = new DialogueBox(player, girl, beastMan, lifeBar, player.setFireRate, diamondCounter);
			add(dialogueBox);
			
			checkLastLevel();
		}
		
		override public function update():void
		{
			super.update();
			
			
			FlxG.overlap(player, enemiesGroup, hurtObject);
			FlxG.overlap(enemiesGroup, playerBulletsGroup, hurtObject);
			
			FlxG.collide(player, girl);
			
			if (beastMan != null && !BeastMan.angry) FlxG.collide(player, beastMan);
			
			if (player.y > GameData.RENDER_HEIGHT && !stateDone)
			{
				stateDone = true;
				transitionNextState();
			}
			
			//test key
			if (FlxG.keys.justPressed("SPACE"))
			{
				diamondCounter.changeQuantity(1);
				//lifeBar.increaseBarRange();
				//player.active = !player.active;
				//FlxG.mute = !FlxG.mute;
				//trace(FlxG.mute);
			}
			
		}
		
		private function activateDialogue(npcName:String):void
		{
			dialogueBox.initConversation(npcName);	
		}
		
		override public function stageInit():void
		{
			map = new HubMap();
			
			player = new Player(gibsGroup, playerBulletsGroup, spriteAddons, alertEnemies, map);
			player.x = 200;
			player.y = 200;
			
			FlxG.camera.setBounds(0, 0, map.tileMap.width, map.tileMap.height);
			FlxG.camera.follow(null);
		}
		
		override public function bgmInit():void
		{
			
			FlxG.playMusic(AssetsRegistry.BGM_hubMP3);
			if (!PauseMenu.isMusicOn) FlxG.music.pause();
			FlxG.music.survive = false;

		}
		
		override public function goNextState():void
		{
			super.goNextState();
			
			FlxG.switchState(new DungeonCrawl());
		}
		
		
		protected function checkLastLevel():void
		{
			if (GameData.level == GameData.LAST_LEVEL)
			{
				if (GameData.cravenMode)
				{
					API.unlockMedal("Beat Craven Mode");
					API.postScore("Craven Mode", GameData.completionTime * 1000);
				}
				
				else
				{
					API.unlockMedal("Beat Rogue Mode");
					API.postScore("Rogue Mode", GameData.completionTime * 1000);
				}
			}
		}
		
		override public function alertEnemies():void { } // erases super class alert enemies 
		
		
	}

}