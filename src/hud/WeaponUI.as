package hud 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class WeaponUI extends FlxSprite
	{
		
		public function WeaponUI() 
		{
			super();
			
			loadGraphic(AssetsRegistry.weaponUIPNG, true, false, 32, 32);
			this.addAnimation("normal", [0]);
			this.addAnimation("bounce", [1]);
			this.addAnimation("crossbow", [2]);
			this.addAnimation("spread", [3]);
			this.addAnimation("sniper", [4]);
			
			scrollFactor.x = scrollFactor.y = 0;
			
			this.x = 5;
			this.y = GameData.RENDER_HEIGHT - this.height - 5;
			
			changeGraphic(GameData.weaponID);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("E"))
			{
				GameData.weaponID++;
				
				if (GameData.weaponID > GameData.weapon.length - 1) GameData.weaponID = 0;
				
				changeGraphic(GameData.weaponID);
			}
			
			if (FlxG.keys.justPressed("Q"))
			{
				GameData.weaponID--;
				
				if (GameData.weaponID < 0) GameData.weaponID = GameData.weapon.length - 1;
				
				changeGraphic(GameData.weaponID);
			}
		}
		
		public function changeGraphic(_weaponID:uint):void
		{
			if (GameData.weapon[_weaponID] == 0) play("normal");
			else if (GameData.weapon[_weaponID] == 1) play("crossbow");
			else if (GameData.weapon[_weaponID] == 2) play("spread");
			else if (GameData.weapon[_weaponID] == 3) play("sniper");
			else if (GameData.weapon[_weaponID] == 4) play("bounce");
		}
		
	}

}