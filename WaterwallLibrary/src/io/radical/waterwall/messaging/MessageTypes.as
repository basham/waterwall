package io.radical.waterwall.messaging {
	
	import flash.utils.Dictionary;
	
	public class MessageTypes {
		
		
		public static const EMPTY:String = "emptyMessage";
		public static const STRONG_AMPLITUDE:String = "strongAmpMessage";
		public static const AGNOSTIC:String = "agnosticMessage";
		public static const FEW:String = "fewMessage";
		public static const HIGH:String = "highMessage";
		
		private static var emptyMessages:Array = [
			"Where'd everybody go?",
			"Hey You! Come play with me!",
			"I'm so scared!",
			"It sure is lonely over here...",
			"Those seagulls sure look happy." ];
			
		private static var strongAmpMessages:Array = [
			"Surf's up!",
			"Slow down there, tiger!",
			"I'm gonna be sick...",
			"I'm getting dizzy..." ];
			
		private static var agnosticMessages:Array = [
			"Why are fish so smart?\rBecause they live in schools!",
			"What do you call a fish with no eyes?\rFsh!",
			"Why do all pirates have eyepatches?\rChuck Norris",
			"What kind of lettuce did they serve on the Titanic?\rIceburg" ];
			
		private static var fewMessages:Array = [
			"Where are all your friends?",
			"Where's the party at?",
			"Why are you alone?",
			"Let's get this party started." ];
		
		private static var highMessages:Array = [
			"I can see my house from up here.",
			"How's the weather down there?",
			"There sure are a lot of you.",
			"Now this is a party!",
			"Who invited all of you?" ];
			
		
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
				case HIGH:
					return _RandomMessage( highMessages );
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