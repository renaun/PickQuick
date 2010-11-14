package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BackgroundSliceBottom.png")]
	public class EmbedBackgroundSliceBottom extends BitmapData
	{
		public function EmbedBackgroundSliceBottom(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}