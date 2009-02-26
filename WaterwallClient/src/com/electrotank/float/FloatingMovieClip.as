package com.electrotank.float {
	import flash.display.MovieClip;
	public class FloatingMovieClip extends MovieClip implements IFloatable {
		private var yVelocity:Number;
		public function FloatingMovieClip() {
		}
		public function setYVelocity(num:Number):void {
			yVelocity = num;
		}
		public function getYVelocity():Number {
			return yVelocity;
		}
	}
}