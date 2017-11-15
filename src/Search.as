package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	
	public class Search extends Sprite
	{
		
		private var current:int = 0, results:Vector.<int> = new <int>[], pics:Vector.<Loader> = new <Loader>[];
		
		private const OPTIONS:NovaField = new NovaField(0, 0), BOXES:Vector.<Checkbox> = new <Checkbox>[new Checkbox(60, 370), new Checkbox(375, 370), new Checkbox(192, 370), new Checkbox(540, 370)], SETTING:Vector.<Boolean> = new <Boolean>[true, true, true, true], SIZE:int = 25, TEXT:InputSearch = new InputSearch(130, 50), GO:BaseButton = new BaseButton(10, 50, "Search!"), DES:NovaField = new NovaField(SIZE, 0), NEXT:Arrow = new Arrow(1, 600, 380, 0.5), BACK:Arrow = new Arrow(3, 570, 380, 0.5);
		
		public var badge:int, badge2:int, user:User;
		
		public function Search():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			addChild(TEXT);
			TEXT.text = "Enter search (3+ characters)";
			addChild(GO);
			GO.addEventListener(MouseEvent.CLICK, search);
			addChild(DES);
			DES.x = 520;
			DES.y = 100;
			DES.width = stage.stageWidth - DES.x - 10;
			DES.wordWrap = true;
			DES.height = 250;
			addChild(NEXT);
			addChild(BACK);
			BACK.visible = NEXT.visible = false;
			NEXT.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				current += 98;
				build();
			});
			BACK.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				current -= 98;
				build();
			});
			addChild(OPTIONS);
			OPTIONS.x = 15;
			OPTIONS.y = 360;
			OPTIONS.text = "Game         Badge         Description         Developer";
			var i:int, l:int = BOXES.length;
			for (i = 0; i < l; ++i)
			{
				addChild(BOXES[i]);
				BOXES[i].toogle();
				BOXES[i].addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					var ix:int = BOXES.indexOf(e.currentTarget);
					BOXES[ix].toogle();
					SETTING[ix] = SETTING[ix] ? false : true;
				});
			}
		}
		
		/*SEARCH*/
		private function search(e:MouseEvent):void
		{
			current = 0;
			results.splice(0, results.length);
			var s:Array = TEXT.text.split(",");
			if (!s.length) dispatchEvent(new E(E.BAD_SEARCH));
			else if (TEXT.text.length < 3) dispatchEvent(new E(E.BAD_SEARCH));
			else
			{
				var w:int, cs:String;
				for (w = s.length - 1; w > -1; --w)
				{
					cs = s[w];
					while (badChar(cs.charAt(0)))
						if (cs.length) cs = cs.substring(1, cs.length);
					cs = fix(cs);
					if (cs.length < 3)
					{
						s.splice(w, 1);
						continue;
					}
					cs = cs.toLowerCase();
					cs = cs.split("*").join("[^ ]*");
					s[w] = cs;
				}
				var b:int, l:int = Badges.ids.length, game:String, i:int, m:int = s.length, des:String, title:String, name:String, url:String;
				for (b = 0; b < l; ++b)
				{
					game = Badges.badgeData[b][3];
					game = game.substr(game.lastIndexOf("/") + 1, game.length);
					game = game.split("-").join(" ");
					game = game.toLowerCase();
					des = Badges.badgeData[b][1].toLowerCase();
					//title=Badges.badgeData[b][4].toLowerCase();
					name = Badges.badgeData[b][0].toLowerCase();
					url = Badges.badgeData[b][3];
					url = url.substring(url.indexOf("games/") + 6, url.length);
					url = (url.substring(0, url.indexOf("/"))).toLowerCase();
					var ss:RegExp;
					for (i = 0; i < m; ++i)
					{
						ss = new RegExp("\\b" + s[i] + "\\b");
						if (game.search(ss) > -1)
						{
							if (SETTING[0])
							{
								if (results.indexOf(Badges.ids[b]) == -1) results[results.length] = Badges.ids[b];
								continue;
							}
						}
						else if (des.search(ss) > -1)
						{
							if (SETTING[1])
							{
								if (results.indexOf(Badges.ids[b]) == -1) results[results.length] = Badges.ids[b];
								continue;
							}
						}
						/*else if(title.search(ss)>-1){
						   results[results.length]=Badges.ids[b];
						   continue;
						   }*/
						else if (name.search(ss) > -1)
						{
							if (SETTING[2])
							{
								if (results.indexOf(Badges.ids[b]) == -1) results[results.length] = Badges.ids[b];
								continue;
							}
						}
						else if (url.search(ss) > -1)
						{
							if (SETTING[3])
							{
								if (results.indexOf(Badges.ids[b]) == -1) results[results.length] = Badges.ids[b];
								continue;
							}
						}
					}
				}
			}
			build();
		}
		
		/*BUILD*/
		private function build():void
		{
			var p:int, pl:int = pics.length;
			if (pl)
			{
				for (p = pl - 1; p > -1; --p)
				{
					pics[p].removeEventListener(MouseEvent.CLICK, click);
					pics[p].removeEventListener(MouseEvent.MOUSE_OVER, mO);
					removeChild(pics[p]);
				}
				pics.splice(0, pl);
			}
			DES.text = "";
			var r:int, X:int, Y:Number = 0.0, l:int = current + 98 < results.length ? current + 98 : results.length;
			for (r = current; r < l; ++r)
			{
				pics[pics.length] = getPic(Badges.badgeData[Badges.ids.indexOf(results[r])][5], 2 + (37 * X), 100 + (Y * 37));
				if (user.all.indexOf(results[r]) > -1) pics[pics.length - 1].alpha = 0.3;
				pics[pics.length - 1].addEventListener(MouseEvent.CLICK, click);
				pics[pics.length - 1].addEventListener(MouseEvent.MOUSE_OVER, mO);
				if (X < 13) X++;
				else
				{
					++Y;
					X = 0;
				}
			}
			NEXT.visible = current + 98 < results.length;
			BACK.visible = current != 0;
		}
		
		/*CLICK*/
		private function click(e:MouseEvent):void
		{
			badge = results[pics.indexOf(e.target) + current];
			badge2 = Badges.ids.indexOf(results[pics.indexOf(e.target) + current]);
			dispatchEvent(new E(E.LOAD_SEARCH));
		}
		
		/*MOUSE OVER*/
		private function mO(e:MouseEvent):void
		{
			var id:int = Badges.ids.indexOf(results[pics.indexOf(e.target) + current]);
			DES.text = Badges.badgeData[id][4] + "\n[" + Badges.badgeData[id][0] + "]\n" + Badges.badgeData[id][7] + " (" + Badges.badgeData[id][6] + ")\n\n" + Badges.badgeData[id][1] + ".";
		}
		
		/*BAD CHAR*/
		private function badChar(c:String):Boolean
		{
			var good:RegExp = /[A-z0-9\*]/;
			return ((c.search(good) == -1));
		}
		
		/*FIX*/
		private function fix(c:String):String
		{
			var bad:Vector.<String> = new <String>[".", ",", ";", ":", "_", "-", "?", "!", "¿", "¡", "=", "(", ")", "@", "|", "#", "$", "\"", "%", "&", "/"], i:int, l:int = bad.length, a:Array = c.split(""), j:int, ll:int = a.length;
			for (i = 0; i < l; ++i)
			{
				for (j = 0; j < ll; ++j)
				{
					if (a[j] == bad[i])
					{
						a[j] = "";
						continue;
					}
				}
			}
			return a.join("");
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
		internal function draw():void
		{
			DES.setFormat(SIZE, Local.D.d[11]);
			GO.draw();
			NEXT.draw();
			BACK.draw();
			OPTIONS.setFormat(33, Local.D.d[11]);
		}
		
		/*GET TEXT*/
		internal function getText():String
		{
			return TEXT.text;
		}
	
	}
}