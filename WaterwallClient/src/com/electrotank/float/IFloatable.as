package com.electrotank.float {
	import flash.display.DisplayObject
	public interface IFloatable {
		function setYVelocity(num:Number):void;
		function getYVelocity():Number;
		function setDisplayObject(dob:DisplayObject):void;
		function getDisplayObject():DisplayObject;
	}
}