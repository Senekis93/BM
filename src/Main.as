package
{
	import flash.events.Event;
	import flash.events.ContextMenuEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import calista.util.LZW;
	import com.foxarc.images.BitmapEncoder;
	
	public class Main extends Sprite
	{
		
		private var levelbug:Loader, loadedAPI:Boolean, tempArray:Array, tempString:String = "", checkInit:int = 1, currentUser:User, oldUser:User, t:int, l:Loader, lc:LoaderContext, crashed:Boolean;
		
		private const BM:NovaField = new NovaField(0, 0), S:NovaField = new NovaField(0, 0), PATCH:String = "p" + Local.PATCH.toString(), VERSION:String = "3.11 " + PATCH + " Final Release", G_VERSION:String = "18-11-2012", 
		//KONG:API=new API(),
		LOGO:KongLogo = new KongLogo(-140, -50, 3), BACKGROUND:Background = new Background(), GRAPHICS:Sprite = new Sprite(), 
		//text
		MAIN_T:String = "Current version: " + VERSION + "       Last sorted by genre: " + G_VERSION, STATS_T:String = "Here are your badge stats. Click the SAVE button to save a copy to your computer!", SKIN_T:String = "Customize your colors. Click the arrow to see the customizable items. Select a color and click APPLY to save your changes. Use SAVE and LOAD buttons to save/load the skin settings. Click SHARE to share your skin with Kongregate!", COMPARE_T:String = "Type two valid Kongregate usernames and click COMPARE.", SEARCH_T:String = "Type the word or phrase that you want to search. You can search multiple words or phrases by separating them with a comma (,). You can use an asterisk (*) as a wildcard.", BROWSER_T:String = "Click the arrows to filter your badges by status, difficulty and genre.", ABOUT_T:String = "Click the BUG button to report a bug. There's a higher chance that it'll be fixed if you report it that way instead of posting a comment or using Kong's \"report a bug\" option.", TEXT_SPEED:int = 3, SPACE:String = "                         ", STATUS:NovaField = new NovaField(), COPY:NovaField = new NovaField(1), SCREEN_TEXT:Vector.<String> = new <String>[MAIN_T, "", STATS_T, SKIN_T, COMPARE_T, SEARCH_T, BROWSER_T, ABOUT_T], 
		//screens
		MAIN:RandomBadges = new RandomBadges(), LOADER:BadgeLoader = new BadgeLoader(), STATS:Stats = new Stats(), COLORS:Colors = new Colors(), COMPARE:Compare = new Compare(), SEARCH:Search = new Search(), BROWSER:Browser = new Browser(), ABOUT:About = new About(), SCREENS:Vector.<Sprite> = new <Sprite>[MAIN, LOADER, STATS, COLORS, COMPARE, SEARCH, BROWSER, ABOUT], 
		//main
		MAIN_B:NavButton = new NavButton(5, 424, "Main"), STATS_B:NavButton = new NavButton(105, 424, "Stats"), SKIN_B:NavButton = new NavButton(205, 424, "Skin"), COMPARE_B:NavButton = new NavButton(305, 424, "Compare"), REFRESH_B:NavButton = new NavButton(305, 450, "Reload"), SEARCH_B:NavButton = new NavButton(105, 450, "Search"), BROWSER_B:NavButton = new NavButton(5, 450, "Browse"), ABOUT_B:NavButton = new NavButton(205, 450, "About"), MAIN_LISTENERS:Vector.<String> = new <String>[E.LOAD_EASY, E.LOAD_MEDIUM, E.LOAD_HARD, E.LOAD_IMPOSSIBLE, E.LOAD_ANY, E.LOAD_ACTION, E.LOAD_MULTI, E.LOAD_SHOOTER, E.LOAD_DEFENSE, E.LOAD_PUZZLE, E.LOAD_MUSIC, E.LOAD_UNITY, E.LOAD_NEW, E.LOAD_OLD, E.LOAD_FAVORITE, E.LOAD_SPORTS, E.LOAD_ADVENTURE], MAIN_FUNCTIONS:Vector.<Function> = new <Function>[loadEasy, loadMedium, loadHard, loadImpossible, loadAny, loadAction, loadMulti, loadShooter, loadDefense, loadPuzzle, loadMusic, loadUnity, loadNew, loadOld, loadFav, loadSport, loadAdventure], BUTTONS:Vector.<NavButton> = new <NavButton>[MAIN_B, STATS_B, SKIN_B, COMPARE_B, SEARCH_B, BROWSER_B, ABOUT_B], BUTTON_FUNCTIONS:Vector.<int> = new <int>[0, 2, 3, 4, 5, 6, 7], CHANGE:InputName = new InputName(410, 432), CHANGE_BUTTON:Arrow = new Arrow(1, 625, 445, 0.5), 
		//
		UPLOADER:PicUploader = new PicUploader();
		
		public function Main():void
		{
			checkSO();
			customMenu();
			if (stage) go();
			else addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		/*CUSTOM MENU*/
		private function customMenu():void
		{
			var m:ContextMenu = new ContextMenu(), r:ContextMenuItem = new ContextMenuItem("Click to restore default skin and colors.");
			m.hideBuiltInItems();
			m.customItems = [r];
			r.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, restoreSkin);
			r.separatorBefore = true;
			contextMenu = m;
		}
		
		/*RSTORE SKIN*/
		private function restoreSkin(e:ContextMenuEvent):void
		{
			Local.clearSkin();
			redraw();
		}
		
		/*MOVE TEXT*/
		private function moveText():void
		{
			if (STATUS.x - TEXT_SPEED <= -STATUS.width) STATUS.x = 10000;
			else if (COPY.x - TEXT_SPEED <= -COPY.width) COPY.x = 10000;
			if (STATUS.x < COPY.x)
			{
				STATUS.x -= TEXT_SPEED;
				COPY.x = STATUS.x + STATUS.width;
			}
			else
			{
				COPY.x -= TEXT_SPEED;
				STATUS.x = COPY.x + COPY.width;
			}
		}
		
		/*LOADED SKIN*/
		private function onLoaded(p:Object):void
		{
			//Tracer.t(this,"Load called");
			var s:String = p.content.toString();
			tempArray = s.split(":");
			if (tempArray[0] != "hello,world")
			{
				//Tracer.t(this,"Pic found");
				var url:String = "http://senekis.net/pics/badge_master/uploads/" + tempArray[0] + ".jpg";
				lc = new LoaderContext();
				lc.checkPolicyFile = true;
				l = new Loader();
				l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError), l.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedPic);
				try
				{
					var pic:URLRequest = new URLRequest(url);
					l.load(pic, lc);
						//Tracer.t(this,"Pic load started..:"+url);
						//navigateToURL(new URLRequest(url));
				}
				catch (e:Error)
				{
					l.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedPic);
					l.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError)
					updateText(e.message);
				}
			}
			else
			{
				//Tracer.t(this,"No pic..");
				Local.D.d[0] = "hello,world";
				var i:int, end:int = Local.D.d.length;
				for (i = 1; i < end; ++i) Local.D.d[i] = tempArray[i];
				for (i = 1; i < end; ++i) Local.D.d[i] = parseInt(Local.D.d[i]);
				Local.update(12, 0);
				redraw();
			}
			//Tracer.t(this,"End of load");
		}
		
		/*LOAD ERROR*/
		private function loadError(e:Event):void
		{
			l.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedPic);
			l.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			updateText("Image couldn't be loaded from the server. Files which are't accessed in more than 30 days are automatically deleted.");
		}
		
		/*PIC LOADED*/
		private function loadedPic(e:Event):void
		{
			l.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadedPic);
			l.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
			var s:String = tempArray[0], r:URLRequest = new URLRequest("http://senekis.net/pics/badge_master/update.php"), v:URLVariables = new URLVariables();
			r.method = URLRequestMethod.POST;
			v.value = s;
			r.data = v;
			sendToURL(r);
			var bd:BitmapData = new BitmapData(l.width, l.height, true, 0);
			bd.draw(l);
			Local.update(0, BitmapEncoder.encodeBase64(bd));
			var i:int, end:int = Local.D.d.length;
			for (i = 1; i < end; ++i) Local.update(i, parseInt(tempArray[i]));
			redraw();
			//Tracer.t(this,"Loaded and saved.");
		}
		
		/*SHARE SKIN*/
		private function shareSkin(e:E):void
		{
			var s:String = Local.D.d.join(":");
			tempString = s.substring(s.indexOf(":") + 1, s.length);
			var url:String = "", good:Boolean;
			if (Local.D.d[0] != "hello,world")
			{
				if (Local.D.d[0].length > 100)
				{
					if (Local.D.d[12] == 1)
					{
						good = true;
						try
						{
							var bd:BitmapData = BitmapEncoder.decodeBase64(Local.D.d[0]);
							UPLOADER.upload(bd);
						}
						catch (e:Error)
						{
							updateText("Error, file may be corrupted or server may be down.");
						}
					}
				}
			}
			if (!good)
			{
				var ss:String = "";
				ss = "hello,world:" + tempString;
				QuickKong.sharedContent.save("Skin", ss, onSave, this, "My BM colors.");
			}
		}
		
		/*UPLOADED*/
		private function uploaded(e:Event):void
		{
			var s:String = "";
			s = UPLOADER.getCode() + ":" + tempString;
			//Tracer.t(this,s);
			QuickKong.sharedContent.save("Skin", s, onSave, this, "My BM colors.");
			//navigateToURL(new URLRequest("http://senekis.net/pics/ss/kong_avatar_uploads/uploads/"+UPLOADER.getCode()+".jpg"));
		}
		
		/*ON SAVE*/
		private function onSave(p:Object):void
		{
			//Tracer.t(this,"shared");	
		}
		
		/*CHECK BADGES*/
		private function checkbadges():void
		{
			if (checkInit == 1)
			{
				if (Badges.unity.length)
				{
					updateText("Loading user information for " + QuickKong.getUser() + ". This shouldn't take longer than 10 seconds.");
					getUser(QuickKong.getUser());
					if (loadedAPI) checkInit = 2;
				}
			}
			else if (checkInit == 2)
			{
				if (currentUser.finalUnity)
				{
					submit();
					buildGUI();
					checkInit = 0;
				}
			}
		}
		
		/*RELOAD USER*/
		private function reload(e:MouseEvent):void
		{
			addEventListener(Event.ENTER_FRAME, changeEF);
			t = 0;
			updateText("Loading user information... this shouldn't take longer than 10 seconds.");
			getUser(currentUser.user);
			CHANGE_BUTTON.removeEventListener(MouseEvent.CLICK, change);
			REFRESH_B.removeEventListener(MouseEvent.CLICK, reload);
		}
		
		/*CHANGE USER*/
		private function change(E:MouseEvent):void
		{
			if (CHANGE.text)
			{
				oldUser = currentUser;
				addEventListener(Event.ENTER_FRAME, changeEF);
				t = 0;
				updateText("Loading user information... this shouldn't take longer than 10 seconds.");
				getUser(CHANGE.text);
				CHANGE_BUTTON.removeEventListener(MouseEvent.CLICK, change);
				REFRESH_B.removeEventListener(MouseEvent.CLICK, reload);
			}
			else updateText("Type the username first!");
		}
		
		/*CHANGE ENTER FRAME*/
		private function changeEF(e:Event):void
		{
			if (t < 300)
			{
				if (currentUser.finalUnity)
				{
					passUser(currentUser);
					//setScreen(0);
					redraw();
					draw();
					removeEventListener(Event.ENTER_FRAME, changeEF);
					CHANGE_BUTTON.addEventListener(MouseEvent.CLICK, change);
					REFRESH_B.addEventListener(MouseEvent.CLICK, reload);
					updateText("User " + currentUser.user + " loaded");
				}
				++t;
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, changeEF);
				CHANGE_BUTTON.addEventListener(MouseEvent.CLICK, change);
				REFRESH_B.addEventListener(MouseEvent.CLICK, reload);
				updateText("Error: Timeout. Make sure that you typed a valid username");
				currentUser = oldUser;
				CHANGE.text = currentUser.user;
			}
		}
		
		/*GET USER*/
		private function getUser(username:String):void
		{
			currentUser = new User(username);
			CHANGE.text = currentUser.user;
		}
		
		/*FRAME*/
		private function eF(e:Event):void
		{
			moveText();
			if (Badges.error) crash();
			if (checkInit) checkbadges();
		}
		
		/*CRASH*/
		private function crash():void
		{
			if (crashed) return;
			crashed = true;
			updateText("Error retrieving badges.json from Kongregate");
			//removeEventListener(Event.ENTER_FRAME,eF);
			LOGO.errorMessage();
			removeChild(S);
			BM.setFormat(30, 0xD03939);
			BM.text = "The badjes.json file from Kongregate\nseems to be broken or missing.\n\nThis is an issue on Kongregate's side\n and there's nothing I can do to fix it.\n\nPlease give them some days to check\nand fix it. Badge Master should be\nworking again soon. ^^\n\nSorry for the inconveniences and thank\nyou for the bug reports.\n\n- Senekis";
			BM.x = stage.stageWidth * .5 - BM.width * .5;
			BM.y = 90;
		}
		
		/*BUILD GUI*/
		private function buildGUI():void
		{
			//Tracer.t(this,"Building GUI...");
			removeChild(LOGO);
			removeChild(BM);
			removeChild(S);
			addChild(BACKGROUND);
			var i:int;
			for (i = 0; i < SCREENS.length; ++i) addChild(SCREENS[i]);
			for (i = 0; i < MAIN_LISTENERS.length; ++i) MAIN.addEventListener(MAIN_LISTENERS[i], MAIN_FUNCTIONS[i]);
			for (i = 0; i < MAIN_LISTENERS.length; ++i) LOADER.addEventListener(MAIN_LISTENERS[i], MAIN_FUNCTIONS[i]);
			for (i = 0; i < BUTTONS.length; ++i)
			{
				addChild(BUTTONS[i]);
				if (!BUTTONS[i].hasEventListener(MouseEvent.CLICK)) BUTTONS[i].addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					setScreen(BUTTON_FUNCTIONS[BUTTONS.indexOf(e.currentTarget)]);
				});
			}
			LOADER.addEventListener(E.UPDATE_TEXT, function(e:E):void
			{
				badgeUsers(LOADER.badge);
			});
			LOADER.addEventListener(E.BAD_BADGE, function(e:E):void
			{
				updateText("There are no badges of this type");
			});
			UPLOADER.addEventListener(Event.COMPLETE, uploaded);
			COLORS.addEventListener(E.COLORS, redraw);
			COLORS.addEventListener(E.BACKGROUND_ERROR, bgError);
			COLORS.addEventListener(E.BACKGROUND, bg);
			COLORS.addEventListener(E.SHARE_SKIN, shareSkin);
			COMPARE.addEventListener(E.TIMEOUT, timeout);
			COMPARE.addEventListener(E.COMPARE, compare);
			SEARCH.addEventListener(E.BAD_SEARCH, badSearch);
			SEARCH.addEventListener(E.LOAD_SEARCH, loadSearch);
			BROWSER.addEventListener(E.LOAD_BROWSE, loadBrowse);
			passUser(currentUser);
			setScreen(0);
			redraw();
			addChild(REFRESH_B);
			REFRESH_B.draw();
			REFRESH_B.addEventListener(MouseEvent.CLICK, reload);
			addChild(CHANGE);
			addChild(CHANGE_BUTTON);
			CHANGE_BUTTON.addEventListener(MouseEvent.CLICK, change);
			addChild(GRAPHICS);
			draw();
		}
		
		/*PASS USER*/
		private function passUser(u:User):void
		{
			MAIN.user = BROWSER.user = LOADER.user = STATS.user = SEARCH.user = u;
			STATS.getTotals();
			COMPARE.getTotals();
		}
		
		/*SET SCREEN*/
		private function setScreen(s:int):void
		{
			updateText(SCREEN_TEXT[s]);
			var i:int = 0;
			for (; i < SCREENS.length; ++i)
			{
				if (i != s) SCREENS[i].visible = false;
				else SCREENS[i].visible = true;
			}
		}
		
		/*DISPLAY BADGE COUNT*/
		private function badgeUsers(i:int):void
		{
			updateText(Badges.badgeData[i][2] + " players have earned the \"" + Badges.badgeData[i][0] + "\" badge and " + Badges.badgeData[i][6] + " points!");
		}
		
		// -------------------- LOAD BADGES -------------------------
		/*LOAD EASY*/
		private function loadEasy(e:E):void
		{
			setScreen(1);
			if (currentUser.finalEasy.length)
			{
				var ran:int = int(Math.random() * currentUser.finalEasy.length);
				var i:int = Badges.ids.indexOf(currentUser.finalEasy[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalEasy[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD MEDIUM*/
		private function loadMedium(e:E):void
		{
			setScreen(1);
			if (currentUser.finalMedium.length)
			{
				var ran:int = int(Math.random() * currentUser.finalMedium.length);
				var i:int = Badges.ids.indexOf(currentUser.finalMedium[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalMedium[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD HARD*/
		private function loadHard(e:E):void
		{
			setScreen(1);
			if (currentUser.finalHard.length)
			{
				var ran:int = int(Math.random() * currentUser.finalHard.length);
				var i:int = Badges.ids.indexOf(currentUser.finalHard[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalHard[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD IMPOSSIBLE*/
		private function loadImpossible(e:E):void
		{
			setScreen(1);
			if (currentUser.finalImpossible.length)
			{
				var ran:int = int(Math.random() * currentUser.finalImpossible.length);
				var i:int = Badges.ids.indexOf(currentUser.finalImpossible[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalImpossible[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD ANY*/
		private function loadAny(e:E):void
		{
			setScreen(1);
			if (currentUser.finalUnearned.length)
			{
				var ran:int = int(Math.random() * currentUser.finalUnearned.length);
				var i:int = Badges.ids.indexOf(currentUser.finalUnearned[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalUnearned[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD ACTION*/
		private function loadAction(e:E):void
		{
			setScreen(1);
			if (currentUser.finalAction.length)
			{
				var ran:int = int(Math.random() * currentUser.finalAction.length);
				var i:int = Badges.ids.indexOf(currentUser.finalAction[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalAction[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD DEFENSE*/
		private function loadDefense(e:E):void
		{
			setScreen(1);
			if (currentUser.finalDefense.length)
			{
				var ran:int = int(Math.random() * currentUser.finalDefense.length);
				var i:int = Badges.ids.indexOf(currentUser.finalDefense[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalDefense[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD MULTI*/
		private function loadMulti(e:E):void
		{
			setScreen(1);
			if (currentUser.finalMultiplayer.length)
			{
				var ran:int = int(Math.random() * currentUser.finalMultiplayer.length);
				var i:int = Badges.ids.indexOf(currentUser.finalMultiplayer[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalMultiplayer[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD SHOOTER*/
		private function loadShooter(e:E):void
		{
			setScreen(1);
			if (currentUser.finalShooter.length)
			{
				var ran:int = int(Math.random() * currentUser.finalShooter.length);
				var i:int = Badges.ids.indexOf(currentUser.finalShooter[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalShooter[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD PUZZLE*/
		private function loadPuzzle(e:E):void
		{
			setScreen(1);
			if (currentUser.finalPuzzle.length)
			{
				var ran:int = int(Math.random() * currentUser.finalPuzzle.length);
				var i:int = Badges.ids.indexOf(currentUser.finalPuzzle[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalPuzzle[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD SPORTS*/
		private function loadSport(e:E):void
		{
			setScreen(1);
			if (currentUser.finalSports.length)
			{
				var ran:int = int(Math.random() * currentUser.finalSports.length);
				var i:int = Badges.ids.indexOf(currentUser.finalSports[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalSports[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD ADVENTURE*/
		private function loadAdventure(e:E):void
		{
			setScreen(1);
			if (currentUser.finalAdventure.length)
			{
				var ran:int = int(Math.random() * currentUser.finalAdventure.length);
				var i:int = Badges.ids.indexOf(currentUser.finalAdventure[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalAdventure[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD MUSIC*/
		private function loadMusic(e:E):void
		{
			setScreen(1);
			if (currentUser.finalMusic.length)
			{
				var ran:int = int(Math.random() * currentUser.finalMusic.length);
				var i:int = Badges.ids.indexOf(currentUser.finalMusic[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalMusic[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD UNITY*/
		private function loadUnity(e:E):void
		{
			setScreen(1);
			if (currentUser.finalUnity.length)
			{
				var ran:int = int(Math.random() * currentUser.finalUnity.length);
				var i:int = Badges.ids.indexOf(currentUser.finalUnity[ran]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalUnity[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD NEW*/
		private function loadNew(e:E):void
		{
			setScreen(1);
			if (currentUser.finalUnearned.length)
			{
				var i:int = Badges.ids.indexOf(currentUser.finalUnearned[currentUser.finalUnearned.length - 1]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalUnearned[currentUser.finalUnearned.length - 1]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD OLD*/
		private function loadOld(e:E):void
		{
			setScreen(1);
			if (currentUser.finalUnearned.length)
			{
				var i:int = Badges.ids.indexOf(currentUser.finalUnearned[0]);
				badgeUsers(i);
				LOADER.loadBadge(currentUser.finalUnearned[0]);
			}
			else LOADER.loadBadge(-1);
		}
		
		/*LOAD FAVORITE*/
		private function loadFav(e:E):void
		{
			setScreen(1);
			if (Local.D.f.length)
			{
				var ran:int = int(Math.random() * Local.D.f.length);
				var i:int = Badges.ids.indexOf(Local.D.f[ran]);
				badgeUsers(i);
				LOADER.loadBadge(Local.D.f[ran]);
			}
			else LOADER.loadBadge(-1);
		}
		
		// --------------------------------------------------------------
		
		/*CHECK SO*/
		private function checkSO():void
		{
			if (Local.checkNew()) Local.create();
			if (Local.noPatch())
			{
				Local.patch();
				updateText("Your file has been updated with patch " + Local.PATCH.toString() + ". Changes in this version: " + Local.NOTICE);
			}
		}
		
		/*ADD SCROLL*/
		private function addScroll():void
		{
			addChild(STATUS);
			addChild(COPY);
			STATUS.setFormat(30, Local.D.d[1]);
			COPY.setFormat(30, Local.D.d[1]);
		}
		
		/*DRAW*/
		private function draw():void
		{
			GRAPHICS.graphics.clear();
			GRAPHICS.graphics.lineStyle(3, Local.D.d[4]);
			GRAPHICS.graphics.moveTo(0, STATUS.height);
			GRAPHICS.graphics.lineTo(stage.stageWidth, STATUS.height);
			GRAPHICS.graphics.moveTo(0, 420);
			GRAPHICS.graphics.lineTo(stage.stageWidth, 420);
			CHANGE_BUTTON.draw();
		}
		
		/*COMPARE TIMEOUT*/
		private function timeout(e:E):void
		{
			updateText("Error: Timeout. Comparing process took too long and was aborted. Try again and make sure that both names are valid Kongregate accounts.");
		}
		
		/*COMPARING*/
		private function compare(e:E):void
		{
			updateText("Comparing badges for " + COMPARE.getNames());
		}
		
		/*BAD SEARCH*/
		private function badSearch(e:E):void
		{
			updateText("No matching badges found for " + SEARCH.getText());
		}
		
		/*LOAD FROM SEARCH*/
		private function loadSearch(e:E):void
		{
			setScreen(1);
			LOADER.loadBadge(SEARCH.badge);
			badgeUsers(SEARCH.badge2);
		}
		
		/*LOAD FROM BROWSER*/
		private function loadBrowse(e:E):void
		{
			setScreen(1);
			LOADER.loadBadge(BROWSER.badge);
			badgeUsers(BROWSER.badge);
		}
		
		/*UPDATE COLORS*/
		private function redraw(e:E = null):void
		{
			draw();
			BACKGROUND.draw();
			SEARCH.draw();
			REFRESH_B.draw();
			LOADER.draw();
			MAIN.draw();
			STATS.draw();
			COLORS.draw();
			COMPARE.draw();
			BROWSER.draw();
			ABOUT.draw();
			var i:int;
			for (i = 0; i < BUTTONS.length; ++i) BUTTONS[i].draw();
			STATUS.setFormat(30, Local.D.d[1]);
			COPY.setFormat(30, Local.D.d[1]);
			addScroll();
		}
		
		/*BACKGROUND ERROR*/
		private function bgError(e:E):void
		{
			updateText("Error while reading the file. Image may be corrupted");
		}
		
		/*BACKGROUND*/
		private function bg(e:E):void
		{
			updateText("Background changed.");
		}
		
		/*ADDED TO STAGE*/
		private function go(e:Event = null):void
		{
			QuickKong.connectToKong(stage, function():void
			{
				QuickKong.api.sharedContent.addLoadListener("Skin", onLoaded);
				loadedAPI = true;
				//Tracer.t(this,"API connected");
			});
			addChild(LOGO);
			addChild(BM);
			addChild(S);
			BM.setFormat(70, 0xD03939);
			BM.text = "BADGE MASTER";
			BM.x = stage.stageWidth * .5 - BM.width * .5;
			BM.y = 120;
			S.setFormat(30, 0xD03939);
			S.text = "By Senekis.";
			S.x = stage.stageWidth * .5 - S.width * .5;
			S.y = 380;
			/*try{Badges.getJSON();}
			   catch(e:Error){updateText(String(e));}*/
			Badges.getJSON();
			removeEventListener(Event.ADDED_TO_STAGE, go);
			addScroll();
			if (SiteLock.good(stage.loaderInfo.url))
			{
				updateText("Processing over " + Badges.TOTAL.toString() + " badges. Refresh if this takes longer than 10 seconds.");
				addEventListener(Event.ENTER_FRAME, eF);
			}
			else
			{
				updateText("Processing over " + Badges.TOTAL.toString() + " badges. Refresh if this takes longer than 10 seconds.");
				addEventListener(Event.ENTER_FRAME, eF);
				return; 
				//fuck sitelocks.
				
				stage.addEventListener(MouseEvent.CLICK, siteLock);
				addEventListener(Event.ENTER_FRAME, function(e:Event):void
				{
					moveText();
				});
				updateText("This application was stolen. Click anywhere to play the original version.");
			}
		}
		
		/*SITELOCK*/
		private function siteLock(e:MouseEvent):void
		{
			navigateToURL(new URLRequest("http://www.kongregate.com/games/Senekis93/badge-master"), "_self");
			navigateToURL(new URLRequest("http://www.senekis.net"), "_blank");
		}
		
		/*UPDATE TEXT*/
		private function updateText(t:String):void
		{
			STATUS.text = COPY.text = SPACE + t + SPACE;
		}
		
		/*BADGE LEVEL*/
		private function badgeLevel():int
		{
			var v:int = currentUser.points, m1:int = 65, e:Vector.<int> = new <int>[0], a:int = 50, r:int, d:Number, i:int, l:int = m1 + 1;
			while (++i < l)
			{
				e[i] = e[i - 1] + a;
				if (i < 34) a += i < 29 ? 10 : 20;
				else if (i < 49)
				{
					d = ((i + 2) - 35) * .2;
					a += 20 + (5 * (Math.ceil(d)));
				}
				else
				{
					d = ((i + 2) - 50) * .2;
					a += 35 + (10 * (Math.ceil(d)));
				}
			}
			while (v >= e[r]) ++r;
			return r > m1 ? m1 : r;
		}
		
		/*SUMBIT*/
		private function submit():void
		{
			QuickKong.submit("Points", currentUser.points);
			QuickKong.submit("Badges", currentUser.all.length);
			QuickKong.submit("Easy", Badges.easy.length - currentUser.easy.length);
			QuickKong.submit("Medium", Badges.medium.length - currentUser.medium.length);
			QuickKong.submit("Hard", Badges.hard.length - currentUser.hard.length);
			QuickKong.submit("Impossible", Badges.impossible.length - currentUser.impossible.length);
			QuickKong.submit("Badge_Level", badgeLevel());
		}
	
	}
}