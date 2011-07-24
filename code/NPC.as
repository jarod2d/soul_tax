//
// The NPC class. Represents, unsurprisingly, an NPC.
// 
// Created by Jarod Long on 7/2/2011.
//

package {
	
	import org.flixel.*;
	
	public class NPC extends Entity {
		
		// The master list of all NPC types. The keys need to match up with the values for each prop given in Flevel.
		public static var types:Object;
		
		// The list of possible AI states. Their names should hopefully be self-documenting.
		public static const IdleState:int      = 0;
		public static const WanderState:int    = 1;
		public static const FleeState:int      = 2;
		public static const ChaseState:int     = 3;
		public static const PossessedState:int = 4;
		public static const StunnedState:int   = 5;
		
		// Multipliers for the NPC's speed in various states.
		public static const WanderSpeedFactor:Number = 0.25;
		public static const FleeSpeedFactor:Number   = 1.0;
		
		// How long the NPC should flash when they get hurt.
		public static const HurtFlashTime:Number = 0.14;
		
		// The velocity threshold after which the NPC will take damage when colliding with something.
		public static const ContactDamageThreshold:Number = 280.0;
		public static const GlassBreakThreshold:Number    = 150.0;
		
		// Some NPC tinting colors.
		public static const PossessionColor:uint = 0xFFCCEE;
		public static const HurtColor:uint       = 0xEE3333;
		
		// Each NPC stores a reference to their type configuration object.
		public var type:Object;
		
		// The AI state of the NPC, which should correspond to one of the AI state constants above. Don't set this
		// directly -- use the getters and setters.
		public var $state:int;
		
		// How long, in seconds, the NPC has been in its current state, as well as how long the NPC should stay in the
		// current state. It is the responsibility of a particular state's AI methods to set and enforce the max
		// duration. This way untimed states can ignore the value.
		public var state_duration:Number;
		public var state_max_duration:Number;
		
		// Keeps track of the NPC's special attack cooldown.
		public var special_cooldown:Number;
		
		// How much health does the NPC have?
		public var hp:Number;
		
		// How hard does the NPC hit? When an NPC attacks, this value is the amount of damage that will be done. No
		// complex formulas here.
		public var strength:Number;
		
		// How high can the NPC jump? Supposed to be measured in tiles -- so a value of 4.0 would allow the NPC to jump
		// just barely high enough to reach a ledge 4 tiles above. In reality it doesn't quite work that way, so just
		// experiment until you get the value you want.
		public var jump_strength:Number;
		
		// A multiplier for how fast the NPC should attack. 1.0 will give you default attacking speed, < 1.0 attacks
		// faster, > 1.0 attacks slower.
		public var attack_speed:Number;
		
		// A multiplier for how fast the NPC can run. 1.0 gives you default run speed, < 1.0 runs slower, > 1.0 runs
		// faster.
		public var run_speed:Number;
		
		// NPCs need to store their knockback velocity separately from their regular velocity. Just set the x and y
		// values to get knockback behavior.
		public var knockback_velocity:FlxPoint;
		
		// A flag for whether or not the NPC is currently in the process of using their special attack. This helps us
		// out with cooldowns.
		public var using_special:Boolean;
		
		// The target sprite that the NPC is chasing when he's in the chase state.
		public var chase_target:FlxSprite;
		
		// Flixel has a rather poorly-designed collision callback system that doesn't provide information about the
		// objects' changes in velocity. We need that information, so each NPC stores their pre-collision velocity here.
		private var old_velocity:FlxPoint;
		
		// A timer that gets set whenever the NPC gets hurt, used for tinting the NPC and fading it out over time.
		private var flash_timer:Number;
		
		// Constructor. The id should be a string that corresponds to one of the keys in npcs.json.
		public function NPC(id:String, x:Number, y:Number) {
			super(x, y);
			
			// Grab the type data.
			type = NPC.types[id];
			
			// Set up animations.
			for each (var animation:Object in type.animations) {
				sprite.addAnimation(animation.name, animation.frames, animation.speed, animation.looped);
			}
			
			// Set the NPC's stats.
			hp            = type.hp;
			strength      = type.strength;
			jump_strength = type.jump_strength;
			attack_speed  = type.attack_speed;
			run_speed     = type.run_speed;
			
			// Set up movement.
			// TODO: Grab speed stats from the NPC stat data.
			max_velocity       = new FlxPoint(90.0 * run_speed, 480.0);
			drag               = new FlxPoint(450.0 * run_speed, 450.0);
			acceleration.y     = 615.0;
			knockback_velocity = new FlxPoint();
			old_velocity       = new FlxPoint();
			
			// Set the initial state.
			state = IdleState;
			
			// Load the player sprite.
			sprite.loadGraphic(Assets[type.id + "_sprite"], true, true, type.frame_width, type.frame_height);
			
			// Set bounds and offset.
			sprite.width    = type.bounds_width;
			sprite.height   = type.bounds_height;
			sprite.offset.x = type.offset.x;
			sprite.offset.y = type.offset.y;
			
			// Set up timers and flags.
			special_cooldown = flash_timer = 0.0;
			using_special    = false;
		}
		
		// A callback that occurs when an NPC collides with anything, to be used in calculating collision damage,
		// diminishing knockback velocity, etc.
		public static function processCollision(npc_sprite:EntitySprite, obstacle:FlxObject):void {
			var npc:NPC = npc_sprite.entity as NPC;
			
			// Grab the change in the NPC's velocity.
			var velocity_change:FlxPoint = new FlxPoint(Math.abs(npc.velocity.x - npc.old_velocity.x), Math.abs(npc.velocity.y - npc.old_velocity.y));
			
			// We need to diminish the NPC's knockback velocity.
			if (npc.knockback_velocity.x !== 0.0 || npc.knockback_velocity.y !== 0.0) {
				var diminish:FlxPoint = new FlxPoint();
				
				if (npc.old_velocity.x !== 0.0) {
					diminish.x = MathUtil.clamp(Math.abs(velocity_change.x / npc.old_velocity.x), 0.0, 1.0) * npc.knockback_velocity.x;
				}
				
				if (npc.old_velocity.y !== 0.0) {
					diminish.y = MathUtil.clamp(Math.abs(velocity_change.y / npc.old_velocity.y), 0.0, 1.0) * npc.knockback_velocity.y;
				}
				
				// Apply the diminish.
				npc.knockback_velocity.x -= diminish.x;
				npc.knockback_velocity.y -= diminish.y;
				
				// The velocity change needs to account for the diminish as well. We use a multiplier to balance how
				// much knockback velocity contributes to collision damage.
				velocity_change.x += Math.abs(diminish.x) * 0.55;
				velocity_change.y += Math.abs(diminish.y) * 0.3;
			}
			
			// Calculate the NPC's impact force to determine how much damage should be done.
			var base_impact:Number   = MathUtil.vectorLength(velocity_change);
			var damage_impact:Number = (base_impact - ContactDamageThreshold) * 0.95;
			var glass_impact:Number  = (base_impact - GlassBreakThreshold);
			
			// Apply damage.
			if (damage_impact > 0.0) {
				npc.hurt(damage_impact);
				
				// Hurt the other NPC too if the other object is indeed an NPC.
				// TODO: There's some weird stuff going on when colliding with other NPCs at the moment. I think it has
				// to do with the value of the velocity change not being quite right in that case.
				if (obstacle is EntitySprite && (obstacle as EntitySprite).entity is NPC) {
					((obstacle as EntitySprite).entity as NPC).hurt(damage_impact);
				}
			}
			
			// Break glass.
			if (glass_impact >= 0.0 && obstacle === Game.level.wall_tiles) {
				// We look in the opposite direction of our velocity change -- i.e., the opposite of where we're
				// being pushed back from -- to check if the tile in that direction is a glass tile. That should
				// hopefully be a pretty good indication of whether or not we collided with some glass.
				var impact_direction:FlxPoint = new FlxPoint(npc.old_velocity.x - npc.velocity.x, npc.old_velocity.y);
				MathUtil.normalize(impact_direction);
				
				// If we collided with glass, we need to break the glass and restore our old velocity so that the NPC
				// keeps moving through the window.
				if (Game.level.breakGlassAt(npc.center.x + impact_direction.x * Level.TileSize, npc.center.y + impact_direction.y * Level.TileSize)) {
					npc.knockback_velocity.x = npc.old_velocity.x;
					npc.knockback_velocity.y = npc.old_velocity.y;
				}
			}
		}
		
		// Makes the NPC jump. The height of the jump is relative to their jump_strength stat. You can pass in a
		// multiplier to increase or decrease the relative height of the jump. A value of 1.0 will make the NPC jump at
		// their intended maximum jump height. 
		public function jump(power:Number = 1.0):void {
			if (sprite.isTouching(FlxObject.DOWN)) {
				velocity.y = jump_strength * power * -60.0;
			}
		}
		
		// Called when the player just pressed the special attack button. It's a giant nasty monolithic function, but
		// deadlines are calling so it will have to do!
		public function startSpecialAttack():void {
			// Ensure our cooldown is up.
			if (special_cooldown > 0.0) {
				return;
			}
			
			// Set the cooldown and flag us as having started an attack.
			special_cooldown = type.cooldown;
			using_special    = true;
			
			// The burglar opens doors.
			if (type.id === "burglar") {
				Game.level.openDoorAt((facing === FlxObject.RIGHT) ? right + Level.TileSize / 2.0 : left - Level.TileSize / 2.0, s_center.y);
			}
			
			// The businessman does a large knockback attack.
			else if (type.id === "businessman") {
				var hb:HitBox = new HitBox(this, 0, 0, 6, height);
				hb.setAttributes(HitBox.PlayerAllegiance, 0.15, strength / 6.0, 300.0);
			}
			
			// The CEO does a money vomit attack.
			else if (type.id === "ceo") {
				// It's a continuous effect, so just call down to that.
				continueSpecialAttack();
			}
			
			// TODO: Add other attacks.
		}
		
		// Called when the player is holding down the special attack button.
		public function continueSpecialAttack():void {
			// Make sure we're actually using our special attack right now.
			if (!using_special) {
				return;
			}
			
			// CEO special.
			if (type.id === "ceo") {
				Game.level.money_emitter.vomitFromNPC(this);
			}
		}
		
		// Called when the player releases the special attack button.
		public function endSpecialAttack():void {
			// Make sure we're actually using our special attack right now.
			if (!using_special) {
				return;
			}
			
			// We're no longer using the special attack.
			using_special = false;
		}
		
		// Hurts the NPC, killing him if necessary.
		public function hurt(damage:Number):void {
			hp -= damage;
			
			// Set the hurt flash timer.
			flash_timer = HurtFlashTime;
			
			// Kill the NPC if necessary, or make them flee if they're not dead.
			if (hp <= 0.0) {
				kill();
			}
			else if (Game.player.victim !== this && state !== FleeState) {
				state = FleeState;
			}
		}
		
		// Kills the NPC. This is different from Flixel's version of killing -- this is what happens when the NPC
		// actually runs out of health and dies, including playing sounds, animations, etc.
		public function kill():void {
			// If the player is possessing us, we need to release him now.
			if (Game.player.victim === this) {
				Game.player.stopPossessing();
			}
			
			// Update the level progress.
			Game.level.queueDeadNPC(this);
			
			// Explode!!!
			Game.level.gib_emitter.spawnGibsForNPC(this);
			
			// Kill the sprite.
			sprite.kill();
		}
		
		// Callback that occurs when the NPC's behavior changes to idle.
		protected function startIdle():void {
			// Set the max duration.
			state_max_duration = 2.5 + Math.random() * 8.0;
			
			// Set the animation.
			sprite.play("idle");
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
			
			// Set the animation.
			sprite.play("walk");
		}
		
		protected function startChase():void {
			// Set the animation.
			sprite.play("walk");
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
			
			// Set the animation.
			// TODO: Play some sort of stunned animation.
			sprite.play("idle");
		}
		
		// Runs the NPC's idle behavior.
		protected function idle():void {
			// Search for the player if we're a robot.
			if (type.id === "robot") {
				searchForPlayer();
			}
			
			// Search for money!
			searchForMoney();
			
			// Switch to wander behavior after a certain duration.
			if (state !== ChaseState && state_duration > state_max_duration) {
				state = WanderState;
			}
		}
		
		// Runs the NPC's wander behavior.
		protected function wander():void {
			// Search for the player if we're a robot.
			if (type.id === "robot") {
				searchForPlayer();
			}
			
			// Search for money!
			searchForMoney();
			
			// Switch back to idle behavior after a certain duration.
			if (state !== ChaseState && state_duration > state_max_duration) {
				state = IdleState;
			}
		}
		
		// Runs the NPC's flee behavior.
		protected function flee():void {
			// TODO: Implement me!
		}
		
		// Runs the NPC's chase behavior.
		protected function chase():void {
			// Figure out if we're chasing an NPC or not. For now, we have two possible chase targets -- an NPC who is
			// the player's victim (for robot chasing) or a money particle.
			var target_npc:NPC = null;
			
			if ((chase_target is EntitySprite && (chase_target as EntitySprite).entity is NPC)) {
				target_npc = (chase_target as EntitySprite).entity as NPC;
			}
			
			// If the target's gone, we're done chasing.
			if (!chase_target || !chase_target.alive || (target_npc && Game.player.victim !== target_npc)) {
				chase_target = null;
				state = IdleState;
				return;
			}
			
			// The horizontal distance between the NPC and the target.
			var distance:Number = chase_target.x - x;
			
			// If we've found our target, we jump up and down on it unless it's an NPC. Otherwise we chase it.
			if (Math.abs(distance) < 3.0) {
				if (!target_npc) {
					jump(0.35);
				}
			}
			else {
				// Chase the sprite!
				velocity.x = (50.0 * Math.abs(distance) / distance) * run_speed;
				
				// Set the NPC's facing based on the direction.
				facing = (distance < 0.0) ? FlxObject.LEFT : FlxObject.RIGHT;
			}
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
				case ChaseState:     chase();       break;
				case PossessedState: bePossessed(); break;
				case StunnedState:   beStunned();   break;
			}
		}
		
		// Before update.
		override public function beforeUpdate():void {
			super.beforeUpdate();
			
			// We don't run AI if we're possessed.
			if (state !== PossessedState) {
				// Run the AI.
				behave();
				
				// For some reason Flixel makes us explicitly tell sprites to stop following their path when they're
				// done.
				if (state !== ChaseState && sprite.pathSpeed == 0.0) {
					sprite.stopFollowingPath(true);
					velocity.x = 0.0;
					
					if (sprite.finished) {
						sprite.play("idle");
					}
				}
			}
			else {
				// Set the animation.
				if (sprite.finished) {
					if (velocity.x !== 0.0 && sprite.isTouching(FlxObject.DOWN)) {
						sprite.play("walk");
					}
					else {
						sprite.play("idle");
					}
				}
			}
			
			// Set the NPC's color.
			sprite.color = current_color;
			
			// Add knockback velocity and reduce it over time.
			var knockback_drag:Number;
			
			if (knockback_velocity.x !== 0.0) {
				knockback_drag        = (knockback_velocity.x > 0.0) ? -drag.x * FlxG.elapsed / 2.0 : drag.x * FlxG.elapsed / 2.0;
				velocity.x           += knockback_velocity.x;
				knockback_velocity.x  = (Math.abs(knockback_velocity.x) <= knockback_drag) ? 0.0 : knockback_velocity.x + knockback_drag;
			}
			
			if (knockback_velocity.y !== 0.0) {
				knockback_drag       = (knockback_velocity.y > 0.0) ? -drag.y * FlxG.elapsed / 2.0 : drag.y * FlxG.elapsed / 2.0;
				velocity.y           = knockback_velocity.y;
				knockback_velocity.y = (Math.abs(knockback_velocity.y) <= knockback_drag) ? 0.0 : knockback_velocity.y + knockback_drag;
			}
			
			// Decrement the flash timer.
			flash_timer = Math.max(0.0, flash_timer - FlxG.elapsed);
			
			// Reduce cooldown.
			special_cooldown = Math.max(0.0, special_cooldown - FlxG.elapsed);
			
			// Increment the state duration.
			state_duration += FlxG.elapsed;
			
			// Kill the NPC if they've fallen off the map.
			if (y > Game.level.height) {
				kill();
			}
		}
		
		// After update.
		override public function afterUpdate():void {
			super.afterUpdate();
			
			// We store our "old" velocity here, which will be used if the NPC collides with something.
			old_velocity.x = velocity.x;
			old_velocity.y = velocity.y;
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
					sprite.followPath(path, 30.0 * run_speed * (Math.random() * 0.6 + 0.6), FlxObject.PATH_HORIZONTAL_ONLY | FlxObject.PATH_FORWARD);
					
					// Set the NPC's facing based on the direction.
					facing = (direction === 1) ? FlxObject.RIGHT : FlxObject.LEFT;
				}
			}
		}
		
		// An AI helper function that makes the NPC search for any nearby money (spawned by the CEO's special attack)
		// and chase it if so.
		private function searchForMoney():void {
			var money:FlxGroup = Game.level.money_emitter.particles;
			
			// Check to make sure that there is some money to begin with.
			if (money.getFirstAlive()) {
				// We look at each money particle to see if it's close enough to the NPC to attract them. Because the
				// particles are emitted in pairs, and because there are so many of them, we skip every other particle
				// for a bit of a performance boost.
				var nearby_particle:FlxSprite = null;
				var distance:FlxPoint         = new FlxPoint();
				
				for (var i:int = 0; i < money.length; i += 2) {
					var particle:FlxSprite = money.members[i];
					
					// Don't care about dead particles.
					if (!particle.alive) {
						continue;
					}
					
					// Calculate the distance squared.
					distance.x = particle.x - x;
					distance.y = particle.y - y;
					
					var distance_squared:Number = MathUtil.vectorLengthSquared(distance);
					
					// Select any particle that is within the given distance limit.
					if (distance_squared < 2500.0) {
						nearby_particle = particle;
						break;
					}
				}
				
				// Make the NPC run towards the particle.
				if (nearby_particle) {
					chase_target = nearby_particle;
					state        = ChaseState;
				}
			}
		}
		
		// An AI helper function that causes the NPC to search for the player within a certain radius, and if he is
		// found, starts chasing after him.
		private function searchForPlayer():void {
			// We're actually looking for the NPC the player is possessing.
			var victim:NPC = Game.player.victim;
			
			// If the player's not possessing anyone, we have nothing to look for.
			if (!victim) {
				return;
			}
			
			// Get the distance squared from the player.
			var distance_squared:Number = MathUtil.vectorLengthSquared(new FlxPoint(victim.x - x, victim.y - y));
			
			// If they're within a certain distance, run towards them.
			if (distance_squared < 2500.0) {
				chase_target = victim.sprite;
				state        = ChaseState;
			}
		}
		
		// State getters and setters.
		public function get state():int {
			return $state;
		}
		
		public function set state(value:int):void {
			$state         = value;
			state_duration = state_max_duration = 0.0;
			sprite.stopFollowingPath(true);
			
			switch (state) {
				case IdleState:      startIdle();        break;
				case WanderState:    startWander();      break;
				case FleeState:      startFlee();        break;
				case ChaseState:     startChase();       break;
				case PossessedState: startBePossessed(); break;
				case StunnedState:   startBeStunned();   break;
			}
		}
		
		// Getter for the NPC's id.
		public function get id():String {
			return type.id;
		}
		
		// Getter for the NPC's objective type -- that is, which objective they count for.
		public function get objective_type():String {
			var objectives:Object = Game.level.objectives;
			var progress:Object   = Game.level.progress;
			
			// If the NPC type doesn't count for an objective, or the NPC type's objective is full, we count for the
			// "any" or "bonus" objective.
			if (!objectives[id] || progress[id] >= objectives[id]) {
				return (objectives.any && progress.any < objectives.any) ? "any" : "bonus";
			}
			
			// Otherwise we return our own type.
			return id;
		}
		
		// Getter for the current color the NPC should be based on their state and the flash timer.
		public function get current_color():uint {
			var base_color:uint       = (state === PossessedState) ? PossessionColor : 0xFFFFFF;
			var flash_progress:Number = 1.0 - flash_timer / HurtFlashTime;
			
			return (flash_timer > 0.0) ? ColorUtil.blend(HurtColor, base_color, flash_progress) : base_color;
		}
		
	}
	
}
