package io.radical.waterwall.messaging {
	
	public class WWMessage {
		
		public var message:String;
		public var duration:Number;
		
		public function WWMessage( message:String = '', duration:Number = 0 ) {
			this.message = message;
			this.duration = duration;
		}

	}
}