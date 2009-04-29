package io.radical.waterwall.environment {
	
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class Sky extends Sprite {
		
		private var bounds:Rectangle;
		private var colors:Array = [ 0xDDDDFF, 0xFFFFFF ];
		
		public function Sky( width:Number = 200, height:Number = 200 ) {
			super();
			bounds = new Rectangle( 0, 0, width, height );
			render();
		}
		
		public function setSize( width:Number, height:Number ):void {
			bounds.width = width;
			bounds.height = height;
			render();
		}
		
		public function render():void {
			
			var boxRotation:Number = Math.PI / 2;
			var tx:Number = 0;
			var ty:Number = 0;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( bounds.width, bounds.height, boxRotation, tx, ty );
			
			var type:String = GradientType.LINEAR;
			var alphas:Array = [ 1, 1 ];
			var ratios:Array = [ 0, 255 ];
			
			var spreadMethod:String = SpreadMethod.PAD;
			var interp:String = InterpolationMethod.LINEAR_RGB;
			var focalPtRatio:Number = 0;

			this.graphics.clear();
            this.graphics.beginGradientFill( type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio );
			this.graphics.drawRect( bounds.x, bounds.y, bounds.width, bounds.height );
			this.graphics.endFill();
		}
		
	}
}