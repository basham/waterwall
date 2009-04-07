package io.radical.waterwall.buoy {
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import io.radical.waterwall.messaging.WWMovingPoint;

	public class Buoy extends Sprite {
		
		[Embed(source="../assets/buoy_2c.swf")]
		private var buoySWF:Class;
		
		private var buoy:Sprite;
		private var base:Shape = new Shape();
		
		private var movingPoint:WWMovingPoint;
		
		public function Buoy( width:Number = 30 ) {
			super();
			buoy = new buoySWF() as Sprite;
			var scale:Number = width / buoy.width;
			
			var tx:Number = width / 2;
			var ty:Number = buoy.height * scale;
			tx = ty = 0;
			var matrix:Matrix = new Matrix( scale, 0, 0, scale, tx, ty );
			buoy.transform.matrix = matrix;
			//buoy.scaleX = buoy.scaleY = scale;
			//buoy.y -= 80;
			//buoy.x -= buoy.width / 2;
			
			movingPoint = new WWMovingPoint();
			
			this.addChild( buoy );
			
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
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
		
		private function render():void {
			base.graphics.beginFill( 0xFF4D4D );
			base.graphics.drawRect( 0, 0, 15, 15 );
			base.graphics.endFill();
		}
		
	}
}