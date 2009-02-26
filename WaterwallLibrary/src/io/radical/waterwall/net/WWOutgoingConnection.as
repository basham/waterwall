package io.radical.waterwall.net {
	
	public class WWOutgoingConnection extends WWAbstractConnection {
		
		public function WWOutgoingConnection( connectionName:String ) {
			super(connectionName, false);
		}
		
		public function sendFill( fill:Number ):void {
			connection.send( connectionName, "dispatchFill", fill );
		}
		
		public function sendWave( strength:Number, x:Number ):void {
			connection.send( connectionName, "dispatchWave", strength, x );
		}
		
	}
}