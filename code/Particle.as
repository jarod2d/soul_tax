//
// Nabbed from Zombies like the Emitter class. A particle is a simple extension of a FlxSprite to add functionality for
// things like fading out over time.
// 
// Created by Jarod Long on 7/14/2011.
//

package {
	
	import org.flixel.*;
	
	public class Particle extends FlxSprite {
		
		// How long should this particle last?
		public var duration:Number;
		
		// How long has this particle been alive?
		public var time_alive:Number;
		
		// Should this particle fade out over time?
		public var fade:Boolean;
		
		// Constructor.
		public function Particle() {
			super();
			
			duration = 1.0;
			fade     = true;
			
			// Particles start off dead.
			kill();
		}
		
		// Launches the particle!
		public function launch(x:Number, y:Number, angle:Number, velocity:Number, drag:Number, gravity:Number, duration:Number, fade:Boolean):void {
			reset(x - origin.x, y - origin.y);
			
			var angle_sin:Number = Math.sin(angle);
			var angle_cos:Number = Math.cos(angle);
			
			this.velocity.x     = velocity * angle_cos;
			this.velocity.y     = velocity * angle_sin;
			this.drag.x         = Math.abs(drag * angle_cos);
			this.drag.y         = Math.abs(drag * angle_sin);
			this.acceleration.y = gravity;
			this.duration       = duration;
			this.fade           = fade;
			
			// Play the particle's animation if it exists.
			// TODO: Check if it exists so we don't get Flixel's console spamming.
//			play("particle", true);
		}
		
		// Need to reset some stuff when the particle is killed.
		override public function kill():void {
			super.kill();
			time_alive = 0.0;
		}
		
		// Update will manage fading, duration, etc.
		override public function update():void {
			super.update();
			
			// Update opacity.
			if (fade) {
				alpha = 1.0 - (time_alive / duration);
			}
			
			time_alive += FlxG.elapsed;
			
			// Kill particles when their time is up.
			if (time_alive >= duration) {
				kill();
			}
		}
	}
	
}
