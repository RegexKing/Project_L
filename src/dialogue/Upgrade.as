package dialogue 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class Upgrade extends FlxGroup
	{
		
		private const MAX_UPGRADES:uint = 5;
		
		private var advanceConversation:Function;
		private var setHealthUpgrade:Function;
		private var header:FlxText;
		
		private var vitBar:FlxBar;
		
		private var healthCost:FlxText;
		
		public function Upgrade(_advanceConversation:Function, _setHealthUpgrade:Function) 
		{
			advanceConversation = _advanceConversation;
			setHealthUpgrade = _setHealthUpgrade;
			
			header = new FlxText(37, 262, 468, "");
			header.setFormat("NES", 16);
			
			var background:FlxSprite = FlxGradient.createGradientFlxSprite(468, 209, [0xff0066FF, 0xff000066], 10);
			background.x = 22;
			background.y = 252;
			
			background.stamp(FlxGradient.createGradientFlxSprite(468, 174, [0xff0000FF, 0xff0099FF]), 22, 284);
			
			var vitality:FlxButtonPlus = new FlxButtonPlus(37, 299, null, null, "Vitality");
			var attack:FlxButtonPlus = new FlxButtonPlus(37, 329, null, null, "Attack");
			var defense:FlxButtonPlus = new FlxButtonPlus(37, 359, null, null, "Defense");
			var rate:FlxButtonPlus = new FlxButtonPlus(37, 389, null, null, "Rate");
			var cancelButton:FlxButtonPlus = new FlxButtonPlus(37, 419, kill, null, "done");
			
			vitality.setMouseOverCallback(vitalityDescription);
			attack.setMouseOverCallback(attackDescription);
			defense.setMouseOverCallback(defenseDescription);
			rate.setMouseOverCallback(rateDescription);
			
			vitality.setMouseOutCallback(updateHeader);
			attack.setMouseOutCallback(updateHeader);
			defense.setMouseOutCallback(updateHeader);
			rate.setMouseOutCallback(updateHeader);
			
			//
			vitBar = new FlxBar(300, 299, FlxBar.FILL_LEFT_TO_RIGHT, 78, 14);
			vitBar.createImageBar(AssetsRegistry.lifeBar_border_5PNG, AssetsRegistry.lifeBar_5PNG, 0x0);
			vitBar.setRange(0, 5);
			
			vitBar.currentValue = GameData.totalHealth - 3;
			
			healthCost = new FlxText(237, 299, 100, String(findCost(GameData.vitalityUpgrades)));
			healthCost.setFormat("NES", 16);
			
			//var attackBar:FlxBar = new FlxBar(300, 200, FlxBar.FILL_LEFT_TO_RIGHT, 78, 14);
			//attackBar.createImageBar(AssetsRegistry.lifeBar_border_5PNG, AssetsRegistry.lifeBar_5PNG, 0x0);
			//attackBar.setRange (0, 5);
			//
			
			add(background);
			add(header);
			add(vitality);
			add(attack);
			add(defense);
			add(rate);
			add(cancelButton);
			add(vitBar);
			add(healthCost);
			
			
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function upgradeHealth():void
		{
			if (vitBar.currentValue < 5 && GameData.diamonds >= findCost(GameData.vitalityUpgrades))
			{
				vitBar.currentValue++;
				setHealthUpgrade();
				
				GameData.diamonds -= findCost(GameData.vitalityUpgrades);
				GameData.vitalityUpgrades++;
				if (findCost(GameData.vitalityUpgrades) < 6)
				{
					healthCost.text = String(findCost(GameData.vitalityUpgrades));
				}
				else
					healthCost.text = "max";
			}
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
			switch(_upgradeQuantity)
			{
				case 0:
					return 1;
					break;
				case 1:
					return 2;
					break;
				case 2:
					return 3;
					break;
				case 3:
					return 4;
					break;
				case 4:
					return 6;
					break;
				default:
					throw new Error("upgrade quantity is not in valid range");
					break;
			}
		}
		
		private function vitalityDescription():void { updateHeader("vitality"); }
		private function attackDescription():void { updateHeader("attack"); }
		private function defenseDescription():void { updateHeader("defense"); }
		private function rateDescription():void { updateHeader("rate"); }
	}
}