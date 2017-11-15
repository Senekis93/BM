package
{
	import skyboy.serialization.JSON;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/*   [name , description , users_count , url , title , icon , points , difficulty ]
	   [0  ,       1      ,     2        ,  3  ,  4     ,  5   ,   6   ,    7       ]   */
	
	public class Badges
	{
		public static var badgeData:Vector.<Object> = new <Object>[], points:int, ids:Vector.<int> = new <int>[], easy:Vector.<int>, medium:Vector.<int>, hard:Vector.<int>, impossible:Vector.<int>, action:Vector.<int> = new <int>[], multiplayer:Vector.<int> = new <int>[], shooter:Vector.<int> = new <int>[], adventure:Vector.<int> = new <int>[], sports:Vector.<int> = new <int>[], defense:Vector.<int> = new <int>[], puzzle:Vector.<int> = new <int>[], music:Vector.<int> = new <int>[], unity:Vector.<int> = new <int>[], error:Boolean;
		
		//CONSTANTS 
		[Embed(source = '../lib/G.txt', mimeType = 'application/octet-stream')]
		private static const G:Class, GENRES:String = (new G() as ByteArray).toString(), URL:String = "http://api.kongregate.com/badges.json", CURRENT:int = 2196;
		
		public static const TOTAL:int = 2196;
		
		/*CONSTRUCTOR*/
		public function Badges():void
		{
			throw new Error("[Badges] ♥");
		}
		
		/*DECODE JSON*/
		private static function decodeJSON(e:Event):void
		{
			//var time:int=getTimer();
			//Tracer.t(null,"[Badges] Loading badges JSON...");
			var loader:URLLoader = URLLoader(e.target);
			var data:Object = skyboy.serialization.JSON.decode(loader.data);
			badgeData = buildBadge(data);
			points = getPoints();
			//Tracer.t(null,"[Badges] Sorting by difficulty.");
			buildByDifficulty();
			//Tracer.t(null,"[Badges] Sorting by genre.");
			loadGenres();
			//trace(getTimer()-time);
		}
		
		/*ERROR*/
		private static function JSONError(e:IOErrorEvent):void
		{
			Tracer.t(null, "[Badges] JSONError", e);
			error = true;
		}
		
		/*BADGES LOADED*/
		private static function buildBadge(data:Object):Vector.<Object>
		{
			//Tracer.t(null,"[Badges] Badge JSON loaded... processing...");
			var v:Vector.<Object> = new <Object>[], s:String = "", i:int, j:Object;
			var points:int;
			for (i = 0; i < data.length; ++i)
			{
				j = data[i];
				v[i] = [j.name, j.description, j.users_count, j.games[0].url, j.games[0].title, j.icon_url, j.points, j.difficulty, j.id];
				if (i > CURRENT - 1) s = s + "\n" + j.id + ": " + j.name + "   " + j.games[0].url;
				ids[i] = j.id;
				points += j.points;
			}
			trace(s);
			trace(points, ":::", points / TOTAL);
			return v;
		}
		
		/*GET POINTS*/
		private static function getPoints():int
		{
			var p:int, i:int;
			for (; i < badgeData.length; ++i) p += badgeData[i][6];
			return p;
		}
		
		/*GET BY DIFFICULTY*/
		private static function buildByDifficulty():void
		{
			easy = getTotalEasy();
			medium = getTotalMedium();
			hard = getTotalHard();
			impossible = getTotalImpossible();
		}
		
		/*TOTAL EASY*/
		private static function getTotalEasy():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int;
			for (i = 0; i < badgeData.length; ++i)
				if (badgeData[i][7] == "easy") v[v.length] = ids[i];
			return v;
		}
		
		/*TOTAL MEDIUM*/
		private static function getTotalMedium():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int;
			for (i = 0; i < badgeData.length; ++i)
				if (badgeData[i][7] == "medium") v[v.length] = ids[i];
			return v;
		}
		
		/*TOTAL HARD*/
		private static function getTotalHard():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int;
			for (i = 0; i < badgeData.length; ++i)
				if (badgeData[i][7] == "hard") v[v.length] = ids[i];
			return v;
		}
		
		/*TOTAL IMPOSSIBLE*/
		private static function getTotalImpossible():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int;
			for (i = 0; i < badgeData.length; ++i)
				if (badgeData[i][7] == "impossible") v[v.length] = ids[i];
			return v;
		}
		
		/*BUILD GENRES*/
		public static function loadGenres():void
		{
			var temp:Array = GENRES.split(/\r/), l:int = temp.length,//genres:Vector.<Array>=new <Array>[],
			genres:Array = [], i:int, j:int, k:int;
			for (i = 0; i < l; ++i) genres[i] = temp[i].split(" ");
			for (j = 0; j < genres.length; ++j)
			{
				for (k = 0; k < genres[j].length; ++k)
				{
					if (genres[j][k] == "action") action[action.length] = ids[j];
					else if (genres[j][k] == "multiplayer") multiplayer[multiplayer.length] = ids[j];
					else if (genres[j][k] == "shooter") shooter[shooter.length] = ids[j];
					else if (genres[j][k] == "adventure") adventure[adventure.length] = ids[j];
					else if (genres[j][k] == "sports") sports[sports.length] = ids[j];
					else if (genres[j][k] == "defense") defense[defense.length] = ids[j];
					else if (genres[j][k] == "puzzle") puzzle[puzzle.length] = ids[j];
					else if (genres[j][k] == "music") music[music.length] = ids[j];
					else if (genres[j][k] == "unity") unity[unity.length] = ids[j];
				}
			}
		}
		

		/*GET JSON*/
		public static function getJSON():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(URL);
			loader.addEventListener(IOErrorEvent.IO_ERROR, JSONError);
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, decodeJSON);
		}
	
	
	}
}