//
// The class that displays the custom pause screen.
// 
// Created by Jarod Long on 7/24/2011.
//

package {
	
	import org.flixel.*;
	
	public class PauseScreen extends FlxGroup {
		
		// How long it takes for the screen to fade in or out.
		public static const FadeRate:Number = 0.135;
		
		// Whether or not the screen is currently in the process of fading.
		public var fading:Boolean;
		
		// Constructor.
		public function PauseScreen() {
			super();
			
			// Set up the background.
			var bg:FlxSprite = new FlxSprite(0, 0);
			bg.scrollFactor.x = bg.scrollFactor.y = 0.0;
			bg.makeGraphic(FlxG.width, FlxG.height, 0x99000000);
			
			// Set up the pause text.
			var pause_text:FlxText = new FlxText(0, FlxG.height / 3.0 - 10.0, FlxG.width, "PAUSED");
			pause_text.setFormat("propomin", 48, 0xFFDDDDDD, "center");
			pause_text.scrollFactor.x = pause_text.scrollFactor.y = 0.0;
			
			// Set up the instruction texts.
			var level_select_text:FlxText = new FlxText(25.0, FlxG.height - 30.0, FlxG.width - 50.0, "L: Level Select");
			level_select_text.setFormat("propomin", 16, 0xFFEEEEEE, "left");
			level_select_text.scrollFactor.x = level_select_text.scrollFactor.y = 0.0;
			
			var replay_text:FlxText = new FlxText(25.0, FlxG.height - 30.0, FlxG.width - 50.0, "R: Restart Level");
			replay_text.setFormat("propomin", 16, 0xFFEEEEEE, "right");
			replay_text.scrollFactor.x = replay_text.scrollFactor.y = 0.0;
			
			// Add everything.
			add(bg);
			add(pause_text);
			add(level_select_text);
			add(replay_text);
			
			// We're hidden initially.
			setAll("alpha", 0.0);
		}
		
		// Toggles the screen, fading it in or out based on whether FlxG.paused is true or not.
		public function fadeInOrOut():void {
			fading = true;
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// Fade the screen.
			if (fading) {
				var fade_difference:Number = FlxG.elapsed / FadeRate;
				fade_difference *= (FlxG.paused) ? 1.0 : -1.0;
				
				setAll("alpha", MathUtil.clamp(members[0].alpha + fade_difference, 0.0, 1.0));
				
				if (members[0].alpha === 0.0 || members[0].alpha === 1.0) {
					fading = false;
				}
			}
		}
		
	}
	
}
