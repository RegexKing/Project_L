package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FlxBar;
	import maps.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class RangedEnemy extends Enemy
	{
		
		private var weapon:FlxWeapon;
		
		public function RangedEnemy(_player:Player, _map:Map, _enemyBullets:FlxGroup, _gibsGroup:FlxGroup, _enemyBars:FlxGroup,  _itemEmitter:FlxEmitter=null) 
		{
			super(_player, _map,  _itemEmitter);
			
			patrolSpeed = 100;
			alertSpeed = 160;
			health = 3;
			attackValue = 1;
			
			health = GameUtil.scaleHealth(health);
			attackValue = GameUtil.scaleDamage(attackValue);
			
			loadGraphic(AssetsRegistry.guyPNG, true, true, 54, 64);
			width = 22;
			height = 38;
			offset.x = 16;
			offset.y = 13;
			//this.addAnimation("idle", [24], 60);
			this.addAnimation("run", [16, 17, 18, 19, 20, 21], 10);
			this.play("run");
			
			lifeBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, this.width, lifeBarHeight, this, "health", 0, health);
			lifeBar.createFilledBar(0xffFF0000, 0xff00FF00);
			lifeBar.trackParent(0, lifeBarOffset);
			lifeBar.visible = false;
			_enemyBars.add(lifeBar);
			
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
			
			if (aware && inSight)
			{
				weapon.fireAtTarget(player);
			}
		}	
	}

}