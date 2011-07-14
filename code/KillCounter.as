//
// A UI widget that displays the user's kill counts.
// 
// Created by Jarod Long on 7/10/2011.
//

package {
	
	import org.flixel.*;
	
	public class KillCounter extends FlxGroup {
		
		// Some metrics for the meters.
		private static const MeterWidth:Number   = 56.0;
		private static const MeterHeight:Number  = 2.0;
		private static const MeterMarginX:Number = 4.0;
		private static const MeterMarginY:Number = 10.0;
		private static const MetersPerRow:int    = 6;
		
		// How fast the ghosts move towards the meters.
		private static const GhostVelocity:Number     = 250.0;
		private static const GhostAcceleration:Number = 160.0;
		
		// Each type of NPC that needs to be killed gets a meter. Each meter goes in this group.
		public var meters:FlxGroup;
		
		// These are the components of the labels for each meter.
		public var meter_icons:FlxGroup;
		public var meter_labels:FlxGroup;
		
		// Displays some text for bonus kills.
		public var bonus_label:FlxText;
		public var bonus_value:FlxText;
		
		// When an NPC dies, we create a ghost sprite at their corpse and animate it up to the meter. We have an array
		// of plain objects, each of which contains the ghost sprite and some information necessary for the animation to
		// complete. The FlxGroup contains just the sprites like a normal FlxGroup.
		public var ghosts:Array;
		public var ghost_sprites:FlxGroup;
		
		// Constructor.
		public function KillCounter() {
			super();
			
			meters        = new FlxGroup();
			meter_icons   = new FlxGroup();
			meter_labels  = new FlxGroup();
			ghosts        = [];
			ghost_sprites = new FlxGroup();
			
			// Get a sorted list of objective keys so that the meters maintain a consistent display order.
			var objective_keys:Array = [];
			
			for (var npc_type:String in Game.level.objectives) {
				objective_keys.push(npc_type);
			}
			
			objective_keys.sort();
			
			// Create the objective meters and their labels.
			var meter_position:FlxPoint = new FlxPoint(4.0, 3.0);
			var row_count:int           = 0;
			
			for each (var npc_type:String in objective_keys) {
				// Create the meter.
				var npc_data:Object = NPC.types[npc_type];
				var color:uint      = (npc_data && npc_data.color) ? npc_data.color : 0xFFCCCCCC;
				var meter:Meter     = new Meter(Game.level.progress, npc_type, Game.level.objectives, npc_type, meter_position.x, meter_position.y, MeterWidth, MeterHeight, color);
				meters.add(meter);
				
				// Create the icon.
				var icon:FlxSprite;
				
				if (npc_type === "any") {
					icon = new FlxText(meter.x - 1, meter.y + MeterHeight + 1.0, MeterWidth + 4.0, "any").setFormat("propomin", 8, 0xFFFFFFFF, "left", 0xFF111111);
				}
				else {
					icon = new FlxSprite(meter.x + 2.0, meter.y + MeterHeight + 4.0, Assets[npc_type + "_icon"]);
				}
				
				icon.scrollFactor.x = icon.scrollFactor.y = 0.0;
				meter_icons.add(icon);
				
				// Create the label.
				var label:FlxText = new FlxText(meter.x - 1, meter.y + MeterHeight + 1.0, MeterWidth + 4.0, "0/0").setFormat("propomin", 8, 0xFFFFFFEE, "right", 0xFF111111);
				label.scrollFactor.x = label.scrollFactor.y = 0.0;
				meter_labels.add(label);
				
				// Move the meter position.
				meter_position.x += MeterWidth + MeterMarginX;
				row_count++;
				
				if (row_count === 3) {
					meter_position.x += 36.0;
				}
				
				if (row_count === MetersPerRow) {
					meter_position.x  = 4.0;
					meter_position.y += MeterHeight + MeterMarginY + 2.0;
					row_count = 0;
				}
			}
			
			// Set up the bonus text.
			var bonus_y:Number = meter_position.y;
			
			if (row_count > 0) {
				bonus_y += MeterHeight + MeterMarginY;
			}
			
			bonus_label = new FlxText(3.0, bonus_y, FlxG.width, "bonus:").setFormat("propomin", 8, 0xFFEEEEE0, "left", 0xFF332222);
			bonus_value = new FlxText(34.0, bonus_y, FlxG.width, "0").setFormat("propomin", 8, 0xFFEEEE66, "left", 0xFF442222);
			bonus_label.scrollFactor.x = bonus_label.scrollFactor.y = bonus_value.scrollFactor.x = bonus_value.scrollFactor.y = 0.0;
			bonus_label.alpha = bonus_value.alpha = 0.0;
			
			// Add everything.
			add(meters);
			add(meter_icons);
			add(meter_labels);
			add(ghost_sprites);
			add(bonus_label);
			add(bonus_value);
		}
		
		// When an NPC dies, we animate their ghost up to their meter.
		public function spawnGhost(dead_npc:NPC):void {
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
			if (dead_npc.objective_type === "bonus") {
				ghost_data.destination = new FlxPoint(bonus_value.x, bonus_value.y);
			}
			else {
				for each (var meter:Meter in meters.members) {
					if (meter.value_property === dead_npc.objective_type) {
						// TODO: This is a bit of a problem. We don't actually update the level progress until the ghost
						// reaches the meter, and which meter we move towards depends on the current progress. Thus if
						// you have, say, 1 businessman left to kill and 5 of any, and you kill 2 businessmen
						// simultaneously, both will fly towards the businessman meter.
						// 
						// Not a HUGE deal I guess because the score is still counted properly, but it still sucks.
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
				ghost.kill();
				ghosts.pop();
				Game.level.updateProgress(dead_npc);
			}
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			var i:int;
			
			// Check to see if any ghosts have reached their destination.
			for (i = 0; i < ghosts.length; i++) {
				var ghost_data:Object = ghosts[i];
				
				if (ghost_data.sprite.y <= ghost_data.destination.y) {
					// Show the bonus text if necessary and update the progress.
					if (ghost_data.npc.objective_type === "bonus") {
						bonus_label.alpha = bonus_value.alpha = 1.0;
					}
					
					Game.level.updateProgress(ghost_data.npc);
					
					// Destroy the ghost.
					ghost_data.sprite.kill();
					ghosts.splice(i, 1);
					ghost_sprites.remove(ghost_data.sprite);
					
					i--;
				}
			}
			
			// Update the meter labels.
			for (i = 0; i < meters.length; i++) {
				var meter:Meter     = meters.members[i];
				var label:FlxText   = meter_labels.members[i];
				var npc_type:String = meter.value_property;
				var progress:int    = Game.level.progress[npc_type];
				var objective:int   = Game.level.objectives[npc_type];
				
				label.text  = progress + "/" + objective;
				
				if (progress >= objective) {
					label.color = 0xFFFFCC55;
				}
			}
			
			// Update the bonus value.
			bonus_value.text = Game.level.progress.bonus;
		}
		
	}
	
}
