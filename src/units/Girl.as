package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	 
	public class Girl extends FlxSprite
	{
		private var beastMan:BeastMan
		
		public function Girl(_beastMan:BeastMan=null) 
		{
			super();
			
			immovable = true;
			
			beastMan = _beastMan;
			
			makeGraphic(20, 20);
		}
		
		override public function hurt(_damagePoints:Number):void
		{
			super.hurt(_damagePoints);
			
			if(beastMan != null) beastMan.angry = true;
			
			FlxG.play(AssetsRegistry.enemyHurtMP3);
		}
		
	}

}