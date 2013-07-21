package util 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	 
	public class Darkness extends FlxSprite
	{
		
		public function Darkness() 
		{
			super();
			
			makeGraphic(GameData.RENDER_WIDTH, GameData.RENDER_HEIGHT, 0xff000000);
			
			blend = "multiply";
			//alpha = 0.95;	
		}	
	}

}