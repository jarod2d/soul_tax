//
// The base class for all of our in-game entities. Analogous to a FlxSprite, but rather than extending FlxSprite, each
// entity contains a FlxSprite. This allows us to ignore a lot of the cruft that comes with the FlxSprite class.
// 
// Created by Jarod Long on 7/1/2011.
//

package {
	
	import org.flixel.*;
	
	public class Entity {
		
		// The entity's FlxSprite object.
		public var sprite:EntitySprite;
		
		// Constructor.
		public function Entity(x:Number = 0, y:Number = 0) {
			sprite = new EntitySprite(this, x, y);
		}
		
		// Convenience function allows moving an Entity in one call.
		public function warp(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		
		// Update callbacks -- one before the Sprite gets updated and one after.
		public function beforeUpdate():void {}
		public function afterUpdate():void {}
		
		// Draw callbacks -- one before the Sprite gets updated and one after.
		public function beforeDraw():void {}
		public function afterDraw():void {}
		
		// To string.
		public function toString():String {
			return "Entity: " + x + ", " + y;
		}
		
		// A getter that returns the index of the tile that is currently underneath the entity's center point.
		public function get current_tile():int {
			var center:FlxPoint = this.center;
			return Math.floor(center.y / Level.TileSize) * Game.level.t_width + Math.floor(center.x / Level.TileSize);
		}
		
		// A getter that returns the index of the tile that is currently underneath the entity (i.e., the one they're
		// standing on, in a platforming context), based on their center point.
		public function get tile_below():int {
			return int((bottom + 1.0) / Level.TileSize) * Game.level.wall_tiles.widthInTiles + int(center.x / Level.TileSize);
		}
		
		// A collection of getters and setters, mostly to allow access to the properties of the entity's sprite through
		// the entity itself.
		public function get x():Number {
			return sprite.x;
		}
		
		public function set x(value:Number):void {
			sprite.x = value;
		}
		
		public function get y():Number {
			return sprite.y;
		}
		
		public function set y(value:Number):void {
			sprite.y = value;
		}
		
		public function get width():Number {
			return sprite.width;
		}
		
		public function set width(value:Number):void {
			sprite.width = value;
		}
		
		public function get height():Number {
			return sprite.height;
		}
		
		public function set height(value:Number):void {
			sprite.height = value;
		}
		
		public function get center():FlxPoint {
			return new FlxPoint(sprite.x + sprite.width / 2, sprite.y + sprite.height / 2);
		}
		
		public function get top():Number {
			return y;
		}
		
		public function get right():Number {
			return left + width;
		}
		
		public function get bottom():Number {
			return top + height;
		}
		
		public function get left():Number {
			return x;
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
			return top - sprite.offset.y;
		}
		
		public function get s_right():Number {
			return s_left + s_width;
		}
		
		public function get s_bottom():Number {
			return s_top + s_height;
		}
		
		public function get s_left():Number {
			return left - sprite.offset.x;
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
		
		public function get velocity():FlxPoint {
			return sprite.velocity;
		}
		
		public function set velocity(value:FlxPoint):void {
			sprite.velocity = value;
		}
		
		public function get acceleration():FlxPoint {
			return sprite.acceleration;
		}
		
		public function set acceleration(value:FlxPoint):void {
			sprite.acceleration = value;
		}
		
		public function get drag():FlxPoint {
			return sprite.drag;
		}
		
		public function set drag(value:FlxPoint):void {
			sprite.drag = value;
		}
		
		public function get max_velocity():FlxPoint {
			return sprite.maxVelocity;
		}
		
		public function set max_velocity(value:FlxPoint):void {
			sprite.maxVelocity = value;
		}
		
		public function set scrollFactor(value:Number):void {
			sprite.scrollFactor.x = sprite.scrollFactor.y = value;
		}
		
	}
	
}
