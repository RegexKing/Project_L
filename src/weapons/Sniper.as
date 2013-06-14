package weapons 
{
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import org.flixel.FlxGroup;
	
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Sniper extends BaseGun
	{
		
		private var isEnemy:Boolean;
		
		public function Sniper(name:String, parentRef:* = null, _isEnemy:Boolean=false, xVariable:String = "x", yVariable:String = "y") 
		{
			super(name, parentRef, _isEnemy, xVariable, yVariable);
			isEnemy = _isEnemy;
		}
		
		override public function makePixelBullet(quantity:uint, width:int = 2, height:int = 2, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:SniperBullet = new SniperBullet(this, b, isEnemy);
				
				tempBullet.makeGraphic(width, height, color);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
	}

}