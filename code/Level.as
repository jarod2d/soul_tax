//
// Represents a level in the game. It contains the level's tilemaps, props and NPCs.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class Level {
		
		// The width and height of our tiles.
		public static const TileSize:int = 8;
		
		// We have two tilemaps -- one for the background stuff, and one for the wall and platform tiles on top of the
		// background.
		public var bg_tiles:FlxTilemap;
		public var wall_tiles:FlxTilemap;
		
		// Constructor. The level is created based on its name, which corresponds to the tilemap filenames.
		public function Level(name:String) {
			// Create the tilemaps.
			bg_tiles   = new FlxTilemap();
			wall_tiles = new FlxTilemap();
			
			// TEMP: Hardcode the tiles. We'll need to fetch the tiles based on the name eventually.
			bg_tiles.loadMap(new Assets.TestBGTiles, Assets.Tiles, TileSize, TileSize, NaN, 1, 1, 2);
			wall_tiles.loadMap(new Assets.TestWallTiles, Assets.Tiles, TileSize, TileSize, NaN, 1, 1, 2);
		}
		
		// Getters for the width and height, in tiles and pixels.
		public function get width():Number {
			return bg_tiles.width - TileSize;
		}
		
		public function get height():Number {
			return bg_tiles.height;
		}
		
		public function get t_width():int {
			// For some reason the width Flixel gives us is off by one.
			return bg_tiles.widthInTiles - 1;
		}
		
		public function get t_height():int {
			return bg_tiles.heightInTiles;
		}
		
	}
	
}
