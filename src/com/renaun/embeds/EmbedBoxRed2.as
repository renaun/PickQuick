package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BoxRed2.png")]
	public class EmbedBoxRed2 extends BitmapData
	{
		public function EmbedBoxRed2(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}