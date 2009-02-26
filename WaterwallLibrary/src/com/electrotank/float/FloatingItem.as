package com.electrotank.float {
	import flash.display.DisplayObject;
	public class FloatingItem implements IFloatable {
		private var yVelocity:Number;
		private var displayObject:DisplayObject;
		public function FloatingItem() {
		}
		public function setDisplayObject(dob:DisplayObject):void {
			displayObject = dob;
		}
		public function getDisplayObject():DisplayObject {
			return displayObject;
		}
		public function setYVelocity(num:Number):void {
			yVelocity = num;
		}
		public function getYVelocity():Number {
			return yVelocity;
		}
	}
}