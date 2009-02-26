﻿package com.electrotank.water {
	import com.electrotank.float.*;
	import com.gskinner.motion.GTween;
	
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
	
	import mx.effects.easing.Quadratic;
	
	public class Water extends Sprite {
		
		private var dots:Array;
		private var waves:Array;
		private var shape:Shape;
		private var floatingItems:Array;
		private var _waterWidth:Number;
		private var _bounds:Rectangle;
		private var _fill:Number;
		
		public function Water( width:Number = 200, height:Number = 100, fill:Number = .5 ) {
			this.bounds = new Rectangle(0, 0, width, height);
			this.fill = fill;
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
			injectWave(3, Math.random()*waterWidth);
		}
		
		/**
		 * Less Gently Disturb: wave ower of 7, random point
		 */
		public function lessGentlyDisturbWater():void {
			injectWave(7, Math.random()*waterWidth);
		}
		
		/**
		 * Violent disturbence: wave power of 15, random point
		 */
		public function violentlyDisturbWater():void {
			injectWave(15, Math.random()*waterWidth);
		}
		
		/**
		 * Inject a wave at a given point
		 * 
		 * @param	wave power
		 * @param	location on x axis
		 */
		public function injectWave(A:Number, x:Number):void {
			addWave(A, x, 1);
			addWave(A, x, -1);
		}
		
		
		/**
		 * Adjust the wave height gradually
		 * 
		 * @param	new height: should be a percentage (0.00 - 1.0)
		 * @param	length of tween
		 */
		public function tweenFill( value:Number, length:Number ):void {
			
			var tweenValue:Number = NumberUtil.CleanPercentage(value);
			var initialFill:Number = this.fill;

			GTween.timingMode = GTween.TIME;
			var myTween:GTween = new GTween(this, length);
			myTween.setProperty("fill", tweenValue);
			myTween.ease = Quadratic.easeOut;
			myTween.play();
			
		}

		public function addFloatingItem(dob:DisplayObject):void {
			var fi:IFloatable = new FloatingItem();
			fi.setDisplayObject(dob);
			fi.setYVelocity(0);
			addIFloatable(fi);
		}
		
		/* ===============================================================
		 * PRIVATE FUNCTIONS: IT DOES STUFF
		 * ===============================================================*/	

		private function enterFrameHandler(ev:Event):void {
			
			if (Math.round(Math.random()*20) == 0) {
				gentlyDisturbWater();
			}

			if (Math.round(Math.random()*40) == 0) {
				lessGentlyDisturbWater();
			}
			
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
			var wave:Wave = new Wave();
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
					waves.splice(j, 1);
				} else if (index != wave.getIndex() || (index == wave.getIndex() && wave.getDir() == 1 && wave.getFirstOne())) {
					var w:Wave;
					if (wave.getFirstOne() && wave.getDir() == 1) {
						w = new Wave();
						w.setA(wave.getA());
						w.setStartTime(t);
						dot = getDots()[wave.getIndex()];
						dot.getWaves().push(w);
					}
					if (wave.getDir() == 1) {
						for (i=wave.getIndex()+1;i<=index;++i) {
							w = new Wave();
							w.setA(wave.getA());
							w.setStartTime(t);
							dot = getDots()[i];
							dot.getWaves().push(w);
						}
					} else {
						for (i=wave.getIndex()-1;i>=index;--i) {
							w = new Wave();
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
						dot.getWaves().splice(j, 1);
					}
				}
				dot.y = y + ( (1-fill) * bounds.height );
			}
		}
		

		private function moveFloatingItems():void {
			var g:Number = .25;
			for (var j:int=0;j<getFloatingItems().length;++j) {
				var fi:FloatingItem = getFloatingItems()[j];
				var dob:DisplayObject = fi.getDisplayObject();
				var d:Number = .9;
				var x:Number = Math.round(dob.x);
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
				y = y/margin;
				fi.setYVelocity(fi.getYVelocity()+g);
				dob.y += fi.getYVelocity();
				if (dob.y >= y) {
					dob.y = y;
					fi.setYVelocity(fi.getYVelocity()*.4);
					var k:Number = .3;
					dob.rotation += ((ang/margin)*180/Math.PI-dob.rotation)*k;
				}
			}
		}
		
		private function renderWater():void {
			//trace(this.width);
			//this.width = 1107;
			//var waterHeight:Number = 300;
			
			//trace(this.y);
			
			shape.graphics.clear();
            //shape.graphics.beginFill(0x006699);
            
			var type:String = GradientType.LINEAR;
			
			//var colors:Array = [ 0x006699, 0x003652];
			var colors:Array = [  0x009CE5, 0x006699, 0x00131C];
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
		
		public function addIFloatable(fi:IFloatable):void {
			getFloatingItems().push(fi);
			addChild(fi.getDisplayObject());
		}
		
		private function addedToStage(ev:Event):void {
			dots = new Array();
			waves = new Array();
			floatingItems = new Array();
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
			gentlyDisturbWater();
			gentlyDisturbWater();
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
			_fill = ( value > 1 ) ? 1 : ( value < 0 ? 0 : value );
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
			return Math.ceil(_waterWidth/(dots.length-1-2));
		}

		private function get numDots():Number {
			return dots.length;
		}
		
	}
}