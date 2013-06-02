package util 
{
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class PlayerLight extends Light
	{
		
		public function PlayerLight(_darkness:Darkness, _object:FlxObject) 
		{
			super(_darkness, _object);
			
			loadGraphic(AssetsRegistry.crystalLightPNG, true, false, 490, 490);
			addAnimation("glow", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1], 10);
			
			play("glow");
		}
		
	}

}