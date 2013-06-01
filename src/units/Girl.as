package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	import org.flixel.plugin.photonstorm.*;
	 
	public class Girl extends FlxSprite
	{
		private var beastMan:BeastMan;
		private var player:Player;
		
		public function Girl(_player:Player, _beastMan:BeastMan=null) 
		{
			super();
			
			immovable = true;
			
			player = _player;
			beastMan = _beastMan;
			
			makeGraphic(20, 20);
		}
		
		override public function update():void
		{
			if (GameData.level == GameData.LAST_LEVEL && !touching)
			{
				FlxVelocity.moveTowardsObject(this, player, 250);
			}
			
			else if (justTouched(FLOOR) || justTouched(CEILING) || justTouched(LEFT) || justTouched(RIGHT))
			{
				//function callback for dialogue box
				FlxG.log("Just touched girl");
			}
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			super.hurt(_damagePoints);
			
			if(beastMan != null) beastMan.angry = true;
			
			FlxG.play(AssetsRegistry.enemyHurtMP3);
		}
		
	}

}