package
{
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class Arrow extends Sprite
	{
		
		public function Arrow(d:int, X:int, Y:int, S:Number):void
		{
			rotation = 90 * (d - 1);
			x = X;
			y = Y;
			scaleX = scaleY = S;
		}
		
		internal function draw():void
		{
			graphics.clear();
			graphics.beginFill(Local.D.d[8]);
			graphics.drawRect(-25, -25, 50, 50);
			graphics.endFill();
			graphics.beginFill(Local.D.d[7]);
			graphics.moveTo(-20, -20);
			graphics.lineTo(20, 0);
			graphics.lineTo(-20, 20);
			graphics.lineTo(-20, -20);
			graphics.endFill();
		}
	
	}
}