﻿package io.radical.waterwall.float{
	
	import flash.display.DisplayObject;
	
	public class FloatingItem implements IFloatable {
		
		private var _yVelocity:Number;
		private var _displayObject:DisplayObject;
		
		public function FloatingItem( displayObject: DisplayObject = null, yVelocity:Number = 0 ) {
			this.displayObject = displayObject;
			this.yVelocity = yVelocity;
		}
		
		public function get yVelocity():Number {
			return _yVelocity;
		}
		
		public function set yVelocity( value:Number ):void {
			_yVelocity = value;
		}
		
		public function get displayObject():DisplayObject {
			return _displayObject;
		}
		
		public function set displayObject( object:DisplayObject ):void {
			_displayObject = object;
		}

	}
}