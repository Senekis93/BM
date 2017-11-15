package
{
	import flash.events.Event;
	import flash.display.Sprite;
	
	public class NavButton extends Sprite
	{
		private var t:String, first:Boolean = true;
		
		private const field:NovaField = new NovaField(35, 0);
		
		public function NavButton(X:int, Y:int, T:String):void
		{
			x = X;
			y = Y;
			t = T;
		}
		
		/*DRAW*/
		internal function draw():void
		{
			graphics.clear();
			graphics.lineStyle(2, Local.D.d[4]);
			graphics.beginFill(Local.D.d[8]);
			graphics.drawRoundRect(0, 0, 100, 24, 5);
			graphics.endFill();
			addChild(field);
			field.text = t;
			if (first)
			{
				field.y -= 5;
				first = false;
			}
			field.setFormat(32, Local.D.d[7]);
			field.x = width * .5 - field.width * .5;
		}
	
	}
}