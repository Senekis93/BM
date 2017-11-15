package
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public final class Checkbox extends Sprite
	{
		public var checked:Boolean;
		
		public function Checkbox(X:int, Y:int):void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
			x = X;
			y = Y;
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			addEventListener(Event.REMOVED_FROM_STAGE, die);
			graphics.lineStyle(0);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, 15, 15);
			graphics.endFill();
		}
		
		private function die(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, die);
		}
		
		/*TOOGLE*/
		public function toogle():void
		{
			if (!checked)
			{
				graphics.moveTo(1, 10);
				graphics.lineStyle(2, 0);
				graphics.lineTo(5, 14);
				graphics.lineTo(14, 1);
				checked = true;
			}
			else
			{
				graphics.clear();
				graphics.lineStyle(0);
				graphics.beginFill(0xFFFFFF);
				graphics.drawRect(0, 0, 15, 15);
				graphics.endFill();
				checked = false;
			}
		}
	
	}
}