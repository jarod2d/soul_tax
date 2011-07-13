//
// A generic UI widget that represents a meter. It strictly adheres to the MVC paradigm in that it doesn't store its
// value directly. Instead, it stores a reference to a model from which to grab the value directly. This way, the value
// is automatically updated as the model value changes.
// 
// The meter is animated by default, and at the moment this is not configurable. Whenever you model's value changes, it
// will animate to the new value over time.
// 
// Created by Jarod Long on 7/10/2011.
//

package {
	
	import org.flixel.*;
	
	public class Meter extends FlxGroup {
		
		// The size of the meter's borders.
		private static const BorderSize:Number = 1.0;
		
		// The amount of time it takes to animate to a new meter value, in seconds.
		private static const AnimationTime:Number = 1.0;
		
		// The models that supply the meter's value and max value, along with the names of the properties on those
		// models that provide the value and max value.
		public var value_model:Object;
		public var value_property:String;
		public var max_value_model:Object;
		public var max_value_property:String;
		
		// The color of the meter.
		private var color:int;
		
		// The various components of the meter.
		private var background:FlxSprite;
		private var empty_fill:FlxSprite;
		private var fill:FlxSprite;
		
		// The size of the meter. For simplicity, at the moment the meter size is immutable after creation.
		private var width:Number;
		private var height:Number;
		
		// We keep track of the old value of the meter so that we know when the value has changed.
		private var old_value:Number;
		
		// Some values to help with animation. The animation stage is a value from 0 to 1 that tells us where we are
		// within the current animation. 0 means we just started, 1 means we're done, and 0.5 means we're halfway done.
		// The animation start and end are the values that we're animating from and to.
		private var animation_stage:Number;
		private var animation_start:Number;
		private var animation_end:Number;
		
		// Constructor.
		public function Meter(value_model:Object, value_property:String, max_value_model:Object, max_value_property:String,
							  x:Number = 0.0, y:Number = 0.0, width:Number = 80.0, height:Number = 8.0, color:int = 0xCC1111) {
			super();
			
			// Set the values.
			this.value_model        = value_model;
			this.value_property     = value_property;
			this.max_value_model    = max_value_model;
			this.max_value_property = max_value_property;
			this.color              = color;
			this.width              = width;
			this.height             = height;
			animation_stage         = 1.0;
			animation_start         = value;
			animation_end           = value;
			old_value               = value;
			
			// Create the components.
			background = new FlxSprite(x, y);
			background.makeGraphic(width + BorderSize * 2, height + BorderSize * 2, 0xDD222222);
			background.scrollFactor.x = background.scrollFactor.y = 0.0;
			
			empty_fill = new FlxSprite(x + BorderSize, y + BorderSize);
			empty_fill.makeGraphic(width, height, color);
			empty_fill.alpha = 0.33;
			empty_fill.scrollFactor.x = empty_fill.scrollFactor.y = 0.0;
			
			fill = new FlxSprite(x + BorderSize, y + BorderSize);
			fill.alpha = 0.0;
			fill.scrollFactor.x = fill.scrollFactor.y = 0.0;
			
			// Add everything.
			add(background);
			add(empty_fill);
			add(fill);
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// If the value has changed, we need to start a new animation.
			if (value !== old_value) {
				animation_start = animated_value;
				animation_end   = value;
				animation_stage = 0.0;
			}
			
			// Update the meter fill if necessary.
			if (animation_stage < 1.0) {
				var fill_width:Number = Math.round(width * Math.min(animated_value, max_value) / max_value);
				
				if (fill_width > 0.0) {
					fill.alpha = 1.0;
					fill.makeGraphic(fill_width, height, color);
				}
				else {
					fill.alpha = 0.0;
				}
			}
			
			// Update the animation.
			animation_stage = Math.min(1.0, animation_stage + FlxG.elapsed / AnimationTime);
			
			// Remember the current value.
			old_value = value;
		}
		
		// Getters for the value.
		public function get value():Number {
			return value_model[value_property];
		}
		
		public function get max_value():Number {
			return max_value_model[max_value_property];
		}
		
		public function get animated_value():Number {
			return animation_start + (animation_end - animation_start) * (-(Math.cos(animation_stage * Math.PI) / 2.0) + 0.5);
		}
		
		// Some getters for position data.
		public function get x():Number {
			return background.x;
		}
		
		public function get y():Number {
			return background.y;
		}
		
		public function get center():FlxPoint {
			return new FlxPoint(background.x + background.width / 2.0, background.y + background.height / 2.0);
		}
		
	}
	
}
