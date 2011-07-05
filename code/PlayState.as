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
			add(player.trails);
			add(player.sprite);
		}
		
		override public function update():void {
			super.update();
			
			var player:Player = Game.player;
			var level:Level   = Game.level;
			
			// Process player input.
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
			
			// Perform collisions.
			FlxG.collide(player.sprite, level.borders);
			FlxG.collide(level.NPCs, level.wall_tiles);
		}
		
	}
	
}
