package io.radical.waterwall.events {
	
	import flash.events.Event;

	public class WaveEvent extends Event {
		
		public static const WAVE_INJECTION:String = "WWWaveInjectionEvent";
		
		public var amplitude:Number = 0;
		public var x:Number = 0;
		
		public function WaveEvent( amplitude:Number, x:Number, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super(WAVE_INJECTION, bubbles, cancelable);
			this.amplitude = amplitude;
			this.x = x;
		}
		
	}
}