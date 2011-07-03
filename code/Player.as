//
// The player class. It's important!
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class Player extends Entity {
		
		// The various colors the player character changes to.
		private static const NormalColor:uint     = 0x55DDFF;
		private static const PossessionColor:uint = 0xDDAAEE;
		
		public function Player() {
			super();
			
			// Load the player sprite.
			sprite.loadGraphic(Assets.GhostSprite, true, true, 4, 15);
			
			// Set up animations.
			sprite.addAnimation("float", [0, 1, 2, 3, 4, 5, 6, 7], 20);
			sprite.play("float");
			
			// Set up the player's basic stats.
			max_speed    = new FlxPoint(100.0, 100.0);
			acceleration = new FlxPoint(280.0, 280.0);
			
			// Set the player's default color and opacity.
			sprite.color = NormalColor;
			sprite.alpha = 0.8;
		}
		
	}
	
}
