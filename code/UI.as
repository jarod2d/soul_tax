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
		
		// Constructor.
		public function UI() {
			contents           = new FlxGroup();
			hud_bar            = new FlxSprite();
			possession_monitor = new PossessionMonitor();
			kill_counter       = new KillCounter();
			level_timer        = new LevelTimer();
			
			// Set up the HUD bar.
			hud_bar.makeGraphic(FlxG.width, HUDBarHeight, 0x99151818);
			hud_bar.scrollFactor.x = hud_bar.scrollFactor.y = 0.0;
			
			// Add everything.
			contents.add(hud_bar);
			contents.add(possession_monitor);
			contents.add(kill_counter);
			contents.add(level_timer);
		}
		
	}
	
}
