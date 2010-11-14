package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BoxBlue1.png")]
	public class EmbedBoxBlue1 extends BitmapData
	{
		public function EmbedBoxBlue1(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}