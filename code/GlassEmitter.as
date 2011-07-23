//
// Another emitter, this time for a breaking-glass effect.
// 
// Created by Jarod Long on 7/22/2011.
//

package {
	
	import org.flixel.*;
	
	public class GlassEmitter extends Emitter {
		
		// Constructor.
		public function GlassEmitter() {
			super();
			
			// Create all the particles.
			createParticles(80, [0xFF8DA9B4], new Range(1, 3));
			
			// Set up the particle motion.
			velocity.min = 75.0;
			velocity.max = 190.0;
			drag.min     = 140.0;
			drag.max     = 180.0;
		}
		
		// Emits a bunch of glass for the window at the given location. Automatically detects the size of the window. If
		// there's no window there, nothing happens.
		public function spawnGlassAt(x:Number, y:Number):void {
			var wall_tiles:FlxTilemap = Game.level.wall_tiles;
			
			// Convert to tiles.
			x /= Level.TileSize;
			y /= Level.TileSize;
			
			// Figure out if we have a window at all, and if so, which type it is.
			var window_type:int = wall_tiles.getTile(x, y);
			
			// Set our bounds to match the window's.
			if (window_type === 4 || window_type === 6) {
				// Move to the top of the window.
				while (wall_tiles.getTile(x, y - 1) === window_type) {
					y--;
				}
				
				// Set the position.
				setPosition(x * Level.TileSize, y * Level.TileSize);
				
				// Modify the horizontal position based on the type.
				if (window_type === 4) {
					this.x += Level.TileSize;
				}
				
				// Now move to the bottom of the window.
				while (wall_tiles.getTile(x, y) === window_type) {
					y++;
				}
				
				// Set the width and height.
				width  = Level.TileSize / 2.0;
				height = this.y * Level.TileSize - y;
				
				// Emit.
				emit(40, 1.75);
			}
		}
		
	}
	
}
