//
// A little utility class with some useful string-related functions.
// 
// Created by Jarod Long on 7/19/2011.
//

package {
	
	import org.flixel.*;
	
	public class StringUtil {
		
		// "Cleans" a string, converting it from a typically human-based format to a more code-friendly format. Namely,
		// it downcases everything, strips out everything that's not alphanumeric, and replaces spaces with underscores.
		public static function clean(s:String):String {
			return s.toLowerCase().replace(/ /g, "_").replace(/\W/, "");
		}
		
	}
	
}
