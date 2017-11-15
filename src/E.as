package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class E extends Event
	{
		public static const LOAD_EASY:String = "a", LOAD_MEDIUM:String = "b", LOAD_HARD:String = "c", LOAD_IMPOSSIBLE:String = "d", LOAD_ANY:String = "e", LOAD_ACTION:String = "f", LOAD_MULTI:String = "g", LOAD_SHOOTER:String = "h", LOAD_DEFENSE:String = "i", LOAD_PUZZLE:String = "j", LOAD_MUSIC:String = "k", LOAD_UNITY:String = "l", LOAD_NEW:String = "m", LOAD_OLD:String = "n", SET_COLOR:String = "o", COLORS:String = "p", TIMEOUT:String = "q", COMPARE:String = "r", BAD_SEARCH:String = "s", LOAD_SEARCH:String = "t", UPDATE_TEXT:String = "u", LOAD_FAVORITE:String = "v", BAD_BADGE:String = "w", LOAD_BROWSE:String = "x", BACKGROUND_ERROR:String = "y", BACKGROUND:String = "z", LOAD_ADVENTURE:String = "0", LOAD_SPORTS:String = "1", SHARE_SKIN:String = "2";
		
		public function E(man:String):void
		{
			super(man);
		}
		
		/*PROXY*/
		public static function createListenerProxy(t:EventDispatcher, s:String):Function
		{
			return function(e:Event):void
			{
				t.dispatchEvent(new E(s));
			}
		}
	
	}
}