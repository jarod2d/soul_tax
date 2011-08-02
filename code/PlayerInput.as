//
// A class to manage some basic aspects of user input. Currently we just use it to set up our keybind schemes.
// 
// Created by Jarod Long on 8/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class PlayerInput {
		
		// The different control schemes. Each object's properties should be general names that correspond to some game
		// function such as movement or attacking. Each value should be a string representing the key you want the
		// to be bound to (the same as if you were using FlxG.keys).
		public static const ESDFControlScheme:Object = {
			move_up:    "E",
			move_right: "F",
			move_down:  "D",
			move_left:  "S"
		};
		
		public static const WASDControlScheme:Object = {
			move_up:    "W",
			move_right: "D",
			move_down:  "S",
			move_left:  "A"
		};
		
		// The currently-selected control scheme.
		public var control_scheme:Object;
		
		// Constructor.
		public function PlayerInput() {
			// The default control scheme for winners is ESDF!
			control_scheme = PlayerInput.ESDFControlScheme;
		}
		
		// This function checks if a key is down, analogous to doing something like "FlxG.keys.E". The string you pass
		// in can either be the name of a keybind (for example, "move_up"), or a regular key string like "E".
		public function key(name:String):Boolean {
			return FlxG.keys[key_from_name(name)];
		}
		
		// Analogous to the above, but for the key being just pressed.
		public function justPressed(name:String):Boolean {
			return FlxG.keys.justPressed(key_from_name(name));
		}
		
		// Analogous to the above, but for the key being just released.
		public function justReleased(name:String):Boolean {
			return FlxG.keys.justReleased(key_from_name(name));
		}
		
		// A helper function that returns an actual key from a keybind name. If the keybind name doesn't exist, we
		// assume that the name is a key itself, and we just return what was passed in.
		private function key_from_name(name:String):String {
			if (control_scheme[name]) {
				return control_scheme[name];
			}
			
			return name;
		}
		
	}
	
}
