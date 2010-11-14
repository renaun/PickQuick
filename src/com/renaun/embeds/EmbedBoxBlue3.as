package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BoxBlue3.png")]
	public class EmbedBoxBlue3 extends BitmapData
	{
		public function EmbedBoxBlue3(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}