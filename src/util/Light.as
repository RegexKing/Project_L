package  util
{
	import org.flixel.*;
	import units.Player;
 
	public class Light extends FlxSprite 
	{
 
		private var darkness:FlxSprite;
		private var object:FlxObject;
    
		public function Light(_darkness:Darkness, _object:FlxObject):void 
		{
			super();
			
			darkness = _darkness;
			object = _object;
			
			this.blend = "screen";
		}
		
		override public function update():void
		{
			this.x = object.x + object.width/2;
			this.y = object.y + object.height/2;
		}
 
		override public function draw():void 
		{
			var screenXY:FlxPoint = getScreenXY();
 
			darkness.stamp(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
		}
	}
}