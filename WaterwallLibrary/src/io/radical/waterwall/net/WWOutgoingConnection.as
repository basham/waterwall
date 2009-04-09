package io.radical.waterwall.net {
	
	import flash.utils.Dictionary;
	
	public class WWOutgoingConnection extends WWAbstractConnection {
		
		private var lastFill:Number = 0;
		
		public function WWOutgoingConnection( connectionName:String ) {
			super(connectionName, false);
		}
		
		public function sendFill( fill:Number ):void {
			fill = Number( fill.toFixed( 3 ) );
			if ( fill == lastFill )
				return;
			lastFill = fill;
			connection.send( connectionName, "dispatchFill", fill );
		}
		
		public function sendWave( strength:Number, x:Number ):void {
			connection.send( connectionName, "dispatchWave", strength, x );
		}
		
		public function sendWaveSeries( waves:Dictionary ):void {
			connection.send( connectionName, "dispatchWaveSeries", waves );
		}
		
	}
}