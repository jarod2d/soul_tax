//
// The second game state after the MainMenuState. Lets users select a level, then sends them to the PlayState.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class LevelSelectState extends FlxState {
		
		// Some numbers related to key repeating.
		private static const KeyRepeatThreshold:Number = 0.44;
		private static const KeyRepeatRate:Number      = 0.05;
		
		// Some metrics for the various components of the screen.
		private static const ScreenPaddingX:Number = 10.0;
		private static const ScreenPaddingY:Number = 18.0;
		private static const TitleHeight:Number    = 48.0;
		private static const IconSize:Number       = 32.0;
		private static const IconPaddingX:Number   = 12.0;
		private static const IconPaddingY:Number   = 22.0;
		
		// The level icons and the numbers that go on top of them.
		public var icons:FlxGroup;
		public var icon_numbers:FlxGroup;
		public var level_scores:FlxGroup;
		
		// We have a little highlight that goes behind the selected icon to show the player which icon is selected.
		public var icon_highlight:FlxSprite;
		
		// The text at the bottom of the screen that displays the current level's name.
		public var level_name:FlxText;
		
		// We want a ghost sprite to follow the player's selection in the menu. To do that we use a bit of a hack (okay,
		// a pretty big hack) and create our own temporary player who follows an invisible NPC, because NPC following
		// behavior is already created for gameplay.
		private var ghost:Player;
		private var bait:NPC;
		
		// The number of levels in each row.
		private var levels_per_row:int;
		
		// Timers for key repeating.
		private var button_held_time:Number;
		private var repeat_time:Number;
		
		override public function create():void {
			super.create();
			
			// Initialize some crap.
			icons        = new FlxGroup();
			icon_numbers = new FlxGroup();
			level_scores = new FlxGroup();
			button_held_time = repeat_time = 0.0;
			
			// We need to restrict the camera because it tries to follow the ghost.
			FlxG.camera.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
			
			// Set a boring background color for now until we can make something better.
			FlxG.bgColor = 0xFF33353A;
			
			// Figure out how many levels we can have per row and how to position them.
			levels_per_row              = Math.floor((FlxG.width - ScreenPaddingX * 2 + IconPaddingX) / (IconSize + IconPaddingX));
			var screen_padding_x:Number = (FlxG.width - levels_per_row * (IconSize + IconPaddingX) + IconPaddingX) / 2.0;
			
			// Set up the title text.
			var title:FlxText = new FlxText(0, ScreenPaddingY, FlxG.width, "Level Select");
			title.setFormat("propomin", 24, 0xFFE0E2E4, "center", 0xFF001118);
			
			// Create the text for the level title.
			level_name = new FlxText(0, 42.0, FlxG.width, "");
			level_name.setFormat("propomin", 16, 0xFFC0C2C4, "center", 0xFF000508);
			
			// Set up the icon highlight.
			icon_highlight = new FlxSprite();
			icon_highlight.makeGraphic(IconSize + 2.0, IconSize + 2.0, 0xFF11AAEE);
			icon_highlight.alpha = 0.75;
			
			// Create the icons.
			var scores:Array = LevelProgress.scores;
			var row:int      = 0;
			
			for (var i:int = 0; i < Level.levels.length; i++) {
				var col:int      = i % levels_per_row;
				var alpha:Number = (i <= LevelProgress.levels_completed) ? 1.0 : 0.45;
				
				// Create the icon.
				var icon:FlxSprite = new FlxSprite(screen_padding_x + col * (IconSize + IconPaddingX), ScreenPaddingY + TitleHeight + row * (IconSize + IconPaddingY));
				icon.makeGraphic(IconSize, IconSize, 0xFF606468);
				icon.alpha = alpha;
				icons.add(icon);
				
				// Create the number.
				var number:FlxText = new FlxText(icon.x - 1.0, icon.y + 9.0, icon.width, String(i + 1));
				number.setFormat("propomin", 16, 0xFFCCDDEE, "center", 0xFF001122);
				number.alpha = alpha;
				icon_numbers.add(number);
				
				// Add score data if necessary.
				if (i < LevelProgress.levels_completed && scores[i]) {
					// The time icon.
					level_scores.add(new FlxSprite(icon.x - 2.0, icon.y + icon.height + 4.0, Assets.clock_icon));
					
					// The time text.
					var time:FlxText = new FlxText(icon.x + 3.0, icon.y + icon.height + 2.0, icon.width, MathUtil.formatNumber(scores[i].time, 1));
					time.setFormat("propomin", 8, 0xFFE0E2E4, "left");
					level_scores.add(time);
					
					// Bonus kills text.
					if (scores[i].bonus_kills > 0) {
						var bonus_kills:FlxText = new FlxText(icon.x - 3.0, icon.y + icon.height + 2.0, icon.width + 7.0, scores[i].bonus_kills);
						bonus_kills.setFormat("propomin", 8, 0xFFDD2222, "right");
						level_scores.add(bonus_kills);
					}
				}
				
				// Move to the next row if necessary.
				if (col === levels_per_row - 1) {
					row++;
				}
			}
			
			// Add the keyboard instruction graphics and labels.
			var select_label:FlxText  = new FlxText(58.0, FlxG.height - 38.0, 200.0, "Select");
			select_label.setFormat("propomin", 8, 0xFFE0E2E4, "left", 0xFF000A10);
			
			var confirm_label:FlxText = new FlxText(6.0, FlxG.height - 38.0, 200.0, "Continue");
			confirm_label.setFormat("propomin", 8, 0xFFE0E2E4, "left", 0xFF000A10);
			
			var esdf_keys:FlxSprite = new FlxSprite(54.0, FlxG.height - 27.0, Assets.esdf_keys);
			var j_key:FlxSprite     = new FlxSprite(21.0, FlxG.height - 22.0, Assets.j_key);
			
			// Set up our hacky ghost following stuff.
			ghost = new Player();
			ghost.max_velocity.x = ghost.max_velocity.y = 90.0;
			bait  = new NPC("businessman", 0.0, 0.0);
			ghost.potential_victim = bait;
			ghost.possess();
			ghost.color = Player.NormalColor;
			
			// Set the initial selection.
			selectLevel(Game.current_level);
			
			// Add everything.
			add(title);
			add(icon_highlight);
			add(icons);
			add(icon_numbers);
			add(level_scores);
			add(ghost.trails);
			add(ghost.sprite);
			add(select_label);
			add(confirm_label);
			add(esdf_keys);
			add(j_key);
			add(level_name);
			
			// Play the level select music.
			if (FlxG.music) {
				FlxG.music.stop();
				FlxG.music = null;
			}
			
			FlxG.playMusic(Assets.level_select_music, 0.32);
		}
		
		// Selects the given level, moving the selection.
		public function selectLevel(level_index:int):void {
			Game.current_level = MathUtil.mod(level_index, Level.levels.length);
			
			// Move the NPC bait and selection highlight.
			var icon_position:FlxPoint = levelIconPosition(Game.current_level);
			bait.x = icon_position.x;
			bait.y = icon_position.y;
			icon_highlight.x = icon_position.x - IconSize / 2.0 - 1.0;
			icon_highlight.y = icon_position.y - IconSize / 2.0 - 1.0;
			
			// Set the level's name.
			level_name.text = (Game.current_level < Level.levels.length) ? Level.levels[Game.current_level].name : "";
		}
		
		// Moves the selection in the given direction (FlxObject.LEFT, etc). This is a pretty nasty function, and I'm
		// sure there's an easier way to do this, but I'm hella tired right now.
		public function moveSelection(direction:int):void {
			var new_index:int        = Game.current_level;
			var level_count:int      = Level.levels.length;
			var levels_completed:int = LevelProgress.levels_completed;
			
			// Figure out our new level index.
			if (direction === FlxObject.UP) {
				if (new_index - levels_per_row < 0) {
					while (new_index + levels_per_row <= levels_completed) {
						new_index += levels_per_row;
					}
				}
				else {
					new_index -= levels_per_row;
				}
			}
			else if (direction === FlxObject.RIGHT) {
				new_index = MathUtil.mod(new_index + 1, Math.min(levels_completed + 1, level_count));
			}
			else if (direction === FlxObject.DOWN) {
				new_index += levels_per_row;
				
				if (new_index > levels_completed) {
					new_index %= levels_per_row;
				}
			}
			else if (direction === FlxObject.LEFT) {
				new_index = MathUtil.mod(new_index - 1, Math.min(levels_completed + 1, level_count));
			}
			
			// Play the selection sound.
			if (new_index !== Game.current_level) {
				FlxG.play(Assets.menu_select_sound, 0.75);
			}
			
			selectLevel(new_index);
		}
		
		// Returns the center point of the icon for the given level index. Depends on the icons already being generated.
		private function levelIconPosition(level_index:int):FlxPoint {
			level_index        = MathUtil.mod(level_index, Level.levels.length);
			var icon:FlxSprite = icons.members[level_index];
			
			return new FlxPoint(icon.x + icon.width / 2.0, icon.y + icon.height / 2.0);
		}
		
		// Update.
		override public function update():void {
			// Move on to the play state.
			if (FlxG.keys.SPACE || FlxG.keys.ENTER || FlxG.keys.J) {
				FlxG.play(Assets.menu_confirm_sound).survive = true;
				FlxG.switchState(new PlayState());
				return;
			}
			
			// Reset or increment button held time.
			button_held_time = (!Game.input.key("move_left") && !Game.input.key("move_right")) ? 0.0 : button_held_time + FlxG.elapsed;
			
			// Move the selection.
			// TODO: Clean this crap up.
			if (Game.input.justPressed("move_up")) {
				moveSelection(FlxObject.UP);
			}
			else if (Game.input.justPressed("move_left")) {
				moveSelection(FlxObject.LEFT);
			}
			else if (Game.input.justPressed("move_down")) {
				moveSelection(FlxObject.DOWN);
			}
			else if (Game.input.justPressed("move_right")) {
				moveSelection(FlxObject.RIGHT);
			}
			else if (button_held_time >= KeyRepeatThreshold) {
				repeat_time += FlxG.elapsed;
				
				if (repeat_time >= KeyRepeatRate) {
					if (Game.input.key("move_up")) {
						moveSelection(FlxObject.UP);
					}
					else if (Game.input.key("move_left")) {
						moveSelection(FlxObject.LEFT);
					}
					else if (Game.input.key("move_down")) {
						moveSelection(FlxObject.DOWN);
					}
					else if (Game.input.key("move_right")) {
						moveSelection(FlxObject.RIGHT);
					}
					
					repeat_time = 0.0;
				}
			}
			else {
				repeat_time = 0.0;
			}
			
			super.update();
		}
		
	}
	
}
