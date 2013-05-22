package  
{
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class PurpleEnemy extends Enemy
	{
		
		public function PurpleEnemy(_player:Player, _dungeon:Dungeon) 
		{
			super(_player, _dungeon);
			
			makeGraphic(16, 16, 0xffFF00FF);
			width = 16;
			height = 16;
		}
		
		override public function update():void
		{
			//super.update();
			
			//trace(inSight);
		}
		
	}

}