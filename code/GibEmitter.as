//
// A little subclass of our Emitter class that makes it really convenient to create a bunch of nice gib effects.
// 
// Created by Jarod Long on 7/14/2011.
//

package {
	
	import org.flixel.*;
	
	public class GibEmitter extends Emitter {
		
		// Constructor. You can specify what color you want your gibs to be. By default they're blood-colored.
		public function GibEmitter(color:int = 0xFFCC0000, count:int = 125) {
			super();
			
			// Create all the particles.
			createParticles(count, [color], new Range(1, 3));
			
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
