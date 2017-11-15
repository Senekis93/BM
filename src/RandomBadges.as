package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class RandomBadges extends Sprite
	{
		private const TOTAL_EXLUDED:int = 7, FILL:String = "linear", ALPHAS:Array = [1, 1], RATIOS:Array = [0x00, 0xFF], MATRIX:Matrix = new Matrix(), SPREAD:String = "reflect", SIZE:int = 540, X:int = 50, Y:int = 290, TITLES:Vector.<String> = new <String>["Badge Avoider", "Badgeophage", "Casual Badger", "Midnight Gamer", "Emblem Gatherer", "Achievement Lover", "Badge Hoarder", "Royal Hunter", "Badge Kaiser", "Elite Collector", "Badge Master"], TIT:NovaField = new NovaField(30, 0), PER:NovaField = new NovaField(30, 0), 
		//
		TITLE:Div = new Div(40, "Get an unearned badge"), ANY:BaseButton = new BaseButton(10, 100, "Any"), EASY:BaseButton = new BaseButton(140, 100, "Easy"), MEDIUM:BaseButton = new BaseButton(270, 100, "Medium"), HARD:BaseButton = new BaseButton(400, 100, "Hard"), IMPOSSIBLE:BaseButton = new BaseButton(530, 100, "Impossible"), ACTION:BaseButton = new BaseButton(10, 170, "Action"), MULTI:BaseButton = new BaseButton(140, 170, "Multiplayer"), SHOOTER:BaseButton = new BaseButton(270, 170, "Shooter"), DEFENSE:BaseButton = new BaseButton(400, 170, "Strategy"), PUZZLE:BaseButton = new BaseButton(530, 170, "Puzzle"), ADVENTURE:BaseButton = new BaseButton(10, 240, "Adventure"), SPORTS:BaseButton = new BaseButton(140, 240, "Sports"), MUSIC:BaseButton = new BaseButton(270, 240, "Music/?"), UNITY:BaseButton = new BaseButton(400, 240, "Unity"), 
		//NEWEST:BaseButton=new BaseButton(270,240,"Newest"),
		//OLDEST:BaseButton=new BaseButton(400,240,"Oldest"),
		FAVORITE:BaseButton = new BaseButton(530, 240, "Favorite"), BUTTONS:Vector.<BaseButton> = new <BaseButton>[EASY, MEDIUM, HARD, IMPOSSIBLE, ANY, ACTION, MULTI, SHOOTER, DEFENSE, PUZZLE, ADVENTURE, SPORTS, MUSIC, UNITY,//NEWEST,OLDEST,
		FAVORITE], EVENTS:Vector.<String> = new <String>[E.LOAD_EASY, E.LOAD_MEDIUM, E.LOAD_HARD, E.LOAD_IMPOSSIBLE, E.LOAD_ANY, E.LOAD_ACTION, E.LOAD_MULTI, E.LOAD_SHOOTER, E.LOAD_DEFENSE, E.LOAD_PUZZLE, E.LOAD_ADVENTURE, E.LOAD_SPORTS, E.LOAD_MUSIC, E.LOAD_UNITY,/*E.LOAD_NEW,E.LOAD_OLD,*/ E.LOAD_FAVORITE];
		
		public var user:User;
		
		public function RandomBadges():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
			MATRIX.createGradientBox(100, 1, 225, 0, 0);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			addChild(TITLE);
			addChild(TIT);
			addChild(PER);
			var i:int;
			for (i = 0; i < BUTTONS.length; ++i)
			{
				BUTTONS[i].addEventListener(MouseEvent.CLICK, E.createListenerProxy(this, EVENTS[i]));
				addChild(BUTTONS[i]);
			}
		}
		
		/*DRAW*/
		internal function draw():void
		{
			var i:int;
			for (i = 0; i < BUTTONS.length; ++i) BUTTONS[i].draw();
			TITLE.draw();
			graphics.clear();
			var p:Number = (int((((((Badges.ids.length - TOTAL_EXLUDED) - user.unearned.length) * 100) / (Badges.ids.length - TOTAL_EXLUDED))))) * 0.01;
			graphics.beginFill(0, 0);
			graphics.lineStyle(3);
			graphics.lineGradientStyle("linear", [Local.D.d[9], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
			graphics.drawRect(X, Y, SIZE, 50);
			graphics.beginGradientFill(FILL, [Local.D.d[9], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
			graphics.drawRect(X, Y, SIZE * p, 50);
			var l:int = SIZE * .1;
			for (i = 0; i < 11; ++i)
			{
				graphics.moveTo(X + (l * i), Y + 50);
				graphics.lineTo(X + (l * i), Y + 65);
			}
			graphics.endFill();
			TIT.setFormat(30, Local.D.d[11]);
			TIT.y = Y + 90;
			var t:int = int(p * 10);
			trace(p, t);
			if (t < 0) t = 0;
			TIT.text = "Your title: " + TITLES[t];
			TIT.x = stage.stageWidth * .5 - TIT.width * .5;
			PER.setFormat(23, Local.D.d[11]);
			PER.y = Y + 60;
			PER.text = "0%      10%      20%     30%      40%     50%      60%     70%     80%      90%     100%";
			PER.x = X - 10;
		}
	
	}
}