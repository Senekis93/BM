package
{
	import flash.events.Event;
	import flash.text.TextField;
	
	public class InputField extends TextField
	{
		public function InputField():void
		{
			type = "input";
			multiline = false;
			width = 145;
			height = 35;
			background = true;
			backgroundColor = 0xFFFFFF;
			selectable = true;
			restrict = "0-9A-F#";
			maxChars = 8;
			defaultTextFormat = new NovaFormat(30, 0);
		}
		
		/*SET TEXT*/
		internal function setText(c:String):void
		{
			text = "#" + c;
		}
	
	}
}