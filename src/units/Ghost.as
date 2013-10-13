package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.plugin.photonstorm.FlxVelocity; 
	import maps.Map;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	 
	public class Ghost extends Enemy
	{
		
		public function Ghost(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyBars:FlxGroup,  _itemEmitter:FlxEmitter=null) 
		{
			super(_player, _map,  _itemEmitter);
			
			patrolSpeed = 100;
			alertSpeed = 80;
			health = 2;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			loadGraphic(AssetsRegistry.ghostPNG, true, true, 32, 32);
			addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 26, 27, 28], 10);
			play("idle");
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
		}
		
		override public function update():void
		{
			enemyCoords = new FlxPoint(this.x + this.width / 2, this.y + this.height / 2);
			playerCoords = new FlxPoint(player.x + player.width / 2, player.y + player.height / 2);
			
			inSight = map.tileMap.ray(enemyCoords, playerCoords);
			
			if (aware)
			{
				if (patrolPath != null) destroyPath();
				
				//accelerate
				if(alertSpeed < 220) alertSpeed += 1;
				
				FlxVelocity.moveTowardsObject(this, player, alertSpeed);
			}
			
			else if (!aware && isEnemyNear())
			{
				aware = true;
				
				// Todo: signal aware sprite??
			}
			
			else
			{
				if (this.path == null || this.pathSpeed == 0)
				{
					if (this.pathSpeed == 0) destroyPath();
					
					patrolPath = calculatePath(enemyCoords, findRandEmptyTile());
					this.followPath(patrolPath, patrolSpeed);
				}
				
			}
			
			
			// change facing
			if (velocity.x < 0) _facing = LEFT;
			else _facing = RIGHT;
		}
		
		override public function isEnemyNear():Boolean
		{
			return  (FlxVelocity.distanceBetween(this, player) < (GameData.RENDER_HEIGHT/2 + GameData.RENDER_HEIGHT/3)) ? true : false;
		}
		
		override public function kill():void
		{
			super.kill();
			
			//play sound
			if (this.onScreen()) FlxG.play(AssetsRegistry.ghostDieMP3);
		}
		
	}

}