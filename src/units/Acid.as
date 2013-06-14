package units 
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	
	import org.flixel.FlxEmitter;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import maps.Map; 
	import org.flixel.plugin.photonstorm.FlxDelay;
	 
	public class Acid extends Enemy
	{
		private var expire:FlxDelay;
		
		public function Acid(_player:Player, _map:Map) 
		{
			super(_player, _map);
			exists = false;
			
			attackValue = 2;
			attackValue = GameUtil.scaleDamage(attackValue);
			
			gibs = null;
			
			makeGraphic(10, 10, 0xffFF0000);
		}
		
		override public function update():void { }
		
		override public function onEmit():void
		{
			elasticity = 0.8;
			drag = new FlxPoint(200, 200);
			
			expire = new FlxDelay(350);
			expire.callback = kill;
			
			expire.start();
		}
		
		override public function kill():void 
		{
			super.kill();
			
			expire.abort();
			expire = null;
		}
		
		override protected function addKillCount():void
		{}
		
	}

}