package   items
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	 import units.Player;
	 import org.flixel.plugin.photonstorm.FlxMath;
	 
	public class WeaponItem extends Item
	{
		private const MIN_ID:int = 1;
		private const MAX_ID:int = 3;
		private var weaponID:int = 0;
		
		public function WeaponItem() 
		{
			expireTime = 10000;
			
			super();
			
			weaponID = FlxMath.rand(MIN_ID, MAX_ID);
			
			//switch statement to choose graphic
			switch(weaponID)
			{
				case Player.NORMAL_GUN:
					makeGraphic(30, 30, 0xffFFFFFF);
					break;
					
				case Player.BOUNCE_GUN:
					makeGraphic(30, 30, 0xffFFFFFF);
					break;
					
				default:
					makeGraphic(30, 30, 0xffFFFFFF);
					break;
					
			}
		}
		
		override public function onEmit():void
		{
			super.onEmit();
			
			//todo add animation to play
		}
		
		override public function pickup():void
		{
			GameData.weapon = weaponID;
			
			//Todo: add sound effect
		}
		
	}

}