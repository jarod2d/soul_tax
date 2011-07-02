//
// The obligatory preloader subclass.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	import org.flixel.system.*;
	
	public class Preloader extends FlxPreloader {
		
		public function Preloader() {
			className = "Game";
			super();
		}
		
	}
	
}
