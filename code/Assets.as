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
		[Embed(source="../images/clock_icon.png")] public static var clock_icon:Class;
		[Embed(source="../images/j_key.png")] public static var j_key:Class;
		[Embed(source="../images/esdf_keys.png")] public static var esdf_keys:Class;
		
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
		
		// Character portraits.
		[Embed(source="../images/ghost_portrait.png")] public static var ghost_portrait:Class;
		[Embed(source="../images/bank_manager_portrait.png")] public static var bank_manager_portrait:Class;
		[Embed(source="../images/burglar_portrait.png")] public static var burglar_portrait:Class;
		[Embed(source="../images/businessman_portrait.png")] public static var businessman_portrait:Class;
		[Embed(source="../images/ceo_portrait.png")] public static var ceo_portrait:Class;
		[Embed(source="../images/maintenance_guy_portrait.png")] public static var maintenance_guy_portrait:Class;
		[Embed(source="../images/old_lady_portrait.png")] public static var old_lady_portrait:Class;
		[Embed(source="../images/robot_portrait.png")] public static var robot_portrait:Class;
		[Embed(source="../images/security_guard_portrait.png")] public static var security_guard_portrait:Class;
		[Embed(source="../images/superhero_portrait.png")] public static var superhero_portrait:Class;
		[Embed(source="../images/supervillain_portrait.png")] public static var supervillain_portrait:Class;
		
		// Projectile images.
		[Embed(source="../images/bullet.png")] public static var bullet_sprite:Class;
		[Embed(source="../images/laser.png")] public static var laser_sprite:Class;
		
		// Tiles.
		[Embed(source="../images/tiles.png")] public static var tiles:Class;
		
		// Music.
		[Embed(source="../audio/title_screen.mp3")] public static var title_screen_music:Class;
		[Embed(source="../audio/level_select.mp3")] public static var level_select_music:Class;
		[Embed(source="../audio/level_start.mp3")] public static var level_start_music:Class;
		[Embed(source="../audio/level_won.mp3")] public static var level_won_music:Class;
		[Embed(source="../audio/level_failed.mp3")] public static var level_failed_music:Class;
		[Embed(source="../audio/main_theme.mp3")] public static var main_theme_music:Class;
		
		// Game data.
		[Embed(source="../game_data/levels.json", mimeType="application/octet-stream")] public static var level_data:Class;
		[Embed(source="../game_data/npcs.json", mimeType="application/octet-stream")] public static var npc_data:Class;
		
		// Level data.
		[Embed(source="../levels/ceo_assassination.0.csv", mimeType="application/octet-stream")] public static var ceo_assassination_bg_tiles:Class;
		[Embed(source="../levels/ceo_assassination.1.csv", mimeType="application/octet-stream")] public static var ceo_assassination_wall_tiles:Class;
		[Embed(source="../levels/ceo_assassination.props.json", mimeType="application/octet-stream")] public static var ceo_assassination_props:Class;
		[Embed(source="../levels/ceo_assassination.dialogue.json", mimeType="application/octet-stream")] public static var ceo_assassination_dialogue:Class;
		
		[Embed(source="../levels/basement.0.csv", mimeType="application/octet-stream")] public static var basement_bg_tiles:Class;
		[Embed(source="../levels/basement.1.csv", mimeType="application/octet-stream")] public static var basement_wall_tiles:Class;
		[Embed(source="../levels/basement.props.json", mimeType="application/octet-stream")] public static var basement_props:Class;
		[Embed(source="../levels/basement.dialogue.json", mimeType="application/octet-stream")] public static var basement_dialogue:Class;
		
		[Embed(source="../levels/superhero_massacre.0.csv", mimeType="application/octet-stream")] public static var superhero_massacre_bg_tiles:Class;
		[Embed(source="../levels/superhero_massacre.1.csv", mimeType="application/octet-stream")] public static var superhero_massacre_wall_tiles:Class;
		[Embed(source="../levels/superhero_massacre.props.json", mimeType="application/octet-stream")] public static var superhero_massacre_props:Class;
		[Embed(source="../levels/superhero_massacre.dialogue.json", mimeType="application/octet-stream")] public static var superhero_massacre_dialogue:Class;
		
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
