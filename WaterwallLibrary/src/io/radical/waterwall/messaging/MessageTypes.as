package io.radical.waterwall.messaging {
	
	import flash.utils.Dictionary;
	
	public class MessageTypes {
		
		
		public static const EMPTY:String = "emptyMessage";
		public static const STRONG_AMPLITUDE:String = "strongAmpMessage";
		public static const AGNOSTIC:String = "agnosticMessage";
		public static const FEW:String = "fewMessage";
		
		
		private static var emptyMessages:Array = [
			"Where'd everybody go?",
			"Hey You! Come play with me!",
			"I'm so scared!",
			"It sure is lonely over here..." ];
			
		private static var strongAmpMessages:Array = [
			"Surf's up!",
			"Slow down there, tiger!",
			"I'm gonna be sick..." ];
			
		private static var agnosticMessages:Array = [
			"Why are fish so smart?\rBecause they live in schools!",
			//"What do you call a fish with no eyes?\rFsh!",
			"Why do all pirates have eyepatches?\rChuck Norris" ];
			
		private static var fewMessages:Array = [
			"Where are all your friends?",
			"Where's the party at?" ];
		
		
		private static var lastIndexes:Dictionary = new Dictionary( true );


		public static function RandomMessage( messageType:String ):String {
			switch( messageType ) {
				case EMPTY:
					return _RandomMessage( emptyMessages );
				case STRONG_AMPLITUDE:
					return _RandomMessage( strongAmpMessages );
				case AGNOSTIC:
					return _RandomMessage( agnosticMessages );
				case FEW:
					return _RandomMessage( fewMessages );
			}
			return '';
		}
		
		private static function _RandomMessage( array:Array ):String {
			return array[ RandomIndex( array ) ];
		}
		
		private static function RandomIndex( array:Array ):uint {
			var r:uint = 0;
			var lastIndex:int = lastIndexes[ array ] >= 0 ? lastIndexes[ array ] : -1;
			if ( array.length <= 1 )
				return r;
			do {
				r = Math.floor( Math.random() * array.length );
			} while ( r == lastIndex );
			lastIndexes[ array ] = r;
			return r;
		}

	}
}