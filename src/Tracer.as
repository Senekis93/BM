package
{
	import org.flashdevelop.utils.FlashConnect;
	import flash.utils.getQualifiedClassName;
	
	public class Tracer
	{
		public function Tracer():void
		{
			throw new Error("No instance method defined. [" + String(this) + "]");
		}
		
		public static function t(C:* = null, S:* = "", ... args):void
		{
			var T:String = C ? "[" + getQualifiedClassName(C) + "] " + String(S) : String(S);
			if (args)
				for (var i:int = 0; i < args.length; ++i) T = T + "  " + args[i];
			FlashConnect.trace(T);
		}
	
	}
}