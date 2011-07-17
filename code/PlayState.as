//
// The main state of the game in which the gameplay actually happens.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		
		// The various substates of the play state.
		public static const NoSubstate:int       = 0;
		public static const IntroSubstate:int    = 1;
		public static const TimeUpSubstate:int   = 2;
		public static const FinishedSubstate:int = 3;
		
		// Metrics for the level intro.
		public static const LevelIntroPauseTime:Number  = 1.0;
		public static const LevelIntroScrollTime:Number = 2.5;
		public static const LevelIntroTotalTime:Number  = LevelIntroPauseTime * 2.0 + LevelIntroScrollTime;
		
		// The play state has a few substates for different situations.
		public var substate:int;
		
		// Some timers.
		public var intro_timer:Number;
		
		override public function create():void {
			super.create();
			
			// Set the background color.
			FlxG.bgColor = 0xFFBBDDFF;
			
			// Create the player.
			var player:Player = Game.player = new Player();
			
			// Create the level.
			var level:Level = Game.level = new Level(Game.current_level);
			
			// Create the UI.
			var ui:UI = Game.ui = new UI();
			
			// Set the initial substate and initialize some stuff.
			substate    = IntroSubstate;
			intro_timer = 0.0;
			
			// Set up the camera and bounds.
			var border_size:int = Level.BorderSize;
			FlxG.camera.bounds  = new FlxRect(0, -UI.HUDBarHeight, level.width, level.height - Level.TileSize / 2 + UI.HUDBarHeight);
			FlxG.worldBounds    = new FlxRect(-border_size, -border_size, level.width + border_size * 2, level.height + border_size * 2);
			
			// Add everything to the scene.
			add(level.contents);
			add(ui.contents);
		}
		
		// Update for dialogue mode.
		private function updateDialogue():void {
			// Just advance the dialogue.
			if (FlxG.keys.justPressed("J") || FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER")) {
				Game.ui.dialogue_box.advanceDialogue();
			}
			
			// Do collisions.
			performCollisions();
		}
		
		// Intro-specific update.
		private function updateIntroSubstate():void {
			var level:Level = Game.level;
			
			// Set the camera location based on the intro timer.
			var time:Number          = MathUtil.clamp((intro_timer - LevelIntroPauseTime) / LevelIntroScrollTime, 0.0, LevelIntroScrollTime);
			var scroll_height:Number = FlxG.camera.bounds.height - FlxG.height;
			FlxG.camera.scroll.y     = time * scroll_height + FlxG.camera.bounds.y;
			
			// Scrolls up instead if the player is in the top half of the level.
			if (Game.player.y < level.height / 2.0) {
				FlxG.camera.scroll.y = scroll_height - FlxG.camera.scroll.y;
			}
			
			// Increment the intro timer.
			intro_timer += FlxG.elapsed;
			
			// Move on to the intro dialogue. If there's no intro dialogue, we go straight into the game.
			if (intro_timer >= LevelIntroTotalTime || FlxG.keys.SPACE || FlxG.keys.J || FlxG.keys.ENTER) {
				// Move the camera to the player.
				FlxG.camera.follow(Game.player.sprite);
				
				// Play the dialogue or change the state.
				if (level.dialogue && level.dialogue.start) {
					Game.ui.dialogue_box.startDialogue(level.dialogue.start, DialogueBox.StoryDialogueMode, function():void {
						substate = NoSubstate;
					});
				}
				else {
					substate = NoSubstate;
				}
			}
			
			// Do collisions.
			performCollisions();
		}
		
		// Update specific to the actual playable part of the game. Handles things like player input, etc.
		private function updateMainSubstate():void {
			var player:Player = Game.player;
			var level:Level   = Game.level;
			
			// Count down the level timer, and end the level if necessary.
			Game.level.time_remaining -= FlxG.elapsed;
			
			// TODO: End the level.
			
			// Process player input. We handle some input differently based on whether the player is possessing an NPC.
			// We start with basic player movement, most of which will work regardless of whether or not the player is
			// possessing someone.
			player.direction.x = player.direction.y = 0.0;
			
			if (FlxG.keys.E) {
				player.direction.y -= 1.0;
			}
			if (FlxG.keys.F) {
				player.direction.x += 1.0;
			}
			if (FlxG.keys.D) {
				player.direction.y += 1.0;
			}
			if (FlxG.keys.S) {
				player.direction.x -= 1.0;
			}
			
			// Possess or unpossess.
			if (FlxG.keys.justPressed("SPACE")) {
				(player.victim) ? player.stopPossessing() : player.possess();
			}
			
			// Attack.
			if (FlxG.keys.justPressed("J")) {
				player.punchAttack();
			}
			else if (FlxG.keys.justPressed("K")) {
				player.knockbackAttack();
			}
			
			// Do collisions.
			performCollisions();
			
			// Controls and behavior that is specific to possession or non-possession goes here.
			if (player.victim) {
				// Jump.
				if (FlxG.keys.justPressed("E")) {
					player.victim.jump();
				}
			}
			else {
				// Set the possessable NPC.
				player.potential_victim = null;
				
				FlxG.overlap(player.sprite, level.NPCs, function(a:FlxObject, b:FlxObject):void {
					player.potential_victim = (b as EntitySprite).entity as NPC;
				});
			}
		}
		
		// Performs pretty much all of our collisions. Each substate needs to call this at some point.
		private function performCollisions():void {
			var player:Player = Game.player;
			var level:Level   = Game.level;
			
			if (player.victim) {
				FlxG.collide(level.borders, player.victim.sprite);
				FlxG.collide(level.NPCs, player.victim.sprite, NPC.processCollision);
			}
			else {
				FlxG.collide(player.sprite, level.borders);
			}
			
			FlxG.collide(level.NPCs, level.wall_tiles, NPC.processCollision);
			FlxG.collide(level.gib_emitter.particles, level.wall_tiles);
			
			// Handle hitbox collisions.
			FlxG.overlap(level.NPCs, level.hitboxes, function(npc_sprite:EntitySprite, hb_sprite:EntitySprite):void {
				var npc:NPC   = npc_sprite.entity as NPC;
				var hb:HitBox = hb_sprite.entity as HitBox;
				
				// Flixel has a very strange bug at the moment where it will give you a bunch of false overlaps in some
				// cases. In order to get around this, we do our own stupid overlap detection before trying to attack
				// the npc.
				if ((hb.left < npc.right && hb.right >= npc.left) && (hb.top < npc.bottom && hb.bottom >= npc.top)) {
					hb.attackNPC(npc);
				}
			});
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// Dialogue is the highest priority.
			// TODO: This may need to come before super.update.
			if (Game.ui.dialogue_box.mode === DialogueBox.StoryDialogueMode) {
				updateDialogue();
				return;
			}
			
			// Perform substate-specific behavior.
			switch (substate) {
				case IntroSubstate: updateIntroSubstate(); break;
				default:            updateMainSubstate();  break;
			}
		}
		
	}
	
}
