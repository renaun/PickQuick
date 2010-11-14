/*
 * Copyright 2010 (c) Renaun Erickson - renaun.com
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
	import org.devboy.hydra.commands.IHydraCommand;
	import org.devboy.hydra.commands.IHydraCommandCreator;

	/**
	 * @author Renaun Erickson - renaun.com
	 */
	public class TextCommandCreator implements IHydraCommandCreator
	{
		public function createCommand(type:String, timestamp:uint, userId:String, 
									  senderPeerId:String, info:Object):IHydraCommand
		{
			if (type != commandType)
				throw new Error("CommandTypes do not match!");
			
			var command : TextCommand = new TextCommand();
			command.userTimestamp = info.userTimestamp;
			command.selection = info.selection;
			command.hotSeat = info.hotSeat;
			command.score = info.score;
			command.userId = userId;
			command.senderPeerId = senderPeerId;
			return command;
		}

		public function get commandType():String
		{
			return TextCommand.TYPE;
		}
	}
}
