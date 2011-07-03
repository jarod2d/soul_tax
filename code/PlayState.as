//
// The main state of the game in which the gameplay actually happens.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		
		// The player object.
		public var player:Player;
		
		// The current level.
		public var level:Level;
		
		override public function create():void {
			super.create();
			
			// Create the player.
			player = new Player();
			
			// Create the level.
			level = new Level("test");
			
			FlxG.log(level.width + ", " + level.t_width + ", " + level.t_height);
			
			// Set up the camera and bounds.
			FlxG.worldBounds = FlxG.camera.bounds = new FlxRect(0, 0, level.width, level.height);
			FlxG.camera.follow(player.sprite);
			
			// Add everything to the scene.
			add(level.bg_tiles);
			add(level.wall_tiles);
			add(player.sprite);
		}
		
		override public function update():void {
			super.update();
			
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
		}
		
	}
	
}
