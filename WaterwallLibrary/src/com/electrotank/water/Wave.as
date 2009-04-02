package com.electrotank.water {
	
	public class Wave {
		
		private static var Pool:Array = new Array();
		//private static var Instances:uint = 0;
		//private static var Gets:uint = 0;
		
		private var index:int;
		private var A:Number;
		private var dir:Number;
		private var startTime:Number;
		private var firstOne:Boolean;
		private var startX:Number;
		
		public function Wave() {
			//Instances++;
			//trace( '$', Instances );
		}
		
		public static function GetInstance():Wave {
			return ( Pool.length > 0 ? Pool.pop() : new Wave() );
		}

		public function setIndex(val:int):void { 
			index = val;
		}
		
		public function getIndex():int { 
			 return index;
		}
		
		public function setA(val:Number):void { 
			A = val;
		}
		
		public function getA():Number { 
			 return A;
		}
		
		public function setDir(val:Number):void { 
			dir = val;
		}
		
		public function getDir():Number { 
			 return dir;
		}
		
		public function setStartTime(val:Number):void { 
			startTime = val;
		}
		
		public function getStartTime():Number { 
			 return startTime;
		}
		
		public function setFirstOne(val:Boolean):void { 
			firstOne = val;
		}
		
		public function getFirstOne():Boolean { 
			 return firstOne;
		}
		
		public function setStartX(val:Number):void { 
			startX = val;
		}
		
		public function getStartX():Number { 
			 return startX;
		}
		
		public function remove():void {
			Pool.push( this );
							//Gets++;
				//trace( '@', Gets, Pool.length );
		}
		
	}
}