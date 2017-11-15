package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class Browser extends Sprite
	{
		private var current:int = 0, results:Vector.<int> = new <int>[];
		private const SELECTION:Vector.<int> = new <int>[0, 0, 0, 0], SIZE:int = 32, SCALE:Number = 0.5, X:int = 20, Y:int = 360, A1:Arrow = new Arrow(3, X, Y, SCALE), A2:Arrow = new Arrow(1, X + 30, Y, SCALE), A3:Arrow = new Arrow(3, X + 150, Y, SCALE), A4:Arrow = new Arrow(1, X + 180, Y, SCALE), A5:Arrow = new Arrow(3, X + 300, Y, SCALE), A6:Arrow = new Arrow(1, X + 330, Y, SCALE), A7:Arrow = new Arrow(3, X + 450, Y, SCALE), A8:Arrow = new Arrow(1, X + 480, Y, SCALE), A9:Arrow = new Arrow(3, X + 560, Y + 15, SCALE), A10:Arrow = new Arrow(1, X + 590, Y + 15, SCALE), ARROWS:Vector.<Arrow> = new <Arrow>[A1, A2, A3, A4, A5, A6, A7, A8, A9, A10], PICS:Vector.<Loader> = new <Loader>[], F1:Vector.<String> = new <String>["Any", "Earned", "Unearned"], F2:Vector.<String> = new <String>["Any", "Easy", "Medium", "Hard", "Impossible"], F3:Vector.<String> = new <String>["Any", "Action", "Multiplayer", "Shooter", "Adventure", "Sports", "Defense", "Puzzle", "Music", "Unity"], F4:Vector.<String> = new <String>["Normal", "Favorited", "Excluded"], FILTERS:Vector.<Vector.<String>> = new <Vector.<String>>[F1, F2, F3, F4], T1:NovaField = new NovaField(0, 0), T2:NovaField = new NovaField(0, 0), T3:NovaField = new NovaField(0, 0), T4:NovaField = new NovaField(0, 0), FIELDS:Vector.<NovaField> = new <NovaField>[T1, T2, T3, T4], XX:Vector.<int> = new <int>[10, 160, 310, 460], DES:NovaField = new NovaField(0, 0);
		
		public var badge:int, user:User;
		
		public function Browser():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
			var i:int, l:int = FIELDS.length;
			for (i = 0; i < l; ++i)
			{
				FIELDS[i].text = FILTERS[i][SELECTION[i]];
				FIELDS[i].x = XX[i];
			}
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			var i:int, l:int = ARROWS.length;
			for (i = 0; i < l; ++i) addChild(ARROWS[i]);
			l = FIELDS.length;
			for (i = 0; i < l; ++i) addChild(FIELDS[i]);
			A1.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				sort(0, false);
			});
			A2.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				sort(0, true);
			});
			A3.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				sort(1, false);
			});
			A4.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				sort(1, true);
			});
			A5.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				sort(2, false);
			});
			A6.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				sort(2, true);
			});
			A7.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				sort(3, false);
			});
			A8.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				sort(3, true);
			});
			A9.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				current -= 112;
				DES.text = "";
				build();
			});
			A10.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				current += 112;
				DES.text = "";
				build();
			});
			addChild(DES);
			DES.x = 520;
			DES.y = 50;
			DES.width = stage.stageWidth - DES.x - 10;
			DES.wordWrap = true;
			DES.height = 250;
			A9.visible = A10.visible = false;
		}
		
		/*SORT*/
		private function sort(i:int, d:Boolean):void
		{
			if (d)
			{
				if (SELECTION[i] != FILTERS[i].length - 1) SELECTION[i]++;
				else SELECTION[i] = 0;
			}
			else
			{
				if (SELECTION[i] != 0) SELECTION[i]--;
				else SELECTION[i] = FILTERS[i].length - 1;
			}
			FIELDS[i].text = FILTERS[i][SELECTION[i]];
			current = 0;
			DES.text = "";
			build();
		}
		
		/*BUILD*/
		private function build():void
		{
			if (results.length)
			{
				var i:int, l:int = PICS.length - 1;
				for (i = l; i > -1; --i)
				{
					removeChild(PICS[i]);
					PICS[i].removeEventListener(MouseEvent.CLICK, click);
					PICS[i].removeEventListener(MouseEvent.MOUSE_OVER, mO);
				}
				PICS.splice(0, l + 1);
			}
			results = new Vector.<int>(Badges.ids.length);
			var ii:int, ll:int = Badges.ids.length;
			for (ii = 0; ii < ll; ++ii) results[ii] = Badges.ids[ii];
			var b:int, e:int;
			e = results.length - 1;
			if (SELECTION[0] == 1)
			{
				for (b = e; b > -1; --b)
				{
					if (user.finalUnearned.indexOf(results[b]) != -1) results.splice(b, 1);
				}
			}
			else if (SELECTION[0] == 2)
				for (b = e; b > -1; --b)
					if (user.finalUnearned.indexOf(results[b]) == -1) results.splice(b, 1);
			e = results.length - 1;
			if (SELECTION[1] == 1)
			{
				for (b = e; b > -1; --b)
					if (Badges.easy.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[1] == 2)
			{
				for (b = e; b > -1; --b)
					if (Badges.medium.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[1] == 3)
			{
				for (b = e; b > -1; --b)
					if (Badges.hard.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[1] == 4)
				for (b = e; b > -1; --b)
					if (Badges.impossible.indexOf(results[b]) == -1) results.splice(b, 1);
			e = results.length - 1;
			if (SELECTION[2] == 1)
			{
				for (b = e; b > -1; --b)
					if (Badges.action.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[2] == 2)
			{
				for (b = e; b > -1; --b)
					if (Badges.multiplayer.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[2] == 3)
			{
				for (b = e; b > -1; --b)
					if (Badges.shooter.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[2] == 4)
			{
				for (b = e; b > -1; --b)
					if (Badges.adventure.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[2] == 5)
			{
				for (b = e; b > -1; --b)
					if (Badges.sports.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[2] == 6)
			{
				for (b = e; b > -1; --b)
					if (Badges.defense.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[2] == 7)
			{
				for (b = e; b > -1; --b)
					if (Badges.puzzle.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[2] == 8)
			{
				for (b = e; b > -1; --b)
					if (Badges.music.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[2] == 9)
			{
				for (b = e; b > -1; --b)
					if (Badges.unity.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			e = results.length - 1;
			if (SELECTION[3] == 0)
			{
				if (Local.D.e.length)
				{
					for (b = e; b > -1; --b)
						if (Local.D.e.indexOf(results[b]) != -1) results.splice(b, 1);
				}
			}
			else if (SELECTION[3] == 1)
			{
				for (b = e; b > -1; --b)
					if (Local.D.f.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			else if (SELECTION[3] == 2)
			{
				for (b = e; b > -1; --b)
					if (Local.D.e.indexOf(results[b]) == -1) results.splice(b, 1);
			}
			var r:int, X:int, Y:Number = 0.0, s:int = current + 112 < results.length ? current + 112 : results.length;
			for (r = current; r < s; ++r)
			{
				PICS[PICS.length] = getPic(Badges.badgeData[Badges.ids.indexOf(results[r])][5], 2 + (37 * X), 40 + (Y * 37));
				PICS[PICS.length - 1].addEventListener(MouseEvent.CLICK, click);
				PICS[PICS.length - 1].addEventListener(MouseEvent.MOUSE_OVER, mO);
				if (X < 13) X++;
				else
				{
					++Y;
					X = 0;
				}
			}
			A10.visible = current + 112 < results.length;
			A9.visible = current != 0;
		}
		
		/*CLICK*/
		private function click(e:MouseEvent):void
		{
			badge = results[PICS.indexOf(e.target) + current];
			dispatchEvent(new E(E.LOAD_BROWSE));
		}
		
		/*MOUSE OVER*/
		private function mO(e:MouseEvent):void
		{
			var id:int = Badges.ids.indexOf(results[PICS.indexOf(e.target) + current]);
			DES.text = Badges.badgeData[id][4] + "\n[" + Badges.badgeData[id][0] + "]\n" + Badges.badgeData[id][7] + " (" + Badges.badgeData[id][6] + ")\n\n" + Badges.badgeData[id][1] + ".";
		}
		
		/*LOAD IMAGE*/
		private function getPic(url:String, X:int, Y:int):Loader
		{
			var picLoader:Loader = new Loader();
			var pic:URLRequest = new URLRequest(url);
			picLoader.load(pic);
			addChild(picLoader);
			picLoader.x = X;
			picLoader.y = Y;
			return picLoader;
		}
		
		/*DRAW*/
		public function draw():void
		{
			var i:int, l:int = ARROWS.length;
			for (i = 0; i < l; ++i) ARROWS[i].draw();
			l = FIELDS.length;
			for (i = 0; i < l; ++i) FIELDS[i].setFormat(SIZE, Local.D.d[11]);
			T1.y = T2.y = T3.y = T4.y = Y + 10;
			build();
			DES.setFormat(25, Local.D.d[11]);
			DES.text = "";
		}
	
	}
}