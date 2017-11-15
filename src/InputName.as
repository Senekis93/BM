package
{
	import flash.events.Event;
	import flash.text.TextField;
	
	public class InputName extends TextField
	{
		public function InputName(X:int, Y:int):void
		{
			x = X;
			y = Y;
			type = "input";
			multiline = false;
			width = 200;
			height = 27;
			background = true;
			backgroundColor = 0xFFFFFF;
			selectable = true;
			restrict = "0-9A-Za-z-_";
			defaultTextFormat = new NovaFormat(25, 0);
		}
	}
}