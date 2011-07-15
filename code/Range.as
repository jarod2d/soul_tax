//
// A simple utility class that defines a range of values.
// 
// Created by Jarod Long on 7/14/2011.
//

package {
	
	public class Range {
		
		public var min:Number;
		public var max:Number;
		
		// Constructor.
		public function Range(min:Number = 0.0, max:Number = 0.0) {
			this.min = min;
			this.max = max;
		}
		
		// Convenient way of setting the range in one call.
		public function setRange(min:Number, max:Number):void {
			this.min = min;
			this.max = max;
		}
		
		// Returns whether the given value is within the range (inclusive).
		public function contains(n:Number):Boolean {
			return (n >= min && n <= max);
		}
		
		// Returns the...range of the range -- i.e., the range of (-10, 10) would be 20.
		public function range():Number {
			return max - min;
		}
		
		// Returns a random value from within the range (inclusive).
		public function random():Number {
			return min + Math.random() * range();
		}
		
		// To string.
		public function toString():String {
			return "Range: (" + min + ", " + max + ")";
		}
		
	}
	
}
