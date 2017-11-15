package
{
	import skyboy.serialization.JSON;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.errors.IOError;
	
	public class User extends Object
	{
		
		public var points:int, all:Vector.<int>, unearned:Vector.<int>, easy:Vector.<int>, medium:Vector.<int>, hard:Vector.<int>, impossible:Vector.<int>, action:Vector.<int>, multiplayer:Vector.<int>, shooter:Vector.<int>, adventure:Vector.<int>, sports:Vector.<int>, defense:Vector.<int>, puzzle:Vector.<int>, music:Vector.<int>, unity:Vector.<int>, finalUnearned:Vector.<int>, finalEasy:Vector.<int>, finalMedium:Vector.<int>, finalHard:Vector.<int>, finalImpossible:Vector.<int>, finalAction:Vector.<int>, finalMultiplayer:Vector.<int>, finalShooter:Vector.<int>, finalAdventure:Vector.<int>, finalSports:Vector.<int>, finalDefense:Vector.<int>, finalPuzzle:Vector.<int>, finalMusic:Vector.<int>, finalUnity:Vector.<int>, user:String;
		
		public function User(username:String):void
		{
			getJSON("http://api.kongregate.com/accounts/" + username + "/badges.json");
			user = username;
		}
		
		/*GET JSON*/
		private function getJSON(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(url);
			loader.load(request);
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
			{
				//Tracer.t(null,"[User]",user,"invalid username?    ",e.text);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
				loader.removeEventListener(Event.COMPLETE, decodeJSON);
			});
			loader.addEventListener(Event.COMPLETE, decodeJSON);
		}
		
		/*DECODE JSON*/
		private function decodeJSON(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var data:Object = JSON.decode(loader.data);
			buildUser(data);
		}
		
		/*USER LOADED*/
		private function buildUser(data:Object):void
		{
			//Tracer.t(this,"Processing user badges for",user);
			getBadges(data);
			points = getUserPoints();
		/*if(Data.getUserPoints()<=Data.points){
		   API.Submit("Points",Data.getUserPoints());
		   Data.loadedGenres();Data.loadedGenres2();
		   STATUS.update("Sorting badges by genre...");
		   }*/
		}
		
		/*GET BADGES*/
		private function getBadges(data:Object):void
		{
			all = getAll(data);
			easy = getEasy();
			medium = getMedium();
			hard = getHard();
			impossible = getImpossible();
			unearned = getUnearned();
			action = getAction();
			multiplayer = getMultiplayer();
			shooter = getShooter();
			adventure = getAdventure();
			sports = getSports();
			defense = getDefense();
			puzzle = getPuzzle();
			music = getMusic();
			unity = getUnity();
			exclude();
			//Tracer.t(this,user,"badges loaded.");
		}
		
		/*USER POINTS*/
		private function getUserPoints():int
		{
			var p:int, i:int;
			for (; i < all.length; ++i)
				if (Badges.ids.indexOf(all[i]) > -1) p += Badges.badgeData[Badges.ids.indexOf(all[i])][6];
			return p;
		}
		
		/*GET USER BADGES*/
		private function getAll(data:Object):Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int;
			for (i = 0; i < data.length; ++i) v[i] = data[i].badge_id;
			return v;
		}
		
		/*EASY*/
		private function getEasy():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (data[i][7] == "easy")
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*MEDIUM*/
		private function getMedium():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (data[i][7] == "medium")
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*HARD*/
		private function getHard():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (data[i][7] == "hard")
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*IMPOSSIBLE*/
		private function getImpossible():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (data[i][7] == "impossible")
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*ALL*/
		private function getUnearned():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*ACTION*/
		private function getAction():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.action.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*MULTI*/
		private function getMultiplayer():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.multiplayer.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*SHOOTER*/
		private function getShooter():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.shooter.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*ADVENTURE*/
		private function getAdventure():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.adventure.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*SPORTS*/
		private function getSports():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.sports.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*DEFENSE*/
		private function getDefense():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.defense.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*PUZZLE*/
		private function getPuzzle():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.puzzle.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*MUSIC*/
		private function getMusic():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.music.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*UNITY*/
		private function getUnity():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, data:Vector.<Object> = Badges.badgeData, ids:Vector.<int> = Badges.ids;
			for (i; i < data.length; ++i)
				if (Badges.unity.indexOf(ids[i]) > -1)
					if ((all.indexOf(ids[i]) < 0)) v[v.length] = ids[i];
			return v;
		}
		
		/*FINAL UNEARNED*/
		private function getFinalUnearned():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = unearned.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(unearned[i]) == -1) v[v.length] = unearned[i];
			return v;
		}
		
		/*FINAL EASY*/
		private function getFinalEasy():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = easy.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(easy[i]) == -1) v[v.length] = easy[i];
			return v;
		}
		
		/*FINAL MEDIUM*/
		private function getFinalMedium():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = medium.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(medium[i]) == -1) v[v.length] = medium[i];
			return v;
		}
		
		/*FINAL HARD*/
		private function getFinalHard():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = hard.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(hard[i]) == -1) v[v.length] = hard[i];
			return v;
		}
		
		/*FINAL IMP*/
		private function getFinalImpossible():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = impossible.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(impossible[i]) == -1) v[v.length] = impossible[i];
			return v;
		}
		
		/*FINAL ACTION*/
		private function getFinalAction():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = action.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(action[i]) == -1) v[v.length] = action[i];
			return v;
		}
		
		/*FINAL MULTI*/
		private function getFinalMultiplayer():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = multiplayer.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(multiplayer[i]) == -1) v[v.length] = multiplayer[i];
			return v;
		}
		
		/*FINAL SHOOTER*/
		private function getFinalShooter():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = shooter.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(shooter[i]) == -1) v[v.length] = shooter[i];
			return v;
		}
		
		/*FINAL ADVENTURE*/
		private function getFinalAdventure():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = adventure.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(adventure[i]) == -1) v[v.length] = adventure[i];
			return v;
		}
		
		/*FINAL SPORTS*/
		private function getFinalSports():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = sports.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(sports[i]) == -1) v[v.length] = sports[i];
			return v;
		}
		
		/*FINAL DEFENSE*/
		private function getFinalDefense():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = defense.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(defense[i]) == -1) v[v.length] = defense[i];
			return v;
		}
		
		/*FINAL PUZZLE*/
		private function getFinalPuzzle():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = puzzle.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(puzzle[i]) == -1) v[v.length] = puzzle[i];
			return v;
		}
		
		/*FINAL MUSIC*/
		private function getFinalMusic():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = music.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(music[i]) == -1) v[v.length] = music[i];
			return v;
		}
		
		/*FINAL UNITY*/
		private function getFinalUnity():Vector.<int>
		{
			var v:Vector.<int> = new <int>[], i:int, l:int = unity.length;
			for (i = 0; i < l; ++i)
				if (Local.D.e.indexOf(unity[i]) == -1) v[v.length] = unity[i];
			return v;
		}
		
		/*EXCLUDE*/
		public function exclude():void
		{
			finalUnearned = getFinalUnearned();
			finalEasy = getFinalEasy();
			finalMedium = getFinalMedium();
			finalHard = getFinalHard();
			finalImpossible = getFinalImpossible();
			finalAction = getFinalAction();
			finalMultiplayer = getFinalMultiplayer();
			finalShooter = getFinalShooter();
			finalAdventure = getFinalAdventure();
			finalSports = getFinalSports();
			finalDefense = getFinalDefense();
			finalPuzzle = getFinalPuzzle();
			finalMusic = getFinalMusic();
			finalUnity = getFinalUnity();
		}
	
	}
}