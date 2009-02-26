package io.radical.waterwall.net {
	
	import io.radical.waterwall.events.FillEvent;
	import io.radical.waterwall.events.WaveEvent;
	
	public class WWIncomingConnection extends WWAbstractConnection {
		
		public function WWIncomingConnection( connectionName:String ) {
			super(connectionName, true);
		}
		
		public function dispatchFill( fill:Number ):void {
			this.dispatchEvent( new FillEvent( fill ) );
		}
		
		public function dispatchWave( strength:Number, x:Number ):void {
			this.dispatchEvent( new WaveEvent( strength, x ) );
		}
		
	}
}