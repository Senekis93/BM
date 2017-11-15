package
{
	
	public class SiteLock
	{
		
		private static const kong:RegExp = /http:\/\/chat\.kongregate\.com\/gamez\/([0-9]{4})\/([0-9]{4})\/[A-z]+\/([A-z0-9\-_]+\.swf\?)kongregate_game_version\=[0-9]+/, senekis:RegExp = /(http:\/\/www\.)?senekis\.net\/swf\/[A-z0-9]+\.swf/, local:String = "file:///F|/F/Programming/", laptop:String = "file:///C|/Users/F/Programming";
		
		public function SiteLock():void
		{
			throw new Error("[SiteLock] Fuck off.");
		}
		
		/*CHECK*/
		public static function good(url:String):Boolean
		{
			
			if (url.indexOf(local) == 0) return true;
			if (url.indexOf(laptop) == 0) return true;
			if (url.search(kong) == 0) return true;
			if (url.search(senekis) == 0) return true;
			Tracer.t(url);
			return false;
		}
	
	}
}