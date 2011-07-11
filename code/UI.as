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
		
		// Constructor.
		public function UI() {
			contents           = new FlxGroup();
			possession_monitor = new PossessionMonitor();
			kill_counter       = new KillCounter();
			
			// Add everything.
			contents.add(possession_monitor);
			contents.add(kill_counter);
		}
		
	}
	
}
