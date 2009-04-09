package io.radical.waterwall.messaging {
	
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class WWMovingLabel extends TextField {
		
		private var format:TextFormat;
		
		private var movingPoint:WWMovingPoint;
		
		[Embed(source="../assets/Arial Rounded Bold.ttf",
		fontWeight="Regular", fontName="messageFont",
		mimeType='application/x-font')]
		private var font:Class;
		
		public function WWMovingLabel( label:String = '' ) {
			
			super();
			
			movingPoint = new WWMovingPoint();
			movingPoint.shift = .4;
			
			format = new TextFormat();
			format.font = "messageFont";
			format.color = 0xFFCCCC;
			format.size = 16;
			
			this.embedFonts = true;
			this.selectable = false;
			this.enableAutoSize = true;
			this.label = label;
		}
		
		public function set enableAutoSize( value:Boolean ):void {
			this.autoSize = value ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
		}
		
		public function set label( value:String ):void {
			this.text = value;
			reset();
		}
		
		public function set color( value:uint ):void {
			format.color = value;
			reset();
		}
		
		public function set size( value:Number ):void {
			format.size = value;
			reset();
		}
		
		private function reset():void {
			this.setTextFormat( format );
		}
		
		public function set centroid( value:Point ):void {
			setCentroid( value.x, value.y );
		}
		
		public function setCentroid( x:Number, y:Number ):void {
			var cx:Number = x - this.width / 2;
			var cy:Number = y - this.height / 2;
			movingPoint.anchorX = cx;
			movingPoint.anchorY = cy;
			movingPoint.animate( this.x < cx ? 1 : 0, this.y < cy ? 1 : 0 );
			this.x = movingPoint.x;
			this.y = movingPoint.y;
		}
		
	}
}