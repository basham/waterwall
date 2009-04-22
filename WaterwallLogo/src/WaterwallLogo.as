package {

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import io.radical.waterwall.buoy.Buoy;
	import io.radical.waterwall.messaging.WWMessageBoard;
	import io.radical.waterwall.water.Water;

	[SWF(width="300", height="100", frameRate="30", backgroundColor="#FFFFFF")]
	public class WaterwallLogo extends Sprite {
		
		private const W:uint = 300;
		private const H:uint = 100;
		private const FRAME_RATE:uint = 30;
		
		private const TEXT_SIZE:uint = 60;
		private const FILL:Number = .45;
		
		private var sendWaves:Boolean = true;
		private var ampLow:uint = 1; // 1
		private var ampHigh:uint = 2; // 5
		private var freqLow:uint = 50; // 2
		private var freqHigh:uint = 50; // 2
		
		private var buoy:Buoy;
		private var board:WWMessageBoard;
		private var water:Water;
		private var timerFrame:Timer;
		
		[Embed(source="../assets/Arial Rounded Bold.ttf",
		fontWeight="Regular", fontName="messageFont",
		mimeType='application/x-font')]
		private var font:Class;
		
		public function WaterwallLogo() {
			
			var buoyWidth:Number = 12;
			buoy = new Buoy( buoyWidth );
			buoy.anchorX = W / 2;
			buoy.borderRadius = W * .3;
				
			board = new WWMessageBoard();
			board.dynamicAnchor( buoy, buoyWidth * .5, - buoyWidth * .25 );
				
			water = new Water( W, H, FILL );
			water.addFloatingItem( buoy );
			
			var format:TextFormat = new TextFormat();
			format.font = "messageFont";
			format.color = 0x86B7DA;
			format.size = TEXT_SIZE;
			
			var logoField:TextField = new TextField();
			logoField.embedFonts = true;
			logoField.selectable = false;
			logoField.text = "waterwall";
			logoField.autoSize = TextFieldAutoSize.LEFT;
			logoField.setTextFormat( format );
			logoField.x = ( W - logoField.width ) / 2;
			logoField.y = H - logoField.height;
			logoField.mask = water.waterShape;
			
			var s:Shape = new Shape();
			s.graphics.beginFill( 0x324C59 );
			s.graphics.drawRect( 0, 0, W, H );
			s.graphics.endFill();

			this.addChild( s );
			this.addChild( water );
			this.addChild( logoField );

			
			
			
			timerFrame = new Timer( 1000 / FRAME_RATE );
			timerFrame.start();
			timerFrame.addEventListener( TimerEvent.TIMER, onTimerFrame );
		}

		private function onTimerFrame( event:TimerEvent ):void {
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
