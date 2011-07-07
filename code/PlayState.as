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
			
			// Create the player.
			var player:Player = Game.player = new Player();
			
			// Create the level.
			var level:Level = Game.level = new Level("test");
			
			// Set up the camera and bounds.
			var border_size:int = Level.BorderSize;	
			FlxG.camera.bounds  = new FlxRect(0, 0, level.width, level.height - Level.TileSize / 2);
			FlxG.worldBounds    = new FlxRect(-border_size, -border_size, level.width + border_size * 2, level.height + border_size * 2);
			FlxG.camera.follow(player.sprite);
			
			// Add everything to the scene.
			add(level.contents);
		}
		
		override public function update():void {
			super.update();
			
			var player:Player = Game.player;
			var level:Level   = Game.level;
			
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
			
			// Perform collisions.
			FlxG.collide(player.sprite, level.borders);
			FlxG.collide(level.NPCs, level.wall_tiles);
			
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
