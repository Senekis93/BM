package
{
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author: Senekis
	 * @project: Badges
	 */
	public class KongLogo extends Sprite
	{
		
		private var s:Number;
		
		public var l:Loader, l2:Loader, l3:Loader, c:int;
		
		[Embed(source = '../lib/KongLoader30.swf', mimeType = 'application/octet-stream')]
		private static const Kong:Class;
		
		public function KongLogo(X:int, Y:int, S:Number):void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
			x = X;
			y = Y;
			s = S;
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			addEventListener(Event.REMOVED_FROM_STAGE, die);
			l = new Loader();
			l.loadBytes(new Kong as ByteArray);
			l2 = new Loader();
			l2.loadBytes(new Kong as ByteArray);
			addChild(l2);
			l3 = new Loader();
			l3.loadBytes(new Kong as ByteArray);
			addChild(l3);
			l.scaleX = l.scaleY = 0.3;
			l.x += 110;
			l.y += 80;
			l2.x -= 100;
			l3.x += 100;
			addChild(l);
			scaleX = scaleY = s;
		}
		
		private function die(e:Event):void
		{
			l.unloadAndStop();
			l2.unloadAndStop();
			l3.unloadAndStop();
			removeChild(l);
			removeChild(l2);
			removeChild(l3);
		}
		
		/*ERROR*/
		public function errorMessage():void
		{
			l.unloadAndStop();
			removeChild(l);
		}
	
	}
}