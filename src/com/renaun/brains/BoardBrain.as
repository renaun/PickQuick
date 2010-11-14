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

package com.renaun.brains
{
	import com.kaigames.core.ITimedExecute;
	import com.kaigames.core.ScreenUtils;
	import com.kaigames.hydrap2p.MulticastConnection;
	import com.renaun.embeds.EmbedBackgroundSliceBottom;
	import com.renaun.embeds.EmbedBackgroundSliceBottomRed;
	import com.renaun.embeds.EmbedBackgroundSliceTop;
	import com.renaun.embeds.EmbedBoxBlue1;
	import com.renaun.embeds.EmbedBoxBlue2;
	import com.renaun.embeds.EmbedBoxBlue3;
	import com.renaun.embeds.EmbedBoxGreen1;
	import com.renaun.embeds.EmbedBoxGreen10;
	import com.renaun.embeds.EmbedBoxGreen2;
	import com.renaun.embeds.EmbedBoxGreen3;
	import com.renaun.embeds.EmbedBoxGreen4;
	import com.renaun.embeds.EmbedBoxGreen5;
	import com.renaun.embeds.EmbedBoxGreen6;
	import com.renaun.embeds.EmbedBoxGreen7;
	import com.renaun.embeds.EmbedBoxGreen8;
	import com.renaun.embeds.EmbedBoxGreen9;
	import com.renaun.embeds.EmbedBoxNormal;
	import com.renaun.embeds.EmbedBoxRed1;
	import com.renaun.embeds.EmbedBoxRed10;
	import com.renaun.embeds.EmbedBoxRed2;
	import com.renaun.embeds.EmbedBoxRed3;
	import com.renaun.embeds.EmbedBoxRed4;
	import com.renaun.embeds.EmbedBoxRed5;
	import com.renaun.embeds.EmbedBoxRed6;
	import com.renaun.embeds.EmbedBoxRed7;
	import com.renaun.embeds.EmbedBoxRed8;
	import com.renaun.embeds.EmbedBoxRed9;
	import com.renaun.embeds.EmbedBoxVoted;
	import com.renaun.embeds.FontAmericanTypeWriterBold;
	import com.renaun.hydrap2p.TextCommand;
	import com.renaun.hydrap2p.TextCommandCreator;
	import com.renaun.vo.BoxVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mx.core.BitmapAsset;
	
	import org.devboy.hydra.users.HydraUserEvent;
	
	public class BoardBrain implements ITimedExecute
	{
		public static const STATE_DEFAULT:String = "default";
		public static const STATE_JOINING:String = "joining";
		public static const STATE_SELECT:String = "select";
		public static const STATE_SCORING:String = "results";
		public static const STATE_WAITING_FOR_USERS:String = "waitingForUsers";
		
		public function BoardBrain()
		{
		}
		
		public var canvas:BitmapData;
		public var canvasRed:BitmapData;
		public var bitmapRed:Bitmap;
		public var textMessage:TextField;
		public var textJoin:TextField;
		public var textScore:TextField;
		public var textLastScore:TextField;
		
		public var currentState:String = "";
		public var multicastConn:MulticastConnection = new MulticastConnection();
		
		protected var container:Stage;
		protected var boxTextFormat:TextFormat;
		
		protected var boxStartIndex:int = 0;
		protected var playerBox:BoxVO;
		protected var currentSelection:BoxVO;
		protected var previousSelection:BoxVO;
		protected var scoreTimer:Timer;
		protected var playerScoreSelectionTime:Number;
		protected var SCORING_TIMEOUT:int = 12000;
		protected var currentScore:int = 0;
		
		protected var redGlows:Vector.<Bitmap> = new Vector.<Bitmap>();
		protected var blueGlows:Vector.<Bitmap> = new Vector.<Bitmap>();
		protected var greenGlows:Vector.<Bitmap> = new Vector.<Bitmap>();
		protected var userBoxes:Vector.<BoxVO> = new Vector.<BoxVO>();
		protected var availableUserBoxes:Vector.<BoxVO> = new Vector.<BoxVO>();
		
		protected var boxNormalData:BitmapData = new EmbedBoxNormal(126, 106);
		
		protected var hasSelection:Boolean = false;
		protected var hasPreviousSelection:Boolean = false;
		protected var hasHotSeat:Boolean = false;
		
		protected var boxWidth:int = 140;// 126 + 14
		protected var boxHeight:int = 120;// 106 + 14
		protected var maxRowCount:int = 1;
		protected var maxColumnCount:int = 1;
		
		protected var topHeight:Number;
		
		public function createChildren(container:Stage):void
		{
			this.container = container;
			// Setup Mouse Clicks
			this.container.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			scoreTimer = new Timer(8000, 1);
			scoreTimer.addEventListener(TimerEvent.TIMER_COMPLETE, calculateScore);
			
			var font1:FontAmericanTypeWriterBold;
			var bottomHeight:int = 649;
			var bottomWidth:int = 96;
			topHeight = 120;
			var topWidth:int = 20;
			// SCALECHECK
			var scale:Number = ScreenUtils.scale;
			var b:BitmapData = new EmbedBackgroundSliceBottom(bottomWidth, bottomHeight);
			var bRed:BitmapData = new EmbedBackgroundSliceBottomRed(bottomWidth, bottomHeight);
			var bTop:BitmapData = new EmbedBackgroundSliceTop(topWidth, topHeight);
			if (ScreenUtils.needsScaling)
			{
				var b2:BitmapData = new EmbedBackgroundSliceBottom(b.width * scale, b.height * scale);
				var bRed2:BitmapData = new EmbedBackgroundSliceBottomRed(bRed.width * scale, bRed.height * scale);
				var bTop2:BitmapData = new EmbedBackgroundSliceTop(bTop.width * scale, bTop.height * scale);
				
				b2.draw(b, ScreenUtils.matrix, null, null, null, true);
				bRed2.draw(bRed, ScreenUtils.matrix, null, null, null, true);
				bTop2.draw(bTop, ScreenUtils.matrix, null, null, null, true);
				b = b2;
				bTop = bTop2;
				bottomHeight *= scale;
				bottomWidth *= scale;
				topHeight *= scale;
				topWidth *= scale;
				
				boxWidth *= scale;
				boxHeight *= scale;
			}
			
			maxRowCount = Math.floor(ScreenUtils.applicationWidth / boxWidth);
			maxColumnCount = Math.floor(ScreenUtils.applicationHeight / boxHeight);
			
			//trace("w/h: " + container.stageWidth + "/" + container.stageHeight);
			canvas = new BitmapData(ScreenUtils.applicationWidth, ScreenUtils.applicationHeight, true, 0xFFFFFF);
			canvasRed = new BitmapData(ScreenUtils.applicationWidth, ScreenUtils.applicationHeight, true, 0xFFFFFF);
			var rect:Rectangle = new Rectangle(0, 0, bottomWidth, bottomHeight);
			var cx:int = 0;
			var p:Point = new Point(cx, topHeight-1);
			canvas.lock();
			canvasRed.lock();
			while (cx < canvas.width)
			{
				p.x = cx;
				canvas.copyPixels(b, rect, p);
				canvasRed.copyPixels(bRed, rect, p);
				cx += bottomWidth;
			}
			canvasRed.unlock();
			rect.width = topWidth;
			rect.height = topHeight;
			cx = 0;
			p.x = 0;
			p.y = 0;
			while (cx < canvas.width)
			{
				p.x = cx;
				canvas.copyPixels(bTop, rect, p);
				cx += topWidth;
			}
			canvas.unlock();
			bitmapRed = new Bitmap(canvasRed);
			bitmapRed.visible = false;
			container.addChild(new Bitmap(canvas));
			container.addChild(bitmapRed);
			
			var format:TextFormat = new TextFormat();
			format.size = (93*scale);
			format.font = "FontAmericanTypeWriterBold";
			format.color = 0xFFFFFF;
			format.bold = true;
			format.align = TextFormatAlign.CENTER;
			
			var scoreTextFormat:TextFormat = new TextFormat();
			scoreTextFormat.size = (80*scale);
			scoreTextFormat.font = "FontAmericanTypeWriterBold";
			scoreTextFormat.color = 0xFFFFFF;
			scoreTextFormat.bold = true;
			scoreTextFormat.align = TextFormatAlign.RIGHT;
			
			boxTextFormat = new TextFormat();
			boxTextFormat.size = (80*scale);
			boxTextFormat.font = "FontAmericanTypeWriterBold";
			boxTextFormat.color = 0xFFFFFF;
			boxTextFormat.bold = true;
			boxTextFormat.align = TextFormatAlign.CENTER;
			
			textMessage = new TextField();
			textMessage.defaultTextFormat = format;
			textMessage.embedFonts = true;
			textMessage.width = int(600*scale);
			textMessage.height = int(120*scale);
			textMessage.selectable = false;
			textMessage.text = "Welcome";
			textMessage.antiAliasType = AntiAliasType.ADVANCED;
			container.addChild(textMessage);
			textMessage.x = canvas.width/2 - textMessage.width/2;


			textJoin = new TextField();
			format.size = int(48*scale);
			textJoin.defaultTextFormat = format;
			textJoin.embedFonts = true;
			textJoin.width = int(600*scale);
			textJoin.height = int(92*scale);
			textJoin.selectable = false;
			textJoin.text = "";
			textJoin.antiAliasType = AntiAliasType.ADVANCED;
			container.addChild(textJoin);
			textJoin.y = (canvas.height-topHeight)/2 - textJoin.height + topHeight;
			textJoin.x = canvas.width/2 - textJoin.width/2;

			
			var textPickQuick:TextField = new TextField();
			format.size = int(20*scale);
			format.align = TextFormatAlign.LEFT;
			format.color = 0xcccccc;
			textPickQuick.defaultTextFormat = format;
			textPickQuick.embedFonts = true;
			textPickQuick.width = int(120*scale);
			textPickQuick.height = int(30*scale);
			textPickQuick.selectable = false;
			textPickQuick.text = "PickQuick";
			textPickQuick.antiAliasType = AntiAliasType.ADVANCED;
			container.addChild(textPickQuick);
			textPickQuick.y = canvas.height - textPickQuick.height;
			textPickQuick.x = int(8*scale);
			
			textScore = new TextField();
			textScore.defaultTextFormat = scoreTextFormat;
			textScore.embedFonts = true;
			textScore.width = int(200*scale);
			textScore.height = int(92*scale);
			textScore.selectable = false;
			textScore.text = "0";
			textScore.antiAliasType = AntiAliasType.ADVANCED;
			container.addChild(textScore);
			textScore.y = topHeight/2 - textJoin.height/2 - int(7*scale);
			textScore.x = canvas.width - textScore.width - int(20*scale);
			textScore.visible = false;
			
			textLastScore = new TextField();
			textLastScore.defaultTextFormat = scoreTextFormat;
			textLastScore.embedFonts = true;
			textLastScore.width = int(200*scale);
			textLastScore.height = int(92*scale);
			textLastScore.selectable = false;
			textLastScore.text = "0";
			textLastScore.antiAliasType = AntiAliasType.ADVANCED;
			container.addChild(textLastScore);
			textLastScore.y = topHeight;
			textLastScore.x = textScore.x;
			textLastScore.visible = false;

			multicastConn.callback = multicastConnectionHandler;
			boxStartIndex = container.numChildren;
			
			// Create Boxes
			// Display Order Matters (Normals go in at index
			
			var boxVO:BoxVO = new BoxVO();
			var data:BitmapData;// = new EmbedBoxNormal(126, 106);
			var box:Bitmap = boxFactory(boxNormalData, scale, true);
			boxVO.pointerBitmap = box;
			container.addChild(box);
			
			data = new EmbedBoxRed1(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed2(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed3(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed4(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed5(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed6(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed7(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed8(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed9(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxRed10(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			redGlows.push(box);
			
			data = new EmbedBoxBlue1(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			blueGlows.push(box);
			
			data = new EmbedBoxBlue2(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			blueGlows.push(box);
			
			data = new EmbedBoxBlue3(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			blueGlows.push(box);
			
			data = new EmbedBoxGreen1(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen2(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen3(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen4(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen5(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen6(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen7(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen8(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen9(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			data = new EmbedBoxGreen10(126, 106);
			box = boxFactory(data, scale, false);
			box.visible = false;
			container.addChild(box);
			greenGlows.push(box);
			
			var userLabel:TextField = new TextField();
			userLabel.defaultTextFormat = boxTextFormat;
			userLabel.embedFonts = true;
			userLabel.width = int(126 * scale);
			userLabel.height = int(89 * scale);
			userLabel.selectable = false;
			userLabel.text = "Join";
			userLabel.antiAliasType = AntiAliasType.ADVANCED;
			container.addChild(userLabel);
		
			boxVO.pointerLabel = userLabel;
			boxVO.x = int(7 * scale);
			boxVO.y = int(5 * scale);
			boxVO.label = "1";
			boxVO.visible = false;
			playerBox = boxVO;
			userBoxes.push(playerBox);
			
			setState(BoardBrain.STATE_DEFAULT);
		}
		
		//----------------------------------
		//  Box Factory / Creation
		//----------------------------------
		
		protected function boxFactory(data:BitmapData, scale:Number = 1, visible:Boolean = false):Bitmap
		{
			var box:Bitmap = new Bitmap(data);
			box.smoothing = true;
			box.visible = visible;
			if (scale < 1)
			{
				box.scaleX = scale;
				box.scaleY = scale;
			}
			return box;
		}
		
		protected function getBoxVO():BoxVO
		{
			if (availableUserBoxes.length <= 0)
			{
				var scale:Number = ScreenUtils.scale;
				var data:BitmapData;
				var boxVO:BoxVO = new BoxVO();
				var box:Bitmap = boxFactory(boxNormalData, scale, true);
				boxVO.pointerBitmap = box;
				container.addChildAt(box, boxStartIndex);
				
				var userLabel:TextField = new TextField();
				userLabel.defaultTextFormat = boxTextFormat;
				userLabel.embedFonts = true;
				userLabel.width = int(126 * scale);
				userLabel.height = int(89 * scale);
				userLabel.selectable = false;
				userLabel.antiAliasType = AntiAliasType.ADVANCED;
				container.addChild(userLabel);
				
				data = new EmbedBoxVoted(126, 106);
				box = boxFactory(data, scale, false);
				boxVO.pointerVoted = box;
				container.addChild(box);
				
				boxVO.pointerLabel = userLabel;
				boxVO.x = 0;
				boxVO.y = 0;
				boxVO.label = "_";
				availableUserBoxes.push(boxVO);
			}
			return availableUserBoxes.pop();
		}
		
		//----------------------------------
		//  User Logic
		//----------------------------------
		
		protected function addUser(timestamp:Number):void
		{
			if (timestamp == playerBox.timestamp)
				return;
			var boxVO:BoxVO = getBoxVO();
			boxVO.timestamp = timestamp;
			userBoxes.push(boxVO);
			
			sortAndLayout();
			
			if (userBoxes.length > 3)
			{
				if (!hasHotSeat)
				{
					playerBox.hotSeat = false;
					if (playerBox.label == "1")
					{
						playerBox.hotSeat = true;
						hasHotSeat = true;
						setGlows(redGlows, playerBox);
					}
				}
				if (playerBox.hotSeat)
					sendMessage(-1, playerBox.timestamp, 0);

				setState(BoardBrain.STATE_SELECT);
			}
			else
			{
				textJoin.text = "Need " + (4 - userBoxes.length) + " more!";
			}
		}
		
		protected function removeUser(timestamp:Number):void
		{
			var needHotSeatReset:Boolean = false;
			var len:int = userBoxes.length;
			quickSortOn(userBoxes, 0, len-1);
			for (var i:int= 0; i < len; i++)
			{
				if (userBoxes[i].timestamp == timestamp)
				{
					var v:Vector.<BoxVO> = userBoxes.splice(i,1);
					v[0].visible = false;
					v[0].oldX = 20000;
					v[0].oldY = 20000;
					if (v[0].hotSeat)
					{
						needHotSeatReset = true;
					}
					availableUserBoxes.push(v.shift());
					v = null;
					break;
				}
			}
			sortAndLayout();
			if (needHotSeatReset)
			{
				if (playerBox.label == "1")
				{
					playerBox.hotSeat = true;
					hasHotSeat = true;
					setGlows(redGlows, playerBox);
				}
				if (playerBox.hotSeat)
					sendMessage(-1, playerBox.timestamp, 0);
			}
			if (userBoxes.length < 4)
			{
				textJoin.text = "Need " + (4 - userBoxes.length) + " more!";
				setState(BoardBrain.STATE_WAITING_FOR_USERS);
			}
		}
		
		protected function sortAndLayout():void
		{
			
			// Sort
			var len:int = userBoxes.length;
			quickSortOn(userBoxes, 0, len-1);
			for (var i:int= 1; i <= len; i++)
			{
				userBoxes[i-1].label = i+"";
				userBoxes[i-1].visible = (currentState == BoardBrain.STATE_SELECT);
			}
			
			// Re-Layout
			len -= 1; 
			var rows:int = 1;
			if (len > maxRowCount)
				rows = Math.ceil(len/maxRowCount);
			var columns:int = Math.floor(len / rows);
			var columnsMod:int = (len % rows);
			var c:int = columns;
			var index:int = 0;
			var startY:Number = ((ScreenUtils.applicationHeight-topHeight)/2) - (rows*boxHeight)/2 + topHeight;
			var startX:Number = 0;
			for (var j:int = 0; j < rows; j++)
			{
				c = (j < columnsMod) ? columns+1:columns;
				startX = (ScreenUtils.applicationWidth/2) - (c * boxWidth)/2;
				var d:int = 0
				while (d < c)
				{
					if (userBoxes[index].timestamp == playerBox.timestamp)
					{
						index++;
						continue;
					}
					userBoxes[index].y = startY + (boxHeight*j);
					userBoxes[index].x = startX + (d * boxWidth);
					if (userBoxes[index].hotSeat)
						setGlows(redGlows, userBoxes[index]);

					index++;
					d++
				}
			}
		}
		
		/**
		 * 	Quick Sort Function
		 */
		protected function quickSortOn(a:Vector.<BoxVO>, left:int, right:int):void 
		{
			var i:int = 0, j:int = 0, pivot:BoxVO, tmp:BoxVO;
			i=left;
			j=right;
			pivot = a[Math.round((left+right)*.5)];
			while (i<=j) {
				while (a[i].timestamp < pivot.timestamp) i++;
				while (a[j].timestamp > pivot.timestamp) j--;
				if (i<=j) 
				{
					tmp=a[i];
					a[i]=a[j];
					i++;
					a[j]=tmp;
					j--;
				}
			}
			if (left<j)  quickSortOn(a, left, j);
			if (i<right) quickSortOn(a, i, right);
		}
		
		
		//----------------------------------
		//  Scoring Methods
		//----------------------------------
		
		/**
		 * 	Records all the incoming selections and send out scores
		 *  once all are in. Goes ahead and checks if timer goes off also.
		 */
		protected function recordScores(sender:Number, selection:Number):void
		{
			//trace("recordScores: " + sender + " - " + selection);
			var allScoresPresent:Boolean = true;
			var len:int = userBoxes.length;
			for (var i:int = 0; i < len; i++)
			{
				if (userBoxes[i].timestamp == sender)
				{
					userBoxes[i].scoreSelection = selection;
				}
				allScoresPresent = allScoresPresent && userBoxes[i].scoreSelection > 0;
			}
			if (allScoresPresent)
				calculateScore();
		}
		
		protected function calculateScore(event:Event = null):void
		{
			playerScoreSelectionTime = -1;
			//trace("calcScore: ");
			var hotSeat:Number = playerBox.timestamp;
			var score:int = 0;
			var len:int = userBoxes.length;
			var i:int = 0;
			var scores:Dictionary = new Dictionary();
			var count:int = 0;
			// Score Logic
			for (i = 0; i < len; i++)
			{
				if (playerBox.timestamp == userBoxes[i].timestamp)
					continue;
				if (userBoxes[i].scoreSelection > 0)
				{
					if (!scores[userBoxes[i].scoreSelection+""])
					{
						count++;
						scores[userBoxes[i].scoreSelection+""] = 0;
					}
					scores[userBoxes[i].scoreSelection+""]++;
				}
			}
			var scoreToBeat:int = scores[playerBox.scoreSelection+""];
			var variance:int = int(count * 0.3);
			var k:int = 0;
			//trace("calcScore:variance1: " + variance + " scoreToBeat: " + scoreToBeat + " - " + playerBox.scoreSelection);
			for (var key:String in scores)
			{	
				//trace("calcScore>>>key: " + key + " scores[key]: " + scores[key]);
				if (scores[key] <= scoreToBeat)
					k++;
			}
			//trace("calcScore:variance2: " + variance + " k: " + k + " count: " + count);
			if (scoreToBeat > 0 && k >= count-variance)
			{
				hotSeat = playerBox.scoreSelection;
				score = scoreToBeat;
			}
			
			// Clean up Scores
			for (i = 0; i < len; i++)
			{
				userBoxes[i].scoreSelection = -1;
				userBoxes[i].voted = false;
			}
			//trace("calcScore:sendMessage: " + hotSeat + " - " + score);
			sendMessage(-1, hotSeat, score);
		}
		
		protected function addScore(score:int):void
		{
			currentScore += score;
			textScore.text = currentScore+"";
			textLastScore.text = score+"";
			textLastScore.visible = true;
			textLastScore.alpha = 1;
			textLastScore.y = topHeight;
		}
		
		//----------------------------------
		//  Board States
		//----------------------------------
		
		protected function setState(state:String):void
		{
			if (currentState == state)
				return;
			playerScoreSelectionTime = -1;
			if (state == BoardBrain.STATE_DEFAULT)
			{
				currentScore = 0;
				textScore.visible = false;
				multicastConn.destroy();
				textMessage.text = "Enter Game";
				textJoin.text = "";
				textMessage.addEventListener(MouseEvent.MOUSE_DOWN, joinHandler);
			}
			else if (state == BoardBrain.STATE_JOINING)
			{
				//textMessage.addEventListener(MouseEvent.MOUSE_DOWN, joinHandler);
			}
			else if (state == BoardBrain.STATE_WAITING_FOR_USERS)
			{
				currentScore = 0;
				textScore.text = "0";
				textScore.visible = false;
				var t:int = 0;
				while (t < 10)
				{
					greenGlows[t].visible = false; 
					redGlows[t++].visible = false;
				}
				var len:int = userBoxes.length;
				for (var i:int= 1; i <= len; i++)
				{
					userBoxes[i-1].visible = false;
					userBoxes[i-1].voted = false;
					userBoxes[i-1].selected = false;
				}
				hasSelection = false;
				hasPreviousSelection = false;
				hasHotSeat = false;
				textMessage.text = "Joining";
				textJoin.text = "Need " + (4 - userBoxes.length) + " more!";
				textJoin.visible = true;
				//textMessage.addEventListener(MouseEvent.MOUSE_DOWN, joinHandler);
			}
			else if (state == BoardBrain.STATE_SELECT)
			{
				textScore.visible = true;
				textJoin.text = "";
				textJoin.visible = false;
				textMessage.text = "Select";
				
				var len2:int = userBoxes.length;
				for (var i2:int= 0; i2 < len2; i2++)
				{
					userBoxes[i2].visible = true;
					userBoxes[i2].voted = false;
				}
				//textMessage.addEventListener(MouseEvent.MOUSE_DOWN, joinHandler);
			}
			else if (state == BoardBrain.STATE_SCORING)
			{
				textMessage.text = "Scoring";
			}
			currentState = state;
		}
		
		public function joinHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			setState(BoardBrain.STATE_JOINING);
			textMessage.removeEventListener(MouseEvent.MOUSE_DOWN, joinHandler);
			
			multicastConn.connect("PickQuick", "game");
			multicastConn.addCommandFactory(new TextCommandCreator());
		}
		public function multicastConnectionHandler(type:String, data:Object):void
		{
			
			//trace("type: " + type);
			if (type == MulticastConnection.TYPE_CONNECT)
			{
				playerBox.timestamp = Number(multicastConn.userName);
				setState(BoardBrain.STATE_WAITING_FOR_USERS);
			}
			else if (type == MulticastConnection.TYPE_MESSAGE)
			{
				data = data.info; 
				var len:int = userBoxes.length;
				var i:int= 0;
				// Ignore your own selection message
				if (data.userTimestamp == playerBox.timestamp
					&& playerBox.hotSeat <= 0)
				{
					return;
				}
				// Hot Seat Player Receiving Selection Msg
				if (data.hotSeat <= 0)
				{
					for (i = 0; i < len; i++)
					{				
						if (userBoxes[i].timestamp == data.userTimestamp)
							userBoxes[i].voted = true;
					}
					if (playerBox.hotSeat)
						recordScores(data.userTimestamp, data.selection);
				}
				// Receiving Scoring Msg from Hot Seat Player
				else if (data.hotSeat > -1)
				{
					// Setting hotSeat
					hasHotSeat = false;
					for (i = 0; i < len; i++)
					{				
						userBoxes[i].hotSeat = false;
						if (userBoxes[i].timestamp == data.hotSeat)
						{
							userBoxes[i].hotSeat = true;
							hasHotSeat = true;
							setGlows(redGlows, userBoxes[i]);
						}
					}
					
					if (currentSelection)
					{
						if (currentSelection.timestamp == data.hotSeat)
							addScore(data.score);
						if (previousSelection)
							previousSelection.lastSelection = false;
						previousSelection = currentSelection;
						previousSelection.selected = false;
						previousSelection.lastSelection = true;
						
						hasPreviousSelection = true;
					}
					hasSelection = false;
					setState(BoardBrain.STATE_SELECT);
				}
			}
			else if (type == MulticastConnection.TYPE_USER)
			{
				//trace("m: " + data.userTimestamp + " - " + data.type);
				if (data.userTimestamp != playerBox.timestamp)
				{
					if (data.type == HydraUserEvent.USER_CONNECT)
						addUser(data.userTimestamp);
					else if (data.type == HydraUserEvent.USER_DISCONNECT)
						removeUser(data.userTimestamp);
				}
			}
		}
		
		//----------------------------------
		//  ITimedExecute Methods
		//----------------------------------
		
		
		public function execute(frameSequence:int):void
		{
			
			if (currentState == BoardBrain.STATE_JOINING)
			{
				var msg:String = "";
				var i:int = Math.floor((frameSequence % 9)/3);
				while (i-- >= 0)
					msg += ".";
				textMessage.text = msg;
			}
			
			if ((currentState == BoardBrain.STATE_SELECT
				|| currentState == BoardBrain.STATE_SCORING))
			{
				var f:int = Math.floor((frameSequence % 30)/3);
				var g:int = Math.floor((frameSequence % 50)/5);
				
				redGlows[0].visible = (hasHotSeat && f == 0); 
				redGlows[1].visible = (hasHotSeat && f == 1); 
				redGlows[2].visible = (hasHotSeat && f == 2); 
				redGlows[3].visible = (hasHotSeat && f == 3); 
				redGlows[4].visible = (hasHotSeat && f == 4); 
				redGlows[5].visible = (hasHotSeat && f == 5); 
				redGlows[6].visible = (hasHotSeat && f == 6); 
				redGlows[7].visible = (hasHotSeat && f == 7); 
				redGlows[8].visible = (hasHotSeat && f == 8); 
				redGlows[9].visible = (hasHotSeat && f == 9);
				
				bitmapRed.visible = playerBox.hotSeat;
				
				if (playerScoreSelectionTime > 1000
					&& getTimer() - playerScoreSelectionTime > SCORING_TIMEOUT)
				{
					playerScoreSelectionTime = -1;
					calculateScore();
				}
				
				if (textLastScore.visible)
				{
					textLastScore.alpha -= 0.02;
					textLastScore.y -= 2;
					if (textLastScore.alpha == 0)
					{
						textLastScore.alpha = 1;
						textLastScore.visible = false;
					}
				}
			}
		}
		
		//----------------------------------
		//  Interactive Methods
		//----------------------------------
		
		public function mouseHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			if (currentState == BoardBrain.STATE_SELECT)
			{				
				var len:int = userBoxes.length;
				var xChange:Number = 0;
				var yChange:Number = 0;
				for (var i:int= 0; i < len; i++)
				{					
					xChange = event.stageX - userBoxes[i].x;
					yChange = event.stageY - userBoxes[i].y;
				
					if (!userBoxes[i].hotSeat
						&& xChange > 0 && yChange > 0
						&& xChange < boxWidth
						&& yChange < boxHeight)
					{
						currentSelection = userBoxes[i];
						currentSelection.selected = true;
						
						if (currentSelection == previousSelection)
							hasPreviousSelection = false;
						
						hasSelection = true; // Gets Cleared with state changes to Select again
						
						//setGlows(greenGlows, userBoxes[i]); TODO GREEN CHANGE
						setState(BoardBrain.STATE_SCORING);
						if (playerBox.hotSeat)
						{
							playerScoreSelectionTime = getTimer();
							playerBox.scoreSelection = currentSelection.timestamp;
							recordScores(playerBox.timestamp, playerBox.scoreSelection);
						}
						else
						{
							
							sendMessage(currentSelection.timestamp, -1, 0);
						}
						break;
					}
				}
			}
		}
		
		public function sendMessage(selection:Number, hotSeat:Number = -1, score:int = 0):void
		{
			var command:TextCommand = new com.renaun.hydrap2p.TextCommand();
			command.userTimestamp = playerBox.timestamp;
			command.selection = selection;
			command.hotSeat = hotSeat;
			command.score = score;
			multicastConn.sendMessage(command);
		}
		
		protected function setGlows(glows:Vector.<Bitmap>, boxVO:BoxVO):void
		{
			var rg:int = 0;
			glows[rg].x = boxVO.x;
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x;
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x;
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x; 
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x; 
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x; 
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x; 
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x; 
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x; 
			glows[rg++].y = boxVO.y;
			glows[rg].x = boxVO.x; 
			glows[rg++].y = boxVO.y;
		}
		
		public function destroy():void
		{
			if (multicastConn)
			{
				multicastConn.destroy();
			}
		}
	}
}