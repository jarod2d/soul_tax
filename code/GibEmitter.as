//
// A little subclass of our Emitter class that makes it really convenient to create a bunch of nice gib effects.
// 
// Created by Jarod Long on 7/14/2011.
//

package {
	
	import org.flixel.*;
	
	public class GibEmitter extends Emitter {
		
		// Constructor.
		public function GibEmitter() {
			super();
			
			// Create all the particles.
			// TODO: We should throw in some gibs of different sizes and colors (get some flesh-colored gibs in there,
			// etc).
			createParticles(125, [0xFFCC0000], new Range(1, 3));
			
			// Set up the particle motion.
			velocity.min = 75.0;
			velocity.max = 190.0;
			drag.min     = 140.0;
			drag.max     = 180.0;
		}
		
		// Emits a bunch of gibs from the given NPC.
		public function spawnGibsForNPC(npc:NPC):void {
			// Set our bounds to match the NPC's.
			setPosition(npc.x, npc.y);
			width  = npc.width;
			height = npc.height;
			
			emit(25, 1.6);
		}
		
	}
	
}
