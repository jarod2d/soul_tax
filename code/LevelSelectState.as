//
// The second game state after the MainMenuState. Lets users select a level, then sends them to the PlayState.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class LevelSelectState extends FlxState {
		
		override public function create():void {
			super.create();
			
			// Set up the text.
			var text:FlxText;
			
			text = new FlxText(0, 100, FlxG.width, "Level Select");
			text.setFormat("propomin", 16, 0x553333, "center", 0xFF705555);
			add(text);
		}
		
		override public function update():void {
			// Move on to the Play state.
			if (FlxG.keys.SPACE) {
				FlxG.switchState(new PlayState());
			}
			
			super.update();
		}
		
	}
	
}
