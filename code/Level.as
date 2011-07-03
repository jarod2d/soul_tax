//
// Represents a level in the game. It contains the level's tilemaps, props and NPCs.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class Level {
		
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
			bg_tiles.loadMap(new Assets.TestBGTiles, Assets.Tiles, 8, 8, NaN, 1, 1, 2);
			wall_tiles.loadMap(new Assets.TestWallTiles, Assets.Tiles, 8, 8, NaN, 1, 1, 2);
		}
		
	}
	
}
