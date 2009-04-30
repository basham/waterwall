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
	
	import io.radical.waterwall.messaging.WWMovingPoint;

	public class Buoy extends Sprite {
		
		private const NORMAL_STATE:uint = 0;
		private const LOCKED_STATE:uint = 1;
		
		[Embed(source="../assets/buoy_4b.swf")]
		private var buoySWF:Class;

		private var buoy:Sprite;
		private var base:Shape = new Shape();
		private var light:Shape = new Shape();
		
		private var movingPoint:WWMovingPoint;
		
		private var lightState:uint = NORMAL_STATE;
		
		public function Buoy( width:Number = 30 ) {
			
			super();
			
			buoy = new buoySWF() as Sprite;
			
			var scale:Number = width / buoy.width;
			buoy.scaleX = buoy.scaleY = scale;
			
			drawLight( width * 1 );
			light.x = light.y = width / 2;
			//light.alpha = .5;
			
			movingPoint = new WWMovingPoint();
			
			this.addChild( buoy );
			this.addChild( light );
			
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			
			var t:Timer = new Timer( 4000 );
			t.start();
			t.addEventListener( TimerEvent.TIMER, onTimer );
		}
		
		private function onTimer( event:Event ):void {
			blink(4);
		}
		
		private function onEnterFrame( event:Event ):void {
			movingPoint.x = this.x;
			movingPoint.animate();
			this.x = movingPoint.x;
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
			trace( 'BLINKING' );
			TweenLite.to( light, fadeDuration, { alpha: 1, ease: Back.easeIn } );
			TweenLite.to( light, fadeDuration, { alpha: 0, ease: Back.easeOut, delay: fadeDuration + duration, onComplete: onBlinkComplete } );
		}
		
		private function onBlinkComplete():void {
			trace( 'COMPLETE' );
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