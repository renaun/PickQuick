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

/**
 * http://renaun.com for more information.
 * Video of this playing at: http://vimeo.com/14998503
 */
package
{
	
import com.kaigames.core.FrameBrain;
import com.kaigames.core.ScreenUtils;
import com.renaun.brains.BoardBrain;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.system.Capabilities;

[SWF(frameRate="30",backgroundColor="0xcccccc")]
public class PickQuick extends Sprite
{
	
	public function PickQuick()
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		if (Capabilities.screenDPI > 96)
			stage.addEventListener(Event.DEACTIVATE, deactivateHandler);
		ScreenUtils.setScaleMatrix(stage);
		frameBrain = new FrameBrain(stage, init);
	}
	
	protected var frameBrain:FrameBrain;
	protected var boardBrain:BoardBrain;
	
	public function init():void
	{
		boardBrain = new BoardBrain()
		boardBrain.createChildren(stage);
		frameBrain.addExecutable(boardBrain);
	}
	
	protected function deactivateHandler(event:Event):void
	{
		boardBrain.destroy();
		NativeApplication.nativeApplication.exit();
	}
}
}