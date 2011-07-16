//
// The second game state after the MainMenuState. Lets users select a level, then sends them to the PlayState.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class LevelSelectState extends FlxState {
		
		// Some numbers related to key repeating.
		private static const KeyRepeatThreshold:Number = 0.38;
		private static const KeyRepeatRate:Number      = 0.04;
		
		// Some metrics for the various components of the screen.
		private static const ScreenPaddingX:Number = 10.0;
		private static const ScreenPaddingY:Number = 18.0;
		private static const TitleHeight:Number    = 38.0;
		private static const IconSize:Number       = 32.0;
		private static const IconPaddingX:Number   = 12.0;
		private static const IconPaddingY:Number   = 22.0;
		
		// The level icons and the numbers that go on top of them.
		public var icons:FlxGroup;
		public var icon_numbers:FlxGroup;
		
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
			button_held_time = repeat_time = 0.0;
			
			// We need to restrict the camera because it tries to follow the ghost.
			FlxG.camera.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
			
			// Set a boring background color for now until we can make something better.
			FlxG.bgColor = 0xFFBBDDFF;
			
			// Figure out how many levels we can have per row and how to position them.
			levels_per_row              = Math.floor((FlxG.width - ScreenPaddingX * 2 + IconPaddingX) / (IconSize + IconPaddingX));
			var screen_padding_x:Number = (FlxG.width - levels_per_row * (IconSize + IconPaddingX) + IconPaddingX) / 2.0;
			
			// Set up the title text.
			var title:FlxText = new FlxText(0, ScreenPaddingY, FlxG.width, "Level Select");
			title.setFormat("propomin", 24, 0xE0F0FF, "center", 0xFF112244);
			
			// Set up the icon highlight.
			icon_highlight = new FlxSprite();
			icon_highlight.makeGraphic(IconSize + 4, IconSize + 4, 0xFF11AAEE);
			icon_highlight.alpha = 0.75;
			
			// Create the icons.
			var row:int = 0;
			
			for (var i:int = 0; i < Level.levels.length; i++) {
				var col:int = i % levels_per_row;
				
				// Create the icon.
				var icon:FlxSprite = new FlxSprite(screen_padding_x + col * (IconSize + IconPaddingX), ScreenPaddingY + TitleHeight + row * (IconSize + IconPaddingY));
				icon.makeGraphic(IconSize, IconSize, 0xFF445566);
				icons.add(icon);
				
				// Create the number.
				var number:FlxText = new FlxText(icon.x - 1.0, icon.y + 9.0, icon.width, String(i + 1));
				number.setFormat("propomin", 16, 0xCCDDEE, "center", 0xFF001122);
				icon_numbers.add(number);
				
				// Move to the next row if necessary.
				if (col === levels_per_row - 1) {
					row++;
				}
			}
			
			// Add the keyboard instruction graphics.
			var j_key:FlxSprite     = new FlxSprite(66.0, FlxG.height - 22.0, Assets.j_key);
			var esdf_keys:FlxSprite = new FlxSprite(6.0,  FlxG.height - 26.0, Assets.esdf_keys);
			
			// Create the text for the level title at the bottom.
			level_name = new FlxText(0, FlxG.height - 30, FlxG.width, "");
			level_name.setFormat("propomin", 16, 0xFF88A0BB, "center", 0xFF001133);
			
			// Set up our hacky ghost following stuff.
			ghost = new Player();
			ghost.max_velocity.x = ghost.max_velocity.y = 150.0;
			bait  = new NPC("businessman", 0, 0);
			ghost.potential_victim = bait;
			ghost.possess();
			
			// Initially we select the first level. Eventually it should be the latest unlocked level.
			selectLevel(0);
			
			// Add everything.
			add(title);
			add(icon_highlight);
			add(icons);
			add(icon_numbers);
			add(ghost.trails);
			add(ghost.sprite);
			add(j_key);
			add(esdf_keys);
			add(level_name);
		}
		
		// Selects the given level, moving the selection.
		public function selectLevel(level_index:int):void {
			Game.current_level = (level_index + Level.levels.length) % Level.levels.length;
			
			// Move the NPC bait and selection highlight.
			var icon_position:FlxPoint = levelIconPosition(Game.current_level);
			bait.x = icon_position.x;
			bait.y = icon_position.y;
			icon_highlight.x = icon_position.x - IconSize / 2.0 - 2;
			icon_highlight.y = icon_position.y - IconSize / 2.0 - 2;
			
			// Set the level's name.
			level_name.text = (Game.current_level < Level.levels.length) ? Level.levels[Game.current_level].name : "";
		}
		
		// Returns the center point of the icon for the given level index. Depends on the icons already being generated.
		private function levelIconPosition(level_index:int):FlxPoint {
			var icon:FlxSprite = icons.members[level_index];
			
			return new FlxPoint(icon.x + icon.width / 2.0, icon.y + icon.height / 2.0);
		}
		
		// Update.
		override public function update():void {
			// Move on to the play state.
			if (FlxG.keys.SPACE || FlxG.keys.ENTER || FlxG.keys.J) {
				FlxG.switchState(new PlayState());
				return;
			}
			
			// Reset or increment button held time.
			button_held_time = (!FlxG.keys.S && ! FlxG.keys.F) ? 0.0 : button_held_time + FlxG.elapsed;
			
			// Move the selection.
			// TODO: Clean this crap up.
			if (FlxG.keys.justPressed("E")) {
				selectLevel(Game.current_level - levels_per_row);
			}
			else if (FlxG.keys.justPressed("S")) {
				selectLevel(Game.current_level - 1);
			}
			else if (FlxG.keys.justPressed("D")) {
				selectLevel(Game.current_level + levels_per_row);
			}
			else if (FlxG.keys.justPressed("F")) {
				selectLevel(Game.current_level + 1);
			}
			else if (button_held_time >= KeyRepeatThreshold) {
				repeat_time += FlxG.elapsed;
				
				if (repeat_time >= KeyRepeatRate) {
					if (FlxG.keys.S) {
						selectLevel(Game.current_level - 1);
					}
					else if (FlxG.keys.F) {
						selectLevel(Game.current_level + 1);
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
