package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.filters.BlurFilter;
	import flash.filters.BevelFilter;
	
	public class BadgeLoader extends Sprite
	{
		private var bad:Boolean, url:String, points:int, title:String, pic:DisplayObject, pics:Vector.<DisplayObject> = new <DisplayObject>[], links:Vector.<int> = new <int>[], all:Vector.<int> = new <int>[], current:int = 0, AD:Ad;
		
		private const URL:String = "http://senekis.net/pics/random/bmlogo.png", LINK:String = "", ADX:int = 35, ADY:int = 335, AD_W:int = 130, AD_H:int = 75, SHOW_AD:Boolean = false, PLAY:PlayButton = new PlayButton(200, 200), FAV:BaseButton = new BaseButton(485, 320, "Favorite"), REMOVE:BaseButton = new BaseButton(485, 320, "Remove"), EXCLUDE:BaseButton = new BaseButton(485, 270, "Exclude"), RESTORE:BaseButton = new BaseButton(485, 270, "Restore"), 
		//
		ANY:LoaderButton = new LoaderButton(0, 30, "Any"), EASY:LoaderButton = new LoaderButton(75, 30, "Easy"), MEDIUM:LoaderButton = new LoaderButton(0, 60, "Medium"), HARD:LoaderButton = new LoaderButton(75, 60, "Hard"), IMPOSSIBLE:LoaderButton = new LoaderButton(0, 90, "Imposs"), ACTION:LoaderButton = new LoaderButton(75, 90, "Action"), MULTI:LoaderButton = new LoaderButton(0, 120, "Multi"), SHOOTER:LoaderButton = new LoaderButton(75, 120, "Shooter"), DEFENSE:LoaderButton = new LoaderButton(0, 150, "Strategy"), PUZZLE:LoaderButton = new LoaderButton(75, 150, "Puzzle"), ADVENTURE:LoaderButton = new LoaderButton(0, 180, "RPG"), SPORTS:LoaderButton = new LoaderButton(75, 180, "Sports"), MUSIC:LoaderButton = new LoaderButton(0, 210, "Music/?"), UNITY:LoaderButton = new LoaderButton(75, 210, "Unity"), NEWEST:LoaderButton = new LoaderButton(0, 240, "Newest"), OLDEST:LoaderButton = new LoaderButton(75, 240, "Oldest"), FAVORITED:LoaderButton = new LoaderButton(0, 270, "Favorite"), PREV:LoaderButton = new LoaderButton(75, 270, "Previous"), NEXT:LoaderButton = new LoaderButton(75, 300, "Next"), 
		//
		BUTTONS:Vector.<LoaderButton> = new <LoaderButton>[ANY, EASY, MEDIUM, HARD, IMPOSSIBLE, ACTION, MULTI, SHOOTER, DEFENSE, PUZZLE, ADVENTURE, SPORTS, MUSIC, UNITY, NEWEST, OLDEST, FAVORITED], EVENTS:Vector.<String> = new <String>[E.LOAD_ANY, E.LOAD_EASY, E.LOAD_MEDIUM, E.LOAD_HARD, E.LOAD_IMPOSSIBLE, E.LOAD_ACTION, E.LOAD_MULTI, E.LOAD_SHOOTER, E.LOAD_DEFENSE, E.LOAD_PUZZLE, E.LOAD_ADVENTURE, E.LOAD_SPORTS, E.LOAD_MUSIC, E.LOAD_UNITY, E.LOAD_NEW, E.LOAD_OLD, E.LOAD_FAVORITE], 
		//
		COLORS:Vector.<int> = new <int>[0xFF00, 0xFFFF00, 0xC15A00, 0xFF0000], DIFFICULTY:Vector.<String> = new <String>["easy", "medium", "hard", "impossible"], DIFF:Sprite = new Sprite(), PIC_X:int = 480, PIC_Y:int = 90, SCALE:Number = 3.0, BEVEL:BevelFilter = new BevelFilter(2, 45, 0, 1, 0, 1, 2, 2, 3), BLUR:BlurFilter = new BlurFilter(2, 2, 3), TITLE:NovaField = new NovaField(45, 0), DES:NovaField = new NovaField(35, 0), TO_EARN:NovaField = new NovaField(30, 0);
		
		internal var user:User, badge:int, bid:int;
		
		public function BadgeLoader():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			if (SHOW_AD)
			{
				AD = new Ad(URL, LINK);
				addChild(AD);
				var scale:Number = 1.0;
				if (AD.width > AD_W || AD.height > AD_H)
				{
					if (AD.width > AD.height) scale = AD_W / AD.width;
					else scale = AD_H / AD.height;
					AD.scaleX = AD.scaleY = scale;
				}
				//AD.y=360-AD.height*.5;
				//AD.x=75-AD.width*.5;
				AD.x = ADX;
				AD.y = ADY;
			}
			addChild(TITLE);
			TITLE.y = 40;
			addChild(DES);
			DES.width = 300;
			DES.multiline = true;
			DES.wordWrap = true;
			addChild(DIFF);
			DIFF.graphics.endFill();
			DIFF.x = PIC_X;
			DIFF.y = PIC_Y + 130;
			addChild(TO_EARN);
			TO_EARN.x = 170;
			TO_EARN.y = 390;
			addChild(PLAY);
			PLAY.addEventListener(MouseEvent.CLICK, launchGame);
			var i:int;
			for (i = 0; i < BUTTONS.length; ++i)
			{
				BUTTONS[i].addEventListener(MouseEvent.CLICK, E.createListenerProxy(this, EVENTS[i]));
				addChild(BUTTONS[i]);
			}
			addChild(PREV);
			addChild(NEXT);
			PREV.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				--current;
				loadBadge(all[current]);
			});
			NEXT.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				++current;
				loadBadge(all[current]);
			});
			addChild(FAV);
			FAV.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				Local.add(bid);
				loadBadge(bid);
			});
			addChild(REMOVE);
			REMOVE.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				Local.remove(bid);
				loadBadge(bid);
			});
			addChild(EXCLUDE);
			EXCLUDE.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				Local.exclude(bid);
				user.exclude();
				loadBadge(bid);
			});
			addChild(RESTORE);
			RESTORE.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				Local.restore(bid);
				user.exclude();
				loadBadge(bid);
			});
		}
		
		private function getPic(url:String, mini:Boolean = false):DisplayObject
		{
			var picLoader:Loader = new Loader();
			var pic:URLRequest = new URLRequest(url);
			picLoader.load(pic);
			addChild(picLoader);
			picLoader.x = PIC_X;
			picLoader.y = PIC_Y;
			picLoader.filters = [BLUR];
			picLoader.scaleX = picLoader.scaleY = SCALE;
			return picLoader;
		}
		
		private function getThumb(X:int, Y:int, url:String):DisplayObject
		{
			var picLoader:Loader = new Loader();
			var pic:URLRequest = new URLRequest(url);
			picLoader.load(pic);
			addChild(picLoader);
			picLoader.x = X;
			picLoader.y = Y;
			return picLoader;
		}
		
		private function loadThumb(e:MouseEvent):void
		{
			const i:int = pics.indexOf(e.target);
			if (i != -1) loadBadge(links[i]);
		}
		
		private function launchGame(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(url + "?referrer=Senekis93"), "_blank");
		}
		
		private function clear():void
		{
			points = 0;
			TO_EARN.text = TITLE.text = DES.text = "";
			var i:int;
			if (pic)
				if (pic.stage) removeChild(pic);
			if (pics.length)
				for (i = pics.length - 1; i > -1; --i)
				{
					if (pics[i].stage) removeChild(pics[i]);
					pics[i].removeEventListener(MouseEvent.CLICK, loadThumb);
					pics.splice(i, 1);
					links.splice(i, 1);
				}
			DIFF.graphics.clear();
		}
		
		private function gameBadges(id:int):Vector.<int>
		{
			var i:int = Badges.ids.indexOf(id), b:int, game:String = Badges.badgeData[i][3], game2:String, v:Vector.<int> = new <int>[], con:int, str:int;
			game = game.substr(game.lastIndexOf("/") + 1, game.length);
			title = (game.substr(0, 1).toUpperCase() + game.substr(1, game.length)).split("-").join(" ");
			//con=i+4<Badges.ids.length-1?i+4:Badges.ids.length-1;
			//str=i-3>0?i-3:0;
			con = Badges.ids.length;
			str = 0;
			for (b = str; b < con; ++b)
			{
				try
				{
					if (Badges.ids[b])
						if (b != i)
							if (user.unearned.indexOf(Badges.ids[b]) > -1)
							{
								game2 = Badges.badgeData[b][3];
								game2 = game2.substr(game2.lastIndexOf("/") + 1, game2.length);
								if (game2 == game)
								{
									v[v.length] = b;
									points += Badges.badgeData[b][6];
								}
							}
				}
				catch (e:Error)
				{
				}
			}
			return v;
		}
		
		internal function loadBadge(id:int):void
		{
			bid = id;
			clear();
			if (id != -1)
			{
				/*if(all.indexOf(id)==-1)*/
				all[all.length] = id;
				current = all.indexOf(id);
				var i:int = Badges.ids.indexOf(id), d:int, p:Number, v:Vector.<int>, dif:int = 1 + (DIFFICULTY.indexOf(Badges.badgeData[i][7]));
				for (d = 0, p = 0; d < dif; ++d, p += 27.5)
				{
					DIFF.graphics.beginFill(COLORS[d]);
					DIFF.graphics.drawRect(p, 0, 27.4, 20);
				}
				DIFF.filters = [BEVEL];
				//Tracer.t(this,"Loading badge "+Badges.badgeData[i][0],id);
				pic = getPic(Badges.badgeData[i][5]);
				TITLE.text = String(Badges.badgeData[i][0]);
				TITLE.x = 150 + ((stage.stageWidth - 150) * .5 - TITLE.width * .5);
				DES.text = Badges.badgeData[i][1] + ".";
				DES.y = PIC_Y;
				DES.x = PIC_X - 320;
				v = gameBadges(id);
				if (v.length)
					for (d = 0; d < v.length; ++d)
					{
						const P:DisplayObject = getThumb((200 + (d * 60)), 350, Badges.badgeData[v[d]][5]);
						pics[pics.length] = P;
						P.addEventListener(MouseEvent.CLICK, loadThumb);
						links[links.length] = Badges.badgeData[v[d]][8];
							//addChild(P);
					}
				if (user.all.indexOf(Badges.ids[i]) == -1) TO_EARN.text = "You can earn " + String(points + Badges.badgeData[i][6]) + " points from " + title + ".";
				else if (points) TO_EARN.text = "You can earn " + String(points) + " points from " + title + ".";
				else TO_EARN.text = "You already have all the badges for " + title + ".";
				PLAY.visible = true;
				url = Badges.badgeData[i][3];
				if (all.length)
				{
					PREV.visible = current != 0;
					NEXT.visible = current < all.length - 1;
				}
				else PREV.visible = NEXT.visible = false;
				bad = false;
			}
			else
			{
				bad = true;
				dispatchEvent(new E(E.BAD_BADGE));
			}
			badge = i;
			if (!bad) dispatchEvent(new E(E.UPDATE_TEXT));
			FAV.visible = Local.D.f.indexOf(id) == -1;
			REMOVE.visible = !FAV.visible;
			EXCLUDE.visible = Local.D.e.indexOf(id) == -1;
			RESTORE.visible = !EXCLUDE.visible;
			if (bad) RESTORE.visible = EXCLUDE.visible = FAV.visible = REMOVE.visible = PLAY.visible = false;
		}
		
		internal function draw():void
		{
			PLAY: visible = false;
			graphics.clear();
			graphics.lineStyle(2, Local.D.d[4]);
			graphics.drawRect(PIC_X - 1, PIC_Y - 1, 110, 110);
			graphics.drawRect(PIC_X - 1, PIC_Y + 129, 112, 22);
			graphics.moveTo(150, 30);
			graphics.lineTo(150, 420);
			var i:int;
			for (i = 0; i < BUTTONS.length; ++i) BUTTONS[i].draw();
			PREV.draw();
			NEXT.draw();
			PLAY.draw();
			DES.setFormat(35, Local.D.d[5]);
			TITLE.setFormat(45, Local.D.d[5]);
			TO_EARN.setFormat(30, Local.D.d[5]);
			FAV.draw();
			REMOVE.draw();
			EXCLUDE.draw();
			RESTORE.draw();
		}
	}
}