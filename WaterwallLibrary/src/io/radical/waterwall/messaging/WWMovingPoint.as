package io.radical.waterwall.messaging {
	
	import flash.geom.Point;
	
	/**
	 * 
	 * @see http://blog.circlecube.com/2009/02/portfolio/random-movement-brownian-revisited-for-as3/
	 * 
	 * */
	public class WWMovingPoint extends Point {
		
		public var borderRadius:Number;
		public var shift:Number;
		public var dampen:Number;
		
		public var anchorX:Number;
		public var anchorY:Number;
		
		private var vx:Number = 0;
		private var vy:Number = 0;
		
		public function WWMovingPoint( anchorX:Number = 0, anchorY:Number = 0, borderRadius:Number = 4, shift:Number = .6, dampen:Number = .95 ) {
			super();
			this.anchorX = this.x = anchorX;
			this.anchorY = this.y = anchorY;
			this.borderRadius = borderRadius;
			this.shift = shift;
			this.dampen = dampen;
		}
		
		public function animate( sx:Number = -1, sy:Number = -1 ):void {
			sx = sx == -1 ? Math.random() : sx;
			sy = sy == -1 ? Math.random() : sy;
			vx += sx * shift - ( shift / 2 );
			vy += sy * shift - ( shift / 2 );
			x += vx;
			y += vy;
			vx *= dampen;
			vy *= dampen;
			constrainWithinBoundries();
		}
		
		private function constrainWithinBoundries():void {
			var anchor:Point = new Point( anchorX, anchorY );
			var distance:Number = distance( this, anchor );
			if ( distance <= borderRadius )
				return;
			var adjusted:Point = interpolate( this, anchor, borderRadius / distance );
			x = adjusted.x;
			y = adjusted.y;
		}

	}
}