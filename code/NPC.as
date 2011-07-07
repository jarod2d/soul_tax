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
				jump_strength: 3.75
			},
			
			"construction_worker": {
				image:         Assets.ConstructionWorkerSprite,
				hp:            100.0,
				strength:      35.0,
				jump_strength: 3.75
			}
		};
		
		// The list of possible AI states. Their names should hopefully be self-documenting.
		public static const IdleState:int      = 0;
		public static const WanderState:int    = 1;
		public static const FleeState:int      = 2;
		public static const PossessedState:int = 3;
		public static const StunnedState:int   = 4;
		
		// Multipliers for the NPC's speed in various states.
		public static const WanderSpeedFactor:Number = 0.25;
		public static const FleeSpeedFactor:Number   = 1.0;
		
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
		
		// How high can the NPC jump? Supposed to be measured in tiles -- so a value of 4.0 would allow the NPC to jump
		// just barely high enough to reach a ledge 4 tiles above. In reality it doesn't quite work that way, so just
		// experiment until you get the value you want.
		public var jump_strength:Number;
		
		// Constructor. The id should be a string that corresponds to one of the keys in the types object above.
		public function NPC(id:String, x:Number, y:Number) {
			super(x, y);
			
			var properties:Object = NPC.types[id];
			
			// Set the NPC's stats.
			hp            = properties.hp;
			strength      = properties.strength;
			jump_strength = properties.jump_strength;
			
			// Set up movement.
			// TODO: Grab speed stats from the NPC stat data.
			max_velocity   = new FlxPoint(90.0, 450.0);
			drag           = new FlxPoint(450.0, 450.0);
			acceleration.y = 600.0;
			
			// Set the initial state.
			state = IdleState;
			
			// Load the player sprite.
			// TEMP: We're just using a default width and height for now.
			sprite.loadGraphic(properties.image, true, true, 4, 13);
			
			// TODO: Set up animations.
		}
		
		// Makes the NPC jump. The height of the jump is relative to their jump_strength stat. You can pass in a
		// multiplier to increase or decrease the relative height of the jump. A value of 1.0 will make the NPC jump at
		// their intended maximum jump height. 
		public function jump(power:Number = 1.0):void {
			if (sprite.isTouching(FlxObject.DOWN)) {
				velocity.y = jump_strength * power * -60.0;
			}
		}
		
		// Callback that occurs when the NPC's behavior changes to idle.
		protected function startIdle():void {
			// Set the max duration.
			state_max_duration = 2.5 + Math.random() * 8.0;
		}
		
		// Callback that occurs when the NPC's behavior changes to wander.
		protected function startWander():void {
			// Set the max duration.
			state_max_duration = 0.5 + Math.random() * 2.25;
			
			// Most of the time we'll just wander on our current platform. But sometimes we'll do a more complicated
			// traversal to another platform. Eventually anyways.
//			if (Math.random() < 0.8) {
				moveOnCurrentPlatform();
//			}
//			else {
//				// TODO: Implement me!
//			}
		}
		
		// Callback that occurs when the NPC's behavior changes to flee.
		protected function startFlee():void {
			// TODO: Implement me!
		}
		
		// Callback that occurs when the NPC enters the possessed state.
		protected function startBePossessed():void {
			// TODO: Implement me!
		}
		
		// Callback that occurs when the NPC enters the stunned state.
		protected function startBeStunned():void {
			// Set the max duration.
			state_max_duration = 0.25;
			
			// Stop the NPC from moving.
			// TODO: It would be nice if we could retain movement if we're currently in the air, so that when the player
			// stops possessing the NPC mid-jump, they continue their trajectory.
			acceleration.x = 0.0;
			
			// TODO: Play some sort of stunned animation.
		}
		
		// Runs the NPC's idle behavior.
		protected function idle():void {
			// Just switch to wander behavior after a certain duration.
			if (state_duration > state_max_duration) {
				state = WanderState;
			}
		}
		
		// Runs the NPC's wander behavior.
		protected function wander():void {
			// Switch back to idle behavior after a certain duration.
			if (state_duration > state_max_duration) {
				state = IdleState;
			}
		}
		
		// Runs the NPC's flee behavior.
		protected function flee():void {
			// TODO: Implement me!
		}
		
		// Runs the NPC's possessed behavior.
		protected function bePossessed():void {
			// We don't really do anything here yet.
		}
		
		// Runs the NPC's stunned behavior.
		protected function beStunned():void {
			// Switch back to idle behavior after a certain duration.
			if (state_duration > state_max_duration) {
				state = IdleState;
			}
		}
		
		// Runs all of the NPC's AI. This just calls out to the AI method that corresponds to the NPC's current state.
		protected function behave():void {
			switch (state) {
				case IdleState:      idle();        break;
				case WanderState:    wander();      break;
				case FleeState:      flee();        break;
				case PossessedState: bePossessed(); break;
				case StunnedState:   beStunned();   break;
			}
		}
		
		// Update.
		override public function beforeUpdate():void {
			super.beforeUpdate();
			
			// We don't do anything if we're being possessed.
			if (state !== PossessedState) {
				// Run the AI.
				behave();
				
				// For some reason Flixel makes us explicitly tell sprites to stop following their path when they're
				// done.
				if (sprite.pathSpeed == 0.0) {
					sprite.stopFollowingPath(true);
					velocity.x = 0.0;
				}
			}
			
			// Increment the state duration.
			state_duration += FlxG.elapsed;
		}
		
		// Returns how far the NPC can walk in the given direction (use -1 for left, 1 for right) without falling in a
		// pit or being blocked by an obstacle. You can pass in a maximum distance you'd like returned, so that the
		// algorithm will stop searching for a path at that distance.
		// 
		// Note that this algorithm makes some assumptions about the layout of the level. In particular, the NPC cannot
		// be standing on a platform that has a walkable path all the way to the edge of a level. Given the nature of
		// our game, this should never be the case anyways.
		private function walkableDistance(direction:int, max:int = 0):int {
			var level:Level      = Game.level;
			var tiles:FlxTilemap = level.wall_tiles;
			
			// We scan the tiles in the given direction, three at a time. We check the platform tiles (the row of tiles
			// immediately beneath the NPC) to make sure they are solid, and we check the two tiles above that to make
			// sure nothing's blocking our path.
			var distance:int    = 0;
			var tile_below:int  = this.tile_below + direction;
			var path_tile_1:int = tile_below - level.t_width;
			var path_tile_2:int = path_tile_1 - level.t_width;
			
			while (tiles.getTileByIndex(tile_below) > 1 && tiles.getTileByIndex(path_tile_1) <= 1 && tiles.getTileByIndex(path_tile_2) <= 1 && (distance < max || max === 0)) {
				distance++;
				tile_below  += direction;
				path_tile_1 += direction;
				path_tile_2 += direction;
			}
			
			return distance;
		}
		
		// An AI helper function that makes the NPC walk a random short distance in a random direction on their current
		// platform. If the NPC isn't currently on a platform or they're unable to move in either direction, they won't
		// do anything. They won't fall down pits or jump onto new platforms.
		private function moveOnCurrentPlatform():void {
			// Make sure we're actually standing on a platform.
			if (!sprite.isTouching(FlxObject.DOWN)) {
				return;
			}
			
			// Randomly select a preferred direction to embark in.
			var direction:int = (Math.random() < 0.5) ? 1 : -1;
			
			// See how far we can go in the chosen direction.
			var walkable_distance:int = walkableDistance(direction, 8);
			
			// If we can't go anywhere in that direction, let's try the other direction instead.
			if (walkable_distance === 0) {
				direction *= -1;
				walkable_distance = walkableDistance(direction, 8);
			}
			
			// If we can walk some distance, let's do it.
			if (walkable_distance > 0) {
				var actual_distance:int = (1 + (walkable_distance - 1) * Math.random()) * direction;
				var path:FlxPath        = Game.level.wall_tiles.findPath(center, new FlxPoint(center.x + actual_distance * Level.TileSize, center.y));
				
				if (path) {
					// TODO: Set speed based on the NPC's speed.
					sprite.followPath(path, 30.0, FlxObject.PATH_HORIZONTAL_ONLY | FlxObject.PATH_FORWARD);
					
					// Set the NPC's facing based on the direction.
					facing = (direction === 1) ? FlxObject.RIGHT : FlxObject.LEFT;
				}
			}
		}
		
		// State getters and setters.
		public function get state():int {
			return $state;
		}
		
		public function set state(value:int):void {
			$state         = value;
			state_duration = state_max_duration = 0.0;
			
			switch (state) {
				case IdleState:      startIdle();        break;
				case WanderState:    startWander();      break;
				case FleeState:      startFlee();        break;
				case PossessedState: startBePossessed(); break;
				case StunnedState:   startBeStunned();   break;
			}
		}
		
	}
	
}
