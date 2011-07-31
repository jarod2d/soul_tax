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
		public static const PanicState:int     = 6;
		
		// Multipliers for the NPC's speed in various states.
		public static const WanderSpeedFactor:Number = 0.25;
		public static const FleeSpeedFactor:Number   = 1.0;
		
		// How long the NPC should flash when they get hurt.
		public static const HurtFlashTime:Number = 0.14;
		
		// The velocity threshold after which the NPC will take damage when colliding with something.
		public static const ContactDamageThreshold:Number = 280.0;
		public static const NPCDamageThreshold:Number     = 140.0;
		public static const GlassBreakThreshold:Number    = 150.0;
		
		// How often the maintenance guy's special attack gets triggered.
		public static const MaintenanceGuySpecialInterval:Number = 0.5;
		
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
		
		// Whether or not the NPC has been shrunk by the supervillain's shrink ray attack.
		public var is_shrunk:Boolean;
		
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
		
		// An interval timer for the maintenance guy's special attack. Since we're not subclassing our NPC types it
		// unfortunately has to be stuck on all NPCs for now.
		public var special_interval:Number;
		
		// The target sprite that the NPC is chasing when he's in the chase state, or who he's fleeing from when he's in
		// the flee state.
		public var target:FlxSprite;
		
		// If the NPC is causing a looping sound at the moment, this will be a reference to that sound so that we can
		// cancel it when we need to.
		public var active_sound:FlxSound;
		
		// Flixel has a rather poorly-designed collision callback system that doesn't provide information about the
		// objects' changes in velocity. We need that information, so each NPC stores their pre-collision velocity here.
		private var old_velocity:FlxPoint;
		
		// A timer that gets set whenever the NPC gets hurt, used for tinting the NPC and fading it out over time.
		private var flash_timer:Number;
		
		// A reference to the NPC's sleeping "z" animation, so we can remove it when we're done sleeping.
		private var sleep_effect:FlxSprite;
		
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
			special_cooldown = special_interval = flash_timer = 0.0;
			using_special    = false;
		}
		
		// A callback that occurs when an NPC collides with anything, to be used in calculating collision damage,
		// diminishing knockback velocity, etc.
		public static function processCollision(npc_sprite:EntitySprite, obstacle:FlxObject):void {
			var npc:NPC                 = npc_sprite.entity as NPC;
			var obstacle_is_npc:Boolean = (obstacle is EntitySprite && (obstacle as EntitySprite).entity is NPC);
			var obstacle_npc:NPC        = (obstacle_is_npc) ? (obstacle as EntitySprite).entity as NPC : null;
			
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
			var damage_threshold:Number = (obstacle is EntitySprite && (obstacle as EntitySprite).entity is NPC) ? NPCDamageThreshold : ContactDamageThreshold;
			
			var base_impact:Number   = MathUtil.vectorLength(velocity_change);
			var damage_impact:Number = (base_impact - damage_threshold) * 0.95;
			var glass_impact:Number  = (base_impact - GlassBreakThreshold);
			
			// Apply damage. We need to make sure not to apply damage when the superhero is charging through NPCs,
			// though.
			if (damage_impact > 0.0 && (!obstacle_is_npc || npc.type.id !== "superhero" || !npc.using_special)) {
				// Need to tweak NPC damage.
				if (obstacle_is_npc) {
					damage_impact *= 3.25;
				}
				
				npc.hurt(damage_impact, "falling");
				
				// Hurt the other NPC too if the other object is indeed an NPC.
				// TODO: There's some weird stuff going on when colliding with other NPCs at the moment. I think it has
				// to do with the value of the velocity change not being quite right in that case.
				if (obstacle_is_npc) {
					obstacle_npc.hurt(damage_impact, "falling");
				}
				
				// Play a sound.
				var sound:Class = (Math.random() < 0.5) ? Assets.punch_hit_2_sound : Assets.punch_hit_3_sound;
				FlxG.play(sound, 0.65);
			}
			
			// Break glass.
			if (glass_impact >= 0.0 && obstacle === Game.level.wall_tiles) {
				// We look in the opposite direction of our velocity change -- i.e., the opposite of where we're
				// being pushed back from -- to check if the tile in that direction is a glass tile. That should
				// hopefully be a pretty good indication of whether or not we collided with some glass.
				var impact_direction:FlxPoint = new FlxPoint(npc.old_velocity.x - npc.velocity.x, npc.old_velocity.y);
				MathUtil.normalize(impact_direction);
				
				// If we collided with glass, we need to break the glass and restore our old velocity so that the NPC
				// keeps moving through the window
				if (Game.level.breakGlassAt(npc.center.x + impact_direction.x * Level.TileSize, npc.center.y + impact_direction.y * Level.TileSize) && npc.state !== PossessedState) {
					npc.knockback_velocity.x = npc.old_velocity.x;
					npc.knockback_velocity.y = npc.old_velocity.y;
				}
			}
		}
		
		// Makes the NPC jump. The height of the jump is relative to their jump_strength stat. You can pass in a
		// multiplier to increase or decrease the relative height of the jump. A value of 1.0 will make the NPC jump at
		// their intended maximum jump height. 
		public function jump(power:Number = 1.0):void {
			// Don't let certain NPCs jump while using their special.
			if (using_special && (type.id === "bank_manager" || type.id === "maintenance_guy" || type.id === "old_lady")) {
				return;
			}
			
			if (sprite.isTouching(FlxObject.DOWN)) {
				velocity.y = jump_strength * power * -60.0;
				
				// Only play a sound if this is the player jumping.
				if (state === PossessedState) {
					FlxG.play(Assets.jump_sound, 0.4);
				}
			}
		}
		
		// Shrinks the NPC so that they can be stomped on.
		public function shrink():void {
			// Scale down the sprite.
			sprite.scale.x = sprite.scale.y = 0.5;
			offset.y += Math.floor((height - 6.0) / 2.0);
			offset.x += Math.floor((width - 2.0) / 2.0);
			width    = 2.0;
			height   = 6.0;
			
			// Add the NPC to the list of shrunken NPCs.
			Game.level.shrunk_NPCs.add(sprite);
			
			// Need to keep track of the fact that we're shrunk.
			is_shrunk = true;
			
			// Play a sound.
			FlxG.play(Assets["shrink_hit_" + (MathUtil.randomInt(3) + 1) + "_sound"], 0.235);
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
				// If we didn't open a door, don't blow our cooldown.
				if (!Game.level.openDoorAt((facing === FlxObject.RIGHT) ? right + Level.TileSize / 2.0 : left - Level.TileSize / 2.0, s_center.y)) {
					special_cooldown = 0.0;
				}
			}
			
			// The businessman does a large knockback attack.
			else if (type.id === "businessman") {
				// Spawn the hitbox.
				var hb:HitBox = new HitBox(this, 0, 0, 6, height);
				hb.setAttributes(HitBox.PlayerAllegiance, 0.15, strength / 6.0, 300.0);
				
				// Break glass.
				var break_direction:Number = (facing === FlxObject.RIGHT) ? right + Level.TileSize / 2.0 : left - Level.TileSize / 2.0;
				Game.level.breakGlassAt(break_direction, s_center.y);
				
				// Play the animation.
				sprite.play("special", true);
				
				// Play a sound.
				FlxG.play(Assets.kick_miss_2_sound, 0.75);
			}
			
			// The security guard shoots a gun.
			else if (type.id === "security_guard") {
				// Spawn the bullet.
				var bullet:HitBox = new HitBox(this, 0, 3, 3, 2, true);
				bullet.dies_on_contact = true;
				bullet.sound = Assets.punch_hit_1_sound;
				bullet.setAttributes(HitBox.PlayerAllegiance, 3.0, 150.0, 50.0, function(hb:HitBox, npc:NPC):void {
					hb.sprite.kill();
				});
				
				bullet.sprite.loadGraphic(Assets.bullet_sprite);
				bullet.velocity.x = (facing === FlxObject.LEFT) ? -300.0 : 300.0;
				
				// Projectiles don't spawn exactly where they're supposed to, so we have to adjust them a bit.
				bullet.x -= bullet.velocity.x * FlxG.elapsed * ((facing === FlxObject.LEFT) ? 2.75 : 0.75);
				
				// Play the shooting animation.
				sprite.play("special", true);
				
				// Play a sound.
				FlxG.play(Assets.gun_sound, 0.9);
			}
			
			// The supervillain shoots a shrink ray.
			else if (type.id === "supervillain") {
				// Spawn the laser.
				var laser:HitBox = new HitBox(this, 0, 5, 5, 2, true);
				laser.setAttributes(HitBox.PlayerAllegiance, 3.0, 0.0, 0.0, function(hb:HitBox, npc:NPC):void {
					if (npc.type.id !== "robot") {
						npc.shrink();
					}
				});
				
				laser.sprite.loadGraphic(Assets.laser_sprite, true, true, 5, 2);
				laser.sprite.addAnimation("shoot", [0, 1, 2, 3], 15, true);
				laser.sprite.play("shoot");
				laser.velocity.x = (facing === FlxObject.LEFT) ? -300.0 : 300.0;
				laser.facing     = facing;
				
				// Same hack as the security guard above.
				laser.x -= laser.velocity.x * FlxG.elapsed * ((facing === FlxObject.LEFT) ? 2.25 : 1.0);
				
				// Play the shooting animation.
				sprite.play("special", true);
				
				// Play a sound.
				FlxG.play(Assets.shrink_ray_sound, 0.8);
			}
			
			// These NPCs have continuous attacks that just require calling down to the continuous effect.
			else if (type.id === "bank_manager" || type.id === "ceo" || type.id === "maintenance_guy" || type.id === "old_lady" || type.id === "superhero") {
				continueSpecialAttack();
			}
			
			// Play sounds.
			if (type.id === "bank_manager") {
				FlxG.play(Assets.female_yell_sound, 0.7);
			}
			else if (type.id === "ceo") {
				active_sound = FlxG.play(Assets.ceo_vomit_sound, 0.85, true);
			}
			else if (type.id === "maintenance_guy") {
				active_sound = FlxG.play(Assets.drill_sound, 0.375, true);
			}
			else if (type.id === "old_lady") {
				FlxG.play(Assets.old_lady_jabber_sound, 0.65);
			}
			else if (type.id === "superhero") {
				FlxG.play(Assets.superhero_special_sound, 0.6);
			}
		}
		
		// Called when the player is holding down the special attack button.
		public function continueSpecialAttack():void {
			// Make sure we're actually using our special attack right now.
			if (!using_special) {
				return;
			}
			
			// Declaring these here to avoid stupid hoisting warnings...
			var distance:FlxPoint;
			var npc:NPC;
			var npc_sprite:EntitySprite;
			var distance_squared:Number;
			
			// Manager special.
			if (type.id === "bank_manager") {
				// Scare everyone within a certain radius.
				distance = new FlxPoint();
				
				for each (npc_sprite in Game.level.NPCs.members) {
					npc = npc_sprite.entity as NPC;
					
					// We don't want to scare ourselves or robots.
					if (npc === this || npc.type.id === "robot") {
						continue;
					}
					
					// Make sure the NPC is within a certain radius.
					distance.x = npc.x - x;
					distance.y = npc.y - y;
					
					distance_squared = MathUtil.vectorLengthSquared(distance);
					
					if (npc.state !== FleeState && distance_squared < 2500.0) {
						// Scare the NPC.
						npc.target = this.sprite;
						npc.state  = FleeState;
					}
				}
				
				// We don't want the player to move while this is happening.
				Game.player.direction.x = Game.player.direction.y = 0.0;
				
				// Play the yelling animation.
				sprite.play("special");
				
				// Manager's cooldown resets when she's done yapping.
				special_cooldown = type.cooldown;
			}
			
			// CEO special.
			else if (type.id === "ceo") {
				Game.level.money_emitter.vomitFromNPC(this);
			}
			
			// Maintenance guy special.
			else if (type.id === "maintenance_guy") {
				// We don't want the player to move while this is happening.
				Game.player.direction.x = Game.player.direction.y = 0.0;
				acceleration.x = velocity.x = 0.0;
				
				// Destroy tiles underneath the NPC.
				if (special_interval <= 0.0) {
					var tiles:FlxTilemap = Game.level.wall_tiles;
					var destroy_y:Number = (bottom + Level.TileSize / 2.0) / Level.TileSize;
					var left:FlxPoint    = new FlxPoint(left / Level.TileSize, destroy_y);
					var right:FlxPoint   = new FlxPoint(right / Level.TileSize, destroy_y);
					
					// The hard-coded value here is the tilemap's collision index -- basically, we're checking to see if
					// there are destroyable tiles underneath us. Flixel gives us no easy way of getting the tilemap's
					// collision index.
					if (tiles.getTile(left.x, left.y) >= 3 ||tiles.getTile(right.x, right.y) >= 3) {
						// Destroy the tiles.
						tiles.setTile(left.x, left.y, 0);
						tiles.setTile(right.x, right.y, 0);
						
						// Set the interval.
						special_interval = MaintenanceGuySpecialInterval;
						
						// Play a sound.
						var sound:Class = (Math.random() < 0.5) ? Assets.block_break_1_sound : Assets.block_break_2_sound;
						FlxG.play(sound, 0.4);
					}
				}
				
				// Maintenance guy's cooldown resets when he's done drilling.
				special_cooldown = type.cooldown;
				
				// Play the drill animation.
				sprite.play("special");
			}
			
			// Old lady special.
			else if (type.id === "old_lady") {
				// Make everyone within a certain radius fall asleep.
				distance = new FlxPoint();
				
				for each (npc_sprite in Game.level.NPCs.members) {
					npc = npc_sprite.entity as NPC;
					
					// We don't want to make ourselves or dead NPCs fall asleep.
					if (npc === this || !npc.sprite.alive) {
						continue;
					}
					
					// Make sure the NPC is within a certain radius.
					distance.x = npc.x - x;
					distance.y = npc.y - y;
					
					distance_squared = MathUtil.vectorLengthSquared(distance);
					
					if (npc.state !== FleeState && distance_squared < 2750.0) {
						// Put some z's above their head if they're not already sleeping.
						if (npc.state !== StunnedState) {
							npc.sleep_effect = new FlxSprite(npc.center.x, npc.top - 10.0);
							npc.sleep_effect.loadGraphic(Assets.zzz_sprite, true, false, 8, 8);
							npc.sleep_effect.addAnimation("pulse", [0, 1], 1, true);
							npc.sleep_effect.play("pulse");
							
							Game.level.sleep_effects.add(npc.sleep_effect);
						}
						
						// Make them fall asleep.
						npc.target = this.sprite;
						npc.state  = StunnedState;
					}
				}
				
				// We don't want the player to move while this is happening.
				Game.player.direction.x = Game.player.direction.y = 0.0;
				
				// Play the jabbering animation.
				sprite.play("special");
				
				// Old lady's cooldown resets when she's done yapping.
				special_cooldown = type.cooldown;
			}
			
			// Superhero special.
			else if (type.id === "superhero") {
				// We need to cancel out player movement during the charge.
				Game.player.direction.x = Game.player.direction.y = 0.0;
				
				// Set our charge velocity.
				velocity.x = max_velocity.x = (facing === FlxObject.LEFT) ? -360.0 : 360.0;
				
				// Kill dudes we run into.
				FlxG.overlap(this.sprite, Game.level.NPCs, function(npc_sprite:EntitySprite, victim_sprite:EntitySprite):void {
					(victim_sprite.entity as NPC).kill();
				});
				
				// Play the charging animation.
				sprite.play("special");
				
				// Superhero's cooldown resets when he's done charging.
				special_cooldown = type.cooldown;
			}
		}
		
		// Called when the player releases the special attack button.
		public function endSpecialAttack():void {
			// Make sure we're actually using our special attack right now.
			if (!using_special) {
				return;
			}
			
			// Superhero special.
			else if (type.id === "superhero") {
				// Reset the charge velocity and max velocity with some yucky repeated values.
				velocity.x     = 0.0;
				max_velocity.x = 90.0 * run_speed;
			}
			
			// Certain NPCs need to stop their animation.
			if (type.id === "bank_manager" || type.id === "maintenance_guy" || type.id === "old_lady") {
				sprite.finished = true;
			}
			
			// We're no longer using the special attack, and we need to reset our interval.
			using_special    = false;
			special_interval = 0.0;
			
			// Stop any looping sounds.
			if (active_sound) {
				active_sound.stop();
				active_sound = null;
			}
		}
		
		// Hurts the NPC, killing him if necessary.
		public function hurt(damage:Number, source:String = null):void {
			hp -= damage;
			
			// Set the hurt flash timer.
			if (damage > 0.0) {
				flash_timer = HurtFlashTime;
			}
			
			// Kill the NPC if necessary.
			if (hp <= 0.0 || is_shrunk) {
				kill(source);
			}
			
			// If the NPC got hurt from falling, shake the screen a bit.
			if (source === "falling") {
				// How severe we want the screen shake to be, based on the damage done.
				var severity:Number = MathUtil.clamp(damage / 100.0, 0.0, 1.0);
				
				FlxG.shake(0.00065 + 0.0015 * severity, 0.15 + 0.075 * severity);
			}
		}
		
		// Kills the NPC. This is different from Flixel's version of killing -- this is what happens when the NPC
		// actually runs out of health and dies, including playing sounds, animations, etc.
		public function kill(source:String = null):void {
			// If the player is possessing us, we need to release him now.
			if (Game.player.victim === this) {
				Game.player.stopPossessing();
			}
			
			// Update the level progress and explode.
			if (type.id !== "robot") {
				Game.level.queueDeadNPC(this);
				Game.level.gib_emitter.spawnGibsForNPC(this);
			}
			else {
				Game.level.robot_gib_emitter.spawnGibsForNPC(this);
				Game.level.smoke_emitter.spawnSmokeForNPC(this);
			}
			
			// Kill the sprite.
			sprite.kill();
			
			// Shake the screen if the NPC died from going out of bounds.
			if (source === "out_of_bounds") {
				FlxG.shake(0.001, 0.15);
			}
			
			// Play a sound.
			var sound:Class;
			
			if (type.id === "robot") {
				sound = (Math.random() < 0.45) ? Assets.npc_death_fancy_1_sound : Assets.npc_death_fancy_2_sound;
			}
			else {
				sound = (Math.random() < 0.45) ? Assets.npc_death_1_sound : Assets.npc_death_2_sound;
			}
			
			FlxG.play(sound, 0.5);
			
			// Remove z's.
			if (sleep_effect) {
				Game.level.sleep_effects.remove(sleep_effect);
			}
			
			// TODO: Make everyone within a certain radius panic, just like in the HitBox class. Make a reusable Level
			// function I guess.
		}
		
		// Callback that occurs when the NPC's behavior changes to idle.
		protected function startIdle():void {
			// Set the max duration.
			state_max_duration = 2.5 + Math.random() * 8.0;
			
			// Set the animation.
			sprite.play(animation_prefix + "idle");
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
			sprite.play(animation_prefix + "walk");
		}
		
		protected function startChase():void {
			// Set the animation.
			sprite.play(animation_prefix + "walk");
		}
		
		// Callback that occurs when the NPC's behavior changes to flee.
		protected function startFlee():void {
			// Set the max duration.
			state_max_duration = 1.0 + Math.random() * 0.75;
			
			// Set the animation.
			sprite.play("panic");
		}
		
		// Callback that occurs when the NPC enters the possessed state.
		protected function startBePossessed():void {
			// Cancel out any old animations.
			sprite.finished = true;
		}
		
		// Callback that occurs when the NPC enters the stunned state.
		protected function startBeStunned():void {
			// Set the max duration.
			state_max_duration = 9.5 + Math.random() * 2.5;
			
			// Stop the NPC from moving.
			velocity.x = acceleration.x = 0.0;
			
			// Set the animation.
			sprite.play("sleep");
		}
		
		// Callback that occurs when the NPC's behavior changes to panic.
		protected function startPanic():void {
			// TODO: Implement me!
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
			// If the target's gone, we're done fleeing. Also switch back to idle behavior after a certain duration.
			if (!target || !target.alive || state_duration > state_max_duration) {
				target = null;
				state = IdleState;
				return;
			}
			
			// Flee!
			velocity.x = (x < target.x) ? -65.0 * run_speed : 65.0 * run_speed;
			
			// Set the NPC's facing based on the direction.
			facing = (velocity.x < 0.0) ? FlxObject.LEFT : FlxObject.RIGHT;
		}
		
		// Runs the NPC's chase behavior.
		protected function chase():void {
			// Figure out if we're chasing an NPC or not. For now, we have two possible chase targets -- an NPC who is
			// the player's victim (for robot chasing) or a money particle.
			var target_npc:NPC = null;
			
			if ((target is EntitySprite && (target as EntitySprite).entity is NPC)) {
				target_npc = (target as EntitySprite).entity as NPC;
			}
			
			// If the target's gone, we're done chasing.
			if (!target || !target.alive || (target_npc && Game.player.victim !== target_npc)) {
				target = null;
				state = IdleState;
				return;
			}
			
			// The horizontal distance between the NPC and the target.
			var distance:Number = target.x - x;
			
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
				
				// Remove our Z's.
				if (sleep_effect) {
					Game.level.sleep_effects.remove(sleep_effect);
				}
			}
		}
		
		// Runs the NPC's panic behavior.
		protected function panic():void {
			// Switch back to idle behavior after a certain duration.
			if (state_duration > state_max_duration) {
				state = IdleState;
			}
			
			// TODO: Run back and forth.
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
				case PanicState:     panic();       break;
			}
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
					target = nearby_particle;
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
				target = victim.sprite;
				state  = ChaseState;
				
				FlxG.play(Assets.robot_aggro_sound, 0.5);
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
				if (state !== ChaseState && state !== FleeState && state !== StunnedState && sprite.pathSpeed == 0.0) {
					sprite.stopFollowingPath(true);
					velocity.x = 0.0;
					
					if (sprite.finished) {
						sprite.play(animation_prefix + "idle");
					}
				}
			}
			else {
				// Set the animation.
				if (sprite.finished) {
					if (velocity.x !== 0.0 && sprite.isTouching(FlxObject.DOWN)) {
						sprite.play(animation_prefix + "walk");
					}
					else {
						sprite.play(animation_prefix + "idle");
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
			
			// Reduce special cooldown and interval.
			special_cooldown = Math.max(0.0, special_cooldown - FlxG.elapsed);
			special_interval = Math.max(0.0, special_interval - FlxG.elapsed);
			
			// Increment the state duration.
			state_duration += FlxG.elapsed;
			
			// Kill the NPC if they've fallen off the map.
			if (y > Game.level.height) {
				kill("out_of_bounds");
			}
			
			// Keep our zzz sprite in sync with our position.
			if (sleep_effect) {
				sleep_effect.x = center.x;
				sleep_effect.y = top - 10.0;
			}
		}
		
		// After update.
		override public function afterUpdate():void {
			super.afterUpdate();
			
			// We store our "old" velocity here, which will be used if the NPC collides with something.
			old_velocity.x = velocity.x;
			old_velocity.y = velocity.y;
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
				case PanicState:     startPanic();       break;
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
			var base_color:uint;
			var flash_progress:Number = 1.0 - flash_timer / HurtFlashTime;
			
			switch (state) {
				case PossessedState: base_color = PossessionColor; break;
				case StunnedState:   base_color = 0x88AAEE;        break;
				default:             base_color = 0xFFFFFF;
			}
			
			return (flash_timer > 0.0) ? ColorUtil.blend(HurtColor, base_color, flash_progress) : base_color;
		}
		
		// A getter for our current animation prefix. Some animations need a prefix of "possessed_" during the possessed
		// state. This getter will return "possessed_" or "" based on the state.
		public function get animation_prefix():String {
			// Robots have different animations.
			if (type.id === "robot") {
				return (state === ChaseState) ? "hunt_" : "scan_";
			}
			
			return (state === PossessedState) ? "possessed_" : "";
		}
		
	}
	
}
