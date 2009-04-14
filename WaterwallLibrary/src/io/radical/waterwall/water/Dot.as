package io.radical.waterwall.water {
	
	import flash.geom.Point;
	
	public class Dot extends Point {
		
		private var _waves:Array = new Array();
		
		public function Dot() {
		}
		
		public function get waves():Array {
			return _waves;
		}
		
		public function addWave( w:Wave ):void {
			_waves.push( w );
		}

		override public function toString():String {
			return "x: " + Math.round(x).toString() + " , " + Math.round(y).toString();
		}
		
	}
}