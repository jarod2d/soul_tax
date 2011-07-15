//
// A simple class that represents a value that is clamped to a certain range.
// 
// Created by Jarod Long on 7/14/2011.
//

package {
	
	public class RangedValue extends Range {
		
		private var $value:Number;
		
		// Constructor.
		public function RangedValue(value:Number = 0.0, min:Number = 0.0, max:Number = 0.0) {
			super(min, max);
			value = value;
		}
		
		// To string.
		override public function toString():String {
			return "Ranged Value: " + value + "(between " + min + " and " + max + ")";
		}
		
		// Getters and setters for the value.
		public function get value():Number {
			return $value;
		}
		
		public function set value(value:Number):void {
			$value = MathUtil.clamp(value, min, max);
		}
		
		// Getter for the position of the value -- a value between 0.0 and 1.0 based on the value's
		// position between the min and max.
		public function get position():Number {
			return (value - min) / (max - min);
		}
		
	}
	
}
