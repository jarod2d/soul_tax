//
// A class that stores all of the player's progress information as they play the game. Handles saving and loading that
// progress as well so that we maintain progress across multiple sessions.
// 
// Created by Jarod Long on 7/26/2011.
//

package {
	
	import org.flixel.*;
	
	public class LevelProgress {
		
		// The Flixel save object that actually stores the data.
		private static var save_data:FlxSave;
		
		// This will load any saved level progress, or create a new progress object if none exists, and return it. You
		// should be using this to get a progress object in most cases rather than creating one yourself.
		public static function load():void {
			save_data = new FlxSave();
			save_data.bind("death_and_taxes_save_data");
			
			// Create the progress object if it doesn't exist already.
			if (!save_data.data.scores) {
				save_data.data.scores = [];
			}
		}
		
		// Forces a save of the currently-stored progress data to disk.
		public static function save():void {
			save_data.flush();
		}
		
		// Marks the current level as completed and stores its score.
		public static function recordCurrentScore():void {
			if (!scores[Game.current_level] || scores[Game.current_level].time > Game.level.completion_time) {
				scores[Game.current_level] = {
					bonus_kills: Game.level.progress.bonus,
					time: Game.level.completion_time
				};
			}
		}
		
		// Resets all of the level progress.
		public static function reset():void {
			if (save_data) {
				save_data.erase();
				save_data.destroy();
				load();
			}
		}
		
		// This class maintains a list of scores for each level that the player has completed. The array is only
		// guaranteed to be as long as the number of levels the player has completed -- in other words, the array will
		// only be the same length as the level list if the player has completed every level.
		// 
		// Each element in the array is a plain object that contains two properties: bonus_kills and time, which contain
		// how many extra kills the player got during the level and the time it took them to complete the level,
		// respectively.
		public static function get scores():Array {
			return save_data.data.scores;
		}
		
		// A getter that the number of levels that the player has completed.
		public static function get levels_completed():int {
			return scores.length;
		}
		
	}
	
}
