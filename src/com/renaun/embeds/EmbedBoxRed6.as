package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BoxRed6.png")]
	public class EmbedBoxRed6 extends BitmapData
	{
		public function EmbedBoxRed6(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}