package
{
	import flash.net.SharedObject;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.LoaderInfo;
	import flash.display.Loader;
	import flash.system.Security;
	
	public class API extends Sprite
	{
		private static var local:Boolean;
		public static var K:*;
		
		public function API():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			var X:Object = LoaderInfo(root.loaderInfo).parameters;
			var url:String = X.kongregate_api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
			if (url === "http://www.kongregate.com/flash/API_AS3_Local.swf") local = true;
			Security.allowDomain(url);
			var r:URLRequest = new URLRequest(url);
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, oL);
			l.load(r);
			addChild(l);
		}
		
		private function oL(event:Event):void
		{
			K = event.target.content;
			K.services.connect();
		}
		
		public static function submit(s:String, v:*):void
		{
			K.stats.submit(s, Math.abs(int(v)));
		}
		
		private function Name():String
		{
			if (local) return "Senekis93";
			else if (!K.services.isGuest()) return K.services.getUsername();
			else return "BadgeMonster";
		}
		
		public function getUser():String
		{
			return Name();
		}
	
	}
}