//
// The base class for all of our in-game entities. Analogous to a FlxSprite, but rather than extending FlxSprite, each
// entity contains a FlxSprite. This allows us to ignore a lot of the cruft that comes with the FlxSprite class.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class Entity {
		
		public var sprite:EntitySprite;
		
		// Constructor.
		public function EntitySprite(x:Number = 0, y:Number = 0) {
			sprite = new Sprite(this, x, y);
		}
		
		// Convenience function allows moving an Entity in one call.
		public function warp(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		// Update callbacks -- one before the Sprite gets updated and one after.
		public function beforeUpdate():void {
			
		}
		
		public function afterUpdate():void {
			
		}
		
		// Render callbacks -- one before the Sprite gets updated and one after.
		public function beforeRender():void {
			
		}
		
		public function afterRender():void {
			
		}
		
		// To string.
		public function toString():String {
			return "Entity: " + x + ", " + y;
		}
		
		// A collection of getters and setters, mostly to allow access to the properties of the entity's sprite through
		// the entity itself.
		public function get x():Number {
			return sprite.x;
		}
		
		public function set x(x:Number):void {
			sprite.x = x;
		}
		
		public function get y():Number {
			return sprite.y;
		}
		
		public function set y(y:Number):void {
			sprite.y = y;
		}
		
		public function get width():Number {
			return sprite.width;
		}
		
		public function set width(w:Number):void {
			sprite.width = w;
		}
		
		public function get height():Number {
			return sprite.height;
		}
		
		public function set height(h:Number):void {
			sprite.height = h;
		}
		
		public function get center():FlxPoint {
			return new FlxPoint(sprite.left + sprite.width / 2, sprite.top + sprite.height / 2);
		}
		
		public function get top():Number {
			return sprite.top;
		}
		
		public function get right():Number {
			return sprite.right;
		}
		
		public function get bottom():Number {
			return sprite.bottom;
		}
		
		public function get left():Number {
			return sprite.left;
		}
		
		public function get s_width():uint {
			return sprite.frameWidth;
		}
		
		public function get s_height():uint {
			return sprite.frameHeight;
		}
		
		public function get s_center():FlxPoint {
			return new FlxPoint(s_left + s_width / 2, s_top + s_height / 2);
		}
		
		public function get s_top():Number {
			return sprite.y - sprite.offset.y;
		}
		
		public function get s_right():Number {
			return s_left + s_width;
		}
		
		public function get s_bottom():Number {
			return s_top + s_height;
		}
		
		public function get s_left():Number {
			return sprite.x - sprite.offset.x;
		}
		
		public function get velocity():FlxPoint {
			return sprite.velocity;
		}
		
		public function get offset():FlxPoint {
			return sprite.offset;
		}
		
		public function get facing():uint {
			return sprite.facing;
		}
		
		public function set facing(facing:uint):void {
			sprite.facing = facing;
		}
		
		public function get scrollFactor():Number {
			return sprite.scrollFactor.x;
		}
		
		public function set scrollFactor(value:Number):void {
			sprite.scrollFactor.x = sprite.scrollFactor.y = value;
		}
		
	}
	
}
