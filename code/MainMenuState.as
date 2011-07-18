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
			
			// Set up the title screen text.
			var text:FlxText;
			
			text = new FlxText(0, 100, FlxG.width, "Muerte y Los Impuestos");
			text.setFormat("propomin", 16, 0x553333, "center", 0xFF705555);
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
			FlxG.playMusic(Assets.title_screen_music);
		}
		
		override public function update():void {
			// Move on to the Level Select state.
			if (FlxG.keys.SPACE) {
				FlxG.switchState(new LevelSelectState());
			}
			
			super.update();
		}
		
	}
	
}
