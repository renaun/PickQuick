package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="../assets_embed/test_2.png")]
	public class Test2 extends BitmapData
	{
		public function Test2(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}