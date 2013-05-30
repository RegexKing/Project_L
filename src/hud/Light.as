package  hud
{
	import org.flixel.*;
	import units.Player;
 
	public class Light extends FlxSprite 
	{
 
		private var darkness:FlxSprite;
		private var object:FlxSprite;
    
		public function Light(_darkness:FlxSprite, _object:FlxSprite):void 
		{
			super();
			loadGraphic(AssetsRegistry.crystalLightPNG, false, false, 215, 215);
 
			darkness = _darkness;
			object = _object;
			
			this.blend = "screen";
		}
 
		override public function draw():void 
		{
			var screenXY:FlxPoint = getScreenXY();
 
			darkness.stamp(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
		}
	}
}