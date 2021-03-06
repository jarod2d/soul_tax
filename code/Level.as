//
// Represents a level in the game. It contains the level's tilemaps, props and NPCs.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	import flash.utils.*;
	import com.adobe.serialization.json.*;
	
	public class Level {
		
		// The width and height of our tiles.
		public static const TileSize:int = 8;
		
		// The width of our borders. Not really important actually, but we need a value.
		public static const BorderSize:int = 16;
		
		// Stores all of the basic level data for each level in the game.
		public static var levels:Array;
		
		// The dialogue that plays when you fail the level, and the default dialogue (typically overridden) when you
		// beat the level.
		public static var LevelFailedDialogue:Array = [
			["Reaper", "right", "Sorry, buddy. Out of time. Time to go to hell!"],
			["Ghost", "left", "Nooooooooooooo!!!!"]
		];
		
		public static var LevelWonDialogue:Array = [
			["Reaper", "right", "You beat the level!!!!"],
			["Ghost", "left", "Woohooooo!!!!"]
		];
		
		// For convenience, we group all of our tiles here.
		public var contents:FlxGroup;
		
		// Contains the various sprites that make up the level's background.
		public var background:FlxGroup;
		
		// We have two tilemaps -- one for the background stuff, and one for the wall and platform tiles on top of the
		// background.
		public var bg_tiles:FlxTilemap;
		public var wall_tiles:FlxTilemap;
		
		// We create a couple sprites around the edge of the level just outside of view to act as borders, preventing
		// the player from exiting the level. We also keep a second set of borders that doesn't have a bottom border,
		// which is useful for other purposes.
		public var borders:FlxGroup;
		public var bottomless_borders:FlxGroup;
		
		// The list of props in the level. Props can be either in the background or the foreground.
		public var background_props:FlxGroup;
		public var foreground_props:FlxGroup;
		
		// The list of NPCs in the level, as well as a subset of shrunken NPCs.
		public var NPCs:FlxGroup;
		public var shrunk_NPCs:FlxGroup;
		
		// The list of all robot NPCs in the level -- a subset of the NPCs group. They have some special behavior that
		// requires them to be in their own list.
		public var robots:FlxGroup;
		
		// The list of hitboxes in the level.
		public var hitboxes:FlxGroup;
		
		// Our gib spawning effect. Robots have their own because they need different-colored gibs.
		public var gib_emitter:GibEmitter;
		public var robot_gib_emitter:GibEmitter;
		
		// A smoke emitter for robot deaths.
		public var smoke_emitter:SmokeEmitter;
		
		// An emitter for the CEO's special attack.
		public var money_emitter:MoneyEmitter;
		
		// An emitter for when glass breaks.
		public var glass_emitter:GlassEmitter;
		
		// Collection of the "zzz" sprites above NPCs' heads when they fall asleep.
		public var sleep_effects:FlxGroup;
		
		// A queue of NPCs that have recently been killed and are waiting to be logged as dead.
		public var dying_npcs:Array;
		
		// The level objectives and progress.
		public var objectives:Object;
		public var progress:Object;
		
		// The amount of time remaining in the level.
		public var time_remaining:Number;
		
		// The time it took the player to complete the level. The value is zero until the player actually completes the
		// level.
		public var completion_time:Number;
		
		// The level's dialogue. The object potentially has two keys -- "start" and "end", which contain the dialogue
		// arrays for the start and the end of the level, respectively.
		public var dialogue:Object;
		
		// Constructor. The level is created based on its index in levels.json, so the first level in the game is 0.
		public function Level(index:uint) {
			// Grab our raw level data.
			var level_data:Object = levels[index];
			var setting:String    = (level_data.setting) ? level_data.setting : "day";
			
			// Create all of our groups, etc.
			contents           = new FlxGroup();
			background         = new FlxGroup();
			bg_tiles           = new FlxTilemap();
			wall_tiles         = new FlxTilemap();
			borders            = new FlxGroup();
			bottomless_borders = new FlxGroup();
			background_props   = new FlxGroup();
			foreground_props   = new FlxGroup();
			NPCs               = new FlxGroup();
			shrunk_NPCs        = new FlxGroup();
			robots             = new FlxGroup();
			hitboxes           = new FlxGroup();
			gib_emitter        = new GibEmitter();
			robot_gib_emitter  = new GibEmitter(0xFF222222, 40);
			smoke_emitter      = new SmokeEmitter();
			money_emitter      = new MoneyEmitter();
			glass_emitter      = new GlassEmitter();
			sleep_effects      = new FlxGroup();
			dying_npcs         = [];
			
			// Set up the background.
			var clouds:FlxSprite;
			
			if (setting === "day") {
				FlxG.bgColor = 0xFFBBDDFF;
				
				var sun:FlxSprite = new FlxSprite(0.0, -UI.HUDBarHeight * 0.2, Assets.sun_image);
				sun.scrollFactor.y = 0.2;
				
				clouds = new FlxSprite(0.0, FlxG.height - 300.0, Assets.clouds_day_image);
				clouds.scrollFactor.y = 0.5;
				
				background.add(sun);
				background.add(clouds);
			}
			else if (setting === "night") {
				FlxG.bgColor = 0xFF23405E;
				
				var stars:FlxSprite = new FlxSprite(0.0, -UI.HUDBarHeight * 0.125 + 4.0, Assets.stars_image);
				stars.scrollFactor.y = 0.125;
				
				var moon:FlxSprite = new FlxSprite(0.0, -UI.HUDBarHeight * 0.2, Assets.moon_image);
				moon.scrollFactor.y = 0.2;
				
				clouds = new FlxSprite(0.0, FlxG.height - 300.0, Assets.clouds_night_image);
				clouds.scrollFactor.y = 0.5;
				
				background.add(stars);
				background.add(moon);
				background.add(clouds);
			}
			
			// Create our tilemaps.
			bg_tiles.loadMap(new Assets[level_data.id + "_bg_tiles"], Assets[setting + "_tiles"], TileSize, TileSize, NaN, 1, 1, 3);
			wall_tiles.loadMap(new Assets[level_data.id + "_wall_tiles"], Assets[setting + "_tiles"], TileSize, TileSize, NaN, 1, 1, 3);
			
			// Grab the dialogue.
			dialogue = JSON.decode(new Assets[level_data.id + "_dialogue"]);
			
			// Set up our objectives.
			objectives = level_data.objectives;
			progress   = { bonus: 0 };
			
			for (var npc_type:String in objectives) {
				progress[npc_type] = 0;
			}
			
			time_remaining  = base_time;
			completion_time = 0.0;
			
			// Set up the props and NPCs.
			var prop_data:Object = JSON.decode(new Assets[level_data.id + "_props"]);
			var data:Object;
			var i:Number;
			
			// Add props.
			for (i = 0; i < prop_data[0].length; i++) {
				data = prop_data[0][i];
				background_props.add(new FlxSprite(data.x, data.y, Assets[data.id]));
			}
			
			for (i = 0; i < prop_data[2].length; i++) {
				data = prop_data[2][i];
				foreground_props.add(new FlxSprite(data.x, data.y, Assets[data.id]));
			}
			
			// Add NPCs and position the player.
			for (i = 0; i < prop_data[1].length; i++) {
				data = prop_data[1][i];
				
				if (data.id === "player") {
					Game.player.warp(data.x, data.y);
				}
				else {
					var npc:NPC = new NPC(data.id, data.x, data.y);
					NPCs.add(npc.sprite);
					
					// Add robots to their own group. Also adjust their position, because their hitbox doesn't line up
					// perfectly with their sprite.
					if (npc.type.id === "robot") {
						robots.add(npc.sprite);
						npc.y += 2.0;
					}
				}
			}
			
			// Create the borders.
			var border:FlxSprite;
			
			// Top border.
			border = new FlxSprite(0, -BorderSize);
			border.immovable = true;
			border.alpha = 0.0;
			borders.add(border.makeGraphic(width, BorderSize));
			bottomless_borders.add(border);
			
			// Right border.
			border = new FlxSprite(width, -BorderSize);
			border.immovable = true;
			borders.add(border.makeGraphic(BorderSize, height + BorderSize * 2));
			bottomless_borders.add(border);
			
			// Bottom border.
			border = new FlxSprite(0, height - TileSize / 2);
			border.immovable = true;
			borders.add(border.makeGraphic(width, BorderSize));
			
			// Left border.
			border = new FlxSprite(-BorderSize, -BorderSize);
			border.immovable = true;
			borders.add(border.makeGraphic(BorderSize, height + BorderSize * 2));
			bottomless_borders.add(border);
			
			// Group all of the contents of the level.
			contents.add(background);
			contents.add(bg_tiles);
			contents.add(background_props);
			contents.add(wall_tiles);
			contents.add(glass_emitter.particles);
			contents.add(gib_emitter.particles);
			contents.add(robot_gib_emitter.particles);
			contents.add(smoke_emitter.particles);
			contents.add(money_emitter.particles);
			contents.add(sleep_effects);
			contents.add(NPCs);
			contents.add(hitboxes);
			contents.add(foreground_props);
			contents.add(Game.player.trails);
			contents.add(Game.player.sprite);
		}
		
		// Looks at the tile at the given coordinates (pixels, not tiles), checks if it is the same type as tile_type,
		// and if so, destroys that tile and any tiles of the same type that are in a contiguous vertical line with it
		// (or horizontal line the horizontal parameter is true, except it doesn't work yet). This is basically used as
		// a helper function for opening doors and breaking glass. Returns whether or not any wall was destroyed.
		public function destroyWall(tile_type:int, x:int, y:int, horizontal:Boolean = false):Boolean {
			// Convert pixels to tiles.
			x /= Level.TileSize;
			y /= Level.TileSize;
			
			// Smash the tiles!!
			if (wall_tiles.getTile(x, y) === tile_type) {
				// Move to the top of the wall.
				while (wall_tiles.getTile(x, y - 1) === tile_type) {
					y--;
				}
				
				// Now move down the door, smashing as we go.
				while (wall_tiles.getTile(x, y) === tile_type) {
					wall_tiles.setTile(x, y, 0);
					y++;
				}
				
				return true;
			}
			
			return false;
		}
		
		// If there's a door tile at the given coordinates (pixels, not tiles), this will open that door. Returns
		// whether we opened a door or not.
		public function openDoorAt(x:int, y:int):Boolean {
			if (destroyWall(4, x, y)) {
				FlxG.play(Assets.door_open_sound, 0.9);
				
				return true;
			}
			
			return false;
		}
		
		// If there's a glass tile at the given coordinates (pixels, not tiles), this will break the glass.
		public function breakGlassAt(x:int, y:int):Boolean {
			// Create a particle effect.
			glass_emitter.spawnGlassAt(x, y);
			
			// Glass can be left- or right-facing, so there are two different tiles we need to check.
			if (destroyWall(5, x, y) || destroyWall(7, x, y)) {
				var sound:Class = (Math.random() < 0.5) ? Assets.glass_break_1_sound : Assets.glass_break_2_sound;
				FlxG.play(sound, 0.5);
				
				return true;
			}
			
			return false;
		}
		
		// A little function that swaps the visual position of the player and the NPCs. That is, if the player is in
		// front of the NPCs (the default), he will be moved behind them, and vice versa. This is necessary for when the
		// player possesses an NPC -- we want him to move to the background.
		public function swapPlayerAndNPCs():void {
			var members:Array    = contents.members;
			var npc_index:int    = members.indexOf(NPCs);
			var trails_index:int = members.indexOf(Game.player.trails);
			var low_index:int    = (npc_index < trails_index) ? npc_index : trails_index;
			
			if (npc_index < trails_index) {
				members[low_index]     = Game.player.trails;
				members[low_index + 1] = Game.player.sprite;
				members[low_index + 2] = NPCs;
				members[low_index + 3] = hitboxes;
				members[low_index + 4] = foreground_props;
			}
			else {
				members[low_index]     = NPCs;
				members[low_index + 1] = hitboxes;
				members[low_index + 2] = foreground_props;
				members[low_index + 3] = Game.player.trails;
				members[low_index + 4] = Game.player.sprite;
			}
		}
		
		// Queues the given NPC, who should have just been killed, to be counted towards the player's progress after
		// playing a dying animation.
		public function queueDeadNPC(dead_npc:NPC):void {
			// Put the dead NPC in the queue.
			dying_npcs.push(dead_npc);
			
			// Tell the UI to spawn a ghost.
			Game.ui.kill_counter.spawnGhost(dead_npc);
			
			// Play a little flying-away sound after a few moments.
			setTimeout(function():void {
				FlxG.play(Assets.ghost_going_up_sound, 0.215);
			}, 400.0 + 350.0 * Math.random());
		}
		
		// Updates the progress of the player in the level by counting the given NPC as a kill. You probably shouldn't
		// call this method directly -- it's meant to be called by way of queueDeadNPC.
		public function updateProgress(dead_npc:NPC):void {
			// Remove the NPC from the dying queue if necessary.
			var index:int = dying_npcs.indexOf(dead_npc);
			
			if (index >= 0) {
				dying_npcs.splice(index, 1);
			}
			
			// Play the appropriate sound.
			var sound:Class;
			
			if (dead_npc.objective_type === "bonus") {
				sound = (Math.random() < 0.666) ? Assets.bonus_kill_1_sound : Assets.bonus_kill_2_sound;
			}
			else {
				sound = Assets.meter_fill_sound;
			}
			
			FlxG.play(sound, 0.385);
			
			// Increment the appropriate progress counter.
			progress[dead_npc.objective_type]++;
			
			// If the level is complete, show the level complete message and make note of the time.
			if (objectives_complete && completion_time === 0.0) {
				if (time_remaining > 0.0) {
					Game.ui.level_complete_message.setAll("alpha", 1.0);
				}
				
				completion_time = base_time - Math.max(0.0, time_remaining);
			}
		}
		
		// A getter for whether or not the player has completed all of their objectives.
		public function get objectives_complete():Boolean {
			for (var objective:String in objectives) {
				if (progress[objective] < objectives[objective]) {
					return false;
				}
			}
			
			return true;
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
		
		// Getter for the level's base time based on the difficulty.
		public function get base_time():Number {
			return (Game.difficulty === Game.HardDifficulty) ? levels[Game.current_level].hard_time : levels[Game.current_level].normal_time;
		}
		
	}
	
}
