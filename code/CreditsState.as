//
// The final game state that displays the game credits. Leads back to the level select state.
// 
// Created by Jarod Long on 7/24/2011.
//

package {
	
	import org.flixel.*;
	
	public class CreditsState extends FlxState {
		
		override public function create():void {
			super.create();
			
			// Set the background color.
			FlxG.bgColor = 0xFF000000;
			
			// Set up the thanks text.
			var thanks_text:FlxText = new FlxText(0.0, 30.0, FlxG.width, "Thanks for playing!\nYou rock!");
			thanks_text.lineSpacing = 16.0;
			thanks_text.setFormat("propomin", 32, 0xFFEEEEEE, "center");
			
			// Set up the credits.
			var roles_text:FlxText = new FlxText(12.0, 120.0, FlxG.width / 2.0, "Coding and Design:\nArt and Design:\nMusic and Sounds:");
			roles_text.lineSpacing = 20.0;
			roles_text.setFormat("propomin", 16, 0xFF888B9A, "right");
			
			var credits_text:FlxText = new FlxText(FlxG.width / 2.0 + 16.0, 120.0, FlxG.width / 2.0 - 4.0, "Jarod Long\nLauren Careccia\nBrad Snyder");
			credits_text.lineSpacing = 20.0;
			credits_text.setFormat("propomin", 16, 0xFFDDDDE2, "left");
			
			var url_text:FlxText = new FlxText(credits_text.x, credits_text.y + 16.0, credits_text.width, "http://jarodlong.com/\nhttp://laurencareccia.com/\nhttp://bradjsnyder.com/");
			url_text.lineSpacing = 25.0;
			url_text.setFormat("propomin", 8, 0xFFAAAAAE, "left");
			
			// Set up the text and icon at the bottom.
			var bottom_text:FlxText = new FlxText(0.0, FlxG.height - 86.0, FlxG.width, "Made in one month for");
			bottom_text.setFormat("propomin", 16, 0xFFEEEEEE, "center");
			
			var logo:FlxSprite = new FlxSprite(0.0, 0.0, Assets.sa_gamedev_logo);
			logo.origin.y = logo.height;
			logo.x = (FlxG.width - logo.width) / 2.0;
			logo.y = FlxG.height - logo.height - 4;
			logo.scale.x = logo.scale.y = 0.5;
			
			// Add everything.
			add(thanks_text);
			add(roles_text);
			add(credits_text);
			add(url_text);
			add(bottom_text);
			add(logo);
			
			// Recycle the title theme for the credits.
			if (FlxG.music) {
				FlxG.music.stop();
				FlxG.music = null;
			}
			
			FlxG.playMusic(Assets.title_screen_music);
		}
		
		override public function update():void {
			// Move on to the level select state.
			if (FlxG.keys.SPACE || FlxG.keys.J || FlxG.keys.ENTER) {
				FlxG.switchState(new LevelSelectState());
			}
			
			super.update();
		}
		
	}
	
}
