package com.renaun.embeds
{
	import flash.text.Font;
	
	[Embed(source="/assets_embed/AmericanTypewriterBold.ttf", fontFamily="FontAmericanTypeWriterBold",
            embedAsCFF="false", unicodeRange="U+002c-U+0039,U+0041-U+005A,U+0061-U+007A", 
				mimeType="application/x-font")]
	public class FontAmericanTypeWriterBold extends Font
	{
		public function FontAmericanTypeWriterBold()
		{
			super();
		}
	}
}