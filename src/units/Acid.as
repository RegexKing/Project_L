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
		private var enemiesGroup:FlxGroup;
		
		public function Acid(_player:Player, _map:Map, _enemiesGroup:FlxGroup) 
		{
			super(_player, _map);
			enemiesGroup = _enemiesGroup;
			exists = false;
			
			attackValue = 2;
			attackValue = GameUtil.scaleDamage(attackValue);
			
			gibs = null;
			
			makeGraphic(10, 10, 0xff66FF00);
		}
		
		override public function update():void { }
		
		override public function onEmit():void
		{
			elasticity = 0.8;
			drag = new FlxPoint(200, 200);
			
			enemiesGroup.add(this);
			
			expire = new FlxDelay(200);
			expire.callback = kill;
			
			expire.start();
		}
		
		override public function kill():void 
		{
			super.kill();
			
			//expire.abort();
			expire = null;
		}
		
		override protected function addKillCount():void
		{}
		
	}

}