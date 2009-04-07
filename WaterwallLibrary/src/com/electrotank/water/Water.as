package com.electrotank.water {
	
	import edu.iu.vis.utils.NumberUtil;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.*;
	
	import io.radical.waterwall.float.FloatingItem;
	import io.radical.waterwall.float.IFloatable;
	
	public class Water extends Sprite {
		
		private var dots:Array;
		private var waves:Array;
		private var shape:Shape;
		private var floatingItems:Array;
		private var _waterWidth:Number;
		private var _bounds:Rectangle;
		private var _fill:Number;
		
		private var maxFill:Number = .9;
		private var minFill:Number = .05;
		
		public function Water( width:Number = 200, height:Number = 100, fill:Number = .5 ) {
			this.bounds = new Rectangle(0, 0, width, height);
			this.fill = fill;
			this.floatingItems = new Array();
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		

		/* ===============================================================
		 * PUBLIC FUNCTIONS: YOU DO STUFF 
		 * ===============================================================*/
		
		/**
		 * Set the size of the water object
		 * 
		 * @param	new width
		 * @param	new height
		 * 
		 */
		public function setSize(width:Number, height:Number):void{
			waterWidth = width;
			bounds.width = width;
			bounds.height = height;
		}
		
		/**
		 * Gently Disturb the Water: injects a wave with power 3, at a random point
		 */
		public function gentlyDisturbWater():void {
			injectWave(1, Math.random()*waterWidth);
		}
		
		/**
		 * Less Gently Disturb: wave ower of 7, random point
		 */
		public function lessGentlyDisturbWater():void {
			injectWave(5, Math.random()*waterWidth);
		}
		
		/**
		 * Violent disturbence: wave power of 15, random point
		 */
		public function violentlyDisturbWater():void {
			injectWave(12, Math.random()*waterWidth);
		}
		
		/**
		 * Inject a wave at a given point
		 * 
		 * @param	wave power
		 * @param	location on x axis
		 */
		public function injectWave(A:Number, x:Number):void {
			x = NumberUtil.CleanPercentage( x );
			x *= this.width;
			x = Math.round( x );
			//trace( '#', x, A );
			addWave(A, x, 1);
			addWave(A, x, -1);
		}
		
		
		/**
		 * Adjust the wave height gradually
		 * 
		 * @param	new height: should be a percentage (0.00 - 1.0)
		 * @param	length of tween
		 */
		 
		//private var frame:uint = 0;
		/*
		public function tweenFill( value:Number, maxDuration:Number = 3, minDuration:Number = 1 ):void {
			
			this.fill = NumberUtil.CleanPercentage(value);
			//trace( '%', frame, this.fill );
			//frame++;
			return;
			
			
			var initialFill:Number = this.fill;
			var diff:Number = Math.abs( tweenValue - initialFill );
			var duration:Number = diff * maxDuration + minDuration;
			
			if ( diff == 0 )
				return;
			
			if ( !fillTween ) {
				GTween.timingMode = GTween.TIME;
				fillTween = new GTween(this, duration);
				fillTween.ease = Quadratic.easeOut;
			}

			fillTween.setProperty("fill", tweenValue);
			fillTween.duration = duration;
			
		}
		*/
		public function addFloatingItem( dob:DisplayObject ):void {
			var fi:FloatingItem = new FloatingItem( dob );
			addIFloatable( fi );
		}
		
		public function addIFloatable( fi:IFloatable ):void {
			getFloatingItems().push( fi );
			addChild( fi.displayObject );
		}
		

		/* ===============================================================
		 * PRIVATE FUNCTIONS: IT DOES STUFF
		 * ===============================================================*/	

		private function enterFrameHandler(ev:Event):void {
			propogateWaves();
			renderWater();
			moveFloatingItems();
		}		 
		 
		 /**
		 * Pushes a Wave to the Queue
		 * 
		 * @param	Wave "power" or strength
		 * @param	Starting X value
		 * @param	I have no idea.  direction, I guess? either 1 or -1
		 * 
		 */
		private function addWave(A:Number, startx:Number, dir:Number):void {
			//f(x) = A*sin(w*t)
			var wave:Wave = Wave.GetInstance();
			wave.setIndex(Math.floor(startx/spacing));
			wave.setA(A);
			wave.setDir(dir);
			wave.setFirstOne(true);
			wave.setStartX(startx);
			wave.setStartTime(getTimer());
			getWaves().push(wave);
		}

		private function propogateWaves():void {
			var t:Number = getTimer();
			var speed:Number = waterWidth/2000;
			var j:int;
			var i:int;
			var wave:Wave;
			var d:Number;
			var dot:Dot;
			for (j=waves.length-1;j>=0;--j) {
				wave = getWaves()[j];
				d = .0001;
				wave.setA(wave.getA() / Math.pow(Math.E, d*(t-wave.getStartTime())));
				var index:Number = Math.floor((wave.getStartX()+wave.getDir()*(t-wave.getStartTime())*speed)/spacing);
				if (index < 0 || index > numDots-1) {
					var a:Wave = waves.splice(j, 1)[0] as Wave;
					if ( a != null ) {
						a.remove();
					}

				} else if (index != wave.getIndex() || (index == wave.getIndex() && wave.getDir() == 1 && wave.getFirstOne())) {
					var w:Wave;
					if (wave.getFirstOne() && wave.getDir() == 1) {
						w = Wave.GetInstance();
						w.setA(wave.getA());
						w.setStartTime(t);
						dot = getDots()[wave.getIndex()];
						dot.getWaves().push(w);
					}
					if (wave.getDir() == 1) {
						for (i=wave.getIndex()+1;i<=index;++i) {
							w = Wave.GetInstance();
							w.setA(wave.getA());
							w.setStartTime(t);
							dot = getDots()[i];
							dot.getWaves().push(w);
						}
					} else {
						for (i=wave.getIndex()-1;i>=index;--i) {
							w = Wave.GetInstance();
							w.setA(wave.getA());
							w.setStartTime(t);
							dot = getDots()[i];
							dot.getWaves().push(w);
						}
					}
					wave.setIndex(index);
					wave.setFirstOne(false);
				}
			}
			var f:Number = 1 - ( fill * ( maxFill - minFill ) + minFill );
			for (i=0;i<dots.length;++i) {
				dot = dots[i];
				var y:Number = 0;
				for (j = dot.getWaves().length-1;j>=0;--j) {
					wave = dot.getWaves()[j];
					var freq:Number = .005;
					d = .99;
					wave.setA(wave.getA()*d);
					y += wave.getA()*Math.sin(freq*(t-wave.getStartTime()));
					if (wave.getA()<.5) {
						var b:Wave = dot.getWaves().splice(j, 1)[0] as Wave;
						if ( b != null )
							b.remove();
					}
				}
				dot.y = y + ( f * bounds.height );
			}
		}
		
		private function moveFloatingItems():void {
			var g:Number = .25;
			//trace( getFloatingItems().length );
			for (var j:int=0;j<getFloatingItems().length;++j) {
				var fi:FloatingItem = getFloatingItems()[j];
				var dob:DisplayObject = fi.displayObject;
				var d:Number = .9;
				var x:Number = Math.round(this.width / 2);
				//dob.x = x;
				var margin:Number = 4;
				var index:Number = Math.floor(x/spacing) - margin/2;
				var y:Number = 0;
				var ang:Number = 0;
				for (var i:uint=index;i<index+margin;++i) {
					y += dots[i].y;
					if (i != index) {
						ang += Math.atan2(dots[i].y-dots[i-1].y, dots[i].x-dots[i-1].x);
					}
				}
				y /= margin;
				fi.yVelocity += g;
				dob.y += fi.yVelocity;
				y -= dob.height * .7;
				if (dob.y >= y) {
					dob.y = y;
					fi.yVelocity *= .4;
					var k:Number = .3;
					dob.rotation += ((ang/margin)*180/Math.PI-dob.rotation)*k;
				}
				//trace( '@', fi.yVelocity, dob.y );
			}
		}
		
		
		public var colors:Array = [  0x009CE5, 0x006699, 0x00131C ];
		
		private function renderWater():void {
			//trace(this.width);
			//this.width = 1107;
			//var waterHeight:Number = 300;
			
			//trace(this.y);
			
			shape.graphics.clear();
            //shape.graphics.beginFill(0x006699);
            
			var type:String = GradientType.LINEAR;
			
			//var colors:Array = [ 0x006699, 0x003652];
			//colors:Array = [  0x009CE5, 0x006699, 0x00131C];
			//var colors:Array = [0x006699, 0x001017];
			
			var alphas:Array = [1,1,1];
			var ratios:Array = [0, 175, 255];
			
			var spreadMethod:String = SpreadMethod.PAD;
			var interp:String = InterpolationMethod.LINEAR_RGB;
			var focalPtRatio:Number = 0;
			var matrix:Matrix = new Matrix();
			
			var boxWidth:Number = waterWidth;
			var boxHeight:Number = 200;
			var boxRotation:Number = Math.PI/2;
			var tx:Number = 0;
			var ty:Number = bounds.height - boxHeight;

			
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty);

            shape.graphics.beginGradientFill(type, colors,alphas, ratios, matrix, spreadMethod, interp, focalPtRatio);
            shape.graphics.lineStyle(0, 0x000000, 0);
			shape.graphics.moveTo(-spacing, 0);
			var t:Number = getTimer();
			for (var i:uint=0;i<dots.length;++i) {
				var dot:Dot = dots[i];
				var next:Dot = (i == dots.length-1 ) ? dot : dots[i+1];
				var ax:Number = dot.x + (next.x - dot.x)/2;
				var ay:Number = dot.y + (next.y - dot.y)/2;
				//shape.graphics.lineTo(dot.x, dot.y);
				shape.graphics.curveTo(dot.x, dot.y, ax, ay);
			}
			shape.graphics.lineTo(dots[dots.length-1].x, bounds.height);
			shape.graphics.lineTo(-spacing, bounds.height);
			
			shape.graphics.endFill();
		}
		
		private function addedToStage(ev:Event):void {
			dots = new Array();
			waves = new Array();
			//floatingItems = new Array();
			//waterWidth = 600;
			waterWidth = 1024;
			//numDots = 60;
			//numDots = 25;
			//spacing = waterWidth/numDots;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			initDots(28);
            shape = new Shape();
            addChild(shape);
			renderWater();
			//gentlyDisturbWater();
			//gentlyDisturbWater();
		}

		private function initDots(nd:Number):void {
			for (var i:int=0;i<nd;++i ){
				var dot:Dot = new Dot();
				dot.x = (i-1)* Math.ceil( waterWidth / (nd-1-2) );
				dot.y = 0;
				addDot(dot);
			}
		}
		
		private function addDot(d:Dot):void {
			getDots().push(d);
		}
		
		private function getDots():Array {
			return dots;
		}

		private function getWaves():Array {
			return waves;
		}
		
		private function getFloatingItems():Array 	{
			return floatingItems;
		}
		
		public function get fill():Number {
			return _fill;
		}
		
		public function set fill( value:Number ):void {
			_fill = NumberUtil.CleanPercentage( value );
		}		

		private function get bounds():Rectangle {
			return _bounds;
		}
		
		private function set bounds( value:Rectangle ):void {
			_bounds = value;
		}
		
		private function set waterWidth(value:Number):void {
			_waterWidth = value;
			var space:Number = spacing;
			
			for (var i:int=0;i<dots.length;++i ){
				var dot:Dot = dots[i];
				dot.x = (i-1)*space;
			}	
		}

		private function get waterWidth():Number {
			return _waterWidth;
		}
		
		private function get spacing():Number {
			return Math.ceil(_waterWidth/( dots.length-1-2 ));
		}

		private function get numDots():Number {
			return dots.length;
		}
		
	}
}