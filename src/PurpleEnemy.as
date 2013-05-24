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
			
			makeGraphic(20, 20, 0xffFF00FF);
			width = 20;
			height = 20;
		}
		
		override public function update():void
		{
			//super.update();
			
			//trace("sight: " + inSight + "\naware: " + aware);
		}
		
	}

}