package
{
	import flash.text.TextField;
	
	public class NovaField extends TextField
	{
		
		private const FORMAT:NovaFormat = new NovaFormat();
		
		public function NovaField(S:int = 30, C:int = 0xFFFFFF):void
		{
			embedFonts = true;
			autoSize = "left";
			selectable = false;
		}
		
		internal function setFormat(S:int, C:int):void
		{
			FORMAT.size = S;
			FORMAT.color = C;
			setTextFormat(FORMAT);
			defaultTextFormat = FORMAT;
		}
	
	}
}