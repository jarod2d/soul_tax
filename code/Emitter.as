//
// Nabbed this from Zombies. We've rolled our own Emitter class instead of using FlxEmitter because FlxEmitter doesn't
// work the way we want it to. Currently it only supports emitting things in "bursts", as opposed to emitting particles
// constantly.
//
// Aside from improved functionality and usability in general, the main difference between this and FlxEmitter is that
// Emitter emits particles based on an angular area rather than ranges of X and Y velocities. Emitter will launch each
// particle from some point within its area at an angle that is within angular_area. This makes it much easier to create
// conal particle effects.
// 
// Created by Jarod Long on 7/14/2011.
//

package {
	
	import org.flixel.*;
	
	public class Emitter {
		
		// The group containing the particles.
		public var particles:FlxGroup;
		
		// The size and position of the emitter.
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		// These properties affect the way particles are emitted.
		public var velocity:Range;
		public var drag:Range;
		public var torque:Range;
		public var angular_area:Range;
		public var gravity:Number;
		
		// Holds the index of the next particle we should emit.
		private var next_index:uint;
		
		// Constructor.
		public function Emitter(x:Number = 0.0, y:Number = 0.0, width:Number = 0.0, height:Number = 0.0) {
			particles = new FlxGroup();
			
			this.x      = x;
			this.y      = y;
			this.width  = width;
			this.height = height;
			
			velocity     = new Range(50.0, 150.0);
			drag         = new Range(20.0, 25.0);
			torque       = new Range(0.0, 0.0);
			angular_area = new Range(0.0, 360.0);
			gravity      = 400.0;
			
			next_index = 0;
		}
		
		// Add a particle to the emitter.
		public function add(particle:Particle):void {
			particles.add(particle);
		}
		
		// Creates the given number of particles as simple colored squares.
		public function createParticles(count:uint, colors:Array, width:Range, height:Range = null):void {
			var particle:Particle;
			
			// If there is no height specified, then we assume the size to be square.
			if (!height) {
				height = width;
			}
			
			for (var i:uint = 0; i < count; i++) {
				particle = new Particle();
				particle.makeGraphic(width.random(), height.random(), colors[MathUtil.randomInt(colors.length)]);
				add(particle);
			}
		}
		
		// Loads the given number of particles with the provided graphic, which can optionally be animated. If the
		// frames array is passed in, the particles will be animated.
		public function loadParticles(graphic:Class, count:uint, frames:Array = null, width:uint = 0, height:uint = 0, speed:Number = 30):void {
			var particle:Particle;
			
			for (var i:uint = 0; i < count; i++) {
				particle = new Particle();
				particle.loadGraphic(graphic, (frames !== null), false, width, height);
				
				if (frames) {
					particle.addAnimation("particle", frames, speed);
					particle.addAnimationCallback(function(name:String, index:uint, frame:uint):void {
						if (index == frames.length - 1) {
							this.kill();
						}
					});
				}
				
				add(particle);
			}
		}
		
		// Emits the given number of particles all at once.
		public function emit(count:uint = 1, duration:Number = 1.0, fade:Boolean = true):void {
			for (var i:uint = 0; i < count; i++) {
				var particle:Particle = particles.members[next_index] as Particle;
				
				// Launch the particle!
				var angle:Number = angular_area.random() * MathUtil.DEGREE_TO_RADIAN_CONSTANT;
				particle.launch(x, y, angle, velocity.random(), drag.random(), gravity, duration, fade);
				
				// Increment the particle counter.
				next_index = (next_index + 1) % particle_count;
			}
		}
		
		// Convenience function to set the position of the emitter.
		public function setPosition(x:Number, y:Number):void {
			this.x = x, this.y = y;
		}
		
		// Getter for the total number of particles.
		public function get particle_count():uint {
			return particles.length;
		}
		
	}
	
}
