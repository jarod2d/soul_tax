//
// A UI widget that displays the user's kill counts.
// 
// Created by Jarod Long on 7/10/2011.
//

package {
	
	import org.flixel.*;
	
	public class KillCounter extends FlxGroup {
		
		// Some metrics for the meters.
		private static const MeterWidth:Number  = 40.0;
		private static const MeterMargin:Number = 4.0;
		
		// Each type of NPC that needs to be killed gets a meter. Each meter goes in this slot.
		public var meters:FlxGroup;
		
		// Constructor.
		public function KillCounter() {
			super();
			
			// Create the objective meters.
			meters = new FlxGroup();
			
			var meter_position:Number = 4.0;
			
			for (var npc_type:String in Game.level.objectives) {
				var meter:Meter = new Meter(Game.level.progress, npc_type, Game.level.objectives, npc_type, meter_position, 4.0, MeterWidth, 3.0, 0xFFCCCCCC);
				meters.add(meter);
				
				meter_position += MeterWidth + MeterMargin;
			}
			
			// Add everything.
			add(meters);
		}
		
		// Update.
		override public function update():void {
			super.update();
		}
		
	}
	
}
