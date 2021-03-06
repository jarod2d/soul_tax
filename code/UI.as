//
// The main UI class that coordinates the entire UI.
// 
// Created by Jarod Long on 7/7/2011.
//

package {
	
	import org.flixel.*;
	
	public class UI {
		
		// The contents of the UI.
		public var contents:FlxGroup;
		
		// The height of the HUD bar at the top of the screen.
		public static const HUDBarHeight:Number = 25.0;
		
		// The HUD bar background.
		public var hud_bar:FlxSprite;
		
		// The individual UI components.
		public var possession_monitor:PossessionMonitor;
		public var kill_counter:KillCounter;
		public var level_timer:LevelTimer;
		public var level_complete_message:LevelCompleteMessage;
		public var level_intro_screen:LevelIntroScreen;
		public var level_end_screen:LevelEndScreen;
		public var dialogue_box:DialogueBox;
		public var pause_screen:PauseScreen;
		
		// Constructor.
		public function UI() {
			contents               = new FlxGroup();
			hud_bar                = new FlxSprite();
			possession_monitor     = new PossessionMonitor();
			kill_counter           = new KillCounter();
			level_timer            = new LevelTimer();
			level_intro_screen     = new LevelIntroScreen();
			level_complete_message = new LevelCompleteMessage();
			level_end_screen       = new LevelEndScreen();
			dialogue_box           = new DialogueBox();
			pause_screen           = new PauseScreen();
			
			// Set up the HUD bar.
			hud_bar.makeGraphic(FlxG.width, HUDBarHeight, 0x99151818);
			hud_bar.scrollFactor.x = hud_bar.scrollFactor.y = 0.0;
			
			// Add everything.
			contents.add(hud_bar);
			contents.add(possession_monitor);
			contents.add(kill_counter);
			
			if (Game.difficulty !== Game.EasyDifficulty) {
				contents.add(level_timer);
			}
			
			contents.add(level_complete_message);
			contents.add(level_intro_screen);
			contents.add(level_end_screen);
			contents.add(dialogue_box);
			contents.add(pause_screen);
		}
		
	}
	
}
