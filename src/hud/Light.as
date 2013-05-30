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
			loadGraphic(AssetsRegistry.crystalLightPNG, true, false, 240, 240);
			addAnimation("glow", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1], 10);
 
			darkness = _darkness;
			object = _object;
			
			this.blend = "screen";
			
			play("glow");
		}
 
		override public function draw():void 
		{
			var screenXY:FlxPoint = getScreenXY();
 
			darkness.stamp(this, screenXY.x - this.width / 2, screenXY.y - this.height / 2);
		}
		
		
	}
}