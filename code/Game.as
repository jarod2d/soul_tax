//
// Our FlxGame subclass.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	[SWF(width="800", height="650", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]
	
	public class Game extends FlxGame {
		
		// The player.
		public static var player:Player;
		
		// The level.
		public static var level:Level;
		
		public function Game() {
			super(400, 325, MainMenuState, 2);
			
			// Set up a few values.
			FlxG.debug     = true;
			FlxG.framerate = FlxG.flashFramerate = 45;
		}
		
	}
	
}
