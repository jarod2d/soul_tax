//
// Represents some kind of hitbox, including melee hitboxes and projectiles. The hitboxes are self-managing, in that all
// you need to do is create one to get it to work. No need to add or remove them from groups or anything.
// 
// Created by Jarod Long on 7/8/2011.
//

package {
	
	import org.flixel.*;
	
	public class HitBox extends Entity {
		
		// The list of allegiance types.
		public static const PlayerAllegiance:int = 0;
		public static const EnemyAllegiance:int  = 1;
		
		// The angle of the knockback force when a hitbox hits an NPC.
		public static const KnockbackAngle:Number = 14.0 * MathUtil.DEGREE_TO_RADIAN_CONSTANT;
		
		// The entity that spawned the hitbox.
		public var host:Entity;
		
		// The offset from the host. For convenience, we make some assumptions about where you want the hitbox to be
		// relative to. The x offset will be relative to either the left or right side of the host's sprite (depending
		// on which way it's facing), and will be offset outward from the host. So an x offset of 0 will make the
		// hitbox's right side barely touch the entity's left side if they're facing left, for example. The y offset
		// will always be relative to the top of the entity's sprite.
		public var host_offset:FlxPoint;
		
		// The hitbox's allegiance, or team. Corresponds to the list of allegiance types above. This isn't really
		// necessary for this game since only the player can attack anything, but it's so easy to add that we might as
		// well.
		public var allegiance:int;
		
		// Every hitbox has a duration for how long it will exist. Once live_time hits the duration, the hitbox will
		// remove itself from the level's hitbox container. Again, not the best way of doing things, but it's quick and
		// easy. If you specify a duration <= 0.0, the hitbox will last forever until you get rid of it manually.
		public var duration:Number;
		public var live_time:Number;
		
		// How much damage and knockback occurs when the hitbox makes contact.
		public var damage:Number;
		public var knockback:Number;
		
		// Whether or not the hitbox is a projectile. The only difference is that a projectile doesn't sync its position
		// during update.
		public var is_projectile:Boolean;
		
		// Whether or not the hitbox will die when it hits a wall.
		public var dies_on_contact:Boolean;
		
		// The sound that plays when the hitbox hits something. You can also specify the maximum number of times that
		// the sound will play when it hits something. Defaults to 2. Set to 0 for no limit.
		public var sound:Class;
		public var max_sound_count:int;
		
		// Any special behavior that needs to happen when the hitbox makes contact, for whatever special effects your
		// attack needs. The function takes two parameters, the hitbox and the victim.
		public var callback:Function;
		
		// We keep track of who we've hit so that we don't attack the same NPC twice.
		public var victims:Array;
		
		// We keep track of how many times we play our sound so that we can make sure not to play
		private var sound_played_count:int;
		
		// Constructor. Everything should be pretty straightforward, except the x_offset and y_offset. These values
		// determine where the hitbox appears relative to the host. For example, an x_offset of 2.0 would mean the
		// hitbox has 2 pixels of space between it and its host on either the right or left side, depending on which way
		// the host is facing.
		public function HitBox(host:Entity, x_offset:Number, y_offset:Number, width:Number, height:Number, is_projectile:Boolean = false) {
			super();
			
			this.host          = host;
			host_offset        = new FlxPoint(x_offset, y_offset);
			this.is_projectile = is_projectile;
			live_time          = 0.0;
			victims            = [];
			dies_on_contact    = false;
			max_sound_count    = 2;
			
			if (!is_projectile) {
				sprite.makeGraphic(width, height, 0xCCEEAA11);
				sprite.alpha = 0.0;
			}
			
			syncPosition();
			
			Game.level.hitboxes.add(this.sprite);
		}
		
		// Sets the main attributes of the hitbox separately from the constructor to keep things clean.
		public function setAttributes(allegiance:int, duration:Number, damage:Number, knockback:Number, callback:Function = null):void {
			this.allegiance = allegiance;
			this.duration   = duration;
			this.damage     = damage;
			this.knockback  = knockback;
			this.callback   = callback;
		}
		
		// Attacks the given NPC. Should be called whenever the hitbox overlaps with the NPC.
		public function attackNPC(npc:NPC):void {
			// We don't want to attack the NPC who spawned the hitbox or NPCs that we've already attacked.
			if (npc === host || victims.indexOf(npc) >= 0) {
				return;
			}
			
			// We skip damage and knockback if we're hitting a robot. We still want the callback though.
			if (npc.type.id !== "robot") {
				// Do damage to the victim.
				npc.hurt(damage);
				
				// Do some knockback.
				if (knockback > 0.0) {
					var angle:Number;
					
					if (host.bottom > npc.bottom) {
						angle = (host.x < npc.x) ? (KnockbackAngle / 1.5) : (Math.PI - KnockbackAngle / 1.5);
					}
					else {
						angle = (host.x < npc.x) ? KnockbackAngle : (Math.PI - KnockbackAngle);
					}
					
					npc.knockback_velocity.x = Math.cos(angle) * knockback;
					npc.knockback_velocity.y = -Math.sin(angle) * knockback;
				}
			}
			
			// Make note that we've attacked this victim.
			victims.push(npc);
			
			// TODO: Make everyone within a certain radius panic.
			
			// Play a sound.
			if (sound && (sound_played_count < max_sound_count || max_sound_count === 0)) {
				FlxG.play(sound, 0.6);
				sound_played_count++;
			}
			
			// Do the callback.
			if (callback !== null) {
				callback(this, npc);
			}
		}
		
		// Syncs the position of the hitbox to the host.
		private function syncPosition():void {
			x = (host.facing === FlxObject.LEFT) ? host.left - width - host_offset.x : host.right + host_offset.x;
			y = host.top + host_offset.y;
			
			x += host.velocity.x * FlxG.elapsed;
			y += host.velocity.y * FlxG.elapsed;
		}
		
		// Before update.
		override public function beforeUpdate():void {
			super.beforeUpdate();
			
			// Only sync position if we're not a projectile.
			if (!is_projectile) {
				syncPosition();
			}
		}
		
		// After update.
		override public function afterUpdate():void {
			super.afterUpdate();
			live_time += FlxG.elapsed;
			
			// Get rid of ourselves once we hit our duration.
			if (live_time >= duration && duration > 0.0) {
				Game.level.hitboxes.remove(this.sprite);
			}
		}
		
	}
	
}
