package io.radical.waterwall.events {
	
	import flash.events.Event;

	public class FillEvent extends Event {
		
		public static const FILL_UPDATE:String = "WWFillUpdateEvent";
		
		public var data:Number = 0;
		
		public function FillEvent( data:Number, bubbles:Boolean = false, cancelable:Boolean = false ) {
			super(FILL_UPDATE, bubbles, cancelable);
			this.data = data;
		}
		
	}
}