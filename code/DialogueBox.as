//
// A UI widget that display's the game's dialogue.
// 
// Created by Jarod Long on 7/15/2011.
//

package {
	
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class DialogueBox extends FlxGroup {
		
		// Some metrics.
		public static const StoryModeHeight:Number = 80.0;
		public static const GameModeHeight:Number  = 34.0;
		public static const StoryModeFontSize:int  = 16;
		public static const GameModeFontSize:int   = 8;
		public static const PaddingX:Number        = 8.0;
		public static const PaddingY:Number        = 3.0;
		public static const NameplateFontSize:int  = 16;
		public static const PortraitMargin:Number  = 30.0;
		
		// Time-related constants.
		public static const ScrollRate:Number     = 0.025;
		public static const FastScrollRate:Number = 0.01;
		public static const AdvancePause:Number   = 0.1;
		
		// The different dialogue modes. This determines the behavior and display of the box. Story mode is your
		// traditional RPG-style dialogue box -- large, with character portraits above it on either side. Game mode is
		// for dialogue that happens during the game. The box is smaller, and the portrait is contained within the box.
		// Also, story mode is modal, while game mode is not.
		public static const NoDialogueMode:int    = 0;
		public static const StoryDialogueMode:int = 1;
		public static const GameDialogueMode:int  = 2;
		
		// The dialogue box's mode.
		public var $mode:int;
		
		// The box's background.
		public var bg:FlxSprite;
		
		// The displayed text for both dialogue modes.
		public var story_text:FlxText;
		public var game_text:FlxText;
		
		// The speaker's nameplate and portrait in story mode.
		public var nameplate:FlxText;
		public var portrait:FlxSprite;
		
		// The portrait used during game mode.
		public var game_mode_portrait:FlxSprite;
		
		// A little helper text that tells the player they can skip the dialogue.
		public var skip_text:FlxText;
		
		// The current dialogue. A dialogue should be a 3 by n array with the first column specifying the name of the
		// speaker, the second column containing the side of the screen the speaker should be on (as in "left" or
		// "right"), and the third column containing the actual line of dialogue.
		public var dialogue:Array;
		
		// Indexes for the current line of dialogue, and the current character within that line.
		public var current_line:int;
		public var current_char:int;
		
		// A callback that gets called when the dialogue is finished.
		public var onEnd:Function;
		
		// The timer for scrolling the text onto the screen, and a timer for keeping track of how long we've been done
		// with a line of dialogue.
		public var scroll_timer:Number;
		public var done_timer:Number;
		
		// Constructor.
		public function DialogueBox() {
			super();
			
			// Set up the background.
			bg = new FlxSprite(0, FlxG.height - StoryModeHeight);
			bg.scrollFactor.x = bg.scrollFactor.y = 0.0;
			bg.makeGraphic(FlxG.width, StoryModeHeight, 0x99000000);
			
			// Set up the texts.
			story_text = new FlxText(PaddingX, bg.y + PaddingY, FlxG.width - PaddingX * 2.0, "");
			story_text.lineSpacing = 4.0;
			story_text.setFormat("propomin", StoryModeFontSize, 0xFFEEFFFF, "left");
			story_text.scrollFactor.x = story_text.scrollFactor.y = 0.0;
			
			game_text = new FlxText(PaddingX + GameModeHeight + 1.0, bg.y + PaddingY, FlxG.width - PaddingX * 2.0 - GameModeHeight - 1.0, "");
			game_text.lineSpacing = 4.0;
			game_text.setFormat("propomin", GameModeFontSize, 0xFFEEFFFF, "left");
			game_text.scrollFactor.x = game_text.scrollFactor.y = 0.0;
			
			skip_text = new FlxText(FlxG.width - PaddingX - 54.0, bg.y - 10.0, 60.0, "Enter: Skip");
			skip_text.setFormat("propomin", 8, 0xFFFAFAFA, "left", 0xFF222222);
			skip_text.scrollFactor.x = skip_text.scrollFactor.y = 0.0;
			
			// Set up the nameplate.
			nameplate = new FlxText(PaddingX, bg.y - 10.0, FlxG.width - PaddingX * 2.0, "");
			nameplate.setFormat("propomin", NameplateFontSize, 0xFFBBCCCC, "left", 0xFF223333);
			nameplate.scrollFactor.x = nameplate.scrollFactor.y = 0.0;
			
			// Set up the portrait.
			portrait = new FlxSprite();
			portrait.scrollFactor.x = portrait.scrollFactor.y = 0.0;
			
			// Add everything.
			add(portrait);
			add(bg);
			add(story_text);
			add(game_text);
			add(skip_text);
//			add(nameplate);
			
			// We start in no-dialogue mode.
			mode = NoDialogueMode;
		}
		
		// Starts a dialogue.
		public function startDialogue(dialogue:Array, mode:int = StoryDialogueMode, onEnd:Function = null):void {
			// Set everything up.
			this.dialogue     = dialogue;
			this.mode         = mode;
			this.onEnd        = onEnd;
			current_line      = 0;
			current_char      = 0;
			scroll_timer      = 0.0;
			done_timer        = 0.0;
			display_text.text = "";
			
			// Set the initial speaker.
			updateSpeaker();
		}
		
		// Advances the dialogue to the next line, ending the dialogue if we're out of lines. Only advances if the
		// current line of text is done scrolling, unless you pass in true.
		public function advanceDialogue(force:Boolean = false):void {
			// Don't advance if we're not done with the current line.
			if (!force && (!done_scrolling || done_timer < AdvancePause)) {
				return;
			}
			
			// Keep reference to our old speaker and side.
			var old_name:String = current_name;
			var old_side:String = current_side;
			
			// Move to the next line.
			current_line++;
			current_char = 0;
			scroll_timer = 0.0;
			done_timer   = 0.0;
			
			if (current_line < dialogue.length) {
				// Some super-hacky last-minute code to get some effects during a few specific dialogue moments.
				if (current_name === "Copier") {
					FlxG.shake(0.01, 0.3);
					FlxG.play(Assets.npc_death_fancy_1_sound, 0.9);
				}
				
				// Some more super-hacky code to parse NPC dialogue and insert correct control key instructions.
				var scheme:Object      = Game.input.control_scheme;
				var move_string:String = (scheme.id === "arrow") ? "the arrow keys" : (scheme.id === "wasd") ? "WASD" : "ESDF";
				var line:Array = dialogue[current_line];
				
				line[2] = line[2].replace("{{MOVE}}", move_string).replace("{{PUNCH}}", scheme.punch).replace("{{KICK}}", scheme.kick).replace("{{SPECIAL}}", scheme.special);
			}
			
			// End the dialogue if necessary, otherwise update the speaker.
			if (current_line >= dialogue.length) {
				endDialogue();
			}
			else if (old_name !== current_name || old_side !== current_side) {
				updateSpeaker();
			}
		}
		
		// Ends the current dialogue.
		public function endDialogue():void {
			// Perform the callback.
			onEnd();
			
			// Reset everything.
			dialogue = null;
			mode     = NoDialogueMode;
			onEnd    = null;
		}
		
		// Moves through the dialogue, updating speaker nameplates and portraits if necessary.
		private function updateSpeaker():void {
			// Update the nameplate.
//			nameplate.text      = current_name;
//			nameplate.alignment = current_side;
			
			// Update the portrait.
			var graphic:Class = Assets[StringUtil.clean(current_name) + "_portrait"];
			
			if (graphic) {
				portrait.alpha = 1.0;
				portrait.loadGraphic(graphic, false, true);
				portrait.y = FlxG.height - portrait.height - StoryModeHeight;
			}
			else {
				portrait.alpha = 0.0;
			}
			
			if (current_side === "right") {
				portrait.x = FlxG.width - portrait.width - PortraitMargin;
				portrait.facing = FlxObject.LEFT;
			}
			else {
				portrait.x = PortraitMargin;
				portrait.facing = FlxObject.RIGHT;
			}
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// Skip out if we're not actually displaying anything.
			if (mode === NoDialogueMode) {
				return;
			}
			
			// Advance the text if necessary. Otherwise, advance the done timer.
			if (!done_scrolling) {
				var scroll_rate:Number = (Game.input.key("possess") || Game.input.key("punch") || FlxG.keys.ENTER) ? FastScrollRate : ScrollRate;
				
				while (scroll_timer >= scroll_rate) {
					// Play a sound.
					if (current_char % 3 === 0) {
						FlxG.play(Assets.dialogue_blip_sound, 0.45);
					}
					
					// Move to the next character.
					current_char++;
					scroll_timer -= scroll_rate;
				}
				
				display_text.text = current_text.substr(0, current_char + 1);
				
				// Advance the timer.
				scroll_timer += FlxG.elapsed;
			}
			else {
				// If we're done, we advance the done timer.
				done_timer += FlxG.elapsed;
			}
		}
		
		// Getter and setter for the mode.
		public function get mode():int {
			return $mode;
		}
		
		public function set mode(value:int):void {
			$mode = value;
			
			// Set the opacity of everything depending on the mode.
			setAll("alpha", ($mode === NoDialogueMode) ? 0.0 : 1.0);
			
			// Adjust the box based on the mode.
			if ($mode === StoryDialogueMode) {
				bg.y = FlxG.height - StoryModeHeight;
			}
			else if ($mode === GameDialogueMode) {
				bg.y = FlxG.height - GameModeHeight;
			}
		}
		
		// Convenience getter for the current text of the dialogue. This gives you the full text of the current line,
		// not the truncated version for scrolling.
		public function get current_text():String {
			return dialogue[current_line][2];
		}
		
		// Same as above, but for the current name.
		public function get current_name():String {
			return dialogue[current_line][0];
		}
		
		// Same as above, but for the current side.
		public function get current_side():String {
			return dialogue[current_line][1];
		}
		
		// Another convenience getter that tells us whether we're done scrolling our current dialogue.
		public function get done_scrolling():Boolean {
			return (current_char >= current_text.length - 1);
		}
		
		// Getter for the current FlxText based on the mode.
		public function get display_text():FlxText {
			return (mode === GameDialogueMode) ? game_text : story_text;
		}
		
	}
	
}
