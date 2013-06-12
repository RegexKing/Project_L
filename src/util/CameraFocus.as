package util 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*; 
	
	import units.Player;
	 
	public class CameraFocus extends FlxObject
	{
		
		private var player:Player;
		private var angleBetween:Number;
		private const MIN_RADIUS:Number = 0;
		public var maxRadius:Number = 200;
		private var radius:Number;
		
		public function CameraFocus(_player:Player) 
		{
			super(0, 0, _player.width, _player.height);
			
			player = _player;
			
			radius = MIN_RADIUS;
		}
		
		public function updateCamera():void
		{	
		
			angleBetween = FlxVelocity.angleBetweenMouse(player);
			
			
			//Move the wand around the fairy
			if (FlxG.keys.pressed("SHIFT"))
			{
				if (radius < maxRadius) radius += 16;
				else radius = maxRadius;
				
				this.x = player.x + (radius * Math.cos(angleBetween));
				this.y = player.y + (radius * Math.sin(angleBetween));
			}
			
			else
			{
				if (radius > MIN_RADIUS)
				{
					radius -= 16;
					this.x = player.x + (radius * Math.cos(angleBetween));
					this.y = player.y + (radius * Math.sin(angleBetween));
				}
				else
				{
					radius = MIN_RADIUS;
					this.x = player.x;
					this.y = player.y;
					
					//if (this.x != player.x) FlxG.log(this.x + " and " + player.x);
				}
				
			}
			
			
		}
	}

}