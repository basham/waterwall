package com.electrotank.water {
	
	import flash.geom.Point;
	
	public class Dot extends Point {
		
		private var waves:Array;
		
		public function Dot() {
			waves = new Array();
		}
		
		public function addWave(w:Wave):void {
			waves.push(w);
		}

		override public function toString():String {
			return "x: "+Math.round(x).toString()+" , "+Math.round(y).toString();
		}
		
		public function getWaves():Array {
			return waves;
		}
	}
}