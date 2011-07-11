//
// Our asset management class. All of our assets are contained as static variables here so we can easily access them
// from anywhere.
// 
// Note that a lot of the assets here follow strict naming conventions -- in particular, the level data and character
// sprites. If you don't follow the same general naming format, your stuff probably won't work.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	import com.adobe.serialization.json.*;
	
	public class Assets {
		
		// Fonts.
		[Embed(source="../fonts/monomin_6x5.ttf", fontName="monomin",  embedAsCFF="false")] private var MonominFont:Class;
		[Embed(source="../fonts/propomin_5.ttf",  fontName="propomin", embedAsCFF="false")] private var PropominFont:Class;
		
		// Character sprites.
		[Embed(source="../images/ghost.png")] public static var GhostSprite:Class;
		[Embed(source="../images/businessman.png")] public static var BusinessmanSprite:Class;
		[Embed(source="../images/maintenance_guy.png")] public static var MaintenanceGuySprite:Class;
		
		// Tiles.
		[Embed(source="../images/tiles.png")] public static var Tiles:Class;
		
		// Level data.
		[Embed(source="../levels/levels.json", mimeType="application/octet-stream")] public static var LevelData:Class;
		
		[Embed(source="../levels/test.0.csv", mimeType="application/octet-stream")] public static var TestBGTiles:Class;
		[Embed(source="../levels/test.1.csv", mimeType="application/octet-stream")] public static var TestWallTiles:Class;
		[Embed(source="../levels/test.props.json", mimeType="application/octet-stream")] public static var TestProps:Class;
		
		[Embed(source="../levels/tiny.0.csv", mimeType="application/octet-stream")] public static var TinyBGTiles:Class;
		[Embed(source="../levels/tiny.1.csv", mimeType="application/octet-stream")] public static var TinyWallTiles:Class;
		[Embed(source="../levels/tiny.props.json", mimeType="application/octet-stream")] public static var TinyProps:Class;
		
		// Processes some of the loaded data. Should be called once at the beginning of the game.
		public static function load():void {
			// Load the level data.
			Level.levels = JSON.decode(new LevelData);
		}
		
	}
	
}
