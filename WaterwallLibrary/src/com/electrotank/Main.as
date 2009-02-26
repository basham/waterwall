package com.electrotank {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.events.MouseEvent;
	import com.electrotank.water.Water;
	import com.electrotank.water.Wave;
	import com.electrotank.water.Dot;
	import com.electrotank.float.IFloatable;
	import com.electrotank.float.RubberDucky;
	public class Main extends MovieClip {
		private var water:Water;
		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
        	stage.addEventListener(MouseEvent.CLICK, mouseDownHandler);
		}
		public function mouseDownHandler(ev:Event):void {
			water.injectWave(15, mouseX);
		}
		public function addedToStage(ev:Event):void {
			water = new Water();
			water.y = 300;
			addChild(water);
			for (var i:int=0;i<5;++i) {
				var f:RubberDucky = new RubberDucky();
				f.x = 100+i*80;
				water.addFloatingItem(f);
			}
		}
	}
}