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
			FlxG.bgColor = 0xFFBBDDFF;
			
			// Set up the title.
			var text:FlxText;
			
			text = new FlxText(0, 100, FlxG.width, "A Ghost and His Taxes");
			text.lineSpacing = 10.0;
			text.setFormat("propomin", 32, 0xFFE0F0FF, "center", 0xFF112244);
			add(text);
			
			// Set up the credits.
			text = new FlxText(0, FlxG.height - 30, 100, "Coding and Design:\nArt and Design:\nMusic and Sounds:");
			text.lineSpacing = 3.0;
			text.setFormat("propomin", 8, 0xFF334055, "right", 0xFFE0F0FF);
			add(text);
			
			text = new FlxText(100, FlxG.height - 30, 150, "Jarod Long\nLauren Careccia\nBrad Snyder");
			text.lineSpacing = 3.0;
			text.setFormat("propomin", 8, 0xFF112266, "left", 0xFFE0F0FF);
			add(text);
			
			// Add the SA Gamedev logo.
			var logo:FlxSprite = new FlxSprite(0.0, 0.0, Assets.sa_gamedev_logo);
			logo.origin.x = logo.width;
			logo.origin.y = logo.height;
			logo.x = FlxG.width - logo.width - 4;
			logo.y = FlxG.height - logo.height - 4;
			
			logo.scale.x = logo.scale.y = 0.5;
			add(logo);
			
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
