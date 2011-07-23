//
// Represents a level in the game. It contains the level's tilemaps, props and NPCs.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
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
			["Death", "right", "You have failed!!!!!!"],
			["Ghost", "left", "Nooooooooooooo!!!!"]
		];
		
		public static var LevelWonDialogue:Array = [
			["Death", "right", "You beat the level!!!!"],
			["Ghost", "left", "Woohooooo!!!!"]
		];
		
		// For convenience, we group all of our tiles here.
		public var contents:FlxGroup;
		
		// We have two tilemaps -- one for the background stuff, and one for the wall and platform tiles on top of the
		// background.
		public var bg_tiles:FlxTilemap;
		public var wall_tiles:FlxTilemap;
		
		// We create a couple sprites around the edge of the level just outside of view to prevent the player from
		// exiting the level.
		public var borders:FlxGroup;
		
		// The list of props in the level.
		public var props:FlxGroup;
		
		// The list of NPCs in the level.
		public var NPCs:FlxGroup;
		
		// The list of hitboxes in the level.
		public var hitboxes:FlxGroup;
		
		// Our gib spawning effect.
		public var gib_emitter:GibEmitter;
		
		// An emitter for the CEO's special attack.
		public var money_emitter:MoneyEmitter;
		
		// An emitter for when glass breaks.
		public var glass_emitter:GlassEmitter;
		
		// A queue of NPCs that have recently been killed and are waiting to be logged as dead.
		public var dying_npcs:Array;
		
		// The level objectives and progress.
		public var objectives:Object;
		public var progress:Object;
		
		// The amount of time remaining in the level.
		public var time_remaining:Number;
		
		// The level's dialogue. The object potentially has two keys -- "start" and "end", which contain the dialogue
		// arrays for the start and the end of the level, respectively.
		public var dialogue:Object;
		
		// Constructor. The level is created based on its index in levels.json, so the first level in the game is 0.
		public function Level(index:uint) {
			// Grab our raw level data.
			var level_data:Object = levels[index];
			
			// Create all of our groups, etc.
			contents      = new FlxGroup();
			bg_tiles      = new FlxTilemap();
			wall_tiles    = new FlxTilemap();
			borders       = new FlxGroup();
			props         = new FlxGroup();
			NPCs          = new FlxGroup();
			hitboxes      = new FlxGroup();
			gib_emitter   = new GibEmitter();
			money_emitter = new MoneyEmitter();
			glass_emitter = new GlassEmitter();
			dying_npcs    = [];
			
			// Create our tilemaps.
			bg_tiles.loadMap(new Assets[level_data.id + "_bg_tiles"], Assets.tiles, TileSize, TileSize, NaN, 1, 1, 2);
			wall_tiles.loadMap(new Assets[level_data.id + "_wall_tiles"], Assets.tiles, TileSize, TileSize, NaN, 1, 1, 2);
			
			// Grab the dialogue.
			dialogue = JSON.decode(new Assets[level_data.id + "_dialogue"]);
			
			// Set up our objectives.
			objectives = level_data.objectives;
			progress   = { bonus: 0 };
			
			for (var npc_type:String in objectives) {
				progress[npc_type] = 0;
			}
			
			time_remaining = level_data.time;
			
			// Set up the props and NPCs.
			var prop_data:Object = JSON.decode(new Assets[level_data.id + "_props"]);
			var i:Number;
			
			// Add props.
			for (i = 0; i < prop_data[0].length; i++) {
				// TODO: Add props.
			}
			
			// Add NPCs and position the player.
			for (i = 0; i < prop_data[1].length; i++) {
				var npc_data:Object = prop_data[1][i];
				
				if (npc_data.id === "player") {
					Game.player.warp(npc_data.x, npc_data.y);
				}
				else {
					NPCs.add(new NPC(npc_data.id, npc_data.x, npc_data.y).sprite);
				}
			}
			
			// Create the borders.
			var border:FlxSprite;
			
			// Top border.
			border = new FlxSprite(0, -BorderSize);
			border.immovable = true;
			border.alpha = 0.0;
			borders.add(border.makeGraphic(width, BorderSize));
			
			// Right border.
			border = new FlxSprite(width, -BorderSize);
			border.immovable = true;
			borders.add(border.makeGraphic(BorderSize, height + BorderSize * 2));
			
			// Bottom border.
			border = new FlxSprite(0, height - TileSize / 2);
			border.immovable = true;
			borders.add(border.makeGraphic(width, BorderSize));
			
			// Left border.
			border = new FlxSprite(-BorderSize, -BorderSize);
			border.immovable = true;
			borders.add(border.makeGraphic(BorderSize, height + BorderSize * 2));
			
			// Group all of the contents of the level.
			contents.add(bg_tiles);
			contents.add(props);
			contents.add(wall_tiles);
			contents.add(borders);
			contents.add(glass_emitter.particles);
			contents.add(gib_emitter.particles);
			contents.add(money_emitter.particles);
			contents.add(NPCs);
			contents.add(hitboxes);
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
			return destroyWall(3, x, y);
		}
		
		// If there's a glass tile at the given coordinates (pixels, not tiles), this will break the glass.
		public function breakGlassAt(x:int, y:int):Boolean {
			// Create a particle effect.
			glass_emitter.spawnGlassAt(x, y);
			
			// Glass can be left- or right-facing, so there are two different tiles we need to check.
			return (destroyWall(4, x, y) || destroyWall(6, x, y));
		}
		
		// A little function that swaps the visual position of the player and the NPCs. That is, if the player is in
		// front of the NPCs (the default), he will be moved behind them, and vice versa. This is necessary for when the
		// player possesses an NPC -- we want him to move to the background.
		public function swapPlayerAndNPCs():void {
			var members:Array    = contents.members;
			var npc_index:int    = members.indexOf(NPCs);
			var trails_index:int = members.indexOf(Game.player.trails);
			var player_index:int = members.indexOf(Game.player.sprite);
			
			if (npc_index < player_index) {
				members[npc_index]    = Game.player.trails;
				members[trails_index] = Game.player.sprite;
				members[player_index] = NPCs;
			}
			else {
				members[trails_index] = NPCs;
				members[player_index] = Game.player.trails;
				members[npc_index]    = Game.player.sprite;
			}
		}
		
		// Queues the given NPC, who should have just been killed, to be counted towards the player's progress after
		// playing a dying animation.
		public function queueDeadNPC(dead_npc:NPC):void {
			// Put the dead NPC in the queue.
			dying_npcs.push(dead_npc);
			
			// Tell the UI to spawn a ghost.
			Game.ui.kill_counter.spawnGhost(dead_npc);
		}
		
		// Updates the progress of the player in the level by counting the given NPC as a kill. You probably shouldn't
		// call this method directly -- it's meant to be called by way of queueDeadNPC.
		public function updateProgress(dead_npc:NPC):void {
			// Remove the NPC from the dying queue if necessary.
			var index:int = dying_npcs.indexOf(dead_npc);
			
			if (index >= 0) {
				dying_npcs.splice(index, 1);
			}
			
			// Increment the appropriate progress counter.
			progress[dead_npc.objective_type]++;
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
		
	}
	
}
