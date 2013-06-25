package items 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import com.newgrounds.API;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Treasure extends Item
	{
		private var win:Function;
		
		public function Treasure(_win:Function) 
		{
			super();
			
			exists = true;
			expireTime = 0;
			win = _win;
			
			loadGraphic(AssetsRegistry.chestPNG, true, false, 40, 40);
			addAnimation("closed", [0]);
			addAnimation("open", [1]);
			play("closed");
			
		}
		
		override public function pickup():void
		{
			this.solid = false;
			play("open");
			
			//play sound
			FlxG.play(AssetsRegistry.openChestMP3);
			
			win();
		}
	}

}