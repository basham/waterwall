package io.radical.waterwall.net {
	
	import flash.utils.Dictionary;
	
	import io.radical.waterwall.events.FillEvent;
	import io.radical.waterwall.events.WaveEvent;
	
	[Bindable]
	public class WWIncomingConnection extends WWAbstractConnection {
		
		public var enabled:Boolean = true;
		[Bindable]
		public var conflicted:Boolean = false;
		
		public function WWIncomingConnection( connectionName:String ) {
			super(connectionName, true);
		}
		
		public function dispatchFill( fill:Number ):void {
			if ( !enabled ) {
				conflicted = true;
				trace( "** FILL Conflict" );
				return;
			}
			//trace("!!!!!!!!!!  FILL");
			enabled = false;
			this.dispatchEvent( new FillEvent( fill ) );
		}
		
		public function dispatchWave( amplitude:Number, x:Number ):void {
			if ( !enabled ) {
				conflicted = true;
				trace( "** WAVE Conflict" );
				return;
			}
			//trace("!!!!!!!!!!  WAVE");
			enabled = false;
			_dispatchWave( amplitude, x );
		}
		
		private function _dispatchWave( amplitude:Number, x:Number ):void {
			this.dispatchEvent( new WaveEvent( amplitude, x ) );
		}
		
		public function dispatchWaveSeries( waves:Dictionary ):void {
			if ( !enabled ) {
				conflicted = true;
				trace( "** SERIES Conflict" );
				return;
			}
			//trace("!!!!!!!!!!  SERIES");
			enabled = false;
			for ( var key:String in waves )
				_dispatchWave( waves[key], Number(key) );
		}
		
	}
}