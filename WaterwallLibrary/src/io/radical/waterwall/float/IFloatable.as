package io.radical.waterwall.float {
	
	import flash.display.DisplayObject;
	
	public interface IFloatable {
		
		function get yVelocity():Number;
		function set yVelocity( value:Number ):void;
		
		function get displayObject():DisplayObject;
		function set displayObject( object:DisplayObject ):void;

	}
}