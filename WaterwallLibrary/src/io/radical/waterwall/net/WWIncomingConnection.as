package io.radical.waterwall.net {
	
	import flash.utils.Dictionary;
	
	import io.radical.waterwall.events.FillEvent;
	import io.radical.waterwall.events.WaveEvent;
	
	[Bindable]
	public class WWIncomingConnection extends WWAbstractConnection {
		
		public function WWIncomingConnection( connectionName:String ) {
			super(connectionName, true);
		}
		
		public function dispatchFill( fill:Number ):void {
			_connected = true;
			this.dispatchEvent( new FillEvent( fill ) );
		}
		
		public function dispatchWave( amplitude:Number, x:Number ):void {
			_connected = true;
			_dispatchWave( amplitude, x );
		}
		
		private function _dispatchWave( amplitude:Number, x:Number ):void {
			this.dispatchEvent( new WaveEvent( amplitude, x ) );
		}
		
		public function dispatchWaveSeries( waves:Dictionary ):void {
			_connected = true;
			for ( var key:String in waves )
				_dispatchWave( waves[key], Number(key) );
		}
		
		public function reconnect():void {
			this.connect();
		}
				
	}
}