package  units
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * 
	 * ...
	 * @author Frank Fazio
	 */
	public class Player extends FlxSprite
	{
		//constants
		private const MOVEMENT_SPEED:Number = 100;
		
		public var playerGibs:FlxEmitter;
		
		public function Player(_gibsGroup:FlxGroup) 
		{
			super();
			
			makeGraphic(40, 40, 0xff00FF00);
			
			width = 40;
			height = 40;
			
			playerGibs = new FlxEmitter(0, 0, 50);
			playerGibs.particleDrag = new FlxPoint(300, 300);
			playerGibs.setXSpeed(-200,200);
			playerGibs.setYSpeed(-200,200);
			playerGibs.setRotation(0, 0);
			playerGibs.bounce = 0.5;
			playerGibs.makeParticles(AssetsRegistry.playerGibsPNG, 50, 10, true, 0.5);
			
			_gibsGroup.add(playerGibs);
			
			if (FlxG.getPlugin(FlxControl) == null) FlxG.addPlugin(new FlxControl);
			
			FlxControl.create(this, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, false);
			FlxControl.player1.setWASDControl();
			FlxControl.player1.setStandardSpeed(100);
		}
		
		override public function update():void
		{	
		}
		
		/*
		public function set fireRateMultiplier(_fireRateMultiplier:Number):void //To use at home
		{
			//TODO: update the firerates of all weapons
			normalGun.setFireRate(NORMAL_RATE - (NORMAL_RATE * _fireRateMultiplier));
			bounceGun.setFireRate(BOUNCE_RATE - (BOUNCE_RATE * _fireRateMultiplier));
		}
		*/
		
		override public function hurt(_damageNumber:Number):void
		{
			this.flicker(1);
			FlxG.camera.shake(0.005, 0.35);
			
			//sound effect
			FlxG.play(AssetsRegistry.playerHurtMP3);
		}
		
		override public function kill():void
		{
			if (!alive) return;
			
			
			solid = false;
			super.kill();
			exists = true;
			visible = false;
			velocity.make()
			acceleration.make();
			
			FlxControl.clear();
			
			FlxG.camera.shake(0.01,0.35);
			FlxG.camera.flash(0xffFF0000, 0.35);
			
			if(playerGibs != null)
			{
				playerGibs.at(this);
				playerGibs.start(true, 0, 0, 0);
			}
			
			//sound effect
			FlxG.play(AssetsRegistry.playerDieMP3);
		}
		
	}

}