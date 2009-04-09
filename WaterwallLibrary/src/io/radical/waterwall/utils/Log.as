package io.radical.waterwall.utils {
	
	import edu.iu.vis.utils.Normalize;
	
	public class Log {
		
		private var values:Array = new Array();
		private var _maxLength:uint = 0;
		
		public function Log( maxLength:uint = 0 ) {
			_maxLength = maxLength;
		}
		
		public function index( index:uint ):Number {
			return values[ index ];
		}
		
		public function get length():uint {
			return values.length;
		}
		
		public function get maxLength():uint {
			return _maxLength;
		}
		
		public function set maxLength( value:uint ):void {
			_maxLength = value;
		}
		
		public function push( value:Number ):void {
			values.unshift( value );
			while( values.length > maxLength )
				values.pop();
		}

		public function average():Number {
			return Normalize.Average( values, Normalize.LINEAR );
		}

	}
}