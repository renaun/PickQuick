package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BackgroundSliceBottomRed.png")]
	public class EmbedBackgroundSliceBottomRed extends BitmapData
	{
		public function EmbedBackgroundSliceBottomRed(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}