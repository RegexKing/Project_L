package weapons 
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class SpreadGun extends FlxWeapon
	{
		
		public function SpreadGun(name:String, parentRef:* = null, xVariable:String = "x", yVariable:String = "y") 
		{
			super(name, parentRef, xVariable, yVariable);
		}
		
		override public function makePixelBullet(quantity:uint, width:int = 2, height:int = 2, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:BaseBullet = new BaseBullet(this, b);
				
				tempBullet.makeGraphic(width, height, color);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
		
		
	}

}