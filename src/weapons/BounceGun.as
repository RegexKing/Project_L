package weapons 
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class BounceGun extends FlxWeapon
	{
		
		public function BounceGun(name:String, parentRef:* = null, xVariable:String = "x", yVariable:String = "y") 
		{
			super(name, parentRef, xVariable, yVariable);
		}
		
		override public function makePixelBullet(quantity:uint, width:int = 2, height:int = 2, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:BounceBullet = new BounceBullet(this, b);
				
				tempBullet.makeGraphic(width, height, color);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
	}

}