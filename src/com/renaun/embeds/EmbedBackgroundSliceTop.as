package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BackgroundSliceTop.png")]
	public class EmbedBackgroundSliceTop extends BitmapData
	{
		public function EmbedBackgroundSliceTop(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}