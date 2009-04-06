package io.radical.waterwall.messaging {
	
	import flash.display.Shape;
	import flash.geom.Point;

	public class WWMovingShape extends Shape {

		public var fillColor:uint = 0x000000;

		private var _borderRadius:Number;
		private var _shift:Number;
		private var _dampen:Number; // Lower for more jitter; Range [0, 1]
		
		private var movingPoints:Array = new Array();
		
		public function WWMovingShape( borderRadius:Number = 4, shift:Number = .6, dampen:Number = .95 ) {
			super();
			this.borderRadius = borderRadius;
			this.shift = shift;
			this.dampen = dampen;
		}
		
		public function get borderRadius():Number {
			return _borderRadius;
		}
		
		public function set borderRadius( value:Number ):void {
			_borderRadius = value;
			for each( var mp:WWMovingPoint in movingPoints )
				mp.borderRadius = value;
		}
		
		public function get shift():Number {
			return _shift;
		}
		
		public function set shift( value:Number ):void {
			_shift = value;
			for each( var mp:WWMovingPoint in movingPoints )
				mp.shift = value;
		}

		public function get dampen():Number {
			return _dampen;
		}
		
		public function set dampen( value:Number ):void {
			_dampen = value;
			for each( var mp:WWMovingPoint in movingPoints )
				mp.dampen = value;
		}
		
		public function addAnchor( x:Number, y:Number ):void {
			movingPoints.push( new WWMovingPoint( x, y, borderRadius, shift, dampen ) );
		}
		
		public function clearAnchors():void {
			movingPoints = new Array();
		}
		
		public function animate():void {
			
			this.graphics.clear();
			this.graphics.beginFill( fillColor );
			
			var first:Boolean = true;
			
			for each( var mp:WWMovingPoint in movingPoints ) {
				mp.animate();
				if ( first ) {
					this.graphics.moveTo( mp.x, mp.y );
					first = false;
				}
				this.graphics.lineTo( mp.x, mp.y );
			}
			
			this.graphics.endFill();
		}
		
		public function get centroid():Point {
			// return TrigUtil.AvgPoint( mp );
			var centroid:Point = new Point();
			
			if ( movingPoints.length == 0 )
				return centroid;
			
			for each ( var mp:WWMovingPoint in movingPoints ) {
				centroid.x += mp.x;
				centroid.y += mp.y;
			}
			
			centroid.x /= movingPoints.length;
			centroid.y /= movingPoints.length;
			
			return centroid;
		}
		
	}
}