//
// Our FlxGame subclass. It maintains a number of handy static references to important game objects like the level and
// the player. Any object that gets added to the scene during the play state should be able to be accessed in some way
// through one of these static references.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	[SWF(width="800", height="640", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class Game extends FlxGame {
		
		// Constants for each game difficulty.
		public static const EasyDifficulty:int   = 0;
		public static const NormalDifficulty:int = 1;
		public static const HardDifficulty:int   = 2;
		
		// The major game objects.
		public static var player:Player;
		public static var level:Level;
		public static var ui:UI;
		public static var input:PlayerInput;
		
		// The index of the current level. Should be set before PlayState is loaded.
		public static var current_level:int;
		
		// The current game difficulty.
		public static var difficulty:int;
		
		public function Game() {
			super(400, 320, MainMenuState, 2);
			
			// Set up a few values.
			FlxG.debug     = true;
			FlxG.framerate = FlxG.flashFramerate = 45;
			difficulty     = NormalDifficulty;
			input          = new PlayerInput();
			
			// Load any stored level progress.
			LevelProgress.load();
			current_level = LevelProgress.levels_completed;
			
			// Load assets.
			Assets.load();
		}
		
	}
	
}
