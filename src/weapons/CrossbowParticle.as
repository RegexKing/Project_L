package weapons 
{
	import org.flixel.FlxParticle;
	import org.flixel.FlxSprite;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class CrossbowParticle extends FlxParticle
	{
		
		public function CrossbowParticle(_isEnemy:Boolean) 
		{
			super();
			exists = false;
			
			attackValue = .2;
			
			if (_isEnemy)
			{
				attackValue = 2;
				
				attackValue = GameUtil.scaleDamage(attackValue);
			}
			
			makeGraphic(8, 8, 0xffFF3300);
		}
		
		override public function onEmit():void
		{
			elasticity = 0.8;
			drag = new FlxPoint(200, 200);
		}
		
	}

}