package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.plugin.photonstorm.FlxVelocity; 
	import maps.Map;
	import org.flixel.*;
	import util.FlxTrail;
	 
	public class Ghost extends Enemy
	{
		
		public var trail:FlxTrail;
		
		public function Ghost(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyLifeBars:FlxGroup) 
		{
			super(_player, _map, _enemyLifeBars);
			
			patrolSpeed = 160;
			alertSpeed = 100;
			health = 1;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(40, 40, 0xff00FF00);
			width = 40;
			height = 40;
			
			trail = new FlxTrail(this);
			trail.rotationsEnabled = false;
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
		}
		
		override public function update():void
		{
			enemyCoords = new FlxPoint(this.x + this.width / 2, this.y + this.height / 2);
			playerCoords = new FlxPoint(player.x + player.width / 2, player.y + player.height / 2);
			
			inSight = map.tileMap.rayCast(enemyCoords, playerCoords);
			
			if (aware)
			{
				if (patrolPath != null) destroyPath();
				
				FlxVelocity.moveTowardsObject(this, player, alertSpeed);
			}
			
			else if ((!aware && inSight) && isEnemyNear())
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
			
		}
		
		override public function kill():void
		{
			super.kill();
			
			trail.kill();
		}
		
	}

}