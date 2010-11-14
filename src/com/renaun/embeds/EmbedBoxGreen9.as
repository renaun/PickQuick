package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BoxGreen9.png")]
	public class EmbedBoxGreen9 extends BitmapData
	{
		public function EmbedBoxGreen9(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}