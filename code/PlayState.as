//
// The main state of the game in which the gameplay actually happens.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		
		override public function create():void {
			super.create();
			
			// Set the background color.
			FlxG.bgColor = 0xFFBBDDFF;
			
			// Create the player.
			var player:Player = Game.player = new Player();
			
			// Create the level.
			var level:Level = Game.level = new Level(0);
			
			// Create the UI.
			var ui:UI = Game.ui = new UI();
			
			// Set up the camera and bounds.
			var border_size:int = Level.BorderSize;	
			FlxG.camera.bounds  = new FlxRect(0, 0, level.width, level.height - Level.TileSize / 2);
			FlxG.worldBounds    = new FlxRect(-border_size, -border_size, level.width + border_size * 2, level.height + border_size * 2);
			FlxG.camera.follow(player.sprite);
			
			// Add everything to the scene.
			add(level.contents);
			add(ui.contents);
		}
		
		override public function update():void {
			super.update();
			
			var player:Player = Game.player;
			var level:Level   = Game.level;
			
			// Count down the level timer, and end the level if necessary.
			Game.level.time_remaining -= FlxG.elapsed;
			
			// TODO: End the level.
			
			// Process player input. We handle some input differently based on whether the player is possessing an NPC.
			// We start with basic player movement, most of which will work regardless of whether or not the player is
			// possessing someone.
			player.direction.x = player.direction.y = 0.0;
			
			if (FlxG.keys.E) {
				player.direction.y -= 1.0;
			}
			if (FlxG.keys.F) {
				player.direction.x += 1.0;
			}
			if (FlxG.keys.D) {
				player.direction.y += 1.0;
			}
			if (FlxG.keys.S) {
				player.direction.x -= 1.0;
			}
			
			// Possess or unpossess.
			if (FlxG.keys.justPressed("SPACE")) {
				(player.victim) ? player.stopPossessing() : player.possess();
			}
			
			// Attack.
			if (FlxG.keys.justPressed("J")) {
				player.punchAttack();
			}
			else if (FlxG.keys.justPressed("K")) {
				player.knockbackAttack();
			}
			
			// Perform collisions.
			if (player.victim) {
				FlxG.collide(player.victim.sprite, level.borders);
				FlxG.collide(player.victim.sprite, level.NPCs);
			}
			else {
				FlxG.collide(player.sprite, level.borders);
			}
			
			FlxG.collide(level.NPCs, level.wall_tiles);
			
			// Handle hitbox collisions.
			FlxG.overlap(level.NPCs, level.hitboxes, function(npc_sprite:EntitySprite, hb_sprite:EntitySprite):void {
				var npc:NPC   = npc_sprite.entity as NPC;
				var hb:HitBox = hb_sprite.entity as HitBox;
				
				// Flixel has a very strange bug at the moment where it will give you a bunch of false overlaps in some
				// cases. In order to get around this, we do our own stupid overlap detection before trying to attack
				// the npc.
				if ((hb.left < npc.right && hb.right >= npc.left) && (hb.top < npc.bottom && hb.bottom >= npc.top)) {
					hb.attackNPC(npc);
				}
			});
			
			// Controls and behavior that is specific to possession or non-possession goes here.
			if (player.victim) {
				// Jump.
				if (FlxG.keys.justPressed("E")) {
					player.victim.jump();
				}
			}
			else {
				// Set the possessable NPC.
				player.potential_victim = null;
				
				FlxG.overlap(player.sprite, level.NPCs, function(a:FlxObject, b:FlxObject):void {
					player.potential_victim = (b as EntitySprite).entity as NPC;
				});
			}
		}
		
	}
	
}
