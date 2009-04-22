package {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import io.radical.waterwall.buoy.Buoy;
	import io.radical.waterwall.messaging.WWMessageBoard;
	import io.radical.waterwall.water.Water;

	[SWF(width="300", height="80", frameRate="30", backgroundColor="#FFFFFF")]
	public class WaterwallLogo extends Sprite {
		
		private const W:uint = 300;
		private const H:uint = 80;
		private const FILL:Number = .55;
		
		private var sendWaves:Boolean = true;
		private var ampLow:Number = .5; // 1
		private var ampHigh:Number = 1.5; // 5
		private var freqLow:uint = 50; // 2
		private var freqHigh:uint = 50; // 2
		
		private var buoy:Buoy;
		private var board:WWMessageBoard;
		private var water:Water;
		private var logo:Sprite;
		
		[Embed(source="../assets/logo_text.swf")]
		private var logoSWF:Class;
		
		public function WaterwallLogo() {
			
			var buoyWidth:Number = 12;
			buoy = new Buoy( buoyWidth );
			buoy.anchorX = W / 2;
			buoy.borderRadius = W * .3;
			buoy.y = H / 2;
			buoy.shift = .2;
				
			board = new WWMessageBoard();
			board.dynamicAnchor( buoy, buoyWidth * .5, - buoyWidth * .25 );
				
			water = new Water( W, H, FILL );
			water.addFloatingItem( buoy );
			
			logo = new logoSWF() as Sprite;
			logo.scaleX = logo.scaleY = W / logo.width;
			logo.y = H - logo.height;
			logo.mask = water.waterShape;
			
			//var s:Shape = new Shape();
			//s.graphics.beginFill( 0x324C59 );
			//s.graphics.drawRect( 0, 0, W, H );
			//s.graphics.endFill();

			//this.addChild( s );
			this.addChild( water );
			this.addChild( logo );

			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}

		private function onEnterFrame( event:Event ):void {
			if ( sendWaves )
				randomWaves();
		}
		
		private function randomWaves():void {
			
			var ampRand:Number = Math.random();
			var amplitude:Number = ampRand * ( ampHigh - ampLow ) + ampLow;
			
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
				water.injectWave( amplitude, x );
		}

	}
}
