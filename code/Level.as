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
		
		// The width of our borders. Not really important actually, but we need a value.
		public static const BorderSize:int = 16;
		
		// For convenience, we group all of our tiles here.
		public var tiles:FlxGroup;
		
		// We have two tilemaps -- one for the background stuff, and one for the wall and platform tiles on top of the
		// background.
		public var bg_tiles:FlxTilemap;
		public var wall_tiles:FlxTilemap;
		
		// We create a couple sprites around the edge of the level just outside of view to prevent the player from
		// exiting the level.
		public var borders:FlxGroup;
		
		// Constructor. The level is created based on its name, which corresponds to the tilemap filenames.
		public function Level(name:String) {
			// Create the tilemaps and groups.
			bg_tiles   = new FlxTilemap();
			wall_tiles = new FlxTilemap();
			borders    = new FlxGroup();
			tiles      = new FlxGroup();
			
			// TEMP: Hardcode the tiles. We'll need to fetch the tiles based on the name eventually.
			bg_tiles.loadMap(new Assets.TestBGTiles, Assets.Tiles, TileSize, TileSize, NaN, 1, 1, 2);
			wall_tiles.loadMap(new Assets.TestWallTiles, Assets.Tiles, TileSize, TileSize, NaN, 1, 1, 2);
			
			// Create the borders.
			var border:FlxSprite;
			
			// Top border.
			border = new FlxSprite(0, -BorderSize);
			border.immovable = true;
			borders.add(border.makeGraphic(width, BorderSize));
			
			// Right border.
			border = new FlxSprite(width, -BorderSize);
			border.immovable = true;
			borders.add(border.makeGraphic(BorderSize, height + BorderSize * 2));
			
			// Bottom border.
			border = new FlxSprite(0, height);
			border.immovable = true;
			borders.add(border.makeGraphic(width, BorderSize));
			
			// Left border.
			border = new FlxSprite(-BorderSize, -BorderSize);
			border.immovable = true;
			borders.add(border.makeGraphic(BorderSize, height + BorderSize * 2));
			
			// Group the tilemaps.
			tiles.add(bg_tiles);
			tiles.add(wall_tiles);
			tiles.add(borders);
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
