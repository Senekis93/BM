package
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class ColorButton extends Sprite
	{
		
		private const field:NovaField = new NovaField(30, 0xFFFFFF);
		
		public function ColorButton(X:int, Y:int, T:String):void
		{
			x = X;
			y = Y;
			field.text = T;
		}
		
		/*DRAW*/
		internal function draw():void
		{
			graphics.clear();
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.beginFill(0);
			graphics.drawRoundRect(1, 1, 100, 25, 5);
			graphics.endFill();
			addChild(field);
			field.setFormat(30, 0xFFFFFF);
			field.width = width;
			field.x = width * .5 - field.width * .5;
		}
	
	}

}