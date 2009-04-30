package io.radical.waterwall.float {
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class FloatingSprite extends Sprite implements IFloatable {
		
		private var _yVelocity:Number = 0;
		private var _buoyancy:Number = 0;
		
		public function FloatingSprite() {
			super();
		}
		
		public function get yVelocity():Number {
			return _yVelocity;
		}
		
		public function set yVelocity( value:Number ):void {
			_yVelocity = value;
		}
		
		public function get buoyancy():Number {
			return _buoyancy;
		}
		
		public function set buoyancy( value:Number ):void {
			_buoyancy = value;
		}
		
		public function get displayObject():DisplayObject {
			return this;
		}
		
	}
}