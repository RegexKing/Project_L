package weapons 
{
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.*
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class SpreadGun extends FlxWeapon
	{
		private var isEnemy:Boolean;
		private var deviations:Array;
		
		private const bulletNumber:uint = 5;
		
		public function SpreadGun(name:String, parentRef:* = null, _isEnemy:Boolean=false, xVariable:String = "x", yVariable:String = "y") 
		{
			super(name, parentRef, xVariable, yVariable);
			isEnemy = _isEnemy;
			
			deviations = new Array();
			deviations.push(-0.4);
			deviations.push(-0.2);
			deviations.push(0);
			deviations.push(0.2);
			deviations.push(0.4);
			
		}
		
		override public function makePixelBullet(quantity:uint, width:int = 2, height:int = 2, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:SpreadBullet = new SpreadBullet(this, b, isEnemy);
				
				tempBullet.makeGraphic(width, height, color);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
		override protected function runFire(method:uint, x:int = 0, y:int = 0, target:FlxSprite = null, angle:int = 0):Boolean
		{
			if (fireRate > 0 && (getTimer() < nextFire))
			{
				return false;
			}
			
			if (onPreFireCallback is Function)
				{
					onPreFireCallback.apply();
				}
				
			if (onPreFireSound)
				{
					FlxG.play(onPreFireSound);
				}
			
			for (var i:uint = 0; i < bulletNumber; i++)
			{
			
				currentBullet = getFreeBullet();
				
				if (currentBullet == null)
				{
					return false;
				}
				
				//	Clear any velocity that may have been previously set from the pool
				currentBullet.velocity.x = 0;
				currentBullet.velocity.y = 0;
				
				var launchX:int = positionOffset.x;
				var launchY:int = positionOffset.y;
				
				if (fireFromParent)
				{
					launchX += parent[parentXVariable];
					launchY += parent[parentYVariable];
				}
				else if (fireFromPosition)
				{
					launchX += fireX;
					launchY += fireY;
				}
				
				if (directionFromParent)
				{
					velocity = FlxVelocity.velocityFromFacing(parent, bulletSpeed);
				}
				
				var count:uint = i;
				
				//	Faster (less CPU) to use this small if-else ladder than a switch statement
				if (method == FIRE)
				{
					currentBullet.fire(launchX, launchY, velocity.x, velocity.y);
				}
				
				else if (method == FIRE_AT_MOUSE)
				{
					currentBullet.fireAtMouse(launchX, launchY, bulletSpeed, deviations[count]);
				}
				else if (method == FIRE_AT_POSITION)
				{
					currentBullet.fireAtPosition(launchX, launchY, x, y, bulletSpeed);
				}
				else if (method == FIRE_AT_TARGET)
				{
					currentBullet.fireAtTarget(launchX, launchY, target, bulletSpeed, deviations[count]);
				}
				else if (method == FIRE_FROM_ANGLE)
				{
					currentBullet.fireFromAngle(launchX, launchY, angle, bulletSpeed);
				}
				else if (method == FIRE_FROM_PARENT_ANGLE)
				{
					currentBullet.fireFromAngle(launchX, launchY, parent.angle, bulletSpeed);
				}
			
			}
			
			if (onPostFireCallback is Function)
			{
				onPostFireCallback.apply();
			}
			
			if (onPostFireSound)
			{
				FlxG.play(onPostFireSound);
			}
			
			lastFired = getTimer();
			nextFire = getTimer() + fireRate;
			
			bulletsFired++;
			
			return true;
		}
		
	}

}