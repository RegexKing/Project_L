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
		private var functionCallback:Function;
		
		public function Girl(_player:Player, _functionCallback:Function, _beastMan:BeastMan=null) 
		{
			super();
			
			functionCallback = _functionCallback;
			
			immovable = true;
			
			player = _player;
			beastMan = _beastMan;
			
			makeGraphic(40, 40);
		}
		
		override public function update():void
		{
			if (GameData.level == GameData.LAST_LEVEL && !touching)
			{
				FlxVelocity.moveTowardsObject(this, player, 500);
			}
			
			else if ((justTouched(FLOOR) || justTouched(CEILING) || justTouched(LEFT) || justTouched(RIGHT)) 
				&& (beastMan == null || !beastMan.angry || !beastMan.alive))
			{
				//function callback for dialogue box
				functionCallback("girl");
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