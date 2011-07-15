//
// This utility class contains useful color manipulation functions. RGBA colors are represented as plain Objects with
// properties "r", "b", "g", and "a".
// 
// Created by Jarod Long on 7/14/2011.
//

package p_util {
	
	public class ColorUtil {
		
		// Arithmetic types.
		private static const ADD:uint      = 0;
		private static const SUBTRACT:uint = 1;
		private static const MULTIPLY:uint = 2;
		private static const DIVIDE:uint   = 3;
		
		// Converts a set of RGBA values to a uint.
		public static function valuesToInt(r:uint, g:uint, b:uint, a:uint = 255):uint {
			return (a << 24) | (r << 16) | (g << 8) | b;
		}
		
		// Converts an RGBA object to a uint.
		public static function RGBAToInt(color:Object):uint {
			return valuesToInt(color.r, color.g, color.b, color.a);
		}
		
		// Converts a uint color to an RGBA object.
		public static function intToRGBA(color:uint):Object {
			return {
				r: (color >> 16) & 0xFF,
				g: (color >> 8)  & 0xFF,
				b: (color >> 0)  & 0xFF,
				a: (color >> 24) & 0xFF
			};
		}
		
		// Converts a uint color to an array. Mostly intended to be used internally, but can be used
		// externally if you need it for some reason.
		public static function intToArray(color:uint):Array {
			return [
				(color >> 16) & 0xFF,
				(color >> 8)  & 0xFF,
				(color >> 0)  & 0xFF,
				(color >> 24) & 0xFF
			];
		}
		
		// Adds two colors, capping each component appropriately.
		public static function add(color1:uint, color2:uint):uint {
			return arithmetic(ADD, color1, color2);
		}
		
		// Subtracts two colors, capping each component appropriately.
		public static function subtract(color1:uint, color2:uint):uint {
			return arithmetic(SUBTRACT, color1, color2);
		}
		
		// Multiplies two colors, capping each component appropriately.
		public static function multiply(color1:uint, color2:uint):uint {
			return arithmetic(MULTIPLY, color1, color2);
		}
		
		// Divides two colors, capping each component appropriately.
		public static function divide(color1:uint, color2:uint):uint {
			return arithmetic(DIVIDE, color1, color2);
		}
		
		// Does the actual arithmetic for add, subtract, etc.
		private static function arithmetic(type:uint, color1:uint, color2:uint):uint {
			var result:Array = [0, 0, 0, 0];
			var rgba1:Array  = intToArray(color1);
			var rgba2:Array  = intToArray(color2);
			
			for (var i:uint = 0; i < 4; i++) {
				switch (type) {
					case ADD:      result[i] = MathUtil.clamp(rgba1[i] + rgba2[i], 0, 255); break;
					case SUBTRACT: result[i] = MathUtil.clamp(rgba1[i] - rgba2[i], 0, 255); break;
					case MULTIPLY: result[i] = MathUtil.clamp(rgba1[i] * rgba2[i], 0, 255); break;
					case DIVIDE:   result[i] = MathUtil.clamp(Math.round(rgba1[i] / rgba2[i]), 0, 255); break;
				}
			}
			
			return valuesToInt(result[0], result[1], result[2], result[3]);
		}
		
	}
	
}
