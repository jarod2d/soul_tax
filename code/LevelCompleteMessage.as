//
// A UI widget that displays a message once all the player's objectives have been completed.
// 
// Created by Jarod Long on 7/24/2011.
//

package {
	
	import org.flixel.*;
	
	public class LevelCompleteMessage extends FlxGroup {
		
		// The text of the timer.
		public var complete_message:FlxText;
		public var continue_message:FlxText;
		
		// Constructor.
		public function LevelCompleteMessage() {
			super();
			
			// Set up the text.
			complete_message = new FlxText(0.0, UI.HUDBarHeight + 4.0, FlxG.width, "Level Complete!").setFormat("propomin", 8, 0xFFFAFAFA, "center", 0xFF050505);
			complete_message.scrollFactor.x = complete_message.scrollFactor.y = 0.0;
			
			continue_message = new FlxText(0.0, UI.HUDBarHeight + 13.0, FlxG.width, "Press Enter to end the level").setFormat("propomin", 8, 0xFFDADADA, "center", 0xFF040404);
			continue_message.scrollFactor.x = continue_message.scrollFactor.y = 0.0;
			
			// Add everything.
			add(complete_message);
			add(continue_message);
			
			// The message is hidden initially.
			setAll("alpha", 0.0);
		}
		
	}
	
}
