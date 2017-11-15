package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class Ad extends Sprite
	{
		private var image:Loader, url:String, link:String;
		
		public function Ad(URL:String, LINK:String = ""):void
		{
			url = URL;
			if (LINK.length)
			{
				buttonMode = true;
				link = LINK;
				addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					navigateToURL(new URLRequest(link), "_blank");
				});
			}
			try
			{
				var picLoader:Loader = new Loader(), pic:URLRequest = new URLRequest(url);
				picLoader.load(pic);
				image = picLoader;
			}
			catch (e:Error)
			{
			}
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			if (image) addChild(image);
		}
	}
}