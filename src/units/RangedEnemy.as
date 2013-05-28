package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	import maps.Dungeon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class RangedEnemy extends Enemy
	{
		
		private var enemyBullets:FlxGroup;
		private var weapon:FlxWeapon;
		
		public function RangedEnemy(_player:Player, _dungeon:Dungeon, _enemyBullets:FlxGroup, _gibsGroup:FlxGroup) 
		{
			super(_player, _dungeon, _gibsGroup);
			
			enemyBullets = _enemyBullets;
			
			speed = 50;
			health = 2;
			attackValue = 2;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			makeGraphic(20, 20, 0xff000000);
			
			width = 20;
			height = 20;
			
			gibs.makeParticles(AssetsRegistry.playerGibsPNG, 100, 10, true, 0.5);
			
			weapon = new FlxWeapon("normal", this);
			weapon.makePixelBullet(10, 8, 8);
			weapon.setBulletSpeed(200);
			weapon.setBulletBounds(new FlxRect(0, 0, Dungeon.width, Dungeon.height));
			weapon.setFireRate(500);
			weapon.setPreFireCallback(null, AssetsRegistry.shootMP3);
			
			enemyBullets.add(weapon.group);
		}
		
		override public function update():void
		{
			super.update();
			
			if (aware && inSight)
			{
				weapon.fireAtTarget(player);
			}
		}	
	}

}