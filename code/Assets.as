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
		[Embed(source="../fonts/monomin_6x5.ttf", fontName="monomin",  embedAsCFF="false")] private var monomin_font:Class;
		[Embed(source="../fonts/propomin_5.ttf",  fontName="propomin", embedAsCFF="false")] private var propomin_font:Class;
		
		// Miscellaneous images.
		[Embed(source="../images/sa_gamedev_logo.png")] public static var sa_gamedev_logo:Class;
		
		// Character sprites.
		[Embed(source="../images/ghost.png")] public static var ghost_sprite:Class;
		[Embed(source="../images/bank_manager.png")] public static var bank_manager_sprite:Class;
		[Embed(source="../images/burglar.png")] public static var burglar_sprite:Class;
		[Embed(source="../images/businessman.png")] public static var businessman_sprite:Class;
		[Embed(source="../images/ceo.png")] public static var ceo_sprite:Class;
		[Embed(source="../images/maintenance_guy.png")] public static var maintenance_guy_sprite:Class;
		[Embed(source="../images/old_lady.png")] public static var old_lady_sprite:Class;
		[Embed(source="../images/robot.png")] public static var robot_sprite:Class;
		[Embed(source="../images/security_guard.png")] public static var security_guard_sprite:Class;
		[Embed(source="../images/superhero.png")] public static var superhero_sprite:Class;
		[Embed(source="../images/supervillain.png")] public static var supervillain_sprite:Class;
		
		// Character icons.
		[Embed(source="../images/bank_manager_icon.png")] public static var bank_manager_icon:Class;
		[Embed(source="../images/burglar_icon.png")] public static var burglar_icon:Class;
		[Embed(source="../images/businessman_icon.png")] public static var businessman_icon:Class;
		[Embed(source="../images/ceo_icon.png")] public static var ceo_icon:Class;
		[Embed(source="../images/maintenance_guy_icon.png")] public static var maintenance_guy_icon:Class;
		[Embed(source="../images/old_lady_icon.png")] public static var old_lady_icon:Class;
		[Embed(source="../images/robot_icon.png")] public static var robot_icon:Class;
		[Embed(source="../images/security_guard_icon.png")] public static var security_guard_icon:Class;
		[Embed(source="../images/superhero_icon.png")] public static var superhero_icon:Class;
		[Embed(source="../images/supervillain_icon.png")] public static var supervillain_icon:Class;
		
		// Tiles.
		[Embed(source="../images/tiles.png")] public static var tiles:Class;
		
		// Game data.
		[Embed(source="../game_data/levels.json", mimeType="application/octet-stream")] public static var level_data:Class;
		[Embed(source="../game_data/npcs.json", mimeType="application/octet-stream")] public static var npc_data:Class;
		
		// Level data.
		[Embed(source="../levels/test.0.csv", mimeType="application/octet-stream")] public static var test_bg_tiles:Class;
		[Embed(source="../levels/test.1.csv", mimeType="application/octet-stream")] public static var test_wall_tiles:Class;
		[Embed(source="../levels/test.props.json", mimeType="application/octet-stream")] public static var test_props:Class;
		
		[Embed(source="../levels/tiny.0.csv", mimeType="application/octet-stream")] public static var tiny_bg_tiles:Class;
		[Embed(source="../levels/tiny.1.csv", mimeType="application/octet-stream")] public static var tiny_wall_tiles:Class;
		[Embed(source="../levels/tiny.props.json", mimeType="application/octet-stream")] public static var tiny_props:Class;
		
		// Processes some of the loaded data. Should be called once at the beginning of the game.
		public static function load():void {
			// Load the level data.
			Level.levels = JSON.decode(new level_data);
			
			// Load the NPC data.
			NPC.types = JSON.decode(new npc_data);
			
			// The colors in the NPC data need to be parsed from strings to ints.
			for each (var npc:Object in NPC.types) {
				if (npc.color) {
					npc.color = uint(npc.color);
				}
			}
		}
		
	}
	
}
