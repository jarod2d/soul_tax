//
// The main state of the game in which the gameplay actually happens.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		
		public var player:Player;
		
		override public function create():void {
			super.create();
			
			// Create the player.
			player = new Player();
			
			// Add everything to the scene.
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
