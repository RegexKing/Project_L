package weapons 
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	import org.flixel.FlxGroup
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Crossbow extends FlxWeapon
	{
		
		private var playerBulletsGroup:FlxGroup;
		
		public function Crossbow(name:String,  _playerBulletsGroup:FlxGroup, parentRef:* = null, xVariable:String = "x", yVariable:String = "y") 
		{
			super(name, parentRef, xVariable, yVariable);
			
			playerBulletsGroup = _playerBulletsGroup;
		}
		
		override public function makePixelBullet(quantity:uint, width:int = 2, height:int = 2, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:CrossbowArrow = new CrossbowArrow(this, b, playerBulletsGroup);
				
				tempBullet.makeGraphic(width, height, color);
				tempBullet.width = width;
				tempBullet.height = height;
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
	}

}