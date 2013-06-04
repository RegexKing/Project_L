package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	 import org.flixel.*;
	 import org.flixel.plugin.photonstorm.*;
	 import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	 
	 import maps.*;
	 import units.*;
	 import hud.*;
	 import items.*;
	 import weapons.*;
	 import menu.PauseMenu;
	 
	public class DungeonCrawl extends PlayState
	{
		
		public function DungeonCrawl() 
		{
		}
		
		override public function create():void
		{
			super.create();
			
			//--testing area--//
			var itemEmitter:FlxEmitter = new FlxEmitter(0, 0, 300);
			itemsGroup.add(itemEmitter);
			itemEmitter.setRotation(0, 0);
			itemEmitter.setXSpeed(-400,400);
			itemEmitter.setYSpeed( -400, 400);
			
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
			
			for (var j:int = 1; j < 21; j++)
			{
				var enemy:Enemy;
				
				switch(int(Math.ceil(Math.random() * 2)))
				{
					case 1:
						enemy = new PurpleEnemy(player, map, gibsGroup, itemEmitter);
						break;
					case 2:
						enemy = new RangedEnemy(player, map, enemyBullets, gibsGroup, itemEmitter);
						break;
					default:
						throw new Error("enemy id is ouside acceptable range");
						break;
				}
				
				var randomPoint:FlxPoint = map.randomRoom();
				
				enemy.x = randomPoint.x
				enemy.y = randomPoint.y;
				
				enemiesGroup.add(enemy);
				
			}
			
		}
		
		override public function update():void
		{
			super.update();
			
			
			FlxG.overlap(player, playerHazzardsGroup, hurtObject);
			FlxG.overlap(enemiesGroup, playerBulletsGroup, hurtObject);
			FlxG.overlap(player, itemsGroup, itemPickup);
			
			//test key
			if (FlxG.keys.justPressed("SPACE"))
			{
				//diamondCounter.changeQuantity(1);
				//lifeBar.increaseBarRange();
				//player.active = !player.active;
				//FlxG.mute = !FlxG.mute;
				//trace(FlxG.mute);
			}
			
			if (FlxG.keys.justPressed("M"))
			{
				miniMap.toggleMiniMap();
			}
			
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
				
				else unit.hurt((hazzard as FlxSprite).attackValue + ((hazzard as FlxSprite).attackValue*GameData.damageMultiplier));
			}
			
			if (hazzard is Bullet) hazzard.kill();
		}
		
		
		override public function stageInit():void
		{
			map = new DungeonMap();
			
			var start:FlxPoint = map.randomFirstRoom();
			
			player.x = start.x;
			player.y = start.y;
		}
		
		override public function bgmInit():void
		{
			
			FlxG.playMusic(AssetsRegistry.BGM_dungeonMP3);
			if (!PauseMenu.isMusicOn) FlxG.music.pause();
			FlxG.music.survive = false;

		}
		
		
		override public function goNextState():void
		{
			GameData.playerHealth = lifeBar.currentValue;
			GameData.level++;
			FlxG.switchState(new Hub());
		}
		
		private function itemPickup(player:FlxObject, item:FlxObject):void
		{
			(item as Item).pickup();
			item.kill();
		}
		
		
	}

}