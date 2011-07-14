//
// Our FlxGame subclass. It maintains a number of handy static references to important game objects like the level and
// the player. Any object that gets added to the scene during the play state should be able to be accessed in some way
// through one of these static references.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	[SWF(width="800", height="750", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class Game extends FlxGame {
		
		// The major game objects.
		public static var player:Player;
		public static var level:Level;
		public static var ui:UI;
		
		public function Game() {
			super(400, 375, MainMenuState, 2);
			
			// Set up a few values.
			FlxG.debug     = true;
			FlxG.framerate = FlxG.flashFramerate = 45;
			
			// We start off on level 0!
			
			// Load assets.
			Assets.load();
		}
		
	}
	
}
