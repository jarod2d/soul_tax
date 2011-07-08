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
		
		// Constructor.
		public function UI() {
			contents           = new FlxGroup();
			possession_monitor = new PossessionMonitor();
			
			// Add everything.
			contents.add(possession_monitor);
		}
		
	}
	
}
