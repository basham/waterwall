﻿package io.radical.waterwall.water {
	
	import edu.iu.vis.utils.NumberUtil;
	import edu.iu.vis.utils.TrigUtil;
	
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
	import io.radical.waterwall.float.FloatingSprite;
	import io.radical.waterwall.float.IFloatable;
	
	public class Water extends Sprite {
		
		private const NUM_DOTS:uint = 28;
		
		private var dots:Array = new Array();
		private var waves:Array = new Array();
		private var floatingItems:Array = new Array();
		
		private var shape:Shape;
		private var bounds:Rectangle;
		
		private var _waterWidth:Number;
		private var _fill:Number;
		
		public var maxFill:Number = 1;
		public var minFill:Number = 0;
		
		public var colors:Array = [  0x009CE5, 0x006699, 0x00131C ];
		
		public function Water( width:Number = 200, height:Number = 100, fill:Number = .5 ) {
			this.bounds = new Rectangle( 0, 0, width, height );
			this.fill = fill;
			this.waterWidth = width;
			
            shape = new Shape();
            addChild(shape);
            
            for ( var i:uint = 0; i < NUM_DOTS; ++i ){
				var dot:Dot = new Dot();
				dot.x = ( i - 1 )* Math.ceil( waterWidth / ( NUM_DOTS - 1 - 2 ) );
				dot.y = 0;
				dots.push( dot );
			}
			
			renderWater();
			this.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}


		/* ===============================================================
		 * PUBLIC GETTERS, SETTERS
		 * ===============================================================*/
		
		/**
		 * Set the size of the water object
		 * 
		 * @param	new width
		 * @param	new height
		 * 
		 */
		public function setSize( width:Number, height:Number ):void{
			waterWidth = width;
			bounds.width = width;
			bounds.height = height;
		}
		
		public function get fill():Number {
			return _fill;
		}
		
		public function set fill( value:Number ):void {
			_fill = NumberUtil.CleanPercentage( value );
		}
		
		public function get waterShape():Shape {
			return shape;
		}
		
		
		/* ===============================================================
		 * PUBLIC FUNCTIONS
		 * ===============================================================*/
		 
		/**
		 * Inject a wave at a given point
		 * 
		 * @param	wave power
		 * @param	location on x axis
		 */
		public function injectWave( A:Number, x:Number ):void {
			x = NumberUtil.CleanPercentage( x );
			x *= this.width;
			x = Math.round( x );
			//trace( '#', x, A );
			addWave( A, x, 1 );
			addWave( A, x, -1 );
		}
		
		/**
		 * Pushes a Wave to the Queue
		 * 
		 * @param	Wave "power" or strength
		 * @param	Starting X value
		 * @param	I have no idea.  direction, I guess? either 1 or -1
		 * 
		 */
		private function addWave( A:Number, x:Number, dir:Number ):void {
			//f(x) = A*sin(w*t)
			var wave:Wave = Wave.GetInstance();
			wave.index = Math.floor( x / spacing );
			wave.A = A;
			wave.dir = dir;
			wave.firstOne = true;
			wave.startX = x;
			wave.startTime = getTimer();
			waves.push( wave );
			//propogateWaves();
		}

		public function addFloatingItem( dob:DisplayObject ):void {
			var fi:FloatingItem = new FloatingItem( dob );
			addIFloatable( fi );
		}
		
		public function addIFloatable( fi:IFloatable ):void {
			floatingItems.push( fi );
			addChild( fi.displayObject );
		}
		

		/* ===============================================================
		 * PRIVATE GETTERS, SETTERS
		 * ===============================================================*/	
		
		private function get waterWidth():Number {
			return _waterWidth;
		}
		
		private function set waterWidth(value:Number):void {
			_waterWidth = value;
			var space:Number = spacing;
			
			for ( var i:uint = 0; i < dots.length; ++i ){
				var dot:Dot = dots[i];
				dot.x = ( i - 1 ) * space;
			}	
		}
		
		private function get spacing():Number {
			return Math.ceil( waterWidth / ( dots.length-1-2 ) );
		}
		
		
		/* ===============================================================
		 * FRAME INTERVALS
		 * ===============================================================*/	
		 
		private function onEnterFrame( event:Event ):void {
			try {
				propogateWaves();
				moveFloatingItems();
				renderWater();
			} catch( e:Error ) { }
		}

		private function propogateWaves():void {
			
			var t:Number = getTimer();
			var speed:Number = waterWidth/2000;
			var wave:Wave;
			var d:Number;
			var dot:Dot;
			
			var j:int, i:int;
			
			for ( j = waves.length - 1; j >= 0; --j ) {
				
				d = .0001;
				wave = waves[j];
				wave.A /= Math.pow( Math.E, d * ( t - wave.startTime ) );
				var index:Number = Math.floor( ( wave.startX + wave.dir * ( t - wave.startTime ) * speed ) / spacing );
				
				if ( index < 0 || index > dots.length - 1 ) {
					
					var a:Wave = waves.splice(j, 1)[0] as Wave;
					if ( a != null )
						a.remove();
						
				} else if ( index != wave.index || ( index == wave.index && wave.dir == 1 && wave.firstOne ) ) {
					
					if (wave.firstOne && wave.dir == 1)
						setWave( wave.A, t, wave.index );
						
					if (wave.dir == 1)
						for ( i = wave.index + 1; i <= index; ++i )
							setWave( wave.A, t, i );
					else
						for ( i = wave.index - 1; i >= index; --i )
							setWave( wave.A, t, i );
					
					wave.index = index;
					wave.firstOne = false;
				}
			}
			
			var f:Number = 1 - ( fill * ( maxFill - minFill ) + minFill );
			
			for ( i = 0; i < dots.length; ++i ) {
				
				dot = dots[i];
				var y:Number = 0;
				
				for ( j = dot.waves.length - 1; j >= 0; --j ) {
					wave = dot.waves[j];
					var freq:Number = .005;
					d = .99;
					wave.A *= d;
					y += wave.A * Math.sin( freq * ( t - wave.startTime ) );
					if ( wave.A < .5 ) {
						var b:Wave = dot.waves.splice(j, 1)[0] as Wave;
						if ( b != null )
							b.remove();
					}
				}
				
				dot.y = y + ( f * bounds.height );
			}
		}
		
		private function setWave( A:Number, startTime:Number, index:uint ):void {
			var wave:Wave = Wave.GetInstance();
			wave.A = A;
			wave.startTime = startTime;
			var dot:Dot = dots[ index ];
			dot.waves.push( wave );
		}
		
		private function moveFloatingItems():void {
			
			var gravity:Number = .25;
			var friction:Number = .85
			var k:Number = .3;
			var margin:Number = 4; // # of dots to average
			var x:Number = Math.round(this.width / 2);
			var index:Number = Math.floor(x/spacing) - margin/2;
			
			var y:Number = 0;
			var ang:Number = 0;
			
			for ( var i:uint = index; i < index + margin; ++i ) {
				y += dots[i].y;
				if ( i != index )
					ang += Math.atan2(dots[i].y-dots[i-1].y, dots[i].x-dots[i-1].x);
			}
			
			y /= margin; // Average y water-level coordinate
			ang /= margin;
			ang = TrigUtil.Degrees( ang );
			
			for ( var j:uint = 0; j < floatingItems.length; ++j ) {
				
				var fi:IFloatable = floatingItems[j] as IFloatable;
				var dob:DisplayObject = fi.displayObject;
				
				if ( dob.y >= y - dob.height * fi.buoyancy ) {
					fi.yVelocity -= gravity;
					if ( fi.yVelocity > 0 )
						fi.yVelocity *= friction;
				}
				else {
					fi.yVelocity += gravity;
					if ( fi.yVelocity < 0 )
						fi.yVelocity *= friction;
					ang = 0;
				}
				
				fi.yVelocity = Math.abs( fi.yVelocity ) < .2 ? 0 : fi.yVelocity;
				dob.y += fi.yVelocity;
				dob.rotation += ( ang - dob.rotation ) * k;
			}
		}
		
		private function renderWater():void {
			
			var boxWidth:Number = waterWidth;
			var boxHeight:Number = 200;
			var boxRotation:Number = Math.PI / 2;
			var tx:Number = 0;
			var ty:Number = bounds.height - boxHeight;
				
			var type:String = GradientType.LINEAR;
			var alphas:Array = [ 1, 1, 1 ];
			var ratios:Array = [ 0, 175, 255 ];
			
			var spreadMethod:String = SpreadMethod.PAD;
			var interp:String = InterpolationMethod.LINEAR_RGB;
			var focalPtRatio:Number = 0;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( boxWidth, boxHeight, boxRotation, tx, ty );

			var t:Number = getTimer();

			shape.graphics.clear();
            shape.graphics.beginGradientFill( type, colors, alphas, ratios, matrix, spreadMethod, interp, focalPtRatio );
            shape.graphics.lineStyle( 0, 0x000000, 0 );
			shape.graphics.moveTo( -spacing, 0 );

			for ( var i:uint = 0; i < dots.length; ++i ) {
				var dot:Dot = dots[i];
				var next:Dot = ( i == dots.length - 1 ) ? dot : dots[ i + 1 ];
				var ax:Number = dot.x + ( next.x - dot.x ) / 2;
				var ay:Number = dot.y + ( next.y - dot.y ) / 2;
				//shape.graphics.lineTo(dot.x, dot.y);
				shape.graphics.curveTo( dot.x, dot.y, ax, ay );
			}
			
			shape.graphics.lineTo( dots[ dots.length - 1 ].x, bounds.height );
			shape.graphics.lineTo( -spacing, bounds.height );
			shape.graphics.endFill();
		}
		
	}
}