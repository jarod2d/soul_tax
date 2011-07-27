//
// A UI widget that display's a screen at the end of the level -- either the "you won" or "you lost" screen.
// 
// Created by Jarod Long on 7/17/2011.
//

package {
	
	import org.flixel.*;
	
	public class LevelEndScreen extends FlxGroup {
		
		// The amount of time it takes for the screen to fade in.
		public static const FadeTime:Number = 0.4;
		
		// The contents for both the winning and losing states.
		public var won_contents:FlxGroup;
		public var lost_contents:FlxGroup;
		
		// We keep a reference to the player's score texts so we can update them later.
		public var time_text:FlxText;
		public var bonus_text:FlxText;
		
		// The timer for fading in the screen.
		public var fade_timer:Number;
		
		// Constructor.
		public function LevelEndScreen() {
			super();
			
			// Set up the background.
			var bg:FlxSprite = new FlxSprite(0, 0);
			bg.scrollFactor.x = bg.scrollFactor.y = 0.0;
			bg.makeGraphic(FlxG.width, FlxG.height, 0x99000000);
			
			// Set up win/lose texts.
			var won_text:FlxText = new FlxText(0, FlxG.height / 3.0 - 10.0, FlxG.width, "TAXES PAID!");
			won_text.lineSpacing = 10.0;
			won_text.setFormat("propomin", 32, 0xFF88EE66, "center");
			won_text.scrollFactor.x = won_text.scrollFactor.y = 0.0;
			
			var lost_text:FlxText = new FlxText(0, FlxG.height / 3.0 - 10.0, FlxG.width, "MORE TAXES REQUIRED");
			lost_text.lineSpacing = 10.0;
			lost_text.setFormat("propomin", 32, 0xFFCC2222, "center");
			lost_text.scrollFactor.x = lost_text.scrollFactor.y = 0.0;
			
			// Set up the instruction texts.
			var level_select_text:FlxText = new FlxText(25.0, FlxG.height - 30.0, FlxG.width - 50.0, "L: Level Select");
			level_select_text.setFormat("propomin", 16, 0xFFEEEEEE, "left");
			level_select_text.scrollFactor.x = level_select_text.scrollFactor.y = 0.0;
			
			var continue_text:FlxText = new FlxText(25.0, FlxG.height - 52.0, FlxG.width - 50.0, "J: Continue");
			continue_text.setFormat("propomin", 16, 0xFFEEEEEE, "center");
			continue_text.scrollFactor.x = continue_text.scrollFactor.y = 0.0;
			
			var replay_text:FlxText = new FlxText(25.0, FlxG.height - 30.0, FlxG.width - 50.0, "R: Replay Level");
			replay_text.setFormat("propomin", 16, 0xFFEEEEEE, "right");
			replay_text.scrollFactor.x = replay_text.scrollFactor.y = 0.0;
			
			// Set up the score display.
			var time_icon:FlxSprite = new FlxSprite(111.0, FlxG.height / 2.0, Assets.clock_icon);
			time_icon.scale.x = time_icon.scale.y = 3.0;
			time_icon.scrollFactor.x = time_icon.scrollFactor.y = 0.0;
			
			time_text = new FlxText(124.0, time_icon.y - 5.0, FlxG.width - 280.0, "");
			time_text.setFormat("propomin", 16, 0xFFDDDDDD);
			time_text.scrollFactor.x = time_text.scrollFactor.y = 0.0;
			
			bonus_text = new FlxText(time_text.x, time_text.y, time_text.width, "");
			bonus_text.setFormat("propomin", 16, 0xFFDD2222, "right");
			bonus_text.scrollFactor.x = bonus_text.scrollFactor.y = 0.0;
			
			var bonus_label:FlxText = new FlxText(bonus_text.x + bonus_text.width + 2.0, bonus_text.y, FlxG.width, "bonus");
			bonus_label.setFormat("propomin", 16, 0xFFDDDDDD, "left");
			bonus_label.scrollFactor.x = bonus_label.scrollFactor.y = 0.0;
			
			// Set up the won contents.
			won_contents = new FlxGroup();
			won_contents.add(bg);
			won_contents.add(won_text);
			won_contents.add(continue_text);
			won_contents.add(level_select_text);
			won_contents.add(replay_text);
			won_contents.add(time_icon);
			won_contents.add(time_text);
			won_contents.add(bonus_text);
			won_contents.add(bonus_label);
			
			// Set up the lost contents.
			lost_contents = new FlxGroup();
			lost_contents.add(bg);
			lost_contents.add(lost_text);
			lost_contents.add(level_select_text);
			lost_contents.add(replay_text);
			
			// Everything is initially hidden.
			active = false;
		}
		
		// Activates the level end screen, automatically displaying whether you won or lost based on the current level
		// objective completion status.
		public function activate():void {
			active     = true;
			fade_timer = 0.0;
			
			remove(won_contents);
			remove(lost_contents);
			add(current_contents);
			
			if (Game.level.objectives_complete) {
				time_text.text  = MathUtil.formatNumber(Game.level.completion_time, 1);
				bonus_text.text = Game.level.progress.bonus;
			}
			
			current_contents.setAll("alpha", 0.0);
		}
		
		// Update.
		override public function update():void {
			super.update();
			
			// Fade in the screen.
			if (active && fade_timer < FadeTime) {
				fade_timer += FlxG.elapsed;
				
				current_contents.setAll("alpha", Math.min(1.0, fade_timer / FadeTime));
			}
		}
		
		// Getter for the current contents based on the objective completion status.
		public function get current_contents():FlxGroup {
			return (Game.level.objectives_complete) ? won_contents : lost_contents;
		}
		
	}
	
}
