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
package com.renaun.hydrap2p
{
	import org.devboy.hydra.commands.HydraCommand;

	/**
	 * @author Renaun Erickson - renaun.com
	 */
	public class TextCommand extends HydraCommand
	{
		public static const TYPE:String = "com.renaun.hydrap2p.TextCommand.TYPE";
		
		public function TextCommand() 
		{
			super(TextCommand.TYPE);
		}
		
		protected var _info:Object = {score: 0, hotSeat: -1, selection: -1,userTimestamp: -1};
		
		public var userTimestamp:Number = -1;
		public var selection:Number = -1;
		public var hotSeat:Number = -1;
		public var score:int = 0;
		
		override public function get info():Object
		{
			_info.userTimestamp = userTimestamp;
			_info.selection = selection;
			_info.hotSeat = hotSeat;
			_info.score = score;
			return _info;
		}

	}
}
