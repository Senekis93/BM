package
{
	import flash.display.Sprite;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class ColorPicker extends Sprite
	{
		
		private var colorMap:Sprite, bmd:BitmapData, cPre:Sprite, spectrum:ColorSpectrum, color:uint = 0xFFFFFF;
		
		public function ColorPicker():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			addEventListener(Event.REMOVED_FROM_STAGE, die);
			colorMap = new Sprite();
			addChild(colorMap);
			spectrum = new ColorSpectrum(400, 400);
			colorMap.addChild(spectrum);
			colorMap.addEventListener(MouseEvent.MOUSE_MOVE, setColor);
			colorMap.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void
			{
				dispatchEvent(new E(E.SET_COLOR));
			});
			cPre = new Sprite;
			cPre.graphics.beginFill(color);
			cPre.graphics.drawRect(0, 0, 100, 100);
			cPre.y = stage.stageHeight - 11;
			addChild(cPre);
			bmd = new BitmapData(colorMap.width, colorMap.height);
			bmd.draw(colorMap);
		}
		
		/*SET COLOR*/
		private function setColor(e:MouseEvent):void
		{
			color = int("0x" + bmd.getPixel(colorMap.mouseX, colorMap.mouseY).toString(16));
			cPre.graphics.clear();
			cPre.graphics.beginFill(color);
			cPre.graphics.drawRect(0, 0, 100, 100);
		}
		
		private function die(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, die);
			removeChild(cPre);
			colorMap.removeChild(spectrum);
			spectrum = null;
			removeChild(colorMap);
			cPre = null;
			colorMap = null;
			bmd = null;
			removeEventListener(MouseEvent.MOUSE_UP, setColor);
		}
		
		/*GET COLOR*/
		internal function getColor():int
		{
			return color;
		}
	
	}
}