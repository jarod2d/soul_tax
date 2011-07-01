package {
	
	import org.flixel.*;
	
	public class MainMenuState extends FlxState {
		
		override public function create():void {
			super.create();
			
			add(new FlxText(10, 10, 100, "Dis gam rules!!!"));
		}
		
		override public function update():void {
			super.update();
		}
		
	}
	
}
