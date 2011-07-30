//
// The main state of the game in which the gameplay actually happens.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	import flash.utils.*;
	
	public class PlayState extends FlxState {
		
		// The various substates of the play state.
		public static const NoSubstate:int       = 0;
		public static const IntroSubstate:int    = 1;
		public static const TimeUpSubstate:int   = 2;
		public static const FinishedSubstate:int = 3;
		
		// Metrics for the level intro.
		public static const LevelIntroPauseTime:Number  = 1.55;
		public static const LevelIntroScrollTime:Number = 2.75;
		public static const LevelIntroTotalTime:Number  = LevelIntroPauseTime * 2.0 + LevelIntroScrollTime;
		
		// Metrics for the level end.
		public static const LevelEndGracePeriod:Number      = 2.25;
		public static const GracePeriodDyingNPCBonus:Number = 10.0;
		
		// The play state has a few substates for different situations.
		public var substate:int;
		
		// Some timers.
		public var intro_timer:Number;
		public var level_end_timer:Number;
		
		// We need to keep track of our one-shot music (intro theme, etc) so we can fade it out prematurely if
		// necessary.
		private var music:FlxSound;
		
		// When we pause the game, we reduce the volume. We need to store the player's old volume setting so that we can
		// restore it when they unpause.
		private var old_volume:Number;
		
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
			substate        = IntroSubstate;
			intro_timer     = 0.0;
			level_end_timer = 0.0;
			old_volume      = FlxG.volume;
			
			// Set up the camera and bounds.
			var border_size:int = Level.BorderSize;
			FlxG.camera.bounds  = new FlxRect(0, -UI.HUDBarHeight, level.width, level.height - Level.TileSize / 2 + UI.HUDBarHeight);
			FlxG.worldBounds    = new FlxRect(-border_size, -border_size, level.width + border_size * 2, level.height + border_size * 2);
			
			// Add everything to the scene.
			add(level.contents);
			add(ui.contents);
			
			// Play the level intro music.
			if (FlxG.music) {
				FlxG.music.stop();
				FlxG.music = null;
			}
			
			music = FlxG.play(Assets.level_start_music, 0.22);
		}
		
		// Update for dialogue mode.
		private function updateDialogue():void {
			// Advance the dialogue.
			if (FlxG.keys.justPressed("J") || FlxG.keys.justPressed("SPACE")) {
				Game.ui.dialogue_box.advanceDialogue();
			}
			
			// Allow players to skip the dialogue.
			if ( FlxG.keys.justPressed("ENTER")) {
				Game.ui.dialogue_box.endDialogue();
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
				// Fade out the intro music.
				music.fadeOut(0.3);
				
				// Move the camera to the player.
				FlxG.camera.follow(Game.player.sprite);
				
				// Play the dialogue or change the state.
				if (level.dialogue && level.dialogue.start) {
					Game.ui.dialogue_box.startDialogue(level.dialogue.start, DialogueBox.StoryDialogueMode, function():void {
						substate = NoSubstate;
						FlxG.playMusic(Assets.main_theme_music, 0.28);
					});
				}
				else {
					substate = NoSubstate;
					FlxG.playMusic(Assets.main_theme_music, 0.28);
				}
			}
			
			// Do collisions.
			performCollisions();
		}
		
		// Update specific to the actual playable part of the game. Handles things like player input, etc.
		private function updateMainSubstate():void {
			var player:Player = Game.player;
			var level:Level   = Game.level;
			
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
			
			// Do collisions.
			performCollisions();
			
			// Controls and behavior that are specific to possession or non-possession go here.
			if (player.victim) {
				// Jump.
				if (FlxG.keys.justPressed("E")) {
					player.victim.jump();
				}
				
				// Attack.
				if (FlxG.keys.justPressed("J")) {
					player.punchAttack();
				}
				else if (FlxG.keys.justPressed("K")) {
					player.knockbackAttack();
				}
				
				// Special attack.
				if (FlxG.keys.justPressed("L")) {
					player.victim.startSpecialAttack();
				}
				else if (FlxG.keys.justReleased("L")) {
					player.victim.endSpecialAttack();
				}
				else if (FlxG.keys.L) {
					player.victim.continueSpecialAttack();
				}
			}
			else {
				// Set the possessable NPC.
				player.potential_victim = null;
				
				FlxG.overlap(player.sprite, level.NPCs, function(a:FlxObject, b:FlxObject):void {
					player.potential_victim = (b as EntitySprite).entity as NPC;
				});
			}
			
			// Count down the level timer, and end the level if necessary.
			level.time_remaining -= FlxG.elapsed;
			
			if (level.time_remaining <= 0.0 || (FlxG.keys.ENTER && level.objectives_complete)) {
				// Set the timer to zero in case the user ended the level early.
				level.time_remaining = 0.0;
				
				// Make the player stop possessing their victim and stop their movement.
				player.stopPossessing();
				player.direction.x = player.direction.y = 0.0;
				
				// Stop the music.
				FlxG.music.fadeOut(1.0);
				setTimeout(function():void {
					FlxG.music.stop();
					FlxG.music = null;
				}, 1000.0);
				
				// Play a sound.
				FlxG.play(Assets.level_end_sound, 0.8);
				
				// Update the substate.
				substate = TimeUpSubstate;
				
				// Hide the level complete message.
				Game.ui.level_complete_message.setAll("alpha", 0.0);
			}
		}
		
		// Update for after the timer has run out.
		private function updateTimeUpSubstate():void {
			var level:Level = Game.level;
			
			// The grace period depends on whether we have dying NPCs or not, because we don't want to say the player
			// has lost if he's just waiting on a ghost to fly up to the kill counter.
			var grace_period:Number = LevelEndGracePeriod;
			
			if (level.dying_npcs.length > 0) {
				grace_period += GracePeriodDyingNPCBonus;
			}
			
			// Increment the grace period timer.
			level_end_timer += FlxG.elapsed;
			
			// End the level.
			if (level_end_timer >= grace_period) {
				// Figure out which dialogue we need to show.
				var dialogue:Array;
				
				if (!level.objectives_complete) {
					dialogue = Level.LevelFailedDialogue;
				}
				else if (level.dialogue && level.dialogue.end) {
					dialogue = level.dialogue.end;
				}
				else {
					dialogue = Level.LevelWonDialogue;
				}
				
				// Play the dialogue.
				Game.ui.dialogue_box.startDialogue(dialogue, DialogueBox.StoryDialogueMode, function():void {
					substate = FinishedSubstate;
					Game.ui.level_end_screen.activate();
					
					// Play the proper music.
					if (FlxG.music) {
						FlxG.music.stop();
						FlxG.music = null;
					}
					
					music = FlxG.play((level.objectives_complete) ? Assets.level_won_music : Assets.level_failed_music, 0.25);
					
					// TODO: Play a little cutscene of the player being killed by Death if they lost.
					
					// Save the player's progress.
					if (level.objectives_complete) {
						LevelProgress.recordCurrentScore();
					}
				});
			}
			
			// Do collisions.
			performCollisions();
		}
		
		// Update for the "you won" or "you lost" screen.
		private function updateFinishedSubstate():void {
			// Restart the level.
			if (FlxG.keys.justPressed("R")) {
				FlxG.switchState(new PlayState());
				return;
			}
			
			// Go back to the level select.
			if (FlxG.keys.justPressed("L")) {
				FlxG.switchState(new LevelSelectState());
				return;
			}
			
			// Move on to the next level, or to the credits if we're on the last level.
			if (FlxG.keys.justPressed("J") && Game.level.objectives_complete) {
				if (Game.current_level === Level.levels.length - 1) {
					FlxG.switchState(new CreditsState());
				}
				else {
					Game.current_level++;
					FlxG.switchState(new PlayState());
				}
				
				return;
			}
			
			// Do collisions.
			performCollisions();
		}
		
		// Performs pretty much all of our collisions. Each substate needs to call this at some point.
		private function performCollisions():void {
			var player:Player = Game.player;
			var level:Level   = Game.level;
			
			// Standard collisions.
			if (player.victim) {
				FlxG.collide(player.victim.sprite, level.bottomless_borders);
				FlxG.collide(player.victim.sprite, level.NPCs, NPC.processCollision);
				
				if (!player.victim.is_shrunk) {
					FlxG.overlap(player.victim.sprite, level.shrunk_NPCs, function(victim_sprite:EntitySprite, npc_sprite:EntitySprite):void {
						(npc_sprite.entity as NPC).kill();
					});
				}
			}
			
			FlxG.collide(player.sprite, level.borders);
			FlxG.collide(level.NPCs, level.wall_tiles, NPC.processCollision);
			FlxG.collide(level.gib_emitter.particles, level.wall_tiles);
			FlxG.collide(level.robot_gib_emitter.particles, level.wall_tiles);
			FlxG.collide(level.smoke_emitter.particles, level.wall_tiles);
			FlxG.collide(level.money_emitter.particles, level.wall_tiles);
			FlxG.collide(level.glass_emitter.particles, level.wall_tiles);
			
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
			
			for each (var hb_sprite:EntitySprite in level.hitboxes.members) {
				if (!hb_sprite) {
					continue;
				}
				
				var hb:HitBox = hb_sprite.entity as HitBox;
				
				if (hb.dies_on_contact) {
					FlxG.collide(hb_sprite, level.wall_tiles, function(hb_sprite:EntitySprite, tiles:FlxTilemap):void {
						level.breakGlassAt(hb_sprite.x + Level.TileSize / 2.0, hb_sprite.y);
						level.breakGlassAt(hb_sprite.x - Level.TileSize / 2.0, hb_sprite.y);
						hb_sprite.kill();
					});
				}
			}
			
			// Robot collisions.
			if (player.victim) {
				FlxG.overlap(level.robots, player.victim.sprite, function(robot_sprite:EntitySprite, victim_sprite:EntitySprite):void {
					player.victim.kill();
				});
			}
		}
		
		// Update for the pause menu and pause functionality.
		private function updatePause():void {
			// Pause or unpause the game.
			if (FlxG.keys.justPressed("P") || FlxG.keys.justPressed("ESCAPE")) {
				(FlxG.paused) ? unpause() : pause();
			}
			
			// Handle restarting, etc.
			if (FlxG.paused) {
				// Restart the level.
				if (FlxG.keys.justPressed("R")) {
					unpause();
					FlxG.switchState(new PlayState());
					return;
				}
				
				// Go back to the level select.
				if (FlxG.keys.justPressed("L")) {
					unpause();
					FlxG.switchState(new LevelSelectState());
					return;
				}
				
				// Need to update the pause menu explicitly because the state is not actually being updated.
				Game.ui.pause_screen.update();
			}
		}
		
		// A helper function to pause the game.
		private function pause():void {
			FlxG.paused = true;
			Game.ui.pause_screen.fadeInOrOut();
			
			// Lower the volume.
			old_volume  = FlxG.volume;
			FlxG.volume = (old_volume > 0.25) ? 0.25 : old_volume;
		}
		
		// A helper function to unpause the game.
		private function unpause():void {
			FlxG.paused = false;
			Game.ui.pause_screen.fadeInOrOut();
			
			// Restore volume.
			FlxG.volume = old_volume;
		}
		
		// Update.
		override public function update():void {
			// Handle pause functionality.
			if (substate === NoSubstate) {
				updatePause();
			}
			
			if (FlxG.paused) {
				return;
			}
			
			// Update all of our stuff.
			super.update();
			
			// Handle dialogue functionality.
			if (Game.ui.dialogue_box.mode === DialogueBox.StoryDialogueMode) {
				updateDialogue();
				return;
			}
			
			// Perform substate-specific behavior.
			switch (substate) {
				case IntroSubstate:    updateIntroSubstate();    break;
				case TimeUpSubstate:   updateTimeUpSubstate();   break;
				case FinishedSubstate: updateFinishedSubstate(); break;
				default:               updateMainSubstate();     break;
			}
		}
		
	}
	
}
