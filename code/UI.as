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
		
		// The individual components.
		public var possession_monitor:PossessionMonitor;
		public var kill_counter:KillCounter;
		public var level_timer:LevelTimer;
		
		// Constructor.
		public function UI() {
			contents           = new FlxGroup();
			possession_monitor = new PossessionMonitor();
			kill_counter       = new KillCounter();
			level_timer        = new LevelTimer();
			
			// Add everything.
			contents.add(possession_monitor);
			contents.add(kill_counter);
			contents.add(level_timer);
		}
		
	}
	
}
