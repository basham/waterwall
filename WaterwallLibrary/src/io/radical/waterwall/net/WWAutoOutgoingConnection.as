package io.radical.waterwall.net {
	
	import edu.iu.vis.utils.NumberUtil;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class WWAutoOutgoingConnection {
		
		public var sendWaves:Boolean = true;
		public var ampLow:uint = 1; // 1
		public var ampHigh:uint = 12; // 5
		public var freqLow:uint = 100; // 2
		public var freqHigh:uint = 100; // 2
		
		public var sendFill:Boolean = true;
		public var fillOffset:Number = .2;
		public var fillFreq:uint = 2;
		
		private var timerFrame:Timer;
		private var lastFill:Number = 0;
		
		private var incoming:WWIncomingConnection;
		
		public function WWAutoOutgoingConnection( incoming:WWIncomingConnection, fps:uint = 30 ) {
			this.incoming = incoming;
			timerFrame = new Timer( 1000 / fps );
			timerFrame.start();
			timerFrame.addEventListener( TimerEvent.TIMER, onTimerFrame );
		}
		
		private function onTimerFrame( event:TimerEvent ):void {
			// 3 Waves Max?
			if ( sendWaves )
				randomWaves();

			if ( sendFill )
				randomFill();
		}
		
		private function randomWaves():void {
			
			//var ampLow:Number = randomAmpSlider.values[0];
			//var ampHigh:Number = randomAmpSlider.values[1];
			var ampRand:Number = Math.random();
			var amplitude:Number = ampRand * ( ampHigh - ampLow ) + ampLow;
			
			//var freqLow:Number = randomLowFreqSlider.value;
			//var freqHigh:Number = randomHighFreqSlider.value;
			
			/**
			 * y = mx + b
			 * y = frequency
			 * m = slope
			 * x = amplitude
			 * b = y-axis intersection
			 * */
			var m:Number = ( freqLow - freqHigh ) / ( ampLow - ampHigh );
			var b:Number = freqLow - m * ampLow;
			
			var frequency:Number = m * amplitude + b;
			
			var inject:Boolean = Math.random() * 100 <= frequency;
			
			var x:Number = Math.random();
			
			if ( inject )
				incoming.dispatchWave( amplitude, x );
		}
		
		private function randomFill():void {

			var fill:Number = NumberUtil.CleanPercentage( lastFill + Math.random() * fillOffset * ( Math.random() > .5 ? -1 : 1 ) );
			var inject:Boolean = Math.random() * 100 <= fillFreq;
			
			if ( inject ) {
				incoming.dispatchFill( fill );
				lastFill = fill;
			}
		}
		
	}
}