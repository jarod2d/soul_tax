//
// Another emitter, this time for smoke effects.
// 
// Created by Jarod Long on 7/27/2011.
//

package {
	
	import org.flixel.*;
	
	public class SmokeEmitter extends Emitter {
		
		// Constructor.
		public function SmokeEmitter() {
			super();
			
			// Create all the particles.
			createParticles(40, [0xEEDDDDDD], new Range(2, 4));
			
			// Set up the particle motion.
			angular_area.min = 15.0;
			angular_area.max = 165.0;
			velocity.min     = 35.0;
			velocity.max     = 65.0;
			drag.min         = 30.0;
			drag.max         = 40.0;
			gravity          = -150.0;
		}
		
		// Emits a bunch of gibs from the given NPC.
		public function spawnSmokeForNPC(npc:NPC):void {
			// Set our bounds to match the NPC's.
			setPosition(npc.x, npc.y);
			width  = npc.width;
			height = npc.height;
			
			emit(25, 1.75);
		}
		
	}
	
}
