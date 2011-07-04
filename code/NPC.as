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
		
		// The list of possible AI states. Their names should hopefully be self-documenting.
		public static const IdleState:int   = 0;
		public static const WanderState:int = 1;
		public static const FleeState:int   = 2;
		
		// The AI state of the NPC, which should correspond to one of the AI state constants above. Don't set this
		// directly -- use the getters and setters.
		public var $state:int;
		
		// How long, in seconds, the NPC has been in its current state, as well as how long the NPC should stay in the
		// current state. It is the responsibility of a particular state's AI methods to set and enforce the max
		// duration. This way untimed states can ignore the value.
		public var state_duration:Number;
		public var state_max_duration:Number;
		
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
			
			// Set the NPC's stats.
			hp            = properties.hp;
			strength      = properties.strength;
			jump_strength = properties.jump_strength;
			
			// Set the initial state.
			state = IdleState;
			
			// Load the player sprite.
			// TEMP: We're just using a default width and height for now.
			sprite.loadGraphic(properties.image, true, true, 4, 13);
			
			// TODO: Set up animations.
		}
		
		// Callback that occurs when the NPC's behavior changes to idle.
		public function startIdle():void {
			// Set the max duration.
			state_max_duration = 2.0 + Math.random() * 5.0;
			
			// Remove the NPC's velocity.
			velocity.x = 0.0;
		}
		
		// Callback that occurs when the NPC's behavior changes to wander.
		public function startWander():void {
			// Set the max duration.
			state_max_duration = 0.25 + Math.random() * 1.25;
			
			// Set a random velocity.
			velocity.x = 6.0 + Math.random() * 18.0;
			
			if (Math.random() < 0.5) {
				velocity.x *= -1;
			}
		}
		
		// Callback that occurs when the NPC's behavior changes to flee.
		public function startFlee():void {
			
		}
		
		// Runs the NPC's idle behavior.
		public function idle():void {
			// Just switch to wander behavior after a certain duration.
			if (state_duration > state_max_duration) {
				state = WanderState;
			}
		}
		
		// Runs the NPC's wander behavior.
		public function wander():void {
			// Switch back to idle behavior after a certain duration.
			if (state_duration > state_max_duration) {
				state = IdleState;
			}
		}
		
		// Runs the NPC's flee behavior.
		public function flee():void {
			// TODO
		}
		
		// Runs all of the NPC's AI. This just calls out to the AI method that corresponds to the NPC's current state.
		public function behave():void {
			switch (state) {
				case IdleState:   idle();   break;
				case WanderState: wander(); break;
				case FleeState:   flee();   break;
			}
		}
		
		// Update.
		override public function beforeUpdate():void {
			super.beforeUpdate();
			
			// Run the AI.
			behave();
			
			// Increment the state duration.
			state_duration += FlxG.elapsed;
		}
		
		// State getters and setters.
		public function get state():int {
			return $state;
		}
		
		public function set state(value:int):void {
			$state         = value;
			state_duration = state_max_duration = 0.0;
			
			switch (state) {
				case IdleState:   startIdle();   break;
				case WanderState: startWander(); break;
				case FleeState:   startFlee();   break;
			}
		}
		
		// NPCs are platforming entities.
		override public function get isPlatforming():Boolean {
			return true;
		}
		
	}
	
}
