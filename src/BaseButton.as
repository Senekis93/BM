package
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class BaseButton extends Sprite
	{
		private const field:NovaField = new NovaField(30, 0);
		
		public function BaseButton(X:int, Y:int, T:String):void
		{
			x = X;
			y = Y;
			field.text = T;
		}
		
		internal function draw():void
		{
			graphics.clear();
			graphics.lineStyle(2, Local.D.d[4]);
			graphics.beginFill(Local.D.d[8]);
			graphics.drawRoundRect(0, 0, 100, 35, 5);
			graphics.endFill();
			addChild(field);
			field.width = width;
			field.setFormat(30, Local.D.d[7]);
			field.x = width * .5 - field.width * .5;
		}
	
	}
}