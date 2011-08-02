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
		[Embed(source="../images/wasd_keys.png")] public static var wasd_keys:Class;
		[Embed(source="../images/zzz.png")] public static var zzz_sprite:Class;
		
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
		[Embed(source="../images/reaper_portrait.png")] public static var reaper_portrait:Class;
		[Embed(source="../images/prop_copier_portrait.png")] public static var copier_portrait:Class;
		
		// Projectile images.
		[Embed(source="../images/bullet.png")] public static var bullet_sprite:Class;
		[Embed(source="../images/laser.png")] public static var laser_sprite:Class;
		
		// Tiles.
		[Embed(source="../images/tiles.png")] public static var day_tiles:Class;
		[Embed(source="../images/tiles_night.png")] public static var night_tiles:Class;
		
		// Background images.
		[Embed(source="../images/sun.png")] public static var sun_image:Class;
		[Embed(source="../images/moon.png")] public static var moon_image:Class;
		[Embed(source="../images/stars.png")] public static var stars_image:Class;
		[Embed(source="../images/clouds_day.png")] public static var clouds_day_image:Class;
		[Embed(source="../images/clouds_night.png")] public static var clouds_night_image:Class;
		
		// Props.
		[Embed(source="../images/prop_chair.png")] public static var chair_prop:Class;
		[Embed(source="../images/prop_copier.png")] public static var copier_prop:Class;
		[Embed(source="../images/prop_desk.png")] public static var desk_prop:Class;
		[Embed(source="../images/prop_painting_1.png")] public static var painting_1_prop:Class;
		[Embed(source="../images/prop_painting_2.png")] public static var painting_2_prop:Class;
		[Embed(source="../images/prop_painting_3.png")] public static var painting_3_prop:Class;
		[Embed(source="../images/prop_plant.png")] public static var plant_prop:Class;
		[Embed(source="../images/prop_teller.png")] public static var teller_prop:Class;
		
		// Music.
		[Embed(source="../audio/title_screen.mp3")] public static var title_screen_music:Class;
		[Embed(source="../audio/level_select.mp3")] public static var level_select_music:Class;
		[Embed(source="../audio/level_start.mp3")] public static var level_start_music:Class;
		[Embed(source="../audio/level_won.mp3")] public static var level_won_music:Class;
		[Embed(source="../audio/level_failed.mp3")] public static var level_failed_music:Class;
		[Embed(source="../audio/main_theme.mp3")] public static var main_theme_music:Class;
		
		// Sounds.
		[Embed(source="../audio/block_break_1.mp3")] public static var block_break_1_sound:Class;
		[Embed(source="../audio/block_break_2.mp3")] public static var block_break_2_sound:Class;
		[Embed(source="../audio/bonus_kill_1.mp3")] public static var bonus_kill_1_sound:Class;
		[Embed(source="../audio/bonus_kill_2.mp3")] public static var bonus_kill_2_sound:Class;
		[Embed(source="../audio/ceo_vomit.mp3")] public static var ceo_vomit_sound:Class;
		[Embed(source="../audio/dialogue_blip.mp3")] public static var dialogue_blip_sound:Class;
		[Embed(source="../audio/dialogue_confirm.mp3")] public static var dialogue_confirm_sound:Class;
		[Embed(source="../audio/door_open.mp3")] public static var door_open_sound:Class;
		[Embed(source="../audio/drill.mp3")] public static var drill_sound:Class;
		[Embed(source="../audio/female_yell.mp3")] public static var female_yell_sound:Class;
		[Embed(source="../audio/ghost_flying.mp3")] public static var ghost_flying_sound:Class;
		[Embed(source="../audio/ghost_going_up.mp3")] public static var ghost_going_up_sound:Class;
		[Embed(source="../audio/glass_break_1.mp3")] public static var glass_break_1_sound:Class;
		[Embed(source="../audio/glass_break_2.mp3")] public static var glass_break_2_sound:Class;
		[Embed(source="../audio/gun.mp3")] public static var gun_sound:Class;
		[Embed(source="../audio/jump.mp3")] public static var jump_sound:Class;
		[Embed(source="../audio/kick_miss_1.mp3")] public static var kick_miss_1_sound:Class;
		[Embed(source="../audio/kick_miss_2.mp3")] public static var kick_miss_2_sound:Class;
		[Embed(source="../audio/knockback_1.mp3")] public static var knockback_1_sound:Class;
		[Embed(source="../audio/knockback_2.mp3")] public static var knockback_2_sound:Class;
		[Embed(source="../audio/level_end.mp3")] public static var level_end_sound:Class;
		[Embed(source="../audio/menu_confirm.mp3")] public static var menu_confirm_sound:Class;
		[Embed(source="../audio/menu_select.mp3")] public static var menu_select_sound:Class;
		[Embed(source="../audio/meter_fill.mp3")] public static var meter_fill_sound:Class;
		[Embed(source="../audio/npc_death_1.mp3")] public static var npc_death_1_sound:Class;
		[Embed(source="../audio/npc_death_2.mp3")] public static var npc_death_2_sound:Class;
		[Embed(source="../audio/npc_death_fancy_1.mp3")] public static var npc_death_fancy_1_sound:Class;
		[Embed(source="../audio/npc_death_fancy_2.mp3")] public static var npc_death_fancy_2_sound:Class;
		[Embed(source="../audio/old_lady_jabber.mp3")] public static var old_lady_jabber_sound:Class;
		[Embed(source="../audio/possess.mp3")] public static var possess_sound:Class;
		[Embed(source="../audio/punch_hit_1.mp3")] public static var punch_hit_1_sound:Class;
		[Embed(source="../audio/punch_hit_2.mp3")] public static var punch_hit_2_sound:Class;
		[Embed(source="../audio/punch_hit_3.mp3")] public static var punch_hit_3_sound:Class;
		[Embed(source="../audio/punch_miss_1.mp3")] public static var punch_miss_1_sound:Class;
		[Embed(source="../audio/punch_miss_2.mp3")] public static var punch_miss_2_sound:Class;
		[Embed(source="../audio/robot_aggro.mp3")] public static var robot_aggro_sound:Class;
		[Embed(source="../audio/select.mp3")] public static var select_sound:Class;
		[Embed(source="../audio/shrink_hit_1.mp3")] public static var shrink_hit_1_sound:Class;
		[Embed(source="../audio/shrink_hit_2.mp3")] public static var shrink_hit_2_sound:Class;
		[Embed(source="../audio/shrink_hit_3.mp3")] public static var shrink_hit_3_sound:Class;
		[Embed(source="../audio/shrink_ray.mp3")] public static var shrink_ray_sound:Class;
		[Embed(source="../audio/stop_possess.mp3")] public static var stop_possess_sound:Class;
		[Embed(source="../audio/superhero_special.mp3")] public static var superhero_special_sound:Class;
		[Embed(source="../audio/timer_countdown.mp3")] public static var timer_countdown_sound:Class;
		
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
		
		[Embed(source="../levels/superhero_intro.0.csv", mimeType="application/octet-stream")] public static var superhero_intro_bg_tiles:Class;
		[Embed(source="../levels/superhero_intro.1.csv", mimeType="application/octet-stream")] public static var superhero_intro_wall_tiles:Class;
		[Embed(source="../levels/superhero_intro.props.json", mimeType="application/octet-stream")] public static var superhero_intro_props:Class;
		[Embed(source="../levels/superhero_intro.dialogue.json", mimeType="application/octet-stream")] public static var superhero_intro_dialogue:Class;
		
		[Embed(source="../levels/bullseye.0.csv", mimeType="application/octet-stream")] public static var bullseye_bg_tiles:Class;
		[Embed(source="../levels/bullseye.1.csv", mimeType="application/octet-stream")] public static var bullseye_wall_tiles:Class;
		[Embed(source="../levels/bullseye.props.json", mimeType="application/octet-stream")] public static var bullseye_props:Class;
		[Embed(source="../levels/bullseye.dialogue.json", mimeType="application/octet-stream")] public static var bullseye_dialogue:Class;
		
		[Embed(source="../levels/kill_dudes.0.csv", mimeType="application/octet-stream")] public static var kill_dudes_bg_tiles:Class;
		[Embed(source="../levels/kill_dudes.1.csv", mimeType="application/octet-stream")] public static var kill_dudes_wall_tiles:Class;
		[Embed(source="../levels/kill_dudes.props.json", mimeType="application/octet-stream")] public static var kill_dudes_props:Class;
		[Embed(source="../levels/kill_dudes.dialogue.json", mimeType="application/octet-stream")] public static var kill_dudes_dialogue:Class;
		
		[Embed(source="../levels/float.0.csv", mimeType="application/octet-stream")] public static var float_bg_tiles:Class;
		[Embed(source="../levels/float.1.csv", mimeType="application/octet-stream")] public static var float_wall_tiles:Class;
		[Embed(source="../levels/float.props.json", mimeType="application/octet-stream")] public static var float_props:Class;
		[Embed(source="../levels/float.dialogue.json", mimeType="application/octet-stream")] public static var float_dialogue:Class;
		
		[Embed(source="../levels/vomit_tower.0.csv", mimeType="application/octet-stream")] public static var vomit_tower_bg_tiles:Class;
		[Embed(source="../levels/vomit_tower.1.csv", mimeType="application/octet-stream")] public static var vomit_tower_wall_tiles:Class;
		[Embed(source="../levels/vomit_tower.props.json", mimeType="application/octet-stream")] public static var vomit_tower_props:Class;
		[Embed(source="../levels/vomit_tower.dialogue.json", mimeType="application/octet-stream")] public static var vomit_tower_dialogue:Class;
		
		[Embed(source="../levels/window_tutorial.0.csv", mimeType="application/octet-stream")] public static var window_tutorial_bg_tiles:Class;
		[Embed(source="../levels/window_tutorial.1.csv", mimeType="application/octet-stream")] public static var window_tutorial_wall_tiles:Class;
		[Embed(source="../levels/window_tutorial.props.json", mimeType="application/octet-stream")] public static var window_tutorial_props:Class;
		[Embed(source="../levels/window_tutorial.dialogue.json", mimeType="application/octet-stream")] public static var window_tutorial_dialogue:Class;
		
		[Embed(source="../levels/kill_dudes_2.0.csv", mimeType="application/octet-stream")] public static var kill_dudes_2_bg_tiles:Class;
		[Embed(source="../levels/kill_dudes_2.1.csv", mimeType="application/octet-stream")] public static var kill_dudes_2_wall_tiles:Class;
		[Embed(source="../levels/kill_dudes_2.props.json", mimeType="application/octet-stream")] public static var kill_dudes_2_props:Class;
		[Embed(source="../levels/kill_dudes_2.dialogue.json", mimeType="application/octet-stream")] public static var kill_dudes_2_dialogue:Class;
		
		[Embed(source="../levels/supervillain_intro.0.csv", mimeType="application/octet-stream")] public static var supervillain_intro_bg_tiles:Class;
		[Embed(source="../levels/supervillain_intro.1.csv", mimeType="application/octet-stream")] public static var supervillain_intro_wall_tiles:Class;
		[Embed(source="../levels/supervillain_intro.props.json", mimeType="application/octet-stream")] public static var supervillain_intro_props:Class;
		[Embed(source="../levels/supervillain_intro.dialogue.json", mimeType="application/octet-stream")] public static var supervillain_intro_dialogue:Class;
		
		[Embed(source="../levels/maze.0.csv", mimeType="application/octet-stream")] public static var maze_bg_tiles:Class;
		[Embed(source="../levels/maze.1.csv", mimeType="application/octet-stream")] public static var maze_wall_tiles:Class;
		[Embed(source="../levels/maze.props.json", mimeType="application/octet-stream")] public static var maze_props:Class;
		[Embed(source="../levels/maze.dialogue.json", mimeType="application/octet-stream")] public static var maze_dialogue:Class;
		
		[Embed(source="../levels/ceo_intro.0.csv", mimeType="application/octet-stream")] public static var ceo_intro_bg_tiles:Class;
		[Embed(source="../levels/ceo_intro.1.csv", mimeType="application/octet-stream")] public static var ceo_intro_wall_tiles:Class;
		[Embed(source="../levels/ceo_intro.props.json", mimeType="application/octet-stream")] public static var ceo_intro_props:Class;
		[Embed(source="../levels/ceo_intro.dialogue.json", mimeType="application/octet-stream")] public static var ceo_intro_dialogue:Class;
		
		[Embed(source="../levels/arches.0.csv", mimeType="application/octet-stream")] public static var arches_bg_tiles:Class;
		[Embed(source="../levels/arches.1.csv", mimeType="application/octet-stream")] public static var arches_wall_tiles:Class;
		[Embed(source="../levels/arches.props.json", mimeType="application/octet-stream")] public static var arches_props:Class;
		[Embed(source="../levels/arches.dialogue.json", mimeType="application/octet-stream")] public static var arches_dialogue:Class;
		
		[Embed(source="../levels/cops_and_robbers.0.csv", mimeType="application/octet-stream")] public static var cops_and_robbers_bg_tiles:Class;
		[Embed(source="../levels/cops_and_robbers.1.csv", mimeType="application/octet-stream")] public static var cops_and_robbers_wall_tiles:Class;
		[Embed(source="../levels/cops_and_robbers.props.json", mimeType="application/octet-stream")] public static var cops_and_robbers_props:Class;
		[Embed(source="../levels/cops_and_robbers.dialogue.json", mimeType="application/octet-stream")] public static var cops_and_robbers_dialogue:Class;
		
		[Embed(source="../levels/kill_dudes_3.0.csv", mimeType="application/octet-stream")] public static var kill_dudes_3_bg_tiles:Class;
		[Embed(source="../levels/kill_dudes_3.1.csv", mimeType="application/octet-stream")] public static var kill_dudes_3_wall_tiles:Class;
		[Embed(source="../levels/kill_dudes_3.props.json", mimeType="application/octet-stream")] public static var kill_dudes_3_props:Class;
		[Embed(source="../levels/kill_dudes_3.dialogue.json", mimeType="application/octet-stream")] public static var kill_dudes_3_dialogue:Class;
		
		[Embed(source="../levels/window_washers.0.csv", mimeType="application/octet-stream")] public static var window_washers_bg_tiles:Class;
		[Embed(source="../levels/window_washers.1.csv", mimeType="application/octet-stream")] public static var window_washers_wall_tiles:Class;
		[Embed(source="../levels/window_washers.props.json", mimeType="application/octet-stream")] public static var window_washers_props:Class;
		[Embed(source="../levels/window_washers.dialogue.json", mimeType="application/octet-stream")] public static var window_washers_dialogue:Class;
		
		[Embed(source="../levels/shrink.0.csv", mimeType="application/octet-stream")] public static var shrink_bg_tiles:Class;
		[Embed(source="../levels/shrink.1.csv", mimeType="application/octet-stream")] public static var shrink_wall_tiles:Class;
		[Embed(source="../levels/shrink.props.json", mimeType="application/octet-stream")] public static var shrink_props:Class;
		[Embed(source="../levels/shrink.dialogue.json", mimeType="application/octet-stream")] public static var shrink_dialogue:Class;
		
		[Embed(source="../levels/burglar_intro.0.csv", mimeType="application/octet-stream")] public static var burglar_intro_bg_tiles:Class;
		[Embed(source="../levels/burglar_intro.1.csv", mimeType="application/octet-stream")] public static var burglar_intro_wall_tiles:Class;
		[Embed(source="../levels/burglar_intro.props.json", mimeType="application/octet-stream")] public static var burglar_intro_props:Class;
		[Embed(source="../levels/burglar_intro.dialogue.json", mimeType="application/octet-stream")] public static var burglar_intro_dialogue:Class;
		
		[Embed(source="../levels/robot_intro.0.csv", mimeType="application/octet-stream")] public static var robot_intro_bg_tiles:Class;
		[Embed(source="../levels/robot_intro.1.csv", mimeType="application/octet-stream")] public static var robot_intro_wall_tiles:Class;
		[Embed(source="../levels/robot_intro.props.json", mimeType="application/octet-stream")] public static var robot_intro_props:Class;
		[Embed(source="../levels/robot_intro.dialogue.json", mimeType="application/octet-stream")] public static var robot_intro_dialogue:Class;
		
		[Embed(source="../levels/old_lady_intro.0.csv", mimeType="application/octet-stream")] public static var old_lady_intro_bg_tiles:Class;
		[Embed(source="../levels/old_lady_intro.1.csv", mimeType="application/octet-stream")] public static var old_lady_intro_wall_tiles:Class;
		[Embed(source="../levels/old_lady_intro.props.json", mimeType="application/octet-stream")] public static var old_lady_intro_props:Class;
		[Embed(source="../levels/old_lady_intro.dialogue.json", mimeType="application/octet-stream")] public static var old_lady_intro_dialogue:Class;
		
		[Embed(source="../levels/level1_copier.0.csv", mimeType="application/octet-stream")] public static var level1_copier_bg_tiles:Class;
		[Embed(source="../levels/level1_copier.1.csv", mimeType="application/octet-stream")] public static var level1_copier_wall_tiles:Class;
		[Embed(source="../levels/level1_copier.props.json", mimeType="application/octet-stream")] public static var level1_copier_props:Class;
		[Embed(source="../levels/level1_copier.dialogue.json", mimeType="application/octet-stream")] public static var level1_copier_dialogue:Class;
		
		[Embed(source="../levels/bullseye_2.0.csv", mimeType="application/octet-stream")] public static var bullseye_2_bg_tiles:Class;
		[Embed(source="../levels/bullseye_2.1.csv", mimeType="application/octet-stream")] public static var bullseye_2_wall_tiles:Class;
		[Embed(source="../levels/bullseye_2.props.json", mimeType="application/octet-stream")] public static var bullseye_2_props:Class;
		[Embed(source="../levels/bullseye_2.dialogue.json", mimeType="application/octet-stream")] public static var bullseye_2_dialogue:Class;
		
		[Embed(source="../levels/final_level.0.csv", mimeType="application/octet-stream")] public static var final_level_bg_tiles:Class;
		[Embed(source="../levels/final_level.1.csv", mimeType="application/octet-stream")] public static var final_level_wall_tiles:Class;
		[Embed(source="../levels/final_level.props.json", mimeType="application/octet-stream")] public static var final_level_props:Class;
		[Embed(source="../levels/final_level.dialogue.json", mimeType="application/octet-stream")] public static var final_level_dialogue:Class;
		
		[Embed(source="../levels/hero_justice.0.csv", mimeType="application/octet-stream")] public static var hero_justice_bg_tiles:Class;
		[Embed(source="../levels/hero_justice.1.csv", mimeType="application/octet-stream")] public static var hero_justice_wall_tiles:Class;
		[Embed(source="../levels/hero_justice.props.json", mimeType="application/octet-stream")] public static var hero_justice_props:Class;
		[Embed(source="../levels/hero_justice.dialogue.json", mimeType="application/octet-stream")] public static var hero_justice_dialogue:Class;
		
		[Embed(source="../levels/level_2.0.csv", mimeType="application/octet-stream")] public static var level_2_bg_tiles:Class;
		[Embed(source="../levels/level_2.1.csv", mimeType="application/octet-stream")] public static var level_2_wall_tiles:Class;
		[Embed(source="../levels/level_2.props.json", mimeType="application/octet-stream")] public static var level_2_props:Class;
		[Embed(source="../levels/level_2.dialogue.json", mimeType="application/octet-stream")] public static var level_2_dialogue:Class;
		
		[Embed(source="../levels/maintenance_guy_intro.0.csv", mimeType="application/octet-stream")] public static var maintenance_guy_intro_bg_tiles:Class;
		[Embed(source="../levels/maintenance_guy_intro.1.csv", mimeType="application/octet-stream")] public static var maintenance_guy_intro_wall_tiles:Class;
		[Embed(source="../levels/maintenance_guy_intro.props.json", mimeType="application/octet-stream")] public static var maintenance_guy_intro_props:Class;
		[Embed(source="../levels/maintenance_guy_intro.dialogue.json", mimeType="application/octet-stream")] public static var maintenance_guy_intro_dialogue:Class;
		
		[Embed(source="../levels/manager_intro.0.csv", mimeType="application/octet-stream")] public static var manager_intro_bg_tiles:Class;
		[Embed(source="../levels/manager_intro.1.csv", mimeType="application/octet-stream")] public static var manager_intro_wall_tiles:Class;
		[Embed(source="../levels/manager_intro.props.json", mimeType="application/octet-stream")] public static var manager_intro_props:Class;
		[Embed(source="../levels/manager_intro.dialogue.json", mimeType="application/octet-stream")] public static var manager_intro_dialogue:Class;
		
		[Embed(source="../levels/security_guard_intro.0.csv", mimeType="application/octet-stream")] public static var security_guard_intro_bg_tiles:Class;
		[Embed(source="../levels/security_guard_intro.1.csv", mimeType="application/octet-stream")] public static var security_guard_intro_wall_tiles:Class;
		[Embed(source="../levels/security_guard_intro.props.json", mimeType="application/octet-stream")] public static var security_guard_intro_props:Class;
		[Embed(source="../levels/security_guard_intro.dialogue.json", mimeType="application/octet-stream")] public static var security_guard_intro_dialogue:Class;
		
		[Embed(source="../levels/kill_dudes_6.0.csv", mimeType="application/octet-stream")] public static var kill_dudes_6_bg_tiles:Class;
		[Embed(source="../levels/kill_dudes_6.1.csv", mimeType="application/octet-stream")] public static var kill_dudes_6_wall_tiles:Class;
		[Embed(source="../levels/kill_dudes_6.props.json", mimeType="application/octet-stream")] public static var kill_dudes_6_props:Class;
		[Embed(source="../levels/kill_dudes_6.dialogue.json", mimeType="application/octet-stream")] public static var kill_dudes_6_dialogue:Class;
		
		[Embed(source="../levels/kill_dudes_4.0.csv", mimeType="application/octet-stream")] public static var kill_dudes_4_bg_tiles:Class;
		[Embed(source="../levels/kill_dudes_4.1.csv", mimeType="application/octet-stream")] public static var kill_dudes_4_wall_tiles:Class;
		[Embed(source="../levels/kill_dudes_4.props.json", mimeType="application/octet-stream")] public static var kill_dudes_4_props:Class;
		[Embed(source="../levels/kill_dudes_4.dialogue.json", mimeType="application/octet-stream")] public static var kill_dudes_4_dialogue:Class;
				
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
