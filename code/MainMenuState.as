//
// The first game state that displays the main menu. Leads to LevelSelectState.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class MainMenuState extends FlxState {
		
		override public function create():void {
			super.create();
			
			// Set the background color.
			FlxG.bgColor = 0xFF33353A;
			
			// Set up the title.
			var text:FlxText;
			
			text = new FlxText(0, 90.0, FlxG.width, "A Ghost and His Taxes");
			text.lineSpacing = 10.0;
			text.setFormat("propomin", 32, 0xFFE0E2E4, "center", 0xFF001118);
			add(text);
			
			// Set up the credits.
			text = new FlxText(FlxG.width / 2.0 - 90.0, 180.0, 100.0, "Coding and Design:\nArt and Design:\nMusic and Sounds:");
			text.lineSpacing = 3.0;
			text.setFormat("propomin", 8, 0xFFE0E2E4, "right", 0xFF000A10);
			add(text);
			
			text = new FlxText(FlxG.width / 2.0 + 10.0, 180.0, 150.0, "Jarod Long\nLauren Careccia\nBrad Snyder");
			text.lineSpacing = 3.0;
			text.setFormat("propomin", 8, 0xFFD0D9E8, "left", 0xFF001528);
			add(text);
			
			// Add the SA Gamedev logo.
			var logo:FlxSprite = new FlxSprite(0.0, 0.0, Assets.sa_gamedev_logo);
			logo.origin.y = logo.height;
			logo.x = (FlxG.width - logo.width) / 2.0;
			logo.y = FlxG.height - logo.height - 2.0;
			
			logo.scale.x = logo.scale.y = 0.5;
			add(logo);
			
			// Add keyboard helpers.
			var confirm_label:FlxText = new FlxText(6.0, FlxG.height - 38.0, 200.0, "Continue");
			confirm_label.setFormat("propomin", 8, 0xFFE0E2E4, "left", 0xFF000A10);
			add(confirm_label);
			
			var j_key:FlxSprite = new FlxSprite(21.0, FlxG.height - 22.0, Assets.j_key);
			add(j_key);
			
			// Play the title theme.
			if (FlxG.music) {
				FlxG.music.stop();
				FlxG.music = null;
			}
			
			FlxG.playMusic(Assets.title_screen_music);
		}
		
		override public function update():void {
			// Move on to the Level Select state.
			if (FlxG.keys.SPACE || FlxG.keys.J || FlxG.keys.ENTER) {
				FlxG.switchState(new LevelSelectState());
			}
			
			super.update();
		}
		
	}
	
}
