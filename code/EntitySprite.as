//
// This class is kind of a hack used to allow the Entity class to have its update and render functions called by Flixel.
// It keeps a reference to its parent Entity object and provides callbacks inside the update and render functions.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class EntitySprite extends FlxSprite {
		
		public var entity:Entity;
		
		// Constructor.
		public function EntitySprite(entity:Entity, x:Number = 0, y:Number = 0) {
			super(x, y);
			this.entity = entity;
		}
		
		override public function draw():void {
			entity.beforeDraw();
			super.draw();
			entity.afterDraw();
		}
		
		override public function update():void {
			entity.beforeUpdate();
			super.update();
			entity.afterUpdate();
		}
		
	}
	
}
