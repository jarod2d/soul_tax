//
// The NPC class. Represents, unsurprisingly, an NPC.
// 
// Created by Jarod Long on 7/2/2011.
//

package {
	
	import org.flixel.*;
	
	public class NPC extends Entity {
		
		// The master list of all NPC types. The keys need to match up with the values for each prop given in Flevel.
		public static var types:Object = {
			"office_worker": {
				image:         Assets.OfficeWorkerSprite,
				hp:            100.0,
				strength:      35.0,
				jump_strength: 4.25
			},
			
			"construction_worker": {
				image:         Assets.ConstructionWorkerSprite,
				hp:            100.0,
				strength:      35.0,
				jump_strength: 4.25
			}
		};
		
		// How much health does the NPC have?
		public var hp:Number;
		
		// How hard does the NPC hit? When an NPC attacks, this value is the amount of damage that will be done. No
		// complex formulas here.
		public var strength:Number;
		
		// How high can the NPC jump? Measured in tiles -- so a value of 4.0 would allow the NPC to jump just barely
		// high enough to reach a ledge 4 tiles above.
		public var jump_strength:Number;
		
		// Constructor. The id should be a string that corresponds to one of the keys in the types object above.
		public function NPC(id:String, x:Number, y:Number) {
			super(x, y);
			
			var properties:Object = NPC.types[id];
			
			FlxG.log(properties);
			FlxG.log(id);
			
			// Set the NPC's stats.
			hp            = properties.hp;
			strength      = properties.strength;
			jump_strength = properties.jump_strength;
			
			// Load the player sprite.
			// TEMP: We're just using a default width and height for now.
			sprite.loadGraphic(properties.image, true, true, 4, 13);
			
			// TODO: Set up animations.
		}
		
	}
	
}
