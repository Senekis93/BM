package
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.filters.BevelFilter;
	
	public class PlayButton extends Sprite
	{
		
		private const field:NovaField = new NovaField(0, 0);
		
		public function PlayButton(X:int, Y:int):void
		{
			x = X;
			y = Y;
		}
		
		/*DRAW*/
		internal function draw():void
		{
			graphics.lineStyle(2, Local.D.d[4]);
			graphics.beginFill(Local.D.d[8]);
			graphics.drawRoundRect(0, 0, 230, 100, 20, 10);
			graphics.endFill();
			filters = [new BevelFilter(5, 45, Local.D.d[4], 0.5, Local.D.d[4], 0.5, 2, 2)];
			addChild(field);
			field.text = "Launch this game!";
			field.setFormat(45, Local.D.d[7]);
			field.y = height * .5 - field.height * .5;
			field.x = width * .5 - field.width * .5;
		}
	
	}
}