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
		
		public function WeaponItem() 
		{
			expireTime = 7000;
			
			super();
			
			//switch statement to choose graphic
			switch(FlxMath.rand(MIN_ID, MAX_ID))
			{
				case Player.NORMAL_GUN:
					makeGraphic(15, 15, 0xffFFFFFF);
					width = 15;
					height = 15;
					break;
					
				case Player.BOUNCE_GUN:
					makeGraphic(15, 15, 0xffFFFFFF);
					width = 15;
					height = 15;
					break;
					
				default:
					makeGraphic(15, 15, 0xffFFFFFF);
					width = 15;
					height = 15;
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