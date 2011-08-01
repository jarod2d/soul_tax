//
// A quick little intro screen for each level that displays its name.
// 
// Created by Jarod Long on 7/31/2011.
//

package {
	
	import org.flixel.*;
	import flash.utils.*;
	
	public class LevelIntroScreen extends FlxGroup {
		
		// The level title text.
		public var level_title:FlxText;
		
		// Whether or not the text is currently fading.
		public var fading:Boolean;
		
		// Constructor.
		public function LevelIntroScreen() {
			super();
			
			// Set up the text.
			level_title = new FlxText(4.0, UI.HUDBarHeight + 30.0, FlxG.width - 8.0, "\"" + Level.levels[Game.current_level].name + "\"");
			level_title.setFormat("propomin", 24, 0xFFFAFAFA, "center", 0xFF050505);
			level_title.scrollFactor.x = level_title.scrollFactor.y = 0.0;
			fading = false;
			
			// Set up the delay before fading.
			setTimeout(function():void {
				fading = true;
			}, 1500.0);
			
			// Add everything.
			add(level_title);
		}
		
		override public function update():void {
			if (fading && level_title.alpha > 0.0) {
				level_title.alpha = Math.max(0.0, level_title.alpha - 0.5 * FlxG.elapsed);
			}
			else if (level_title.alpha <= 0.0) {
				remove(level_title);
			}
		}
		
	}
	
}
