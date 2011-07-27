//
// The player class. It's important!
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class Player extends Entity {
		
		// The various colors the player character changes to.
		public static const NormalColor:uint     = 0x55DDFF;
		public static const PossessionColor:uint = 0xFF99DD;
		
		// How quickly (in seconds) player trail sprites should spawn and fade, as well as the initial opacity of the
		// trail when it is spawned.
		public static const TrailSpawnRate:Number      = 0.175;
		public static const TrailFadeRate:Number       = 0.7;
		public static const TrailInitialOpacity:Number = 0.45;
		
		// The base cooldown times for each attack.
		public static const PunchCooldownTime:Number = 0.3;
		public static const KickCooldownTime:Number  = 0.195;
		
		// The direction of the player's movement. To move the player (or the NPC that the player is possessing), set
		// this to point towards where you want the player to move. You need to set the player's sprite's maxSpeed and
		// drag attributes for this to work. They will accelerate in the given direction by the same factor as their
		// drag attribute.
		public var direction:FlxPoint;
		
		// The NPC that the player is hovering over, and therefore can currently possess.
		private var $potential_victim:NPC;
		
		// The NPC that the player is currently possessing. If they're not possessing anyone, this will be null.
		public var victim:NPC;
		
		// The group that contains the player's lingering trail effect and the timer that determines when a new sprite
		// is added.
		public var trails:FlxGroup;
		private var trails_timer:Number;
		
		// Cooldown timers for the player's basic attacks.
		public var punch_cooldown:Number;
		public var kick_cooldown:Number;
		
		public function Player() {
			super();
			
			direction = new FlxPoint();
			
			// Pre-allocate the player's trail sprites. We can figure out how many we need to create based on the spawn
			// and fade rates.
			trails              = new FlxGroup();
			trails_timer        = 0.0;
			var trail_count:int = Math.ceil(TrailFadeRate / TrailSpawnRate);
			
			for (var i:int = 0; i < trail_count; i++) {
				var trail:FlxSprite = new FlxSprite();
				trail.loadGraphic(Assets.ghost_sprite, true, true, 4, 15).kill();
				trails.add(trail);
			}
			
			// Load the player sprite.
			sprite.loadGraphic(Assets.ghost_sprite, true, true, 4, 15);
			
			// Set up animations.
			sprite.addAnimation("float", [0, 1, 2, 3, 4, 5, 6, 7], 20);
			sprite.play("float");
			
			// Set up movement.
			max_velocity = new FlxPoint(100.0, 100.0);
			drag         = new FlxPoint(280.0, 280.0);
			
			// Set the player's default color and opacity.
			color        = NormalColor;
			sprite.alpha = 0.9;
			
			// Set up timers.
			punch_cooldown = 0.0;
			kick_cooldown  = 0.0;
		}
		
		// Possesses the NPC that the player is currently hovering over.
		public function possess():void {
			// We need a potential victim.
			if (!potential_victim) {
				return;
			}
			
			// The potential victim is now the actual victim.
			victim = potential_victim;
			potential_victim = null;
			
			// Set the possession color.
			color = PossessionColor;
			
			// Process the victim and player.
			victim.state = NPC.PossessedState;
			victim.sprite.stopFollowingPath(true);
			
			// Reorder the player and the NPCs in the scene to put the player behind the NPCs.
			if (FlxG.state is PlayState) {
				Game.level.swapPlayerAndNPCs();
			}
			
			// Have the camera follow the NPC now.
			FlxG.camera.follow(victim.sprite);
		}
		
		// Stops possessing the current victim, releasing the ghost from the NPC.
		public function stopPossessing():void {
			// We need to be possessing a victim.
			if (!victim) {
				return;
			}
			
			// Return to the normal color.
			color = NormalColor;
			
			// Get rid of the victim.
			victim.state = NPC.IdleState;
			victim       = null;
			
			// Swap the player and NPCs.
			if (Game.level) {
				Game.level.swapPlayerAndNPCs();
			}
			
			// Have the camera follow the player again.
			FlxG.camera.follow(sprite);
		}
		
		// The regular punch attack the player uses when they're possessing someone.
		public function punchAttack():void {
			// We need a victim to punch anything, and we need to make sure our cooldown is up.
			if (punch_cooldown > 0.0 || !victim) {
				return;
			}
			
			// Set the cooldown.
			punch_cooldown = PunchCooldownTime * victim.attack_speed;
			
			// Create the hitbox.
			var hb:HitBox = new HitBox(victim, 0, 0, 5, victim.height);
			hb.setAttributes(HitBox.PlayerAllegiance, 0.15, victim.strength, 0.0);
			
			// Play the victim's punch animation.
			victim.sprite.play("punch", true);
			
			// Break any glass that we hit.
			var break_direction:Number = (victim.facing === FlxObject.RIGHT) ? victim.right + Level.TileSize / 2.0 : victim.left - Level.TileSize / 2.0;
			Game.level.breakGlassAt(break_direction, victim.s_center.y);
		}
		
		// The secondary knockback attack the player uses when they're possessing someone.
		public function knockbackAttack():void {
			// We need a victim to attack anything, and we need to make sure our cooldown is up.
			if (kick_cooldown > 0.0 || !victim) {
				return;
			}
			
			// Set the cooldown.
			kick_cooldown = KickCooldownTime * victim.attack_speed;
			
			// Create the hitbox.
			var hb:HitBox = new HitBox(victim, 0, 0, 5, victim.height);
			hb.setAttributes(HitBox.PlayerAllegiance, 0.15, victim.strength / 5.0, 150.0);
			
			// Play the victim's kick animation.
			victim.sprite.play("kick", true);
			
			// Break any glass that we hit.
			var break_direction:Number = (victim.facing === FlxObject.RIGHT) ? victim.right + Level.TileSize / 2.0 : victim.left - Level.TileSize / 2.0;
			Game.level.breakGlassAt(break_direction, victim.s_center.y);
		}
		
		// Update.
		override public function beforeUpdate():void {
			super.beforeUpdate();
			
			// Reduce cooldowns.
			punch_cooldown = Math.max(0.0, punch_cooldown - FlxG.elapsed);
			kick_cooldown  = Math.max(0.0, kick_cooldown - FlxG.elapsed);
			
			// Set facing based on the direction.
			if (direction.x !== 0) {
				facing = (direction.x > 0.0) ? FlxObject.RIGHT : FlxObject.LEFT;
			}
			
			// Handle movement. We have very different movement behavior based on whether we're possessing someone at
			// the moment.
			if (victim) {
				// NPCs only move horizontally.
				victim.acceleration.x = direction.x * victim.drag.x;
				
				// Have the player follow behind the victim with a sort of "yoyo" effect.
				var yoyo_distance:FlxPoint  = new FlxPoint(victim.x - x, (victim.y - 5.0) - y);
				
				acceleration.x = yoyo_distance.x * 90.0;
				acceleration.y = yoyo_distance.y * 90.0;
				
				// We need to make sure the player doesn't stray too far from the NPC.
				if (Math.abs(yoyo_distance.x) > 10.0) {
					x += yoyo_distance.x * FlxG.elapsed * 10.0;
				}
				
				if (Math.abs(yoyo_distance.y) > 10.0) {
					y += yoyo_distance.y * FlxG.elapsed * 10.0;
				}
				
				victim.facing = facing;
			}
			else {
				// Normalize the direction.
				MathUtil.normalize(direction);
				
				// Set acceleration.
				acceleration.x = direction.x * drag.x;
				acceleration.y = direction.y * drag.y;
			}
			
			// Update the player's trail effect.
			updateTrail();
		}
		
		// A little helper function for updating the player's trail effect.
		private function updateTrail():void {
			var trail:FlxSprite;
			
			// Fade out the current trails.
			for (var i:int = 0; i < trails.length; i++) {
				trail = trails.members[i];
				
				if (trail.alive) {
					trail.alpha = Math.max(trail.alpha - FlxG.elapsed / (TrailFadeRate / TrailInitialOpacity), 0.0);
					
					// If the trail's completely faded, we should get rid of it.
					if (trail.alpha <= 0.0) {
						trail.kill();
					}
				}
			}
			
			// Add new trails.
			var player_moving:Boolean = velocity.x !== 0.0 || velocity.y !== 0.0;
			
			if (trails_timer >= TrailSpawnRate && (player_moving || victim)) {
				trail = trails.getFirstDead() as FlxSprite;
				
				if (trail) {
					trail.revive();
					trail.x      = x;
					trail.y      = y;
					trail.alpha  = TrailInitialOpacity;
					trail.frame  = sprite.frame;
					trail.facing = facing;
				}
				
				trails_timer = 0.0;
			}
			
			trails_timer += FlxG.elapsed;
		}
		
		// Getters and setters for the player's color.
		public function get color():uint {
			return sprite.color;
		}
		
		public function set color(value:uint):void {
			sprite.color = value;
			
			// We need to set the color of all of our trails as well.
			for (var i:int = 0; i < trails.length; i++) {
				trails.members[i].color = value;
			}
		}
		
		// Getters and setters for the potential victim.
		public function get potential_victim():NPC {
			return $potential_victim;
		}
		
		public function set potential_victim(value:NPC):void {
			// We don't allow the player to possess robots or shrunken NPCs.
			if (value === null || (value.type.id !== "robot" && !value.is_shrunk)) {
				$potential_victim = value;
			}
		}
		
	}
	
}
