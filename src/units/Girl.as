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
			
			if ((justTouched(FLOOR) || justTouched(CEILING) || justTouched(LEFT) || justTouched(RIGHT)) 
				&& (beastMan == null || !BeastMan.angry || !beastMan.alive))
			{
				//function callback for dialogue box
				functionCallback("girl");
			}
			
			if (FlxVelocity.distanceBetween(this, player) <= this.height * 2 || (beastMan != null && beastMan.closeToPlayer()))
			{
				if (beastMan != null && BeastMan.angry)
					player.fireable = true;
				else
					player.fireable = false;
			}
			
			else player.fireable = true;
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			if(beastMan != null) BeastMan.angry = true;
			
			FlxG.play(AssetsRegistry.enemyHurtMP3);
		}
		
	}

}