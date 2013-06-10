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
		
		public function CrossbowParticle() 
		{
			super();
			exists = false;
			
			attackValue = .1;
			
			makeGraphic(4, 4, 0xff00FF00);
		}
		
		override public function onEmit():void
		{
			elasticity = 0.8;
			drag = new FlxPoint(200, 200);
		}
		
	}

}