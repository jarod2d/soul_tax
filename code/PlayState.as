package {
	
	import org.flixel.*;
	
	public class PlayState extends FlxState {
		
		override public function create():void {
			super.create();
			
			// Set up the text.
			var text:FlxText;
			
			text = new FlxText(0, 100, FlxG.width, "Game Over, Buddy!!!");
			text.setFormat(null, 16, 0x553333, "center", 0xFF705555);
			add(text);
		}
		
		override public function update():void {
			super.update();
		}
		
	}
	
}
