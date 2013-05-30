package   items
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	 
	public class Item extends FlxParticle
	{
		
		public function Item() 
		{
			super();
			exists = false;
		}
		
		public function pickup():void
		{
			
		}
		
		override public function onEmit():void
		{
			elasticity = 0.8;
			drag = new FlxPoint(180, 180);
		}
		
	}

}