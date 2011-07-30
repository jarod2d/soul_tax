//
// Another little subclass of our Emitter class, this time for the CEO's special attack. It shoots out some money (both
// coins and bills) in a vomit-like trajectory.
// 
// Created by Jarod Long on 7/21/2011.
//

package {
	
	import org.flixel.*;
	
	public class MoneyEmitter extends Emitter {
		
		// Our angular area depends on whether we're facing right or left.
		public var left_angular_area:Range;
		public var right_angular_area:Range;
		
		// Constructor.
		public function MoneyEmitter() {
			super();
			
			// Create all the particles. We want a nice distribution of coins and bills, so we create particles in
			// batches.
			for (var i:int = 0; i < 24; i++) {
				// Pennies and dimes.
				createParticles(MathUtil.randomInt(4) + 2, [0xFFC67A49, 0xFFAAAAAA], new Range(1, 1));
				
				// Nickels or quarters or whatever.
				createParticles(MathUtil.randomInt(2) + 1, [0xFFAAAAAA], new Range(2, 2));
				
				// Dollar bills.
				createParticles(MathUtil.randomInt(2) + 1, [0xFF528640], new Range(4, 4), new Range(2, 2));
			}
			
			// Set up the particle motion.
			left_angular_area  = new Range(160, 202.5);
			right_angular_area = new Range(-22.5, 20.0);
			velocity.min       = 200.0;
			velocity.max       = 250.0;
			drag.min           = 275.0;
			drag.max           = 350.0;
			width              = 0.0;
			height             = 2.0;
		}
		
		// Vomits a little bit of money from the given NPC. Meant to be called continuously while the NPC vomits.
		public function vomitFromNPC(npc:NPC):void {
			// Set our bounds to be in front of the NPC's face.
			setPosition((npc.facing === FlxObject.LEFT) ? npc.left + 3.0: npc.right - 3.0, npc.y + 4.0);
			
			// Set the angular area so it launches in the right direction.
			angular_area = (npc.facing === FlxObject.LEFT) ? left_angular_area : right_angular_area;
			
			emit(2, 1.75);
		}
		
	}
	
}
