package
{
	import flash.net.SharedObject;
	
	public class Local
	{
		private static const SO:SharedObject = SharedObject.getLocal("senekis.net/save/BM", "/");
		
		public static const D:Object = SO.data, PATCH:int = 2, NOTICE:String = "Removed Zening (can be restored from the excluded list).";
		
		public function Local():void
		{
			throw new Error("[Local] ♥");
		}
		
		/*CREATE*/
		public static function create():void
		{
			D.patch = 0;
			D.e = [1035, 1036, 1037];
			D.f = [];
			D.d = ["hello,world", //B64
			0xFFFFFF, // SCROLLING TEXT
			0x0, 0xFF0937, //DIV
			0xFFFFFF, // BORDERS
			0xB4FFE7,  // BADGE LOADER
			0x0,      //BACKGROUND
			0xD03939, 0x0, // BUTTONS
			0xD03939, 0x0,  //GRAPHICS
			0xD03939, //TEXT
			0 //BG MODE
			];
			/*
			   0 = MN;
			   1 = Scrolling text color;
			   2 = Div background;
			   3 = Div text color;
			   4 = borders and lines;
			   5 = badge title/desc/points text color;
			   6 = background
			   7 = button text color
			   8 = button background
			   9 = Gradient
			   10 = Gradient 2
			   11 = Text.
			   12 = background type
			 */
			
			D.x = 1;
			SO.flush();
			//Tracer.t(null,"[Local] New user.");
		}
		
		/*PATCH*/
		public static function noPatch():Boolean
		{
			if (!D.patch)
			{
				D.patch = 0;
				return true;
			}
			return D.patch !== PATCH;
		}
		
		public static function patch():void
		{
			var i:int = D.patch;
			while (++i < PATCH + 1) applyPatch(i);
			D.patch = PATCH;
			SO.flush();
		}
		
		private static function applyPatch(v:int):void
		{
			if (v === 1)
			{ // battalion-arena
				if (D.e.indexOf(831) == -1) D.e.push(831);
				if (D.e.indexOf(832) == -1) D.e.push(832);
			}
			else if (v === 2)
			{ // zening
				if (D.e.indexOf(841) == -1) D.e.push(841);
				if (D.e.indexOf(842) == -1) D.e.push(842);
			}
		}
		
		/*RESTORE*/
		public static function clearSkin():void
		{
			D.d = ["hello,world", 0xFFFFFF, 0x0, 0xFF0937, 0xFFFFFF, 0xB4FFE7, 0x0, 0xD03939, 0x0, 0xD03939, 0x0, 0xD03939, 0];
			SO.flush();
		}
		
		/*UPDATE*/
		public static function update(e:int, v:*):void
		{
			D.d[e] = v;
		}
		
		/*CHECK*/
		public static function checkNew():Boolean
		{
			return D.x == null;
		}
		
		/*ADD FAVORITE*/
		public static function add(i:int):void
		{
			D.f.push(i);
			SO.flush();
		}
		
		/*REMOVE*/
		public static function remove(i:int):void
		{
			D.f.splice(D.f.indexOf(i), 1);
			SO.flush();
		}
		
		/*EXCLUDE*/
		public static function exclude(i:int):void
		{
			D.e.push(i);
			SO.flush();
		}
		
		/*RESTORE*/
		public static function restore(i:int):void
		{
			D.e.splice(D.e.indexOf(i), 1);
			SO.flush();
		}
	
	}
}