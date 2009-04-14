package io.radical.waterwall.water {
	
	public class Wave {
		
		private static var Pool:Array = new Array();
		
		public var index:int;
		public var A:Number;
		public var dir:Number;
		public var startTime:Number;
		public var firstOne:Boolean;
		public var startX:Number;
		
		public function Wave() {
		}
		
		public static function GetInstance():Wave {
			return ( Pool.length > 0 ? Pool.pop() : new Wave() );
		}
		
		public function remove():void {
			Pool.push( this );
		}
		
	}
}