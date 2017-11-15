package
{
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Graphics;
	
	public class Div extends Sprite
	{
		
		private var f:NovaField = new NovaField(), t:String;
		
		private const HEIGHT:int = 50;
		
		public function Div(Y:int, T:String):void
		{
			y = Y;
			t = T;
		}
		
		/*DRAW*/
		internal function draw():void
		{
			graphics.clear();
			graphics.lineStyle(1, Local.D.d[4]);
			graphics.beginFill(Local.D.d[2]);
			graphics.drawRoundRect(0, 0, stage.stageWidth, HEIGHT, 20);
			graphics.endFill();
			addChild(f);
			f.setFormat(50, Local.D.d[3]);
			f.text = t;
			f.x = stage.stageWidth * .5 - f.width * .5;
		}
		
		/*DRAW*/
		internal function drawBack(back:int):void
		{
			graphics.clear();
			graphics.lineStyle(1, Local.D.d[4]);
			graphics.beginFill(back);
			graphics.drawRoundRect(0, 0, stage.stageWidth, HEIGHT, 20);
			graphics.endFill();
			addChild(f);
			f.setFormat(50, Local.D.d[3]);
			f.text = t;
			f.x = stage.stageWidth * .5 - f.width * .5;
		}
		
		/*DRAW*/
		internal function drawText(text:int):void
		{
			graphics.clear();
			graphics.lineStyle(1, Local.D.d[4]);
			graphics.beginFill(Local.D.d[2]);
			graphics.drawRoundRect(0, 0, stage.stageWidth, HEIGHT, 20);
			graphics.endFill();
			addChild(f);
			f.setFormat(50, text);
			f.text = t;
			f.x = stage.stageWidth * .5 - f.width * .5;
		}
		
		/*CHANGE TEXT*/
		internal function setText(t:String):void
		{
			f.text = t;
			f.x = stage.stageWidth * .5 - f.width * .5;
		}
	
	}
}