package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="/assets_embed/BoxGreen3.png")]
	public class EmbedBoxGreen3 extends BitmapData
	{
		public function EmbedBoxGreen3(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}