package com.electrotank.water {
	import flash.display.Sprite;
	import flash.events.*;
	public class Dot extends Sprite {
		private var waves:Array;
		public function Dot() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			waves = new Array();
		}
		public function addWave(w:Wave):void {
			waves.push(w);
		}
		public function addedToStage(ev:Event):void {
		}
		override public function toString():String {
			return "x: "+Math.round(x).toString()+" , "+Math.round(y).toString();
		}
		public function getWaves():Array {
			return waves;
		}
	}
}