/*
* Copyright 2010 (c) Renaun Erickson renaun.com
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/

package com.renaun.vo
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public final class BoxVO
	{
		
		
		//----------------------------------
		//  label
		//----------------------------------
		
		private var _label:String;
		
		/**
		 *  @private
		 */
		public function get label():String
		{
			return _label;
		}
		
		/**
		 *  @private
		 */
		public function set label(value:String):void  
		{
			if (pointerLabel)
				pointerLabel.text = value;
			_label = value;
		}
		
		//----------------------------------
		//  x
		//----------------------------------
		
		public var oldX:Number = 20000;
		private var _x:Number;
		
		/**
		 *  @private
		 */
		public function get x():Number
		{
			return _x;
		}
		
		/**
		 *  @private
		 */
		public function set x(value:Number):void  
		{
			if (pointerLabel)
			{
				pointerLabel.x = value;
				//pointerLabel.y = value + 22;
			}
			if (pointerBitmap)
			{
				pointerBitmap.x = value;
				//pointerBitmap.y = value;
			}
			oldX = _x;
			_x = value;
		}
		
		
		//----------------------------------
		//  y
		//----------------------------------
		
		public var oldY:Number = 20000;
		private var _y:Number;
		
		/**
		 *  @private
		 */
		public function get y():Number
		{
			return _y;
		}
		
		/**
		 *  @private
		 */
		public function set y(value:Number):void  
		{
			if (pointerLabel)
			{
				//pointerLabel.x = value - 2;
				pointerLabel.y = value + 2;
			}
			if (pointerBitmap)
			{
				//pointerBitmap.x = value;
				pointerBitmap.y = value;
			}
			oldY = _y;
			_y = value;
		}
		
		//----------------------------------
		//  visible
		//----------------------------------
		
		public function get visible():Boolean
		{
			return pointerLabel.visible;
		}
		
		/**
		 *  @private
		 */
		public function set visible(value:Boolean):void  
		{
			if (pointerLabel)
				pointerLabel.visible = value;
			if (pointerBitmap)
				pointerBitmap.visible = value;
		}
		
		//----------------------------------
		//  voted
		//----------------------------------
		
		private var _voted:Boolean = false;
		
		/**
		 *  @private
		 */
		public function get voted():Boolean
		{
			return _voted;
		}
		
		/**
		 *  @private
		 */
		public function set voted(value:Boolean):void  
		{
			_voted = value;
		}
		
		//----------------------------------
		//  selected
		//----------------------------------
		
		private var _selected:Boolean = false;
		
		/**
		 *  @private
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		
		/**
		 *  @private
		 */
		public function set selected(value:Boolean):void  
		{
			if (pointerVoted)
			{
				pointerVoted.x = pointerBitmap.x;
				pointerVoted.y = pointerBitmap.y;
				pointerVoted.visible = value && !hotSeat;
			}
			_selected = value;
		}
		
		
		private var _hotSeat:Boolean = false;
		
		/**
		 *  @private
		 */
		public function get hotSeat():Boolean
		{
			return _hotSeat;
		}
		
		/**
		 *  @private
		 */
		public function set hotSeat(value:Boolean):void  
		{
			if (pointerVoted)
			{
				pointerVoted.visible = false;
			}
			_hotSeat = value;
		}
		
		public var timestamp:Number = 0;
		public var pointerLabel:TextField;
		public var pointerBitmap:Bitmap;
		public var pointerVoted:Bitmap;
		
		public var lastSelection:Boolean = false;
		
		public var scoreSelection:Number = -1;
					
	}
}