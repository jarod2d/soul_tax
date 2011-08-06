//
// The first game state that displays the main menu. Leads to LevelSelectState.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class MainMenuState extends FlxState {
		
		// Images that display the currently-configured controls.
		private var control_scheme_sprite:FlxSprite;
		
		// The text for the current difficulty selection.
		private var difficulty_name:FlxText;
		private var difficulty_description:FlxText;
		
		// The npc and ghost sprites that run around on the menu.
		private var ghost:Player;
		private var bait:NPC;
		
		// Which way the dudes are running.
		private var run_direction:int;
		
		override public function create():void {
			super.create();
			
			// The default volume sucks.
			FlxG.volume = 0.9;
			
			// Set the background color.
			FlxG.bgColor = 0xFF33353A;
			
			// Set up the title.
			var text:FlxText;
			
			text = new FlxText(0, 110.0, FlxG.width, "Soul Tax");
			text.lineSpacing = 10.0;
			text.setFormat("propomin", 48, 0xFFE0E2E4, "center", 0xFF001118);
			add(text);
			
			// Set up the credits.
			text = new FlxText(FlxG.width / 2.0 - 140.0, 180.0, 150.0, "Coding and Design:\nArt and Design:\nMusic and Sounds:\nDialogue Writing:");
			text.lineSpacing = 3.0;
			text.setFormat("propomin", 8, 0xFFE0E2E4, "right", 0xFF000A10);
			add(text);
			
			text = new FlxText(FlxG.width / 2.0 + 10.0, 180.0, 150.0, "Jarod Long\nLauren Careccia\nBrad Snyder\nDevin Presbury");
			text.lineSpacing = 3.0;
			text.setFormat("propomin", 8, 0xFFD0D9E8, "left", 0xFF001528);
			add(text);
			
			// Add the SA Gamedev logo.
			var logo:FlxSprite = new FlxSprite(0.0, 0.0, Assets.sa_gamedev_logo);
			logo.origin.y = logo.height;
			logo.x = (FlxG.width - logo.width) / 2.0 + 3.0;
			logo.y = FlxG.height - logo.height - 2.0;
			
			logo.scale.x = logo.scale.y = 0.5;
			add(logo);
			
			// Add difficulty selection.
			var difficulty_label:FlxText = new FlxText(34.0, FlxG.height - 48.0, FlxG.width, "Difficulty");
			difficulty_label.setFormat("propomin", 8, 0xFFDADADA, "left", 0xFF111111);
			add(difficulty_label);
			
			var difficulty_instructions:FlxText = new FlxText(14.0, FlxG.height - 38.0, FlxG.width, "Press D to change");
			difficulty_instructions.setFormat("propomin", 8, 0xFFADADAD, "left", 0xFF111111);
			add(difficulty_instructions);
			
			difficulty_name = new FlxText(0.0, FlxG.height - 27.0, 120.0);
			difficulty_name.setFormat("propomin", 16, 0xFFD0D9E8, "center", 0xFF111111);
			add(difficulty_name);
			
			difficulty_description = new FlxText(0.0, FlxG.height - 14.0, 118.0);
			difficulty_description.setFormat("propomin", 8, 0xFFB0B6C2, "center", 0xFF111111);
			add(difficulty_description);
			
			setDifficultyText();
			
			// Add keyboard helpers.
			control_scheme_sprite = new FlxSprite(FlxG.width - 104.0, FlxG.height - 25.0);
			add(control_scheme_sprite);
			
			setHelperSprites();
			
			var scheme_label:FlxText = new FlxText(FlxG.width - 100.0, FlxG.height - 48.0, FlxG.width, "Control Scheme");
			scheme_label.setFormat("propomin", 8, 0xFFDADADA, "left", 0xFF111111);
			add(scheme_label);
			
			var scheme_instructions:FlxText = new FlxText(FlxG.width - 106.0, FlxG.height - 38.0, FlxG.width, "Press C to change");
			scheme_instructions.setFormat("propomin", 8, 0xFFADADAD, "left", 0xFF111111);
			add(scheme_instructions);
			
			// Set up our hacky ghost chasing sequence.
			run_direction = FlxObject.RIGHT;
			
			ghost = new Player();
			ghost.warp(-65.0, 55.0);
			ghost.max_velocity.x = ghost.max_velocity.y = 59.0;
			
			bait  = new NPC("businessman", ghost.x + 50.0, ghost.y);
			bait.velocity.x = 60.0;
			bait.acceleration.x = bait.acceleration.y = 0.0;
			bait.sprite.drag.x = bait.sprite.drag.y = 0.0;
			bait.sprite.play("walk");
			
			ghost.potential_victim = bait;
			ghost.possess();
			ghost.color = Player.NormalColor;
			
			add(ghost.trails);
			add(ghost.sprite);
			add(bait.sprite);
			
			// Play the title theme.
			if (FlxG.music) {
				FlxG.music.stop();
				FlxG.music = null;
			}
			
			FlxG.playMusic(Assets.title_screen_music, 0.525);
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// Move on to the Level Select state.
			if (Game.input.key("possess") || Game.input.key("punch") || FlxG.keys.ENTER) {
				FlxG.switchState(new LevelSelectState());
			}
			
			// Keep the ghost and NPC chasing each other.
			if (run_direction === FlxObject.RIGHT && ghost.left > FlxG.width) {
				bait.velocity.x *= -1.0;
				bait.x  = FlxG.width + 130.0;
				ghost.x = bait.x + 50.0;
				
				run_direction = bait.facing = ghost.facing = FlxObject.LEFT;
			}
			else if (run_direction === FlxObject.LEFT && ghost.right < -14.0) {
				bait.velocity.x *= -1.0;
				bait.x  = -130.0;
				ghost.x = bait.x - 50.0;
				
				run_direction = bait.facing = ghost.facing = FlxObject.RIGHT;
			}
			
			// Toggle control scheme.
			if (FlxG.keys.justPressed("C")) {
				Game.input.selectNextControlScheme();
				setHelperSprites();
				
				// Play a sound.
				FlxG.play(Assets.menu_select_sound, 0.55);
			}
			
			// Toggle difficulty.
			if (FlxG.keys.justPressed("D")) {
				Game.difficulty = (Game.difficulty + 1) % 3;
				setDifficultyText();
				
				// Play a sound.
				FlxG.play(Assets.menu_select_sound, 0.55);
			}
		}
		
		// A little helper function to set the correct helper sprites based on the control scheme.
		private function setHelperSprites():void {
			var scheme_id:String  = Game.input.control_scheme.id;
			control_scheme_sprite.loadGraphic(Assets[scheme_id + "_keys"]);
		}
		
		// Sets the difficulty description based on the currently-set difficulty.
		private function setDifficultyText():void {
			switch (Game.difficulty) {
				case Game.EasyDifficulty:   difficulty_name.text = "Easy";   difficulty_description.text = "No time limit!";     break;
				case Game.NormalDifficulty: difficulty_name.text = "Normal"; difficulty_description.text = "Long time limits!";  break;
				case Game.HardDifficulty:   difficulty_name.text = "Hard";   difficulty_description.text = "Short time limits!"; break;
			}
		}
		
	}
	
}
