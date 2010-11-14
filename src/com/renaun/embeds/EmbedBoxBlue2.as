package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BoxBlue2.png")]
	public class EmbedBoxBlue2 extends BitmapData
	{
		public function EmbedBoxBlue2(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}