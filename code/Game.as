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
		
		public function Game() {
			FlxG.debug = true;
			
			super(400, 325, MainMenuState, 2);
		}
		
	}
	
}
