package   items
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*; 
	import org.flixel.plugin.photonstorm.FlxDelay;
	 
	public class Item extends FlxParticle
	{
		protected var expireTime:int = 0;
		private var expire:FlxDelay;
		
		public function Item() 
		{
			super();
			exists = false;
			
			if (expireTime != 0) expire = new FlxDelay(expireTime);
		}
		
		public function pickup():void
		{
			
		}
		
		override public function onEmit():void
		{
			elasticity = 0.8;
			drag = new FlxPoint(180, 180);
			
			if (expire != null)
			{
				expire.callback = startBlink;
				expire.start();
			}
			
		}
		
		protected function startBlink():void
		{
			this.flicker( -1);
		}
		
	}

}