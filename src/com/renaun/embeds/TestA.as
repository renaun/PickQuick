package com.renaun.embeds
{
	import flash.display.BitmapData;

	[Embed(source="../assets_embed/test_a.png")]
	public class TestA extends BitmapData
	{
		public function TestA(width:int, height:int, transparent:Boolean=true, fillColor:uint=4.294967295E9)
		{
			super(width, height, transparent, fillColor);
		}
	}
}