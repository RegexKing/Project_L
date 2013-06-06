package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	import maps.Map;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	 
	public class SkeletonArcher extends Skeleton
	{
		private var weapon:FlxWeapon;
		
		public function SkeletonArcher(_player:Player, _map:Map, _gibsGroup:FlxGroup, _enemyBullets:FlxGroup) 
		{
			super(_player, _map, _gibsGroup);
			
			patrolSpeed = 160;
			alertSpeed = 200;
			health = 1;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(40, 40, 0xff00FF00);
			width = 40;
			height = 40;
	
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true);
			_gibsGroup.add(gibs);
			
			weapon = new FlxWeapon("normal", this);
			weapon.makePixelBullet(10, 16, 16);
			weapon.setBulletSpeed(400);
			weapon.setBulletBounds(new FlxRect(0, 0, map.tileMap.width, map.tileMap.height));
			weapon.setFireRate(500);
			weapon.setPreFireCallback(null, AssetsRegistry.shootMP3);
			
			_enemyBullets.add(weapon.group);
		}
		
		override public function update():void
		{
			super.update();
			
			if (aware && solid && inSight)
			{
				weapon.fireAtTarget(player);
			}
		}	
		
	}

}