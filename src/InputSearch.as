package
{
	import flash.events.Event;
	import flash.text.TextField;
	
	public class InputSearch extends TextField
	{
		public function InputSearch(X:int, Y:int):void
		{
			x = X;
			y = Y;
			type = "input";
			multiline = false;
			width = 480;
			height = 35;
			background = true;
			backgroundColor = 0xFFFFFF;
			selectable = true;
			defaultTextFormat = new NovaFormat(32, 0);
		}
	}
}