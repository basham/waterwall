package io.radical.waterwall.buoy {
	
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	import gs.easing.*;
	
	import io.radical.waterwall.float.FloatingSprite;
	import io.radical.waterwall.messaging.WWMovingPoint;

	public class Buoy extends FloatingSprite {
		
		private const NORMAL_STATE:uint = 0;
		private const LOCKED_STATE:uint = 1;
		
		[Embed(source="../assets/buoy_4b.swf")]
		private var buoySWF:Class;

		private var buoy:Sprite;
		private var base:Shape = new Shape();
		private var light:Sprite = new Sprite();
		
		private var movingPoint:WWMovingPoint;
		
		private var lightState:uint = NORMAL_STATE;
		
		private var blinkDuration:Number = 0;
		private var blinkFadeDuration:Number = 0;
		private var blinkTimer:Timer;
		
		public function Buoy( width:Number = 30 ) {
			
			super();
			
			this.buoyancy = .7;
			
			buoy = new buoySWF() as Sprite;
			
			var scale:Number = width / buoy.width;
			buoy.scaleX = buoy.scaleY = scale;
			
			drawLight( width * .5 );
			light.x = width / 2;
			light.alpha = 0;
			
			movingPoint = new WWMovingPoint();

			this.addChild( buoy );
			this.addChild( light );
			
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			blinker( 0, 1, .5 ); // Medium pace
			//blinker( .1, .1, 0 ); // Really fast
		}
		
		private function onEnterFrame( event:Event ):void {
			movingPoint.x = this.x;
			movingPoint.animate();
			this.x = movingPoint.x;
		}
		
		public function blinker( pause:Number = 1, duration:Number = 1, fadeDuration:Number = 1 ):void {
			this.blinkDuration = duration;
			this.blinkFadeDuration = fadeDuration;
			blinkTimer = new Timer( 1000 * ( duration + fadeDuration * 2 + pause ) );
			blinkTimer.start();
			blinkTimer.addEventListener( TimerEvent.TIMER, onBlinkTimer );
		}
		
		private function onBlinkTimer( event:Event ):void {
			blink( blinkDuration, blinkFadeDuration );
		}
		
		public function set anchorX( value:Number ):void {
			this.x = movingPoint.anchorX = value;
		}
		
		public function set borderRadius( value:Number ):void {
			movingPoint.borderRadius = value;
		}
		
		public function set shift( value:Number ):void {
			movingPoint.shift = value;
		}
		
		public function blink( duration:Number = 1, fadeDuration:Number = 1 ):void {
			
			if ( lightState != NORMAL_STATE )
				return;
			
			lightState = LOCKED_STATE;

			TweenLite.to( light, fadeDuration, { alpha: 1, ease: Back.easeIn } );
			TweenLite.to( light, fadeDuration, { alpha: 0, ease: Back.easeOut, delay: fadeDuration + duration, overwrite: false, onComplete: onBlinkComplete } );
		}
		
		private function onBlinkComplete():void {
			lightState = NORMAL_STATE;
		}
		
		private function drawLight( radius:Number ):void {
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( radius * 2, radius * 2, 0, -radius, -radius );
			
			var type:String = GradientType.RADIAL;
			var colors:Array = [ 0xFFFFFF, 0xFFFF00 ];
			var alphas:Array = [ 1, 0 ];
			var ratios:Array = [ 0, 255 ];
			
			var spreadMethod:String = SpreadMethod.PAD;
			var interp:String = InterpolationMethod.LINEAR_RGB;
			var focalPtRatio:Number = 0;

			light.graphics.clear();
            light.graphics.beginGradientFill( type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio );
			light.graphics.drawCircle( 0, 0, radius );
			light.graphics.endFill();
		}
		
	}
}