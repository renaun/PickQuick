package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BoxGreen7.png")]
	public class EmbedBoxGreen7 extends BitmapData
	{
		public function EmbedBoxGreen7(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}