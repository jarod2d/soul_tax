//
// A UI widget that displays the level's remaining time.
// 
// Created by Jarod Long on 7/10/2011.
//

package {
	
	import org.flixel.*;
	
	public class LevelTimer extends FlxGroup {
		
		// The threshold for when the timer value will start blinking.
		private static const TimerBlinkThreshold:int = 5;
		
		// The colors of the timer value.
		private static const TimerStandardColor:int = 0xFFEEEE66;
		private static const TimerBlinkColor:int    = 0xFFFF5544;
		
		// The text of the timer.
		public var timer_label:FlxText;
		public var timer_value:FlxText;
		
		// Constructor.
		public function LevelTimer() {
			super();
			
			// Set up the timer text.
			timer_label = new FlxText(0, 1.0, FlxG.width, "time").setFormat("propomin", 8, 0xFFEEEEDD, "center", 0xFF332222);
			timer_value = new FlxText(0, 10.0, FlxG.width, "0").setFormat("propomin", 16, TimerStandardColor, "center", 0xFF332222);
			timer_label.scrollFactor.x = timer_label.scrollFactor.y = timer_value.scrollFactor.x = timer_value.scrollFactor.y = 0.0;
			
			add(timer_label);
			add(timer_value);
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// Get the timer value.
			var new_timer_value:int = Math.ceil(Game.level.time_remaining);
			
			// Blink the timer if necessary.
			if (new_timer_value <= TimerBlinkThreshold) {
				var old_timer_value:int = int(timer_value.text);
				
				if (old_timer_value !== new_timer_value) {
					timer_value.color = (new_timer_value % 2 === 0) ? TimerStandardColor : TimerBlinkColor;
					
					// Play a sound.
					if (new_timer_value > 0 && new_timer_value < 5) {
						FlxG.play(Assets.timer_countdown_sound, 0.45);
					}
				}
			}
			
			// Update the timer value.
			timer_value.text = String(new_timer_value);
		}
		
	}
	
}
