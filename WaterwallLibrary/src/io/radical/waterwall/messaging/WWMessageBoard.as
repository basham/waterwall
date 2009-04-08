package io.radical.waterwall.messaging {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import gs.TweenLite;
	import gs.easing.*;

	public class WWMessageBoard extends Sprite {
		
		private const NORMAL:uint = 0;
		private const LOCKED:uint = 1;
		private const HIDDEN:uint = 2;
		
		private var board:Sprite;
		private var bubble:Sprite;
		private var box:WWMovingShape;
		private var arrow:WWMovingShape;
		private var label:WWMovingLabel;
		
		private var absAnchor:Point;
		private var _anchor:Point;
		private var movingAnchor:WWMovingPoint;
		
		private var w:Number = 0;
		private var h:Number = 0;
		private var arrowW:Number = 0;
		private var labelW:Number = 0;
		private var _anchorPosition:Number = .5;
		
		private var timer:Timer;
		private var messageQueue:Array = new Array();
		
		private var state:uint = NORMAL;
		
		private var s:Shape;
		
		public function WWMessageBoard( autoHide:Boolean = true ) {
			
			super();
			
			movingAnchor = new WWMovingPoint();
			_anchor = new Point();
			absAnchor = new Point();
			board = new Sprite();
			bubble = new Sprite();
			s = new Shape();
			
			label = new WWMovingLabel();
			label.color = 0xe73333;
			box = new WWMovingShape( 4, 4 );			
			arrow = new WWMovingShape( 2 );
			box.fillColor = arrow.fillColor = 0xffc8c8;
			
			//var dialogShadow:DropShadowFilter = new DropShadowFilter( 4, 60, 0xe73333, .5, 4, 4, 1, 2 );
			var dialogShadow:DropShadowFilter = new DropShadowFilter( 2, 60, 0xe73333, .5, 1, 1, 1, 2 );
			bubble.filters = [ dialogShadow ];
			
			var labelShadow:DropShadowFilter = new DropShadowFilter( 2, 60, 0xb43332, 1, 1, 1, 1, 2 );
			//label.filters = [ labelShadow ];
			
			setMessage( ' ' );
			
			bubble.addChild( box );
			bubble.addChild( arrow );
			
			board.addChild( bubble );
			board.addChild( label );
			
			this.addChild( board );
			//this.addChild( s );

			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );

			if ( autoHide )			
				hide( 0 ); // Immediately hide
		}
		
		private function setMessage( message:String = '' ):void {
			label.enableAutoSize = true;
			label.label = message;
			w = label.textWidth * 1.1 + 20; // 200
			h = label.textHeight * 1.6 + 20; // 80
			setDimensions( w, h );
			label.enableAutoSize = false;
		}
		
		private function setDimensions( width:Number, height:Number ):void {
			box.clearAnchors();
			box.addAnchor( 0, 0 );
			box.addAnchor( width, 0 );
			box.addAnchor( width, height );
			box.addAnchor( 0, height );
			
			var maxArrowWidth:Number = 200;
			arrow.clearAnchors();
			arrow.addAnchor( 0, 0 );
			arrow.addAnchor( width < maxArrowWidth ? width * .4 : maxArrowWidth * .4, 0 ); // 40, 0
			arrow.addAnchor( width < maxArrowWidth ? width * .2 : maxArrowWidth * .2, height * .75 ); // 20, 70
			
			animate();
			resetAnchor();
			
			arrowW = arrow.width / arrow.scaleX;
			labelW = label.width / label.scaleX;
		}
		
		public function get anchorPosition():Number {
			return _anchorPosition;
		}
		
		public function set anchorPosition( value:Number ):void {
			_anchorPosition = value;
		}
		
		public function get anchor():Point {
			return _anchor;
		}

		public function setAnchor( x:Number, y:Number ):void {
			absAnchor = new Point( x, y );
			var relative:Point = anchor.add( new Point( this.x, this.y ) ).subtract( absAnchor );
			//movingAnchor.anchorX -= relative.x;
			//movingAnchor.anchorY -= relative.y;
			//			this.x = movingAnchor.x;
			//this.y = movingAnchor.y;
			//animateAnchor();
			this.x -= relative.x;
			this.y -= relative.y;
			//TweenLite.to( this, .5, { x: this.x - relative.x, y: this.y - relative.y, ease: Quad.easeOut } );
		}
		
		private function resetAnchor():void {
			setAnchor( absAnchor.x, absAnchor.y );
		}
		
		private var dynamicAnchorDO:DisplayObject;
		private var xOffset:Number = 0;
		private var yOffset:Number = 0;
		
		public function dynamicAnchor( displayObject:DisplayObject, xOffset:Number = 0, yOffset:Number = 0 ):void {
			dynamicAnchorDO = displayObject;
			this.xOffset = xOffset;
			this.yOffset = yOffset;
			dynamicAnchorDO.addEventListener( Event.ENTER_FRAME, onDynamicAnchorFrame, false, 0, true );
		}
		
		private function onDynamicAnchorFrame( event:Event ):void {
			//trace( '*', dynamicAnchorDO.x, dynamicAnchorDO.y );
			setAnchor( dynamicAnchorDO.x + xOffset, dynamicAnchorDO.y + yOffset );
		}
		
		public function queue( dialog:String, duration:Number = -1, delimator:String = '\r' ):void {
			var lines:Array = dialog.split( delimator );
			for each( var line:String in lines )
				_queue( line, duration );
		}
		
		private function _queue( message:String, duration:Number = -1 ):void {

			duration = duration == -1 ? message.length * .15 : duration;
			messageQueue.push( new WWMessage( message, duration ) );
			
			if ( state == HIDDEN ) {
				loadNextMessage();
				show();
			}
		}
		
		private function loadNextMessage():void {
			if ( messageQueue.length > 0 )
				loadMessage( messageQueue.shift() as WWMessage );
		}
		
		private function loadMessage( message:WWMessage ):void {
			setMessage( message.message );
			timer = new Timer( message.duration * 1000, 1 );
			timer.start();
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true );
		}
		
		private function onTimerComplete( event:TimerEvent ):void {
			if ( messageQueue.length > 0 )
				transition();
			else
				hide();
		}
		
		public function toggleShowHide():void {
			if ( state == HIDDEN )
				show();
			else if ( state == NORMAL )
				hide();
		}
		
		public function show( duration:Number = .75 ):void {
			
			if ( state != HIDDEN )
				return;
			
			state = LOCKED;
			box.x = arrow.x = label.x = anchor.x; // This value wasn't completely set following hide tween (TweenLite BUG?), so explicitly set it.
			box.width = arrow.width = 3;
			bubble.height = label.width = 0;

			TweenLite.to( bubble, duration * .375, { alpha: 100, scaleY: 1, y: 0, ease: Back.easeOut } );
			TweenLite.to( box, duration, { scaleX: 1, x: 0, ease: Back.easeOut, delay: duration * .375, onComplete: onShowComplete } );
			TweenLite.to( arrow, duration * .375, { scaleX: 1, x: anchor.x - arrowW / 2, ease: Back.easeOut, delay: duration * .375 } );
			TweenLite.to( label, duration * .375, { alpha: 100, width: labelW, ease: Quad.easeOut, delay: duration * .45 } );
		}
		
		private function onShowComplete():void {
			state = NORMAL;
		}
		
		public function hide( duration:Number = .75 ):void {
			
			if ( state != NORMAL )
				return;
			
			state = LOCKED;

			TweenLite.to( box, duration, { width: 3, x: anchor.x, ease: Back.easeIn } );
			TweenLite.to( arrow, duration * .375, { width: 3, x: anchor.x, ease: Back.easeIn, delay: duration * .625 } );
			TweenLite.to( label, duration * .375, { alpha: 0, width: 0, x: anchor.x, ease: Quad.easeIn, delay: duration * .625 } );
			TweenLite.to( bubble, duration * .375, { alpha: 0, height: 0, y: anchor.y, ease: Back.easeIn, delay: duration, onComplete: onHideComplete } );
		}
		
		private function onHideComplete():void {
			state = HIDDEN;
		}
		
		private function transition( substate:uint = 0, duration:Number = .75 ):void {
			
			state = LOCKED;
			
			switch( substate ) {
				case 0:
					TweenLite.to( box, duration, { width: 3, x: anchor.x, ease: Back.easeIn, onComplete: transition, onCompleteParams: [1] } );
					TweenLite.to( arrow, duration * .375, { width: 3, x: anchor.x, ease: Back.easeIn, delay: duration * .625 } );
					TweenLite.to( label, duration * .375, { alpha: 0, width: 0, x: anchor.x, ease: Quad.easeIn, delay: duration * .625 } );
					break;
				case 1:
					
					loadNextMessage();
					
					positionAnchor();
					resetAnchor();
					box.x = arrow.x = label.x = anchor.x;
					box.width = arrow.width = 3;
					label.width = 0;

					TweenLite.to( box, duration, { scaleX: 1, x: 0, ease: Back.easeOut, delay: duration * .375, onComplete: transition, onCompleteParams: [2] } );
					TweenLite.to( arrow, duration * .375, { scaleX: 1, x: anchor.x - arrowW / 2, ease: Back.easeOut, delay: duration * .375 } );
					TweenLite.to( label, duration * .375, { alpha: 100, width: labelW, ease: Quad.easeOut, delay: duration * .45 } );
					break;
				case 2:
					state = NORMAL;
			}
		}


		private function onEnterFrame( event:Event ):void {
			if ( state != HIDDEN )
				animate();
		}
		
		public function animate():void {
			box.animate();
			arrow.animate();
			label.centroid = box.centroid;
			if ( state != LOCKED )
				positionAnchor();
			animateAnchor();
		}
		
		private function animateAnchor():void {
			movingAnchor.animate();
			board.x = movingAnchor.x;
			board.y = movingAnchor.y;
		}
		
		private function positionAnchor():void {
			
			var offset:Number = arrowW * .55;
			
			_anchor.x = ( w - offset * 2 ) * anchorPosition + offset;
			_anchor.y = h * 1.25;
			
			arrow.x = anchor.x - arrow.width * .5; // 150
			arrow.y = h * .5; // 40
			
			//s.graphics.clear();
			//s.graphics.beginFill( 0xFF0000 );
			//s.graphics.drawRect( anchor.x - 1, anchor.y - 1, 2, 2 );
		}

	}
}