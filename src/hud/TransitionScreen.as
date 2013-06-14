package hud 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.RainbowLineFX;
	/**
	 * ...
	 * @author Frank Fazio
	 */
	public class TransitionScreen extends FlxGroup
	{
		private var backDrop:FlxSprite;
		private var message:FlxText;
		private var timer:Number;
		private var tweenFinished:Boolean;
		private var goNextState:Function;
		private var transitionStarted:Boolean;
		
		public function TransitionScreen(_state:String, _goNextState:Function) 
		{
			super();
			
			goNextState = _goNextState;
			timer = 0;
			
			tweenFinished = false;
			transitionStarted = false;
			
			backDrop = new FlxSprite();
			backDrop.scrollFactor.x = backDrop.scrollFactor.y = 0;
			backDrop.makeGraphic(GameData.RENDER_WIDTH, GameData.RENDER_HEIGHT / 2, 0xff000000);
			backDrop.y = GameData.RENDER_HEIGHT / 2 - backDrop.height / 2;
			
			message = new FlxText(0, backDrop.y + backDrop.height/2 - backDrop.height/8, GameData.RENDER_WIDTH);
			message.scrollFactor.x = message.scrollFactor.y = 0;
			message.setFormat("NES", backDrop.height/4, 0xffFF0000, "center");
			
			if (_state == "gameover")
			{
				message.setFormat("NES", backDrop.height / 4, 0xffFF0000, "center", 0xffFFFFFF);
				message.text = "You Died";
			}
			
			else if (_state == "levelcomplete")
			{
				message.setFormat("NES", backDrop.height/4, 0xffffd700, "center", 0xffFFFFFF);
				message.text = "Level Complete";
				message.y -= message.height / 4;
				
				var topLine:RainbowLineFX =  FlxSpecialFX.rainbowLine();
				var bottomLine:RainbowLineFX =  FlxSpecialFX.rainbowLine();
				
				topLine.create(0, backDrop.y, GameData.RENDER_WIDTH, 1, null, 360, 8);
				bottomLine.create(0, backDrop.y + backDrop.height, GameData.RENDER_WIDTH, 1, null, 360, 8);
				topLine.setDirection(1);
				
				topLine.sprite.scrollFactor.x = topLine.sprite.scrollFactor.y = 0;
				bottomLine.sprite.scrollFactor.x = bottomLine.sprite.scrollFactor.y = 0;
			}
			
			
			backDrop.alpha = 0;
			message.alpha = 0;
			
			add(backDrop);
			add(message);
			
			if (_state == "levelcomplete")
			{
				add(topLine.sprite);
				add(bottomLine.sprite);
			}
			
			
			//TODO play tune
		}
		
		override public function update():void
		{
			super.update();
			
			timer += FlxG.elapsed / 3;
			
			if (!tweenFinished)
			{
				if (timer >= 1)
				{
					backDrop.alpha = 1;
					message.alpha = 1;
					tweenFinished = true;
				}
				
				backDrop.alpha = timer;
				message.alpha = timer;
			}
			
			else if(!transitionStarted)
			{
				transitionStarted = true;
				
				FlxG.music.fadeOut(1);
				FlxG.fade(0xff000000, 1, goNextState);
			}
			
			
		}
		
	}

}