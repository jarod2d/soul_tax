//
// A UI widget that displays the user's kill counts.
// 
// Created by Jarod Long on 7/10/2011.
//

package {
	
	import org.flixel.*;
	
	public class KillCounter extends FlxGroup {
		
		// Some metrics for the meters.
		private static const MeterWidth:Number  = 40.0;
		private static const MeterHeight:Number = 3.0;
		private static const MeterMargin:Number = 4.0;
		
		// How fast the ghosts move towards the meters.
		private static const GhostVelocity:Number     = 250.0;
		private static const GhostAcceleration:Number = 160.0;
		
		// Each type of NPC that needs to be killed gets a meter. Each meter goes in this group.
		public var meters:FlxGroup;
		
		// When an NPC dies, we create a ghost sprite at their corpse and animate it up to the meter. We have an array
		// of plain objects, each of which contains the ghost sprite and some information necessary for the animation to
		// complete. The FlxGroup contains just the sprites like a normal FlxGroup.
		public var ghosts:Array;
		public var ghost_sprites:FlxGroup;
		
		// Constructor.
		public function KillCounter() {
			super();
			
			meters        = new FlxGroup();
			ghosts        = [];
			ghost_sprites = new FlxGroup();
			
			// Create the objective meters.
			var meter_position:FlxPoint = new FlxPoint(4.0, 4.0);
			var row_count:int           = 0;
			
			for (var npc_type:String in Game.level.objectives) {
				var npc_data:Object = NPC.types[npc_type];
				var color:uint      = (npc_data && npc_data.color) ? npc_data.color : 0xFFCCCCCC;
				var meter:Meter     = new Meter(Game.level.progress, npc_type, Game.level.objectives, npc_type, meter_position.x, meter_position.y, MeterWidth, 3.0, color);
				meters.add(meter);
				
				meter_position.x += MeterWidth + MeterMargin;
				row_count++;
				
				meter_position
			}
			
			// Add everything.
			add(meters);
			add(ghost_sprites);
		}
		
		// When an NPC dies, we animate their ghost up to their meter.
		public function spawnGhost(dead_npc:NPC):void {
			// Figure out which meter we're going towards.
			
			// Figure out where the ghost should be in screen coordinates and create it. We need to make the ghost's
			// scroll factor 0 in order to make it part of the UI, so we put the ghost in screen coordinates.
			var ghost:FlxSprite = new FlxSprite(dead_npc.x - FlxG.camera.scroll.x, dead_npc.y - FlxG.camera.scroll.y);
			ghost.scrollFactor.x = ghost.scrollFactor.y = 0.0;
			ghost.maxVelocity.x  = ghost.maxVelocity.y  = GhostVelocity;
//			ghost.color = dead_npc.type.color
			ghost.alpha = 0.75;
			
			ghost.loadGraphic(Assets.ghost_sprite, true, true, 4, 15);
			ghost.addAnimation("float", [0, 1, 2, 3, 4, 5, 6, 7], 20);
			ghost.play("float");
			
			ghost_sprites.add(ghost);
			
			// Store the ghost data.
			var ghost_data:Object = {
				sprite: ghost,
				npc: dead_npc
			};
			
			ghosts.push(ghost_data);
			
			// Make the ghost move towards their meter.
			FlxG.log(dead_npc.objective_type);
			
			if (dead_npc.objective_type === "bonus") {
				// TODO: Fly towards the bonus text.
			}
			else {
				for each (var meter:Meter in meters.members) {
					if (meter.value_property === dead_npc.objective_type) {
						ghost_data.destination = meter.center;
						
						break;
					}
				}
			}
			
			// Accelerate the ghost towards their meter. If, somehow, the ghost didn't get a destination, get rid of it.
			// That should never happen though.
			if (ghost_data.destination) {
				ghost.acceleration.x = ghost_data.destination.x - ghost.x;
				ghost.acceleration.y = ghost_data.destination.y - ghost.y;
				
				MathUtil.normalize(ghost.acceleration);
				
				ghost.acceleration.x *= GhostAcceleration;
				ghost.acceleration.y *= GhostAcceleration;
			}
			else {
				ghost.kill()
				ghosts.pop();
				Game.level.updateProgress(dead_npc);
			}
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// Check to see if any ghosts have reached their destination.
			for (var i:int = 0; i < ghosts.length; i++) {
				var ghost_data:Object = ghosts[i];
				
				if (ghost_data.sprite.y <= ghost_data.destination.y) {
					ghost_data.sprite.kill();
					ghosts.splice(i, 1);
					ghost_sprites.remove(ghost_data.sprite);
					// TODO: Major problem! We don't update the progress until the ghost reaches the meter, but which
					// meter a ghost counts towards depends on the current progress. Thus if you have, say, 1
					// businessman left to kill and 5 of any, and you kill 2 businessmen simultaneously, both will fly
					// towards the businessman meter.
					// 
					// Actually not a HUGE deal I guess because the score should still be counted properly, but it still
					// sucks.
					Game.level.updateProgress(ghost_data.npc);
					
					i--;
				}
			}
		}
		
	}
	
}
