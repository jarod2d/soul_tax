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
		
		// Any special behavior that needs to happen when the hitbox makes contact, for whatever special effects your
		// attack needs. The function takes two parameters, the hitbox and the victim.
		public var callback:Function;
		
		// We keep track of who we've hit so that we don't attack the same NPC twice.
		public var victims:Array;
		
		// Constructor. Everything should be pretty straightforward, except the x_offset and y_offset. 
		public function HitBox(host:Entity, x_offset:Number, y_offset:Number, width:Number, height:Number) {
			super();
			
			this.host   = host;
			host_offset = new FlxPoint(x_offset, y_offset);
			live_time   = 0.0;
			victims     = [];
			
			sprite.makeGraphic(width, height, 0xCCEEAA11);
			sprite.alpha = 0.0;
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
			// We don't want to attack the NPC who spawned the hitbox, or NPCs that we've already attacked.
			if (npc === host || victims.indexOf(npc) >= 0) {
				return;
			}
			
			// Do damage to the victim.
			npc.hurt(damage);
			
			// Do some knockback.
			if (knockback > 0.0) {
				npc.knockback_velocity.x = npc.center.x - host.center.x;
				npc.knockback_velocity.y = npc.center.y - (host.center.y + 1.0);
				
				MathUtil.normalize(npc.knockback_velocity);
				
				npc.knockback_velocity.x *= knockback;
				npc.knockback_velocity.y *= knockback;
			}
			
			// Make note that we've attacked this victim.
			victims.push(npc);
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
			syncPosition();
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
