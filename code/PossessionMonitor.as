//
// A UI widget that displays all the possession-related information.
// 
// Created by Jarod Long on 7/7/2011.
//

package {
	
	import org.flixel.*;
	
	public class PossessionMonitor extends FlxGroup {
		
		// The width and height of the preview box.
		private static const PreviewSize:Number = 20.0;
		
		// The components of the NPC preview pane.
		private var preview:FlxGroup;
		private var preview_bg:FlxSprite;
		
		// Some text that displays the name of the victim.
		private var victim_name:FlxText;
		
		// Constructor.
		public function PossessionMonitor() {
			super();
			
			preview = new FlxGroup();
			
			// Set up the preview.
			preview_bg = new FlxSprite(FlxG.width - (PreviewSize + 4), 4).makeGraphic(PreviewSize, PreviewSize, 0x44000000);
			preview_bg.scrollFactor.x = preview_bg.scrollFactor.y = 0.0;
			preview.add(preview_bg);
			
			// Set up the victim name.
			victim_name = new FlxText(preview_bg.x - 102.0, preview_bg.y, 100.0);
			victim_name.setFormat("propomin", 8, 0xFAFAFA, "right", 0x050505);
			victim_name.scrollFactor.x = victim_name.scrollFactor.y = 0.0;
			
			// Add everything.
			add(preview);
			add(victim_name);
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// Show or hide the preview based on whether the player is able to possess someone right now, and if it is
			// visible, stamp the victim onto the preview so we can see which type they are.
			if (!Game.player.victim && Game.player.potential_victim) {
				var victim_sprite:FlxSprite = Game.player.potential_victim.sprite;
				preview_bg.stamp(victim_sprite, (PreviewSize - victim_sprite.width) / 2.0, (PreviewSize - victim_sprite.height) / 2.0);
				preview.setAll("alpha", 1.0);
				
				victim_name.text  = Game.player.potential_victim.type.name;
				victim_name.alpha = 1.0;
			}
			else {
				preview.setAll("alpha", 0.0);
				victim_name.alpha = 0.0;
			}
		}
		
	}
	
}
