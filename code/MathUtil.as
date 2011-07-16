//
// A little utility class with some useful math-related functions.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class MathUtil {
		
		// Handy constant for speeding up normalization of vectors whose x and y values both have a magnitude of 1.0.
		public static const VECTOR_NORMALIZATION_CONSTANT:Number = 0.7071067811865475;
		
		// More handy constants for converting between radians and degrees.
		public static const RADIAN_TO_DEGREE_CONSTANT:Number = 57.29577951308232;
		public static const DEGREE_TO_RADIAN_CONSTANT:Number = 0.017453292519943295;
		
		// Normalizes a 2D vector in-place.
		public static function normalize(v:FlxPoint):void {
			if (Math.abs(v.x) == 1.0 && Math.abs(v.y) == 1.0) {
				v.x *= VECTOR_NORMALIZATION_CONSTANT;
				v.y *= VECTOR_NORMALIZATION_CONSTANT;
			}
			else {
				var magnitude:Number = vectorLength(v);
				
				if (magnitude != 0) {
					v.x /= magnitude;
					v.y /= magnitude;
				}
			}
		}
		
		// Returns the length of a vector.
		public static function vectorLength(v:FlxPoint):Number {
			return Math.sqrt(vectorLengthSquared(v));
		}
		
		// Returns the length of a vector, squared. Much faster to use this to compare vector lengths, since we forgo
		// the expensive square root calculation.
		public static function vectorLengthSquared(v:FlxPoint):Number {
			return v.x * v.x + v.y * v.y;
		}
		
		// This version of round allows the user to specify the precision of the rounding. A precision of 0 will round
		// to the nearest integer like normal. A precision of 1 will round to the tenths place, and a precision of -1
		// will round to the tens place.
		public static function round(n:Number, precision:int = 0):Number {
			var m:Number = Math.pow(10, precision);
			return Math.round(n * m) / m;
		}
		
		// Clamps a number within a range.
		public static function clamp(n:Number, min:Number, max:Number):Number {
			if (n < min) {
				return min;
			}
			else if (n > max) {
				return max;
			}
			
			return n;
		}
		
		// Increments a number with a cap.
		public static function incrementAndCap(n:Number, amount:Number, max:Number):Number {
			return (n + amount >= max) ? max : n + amount;
		}
		
		// Decrements a number with a cap.
		public static function decrementAndCap(n:Number, amount:Number, min:Number):Number {
			return (n - amount <= min) ? min : n - amount;
		}
		
		// Causes a number to gradually move towards zero.
		public static function decelerate(n:Number, amount:Number):Number {
			if (n - amount > 0.0) {
				n -= amount;
			}
			else if (n + amount < 0.0) {
				n += amount;
			}
			else {
				n = 0.0;
			}
			
			return n;
		}
		
		// Returns a random integer from 0 (inclusive) to n (exclusive).
		public static function randomInt(n:uint):uint {
			return Math.floor(Math.random() * n);
		}
		
		// Returns the next integer above n. This is different from Math.ceil in that if n is an integer, it is still
		// incremented.
		public static function nextInt(n:Number):int {
			if (n == int(n)) {
				return n + 1;
			}
			
			return Math.ceil(n);
		}
		
		// Returns the previous integer before n. This is different from Math.floor in that if n is an integer, it is
		// still decremented.
		public static function prevInt(n:Number):int {
			if (n == int(n)) {
				return n - 1;
			}
			
			return Math.floor(n);
		}
		
		// Performs a modulo on the given numbers, but differs from the standard modulo operator in that it allows you
		// to take the modulo of a negative number.
		public static function mod(divisor:int, dividend:int):int {
			// TODO: Could do this more efficiently, but so lazy...
			while (divisor < 0) {
				divisor += dividend;
			}
			
			return divisor % dividend;
		}
		
		// Rotates a point around a pivot point around the given angle (in degrees, since Flixel likes to use degrees).
		// Rotates clockwise by default -- pass in true for reverse to rotate counter-clockwise.
		public static function rotatePoint(p:FlxPoint, pivot:FlxPoint, angle:Number, reverse:Boolean = false):FlxPoint {
			var result:FlxPoint = new FlxPoint(p.x, p.y);
			
			angle *= reverse ? DEGREE_TO_RADIAN_CONSTANT : -DEGREE_TO_RADIAN_CONSTANT;
			var angle_sin:Number = Math.sin(angle);
			var angle_cos:Number = Math.cos(angle);
			
			result.x = (p.x - pivot.x) * angle_cos - (p.y - pivot.y) * angle_sin + pivot.x;
			result.y = (p.x - pivot.x) * angle_sin + (p.y - pivot.y) * angle_cos + pivot.y;
			
			return result;
		}
		
		// Formats a number into a string, accounting for decimal places.
		public static function formatNumber(n:Number, decimal_places:uint = 0, trailing_zeroes:Boolean = false):String {
			var power:uint    = Math.pow(10, decimal_places);
			var result:String = String(Math.round(n * power) / power);
			
			if (trailing_zeroes) {
				var decimals:uint = result.length - (result.indexOf(".") + 1);
				
				for (var i:uint = 0; i < decimal_places - decimals; i++) {
					result += "0";
				}
			}
			
			return result;
		}
		
		// Little convenience function that returns a numerical direction based on a FlxSprite direction.
		public static function facingToPoint(facing:uint):FlxPoint {
			switch (facing) {
				case FlxObject.UP:    return new FlxPoint(0, -1);
				case FlxObject.RIGHT: return new FlxPoint(1,  0);
				case FlxObject.DOWN:  return new FlxPoint(0,  1);
				case FlxObject.LEFT:  return new FlxPoint(-1, 0);
			}
			
			return new FlxPoint(0, 0);
		}
		
	}
	
}
