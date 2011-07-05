//
// The player class. It's important!
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class Player extends Entity {
		
		// The various colors the player character changes to.
		private static const NormalColor:uint     = 0x55DDFF;
		private static const PossessionColor:uint = 0xDDAAEE;
		
		// How quickly (in seconds) player trail sprites should spawn and fade, as well as the initial opacity of the
		// trail when it is spawned.
		private static const TrailSpawnRate:Number      = 0.175;
		private static const TrailFadeRate:Number       = 0.7;
		private static const TrailInitialOpacity:Number = 0.45;
		
		// The group that contains the player's lingering trail effect and the timer that determines when a new sprite
		// is added.
		public var trails:FlxGroup;
		private var trails_timer:Number;
		
		public function Player() {
			super();
			
			// Pre-allocate the player's trail sprites. We can figure out how many we need to create based on the spawn
			// and fade rates.
			trails              = new FlxGroup();
			trails_timer        = 0.0;
			var trail_count:int = Math.ceil(TrailFadeRate / TrailSpawnRate);
			
			for (var i:int = 0; i < trail_count; i++) {
				var trail:FlxSprite = new FlxSprite();
				trail.loadGraphic(Assets.GhostSprite, true, true, 4, 15).kill();
				
				trails.add(trail);
			}
			
			// Load the player sprite.
			sprite.loadGraphic(Assets.GhostSprite, true, true, 4, 15);
			
			// Set up animations.
			sprite.addAnimation("float", [0, 1, 2, 3, 4, 5, 6, 7], 20);
			sprite.play("float");
			
			// Set up the player's basic stats.
			max_speed    = new FlxPoint(100.0, 100.0);
			acceleration = new FlxPoint(280.0, 280.0);
			
			// Set the player's default color and opacity.
			color        = NormalColor;
			sprite.alpha = 0.9;
		}
		
		override public function beforeUpdate():void {
			super.beforeUpdate();
			
			// Fade out the current trails.
			for (var i:int = 0; i < trails.length; i++) {
				var trail:FlxSprite = trails.members[i];
				
				if (trail.alive) {
					trail.alpha = Math.max(trail.alpha - FlxG.elapsed / (TrailFadeRate / TrailInitialOpacity), 0.0);
					
					// If the trail's completely faded, we should get rid of it.
					if (trail.alpha <= 0.0) {
						trail.kill();
					}
				}
			}
			
			// Add new trails.
			if (trails_timer >= TrailSpawnRate && (velocity.x !== 0.0 || velocity.y !== 0.0)) {
				var trail:FlxSprite = trails.getFirstDead() as FlxSprite;
				
				if (trail) {
					trail.revive();
					trail.x      = x;
					trail.y      = y;
					trail.alpha  = TrailInitialOpacity;
					trail.frame  = sprite.frame;
					trail.facing = facing;
				}
				
				trails_timer = 0.0;
			}
			
			trails_timer += FlxG.elapsed;
		}
		
		// Getters and setters for the player's color.
		public function get color():uint {
			return sprite.color;
		}
		
		public function set color(value:uint):void {
			sprite.color = value;
			
			// We need to set the color of all of our trails as well.
			for (var i:int = 0; i < trails.length; i++) {
				trails.members[i].color = value;
			}
		}
		
	}
	
}
