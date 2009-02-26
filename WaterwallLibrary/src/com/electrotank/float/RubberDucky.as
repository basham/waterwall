package com.electrotank.float {
	import flash.display.MovieClip;
	import flash.events.*;
	public class RubberDucky extends MovieClip {
		public function RubberDucky() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			duck_mc.scaleX = Math.round(1*Math.random()) == 1 ? 1 : -1;
		}
		public function addedToStage(ev:Event):void {
		}
	}
}