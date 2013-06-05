package dialogue 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import hud.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Upgrade extends FlxGroup
	{	
		private var advanceConversation:Function;
		protected var lifeBar:LifeBar;
		protected var setFireRate:Function;
		protected var diamondCounter:DiamondCounter;
		
		private var header:FlxText;
		
		private var vitBar:FlxBar;
		private var attackBar:FlxBar;
		private var defenseBar:FlxBar;
		private var rateBar:FlxBar;
		
		private var healthCost:FlxText;
		private var attackCost:FlxText;
		private var defenseCost:FlxText;
		private var rateCost:FlxText;
		
		
		public function Upgrade(_advanceConversation:Function,  _lifeBar:LifeBar, _setFireRate:Function, _diamondCounter:DiamondCounter) 
		{
			advanceConversation = _advanceConversation;
			lifeBar = _lifeBar;
			setFireRate = _setFireRate;
			diamondCounter = _diamondCounter;
			
			header = new FlxText(37, 262, 468, "");
			header.setFormat("NES", 16);
			
			var background:FlxSprite = FlxGradient.createGradientFlxSprite(468, 209, [0xff0066FF, 0xff000066], 10);
			background.x = 22;
			background.y = 252;
			
			background.stamp(FlxGradient.createGradientFlxSprite(468, 174, [0xff0000FF, 0xff0099FF]), 22, 284);
			
			// Create the buttons
			var vitality:FlxButtonPlus = new FlxButtonPlus(37, 299, upgradeHealth, null, "Vitality");
			var attack:FlxButtonPlus = new FlxButtonPlus(37, 329, upgradeAttack, null, "Attack");
			var defense:FlxButtonPlus = new FlxButtonPlus(37, 359, upgradeDefense, null, "Defense");
			var rate:FlxButtonPlus = new FlxButtonPlus(37, 389, upgradeRate, null, "Rate");
			var cancelButton:FlxButtonPlus = new FlxButtonPlus(37, 419, kill, null, "done");
			
			vitality.setMouseOverCallback(vitalityDescription);
			attack.setMouseOverCallback(attackDescription);
			defense.setMouseOverCallback(defenseDescription);
			rate.setMouseOverCallback(rateDescription);
			
			vitality.setMouseOutCallback(updateHeader);
			attack.setMouseOutCallback(updateHeader);
			defense.setMouseOutCallback(updateHeader);
			rate.setMouseOutCallback(updateHeader);
			
			// create the upgrade bars
			vitBar = new FlxBar(300, 299, FlxBar.FILL_LEFT_TO_RIGHT, 126, 14);
			vitBar.createImageBar(AssetsRegistry.lifeBar_border_8PNG, AssetsRegistry.lifeBar_8PNG, 0x0);
			vitBar.setRange(0, GameData.MAX_UPGRADES);
			
			attackBar = new FlxBar(300, 329, FlxBar.FILL_LEFT_TO_RIGHT, 126, 14);
			attackBar.createImageBar(AssetsRegistry.lifeBar_border_8PNG, AssetsRegistry.lifeBar_8PNG, 0x0);
			attackBar.setRange (0, GameData.MAX_UPGRADES);
			
			defenseBar = new FlxBar(300, 359, FlxBar.FILL_LEFT_TO_RIGHT, 126, 14);
			defenseBar.createImageBar(AssetsRegistry.lifeBar_border_8PNG, AssetsRegistry.lifeBar_8PNG, 0x0);
			defenseBar.setRange (0, GameData.MAX_UPGRADES);
			
			rateBar = new FlxBar(300, 389, FlxBar.FILL_LEFT_TO_RIGHT, 126, 14);
			rateBar.createImageBar(AssetsRegistry.lifeBar_border_8PNG, AssetsRegistry.lifeBar_8PNG, 0x0);
			rateBar.setRange (0, GameData.MAX_UPGRADES);
			
			vitBar.currentValue = GameData.vitalityUpgrades;
			attackBar.currentValue = GameData.attackUpgrades;
			defenseBar.currentValue = GameData.defenseUpgrades;
			rateBar.currentValue = GameData.rateUpgrades;
			
			healthCost = new FlxText(237, 299, 60, String(initDisplayCost(GameData.vitalityUpgrades)));
			healthCost.setFormat("NES", 16);
			
			attackCost = new FlxText(237, 329, 60, String(initDisplayCost(GameData.attackUpgrades)));
			attackCost.setFormat("NES", 16);
			
			defenseCost = new FlxText(237, 359, 60, String(initDisplayCost(GameData.defenseUpgrades)));
			defenseCost.setFormat("NES", 16);
			
			rateCost = new FlxText(237, 389, 60, String(initDisplayCost(GameData.rateUpgrades)));
			rateCost.setFormat("NES", 16);
			
			//
			add(background);
			add(header);
			add(vitality);
			add(attack);
			add(defense);
			add(rate);
			add(cancelButton);
			add(vitBar);
			add(attackBar);
			add(defenseBar);
			add(rateBar);
			add(healthCost);
			add(attackCost);
			add(defenseCost);
			add(rateCost);
			
			
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function upgradeHealth():void
		{
			if (vitBar.currentValue < GameData.MAX_UPGRADES && findCost(GameData.vitalityUpgrades) < GameData.MAX_UPGRADES+1 && GameData.diamonds >= findCost(GameData.vitalityUpgrades))
			{
				vitBar.currentValue++; //increases the upgrade bar
				lifeBar.increaseBarRange(); //actually sets the attribute
				GameData.playerHealth = lifeBar.currentValue;
				
				diamondCounter.changeQuantity(-findCost(GameData.vitalityUpgrades));
				GameData.vitalityUpgrades++;
				
				if (findCost(GameData.vitalityUpgrades) < GameData.MAX_UPGRADES+1)
				{
					healthCost.text = String(findCost(GameData.vitalityUpgrades));
				}
				else
					healthCost.text = "max";

			}
			
			FlxG.log(GameData.totalHealth);
		}
		
		private function upgradeAttack():void
		{
			if (attackBar.currentValue < GameData.MAX_UPGRADES && findCost(GameData.attackUpgrades) < GameData.MAX_UPGRADES+1 && GameData.diamonds >= findCost(GameData.attackUpgrades))
			{
				attackBar.currentValue++; //increases the upgrade bar
				GameData.damageMultiplier += GameData.DAMAGE_FACTOR; //actually sets the attribute
				
				diamondCounter.changeQuantity(-findCost(GameData.attackUpgrades));
				GameData.attackUpgrades++;
				
				if (findCost(GameData.attackUpgrades) < GameData.MAX_UPGRADES+1)
				{
					attackCost.text = String(findCost(GameData.attackUpgrades));
				}
				else
					attackCost.text = "max";

			}
			
			FlxG.log(GameData.damageMultiplier);
		}
		
		private function upgradeDefense():void
		{
			if (defenseBar.currentValue < GameData.MAX_UPGRADES && findCost(GameData.defenseUpgrades) < GameData.MAX_UPGRADES+1 && GameData.diamonds >= findCost(GameData.defenseUpgrades))
			{
				defenseBar.currentValue++; //increases the upgrade bar
				GameData.defenseMultiplier += GameData.DEFENSE_FACTOR; //actually sets the attribute
				
				diamondCounter.changeQuantity(-findCost(GameData.defenseUpgrades));
				GameData.defenseUpgrades++;
				
				if (findCost(GameData.defenseUpgrades) < GameData.MAX_UPGRADES+1)
				{
					defenseCost.text = String(findCost(GameData.defenseUpgrades));
				}
				else
					defenseCost.text = "max";

			}
			
			FlxG.log(GameData.defenseMultiplier);
		}
		
		private function upgradeRate():void
		{
			if (rateBar.currentValue < GameData.MAX_UPGRADES && findCost(GameData.rateUpgrades) < GameData.MAX_UPGRADES+1 && GameData.diamonds >= findCost(GameData.rateUpgrades))
			{
				rateBar.currentValue++; //increases the upgrade bar
				GameData.fireRateMultiplier += GameData.FIRERATE_FACTOR; //actually sets the attribute
				setFireRate();
				
				diamondCounter.changeQuantity(-findCost(GameData.rateUpgrades));
				GameData.rateUpgrades++;
				
				if (findCost(GameData.rateUpgrades) < GameData.MAX_UPGRADES+1)
				{
					rateCost.text = String(findCost(GameData.rateUpgrades));
				}
				else
					rateCost.text = "max";

			}
			
			FlxG.log(GameData.fireRateMultiplier);
		}
		
		private function updateHeader(_description:String = null):void
		{
			switch(_description)
			{
				case "vitality":
					header.text = "Increases total health points";
					break;
				case "attack":
					header.text = "Increases damage done to foes";
					break;
				case "defense":
					header.text = "Decreases damage taken";
					break;
				case "rate":
					header.text = "Increases weapon fire rate";
					break;
				default:
					header.text = "";
					break;
			}
		}
		
		override public function kill():void
		{
			super.kill();
			advanceConversation();
		}
		
		private function findCost(_upgradeQuantity:uint):uint
		{
			return _upgradeQuantity+1;
		}
		
		private function initDisplayCost(_upgradeQuantity:uint):String
		{
			if (findCost(_upgradeQuantity) < GameData.MAX_UPGRADES + 1) return String(_upgradeQuantity);
			else return "MAX";
		}
		
		private function vitalityDescription():void { updateHeader("vitality"); }
		private function attackDescription():void { updateHeader("attack"); }
		private function defenseDescription():void { updateHeader("defense"); }
		private function rateDescription():void { updateHeader("rate"); }
	}
}