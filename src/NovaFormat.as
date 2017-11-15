package
{
	import flash.text.TextFormat;
	
	public class NovaFormat extends TextFormat
	{
		
		[Embed(source = '../lib/Fonts/novamono.ttf', fontName = "Nova", fontFamily = "Font", fontWeight = normal, fontStyle = normal, mimeType = "application/x-font-truetype", embedAsCFF = false)]
		private const Nova:String;
		;
		
		public function NovaFormat(s:int = 30, c:int = 0xFFFFFF):void
		{
			super("Nova", s, c, false, false, false, null, null, "center");
		}
	}
}