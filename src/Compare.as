package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class Compare extends Sprite
	{
		
		private var f:int = 0, u1:User, u2:User, totals:Vector.<int>, c1:Vector.<int>, c2:Vector.<int>, u:Vector.<User> = new <User>[], c:Vector.<Vector.<int>> = new <Vector.<int>>[];
		
		private const SPACE:String = "    ", GO:BaseButton = new BaseButton(265, 30, "Compare"), N1:InputName = new InputName(20, 32), N2:InputName = new InputName(420, 32), WIDTH:int = 150, SIZE:int = 25, BASE:int = 65, FILL:String = "linear", ALPHAS:Array = [1, 1], RATIOS:Array = [0x00, 0xFF], MATRIX:Matrix = new Matrix(), SPREAD:String = "reflect", FIELDS:Vector.<NovaField> = new <NovaField>[new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0)], NAMES:Vector.<String> = new <String>["Easy", "Medium", "Hard", "Impossible", "Action", "Multiplayer", "Shooter", "Adventure", "Sports", "Strategy", "Puzzle", "Music", "Unity", "All"];
		
		public function Compare():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			MATRIX.createGradientBox(100, 1, 225, 0, 0);
			addChild(N1);
			addChild(N2);
			var i:int = 0;
			for (; i < FIELDS.length; ++i)
			{
				addChild(FIELDS[i]);
				FIELDS[i].text = NAMES[i];
				FIELDS[i].setFormat(SIZE, Local.D.d[11]);
				FIELDS[i].x = stage.stageWidth * .5 - FIELDS[i].width * .5;
				FIELDS[i].y = BASE + (25 * i);
			}
			addChild(GO);
			GO.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				if (N1.text)
					if (N2.text)
					{
						compare(new User(N1.text), new User(N2.text));
						graphics.beginFill(0, 0);
						graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
						graphics.endFill();
					}
			});
		}
		
		/*DRAW GRAPHICS*/
		private function drawGraphics():void
		{
			if (u1)
				if (u2)
				{
					//Tracer.t(this,"Drawing graphics...");
					graphics.beginGradientFill(FILL, [Local.D.d[9], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
					var i:int = 0, l:int = c1.length;
					for (; i < l; ++i)
					{
						graphics.drawRect(10, BASE + (25 * i), ((totals[i] - c1[i]) * WIDTH) / totals[i], 20);
						graphics.drawRect(stage.stageWidth - 10, BASE + (25 * i), -(((totals[i] - c2[i]) * WIDTH) / totals[i]), 20);
						FIELDS[i].text = (totals[i] - c1[i]).toString() + "/" + totals[i].toString() + "(" + (Math.floor(((totals[i] - c1[i]) * 100) / totals[i])).toString() + "%)" + SPACE + NAMES[i] + SPACE + (totals[i] - c2[i]).toString() + "/" + totals[i].toString() + "(" + (Math.floor(((totals[i] - c2[i]) * 100) / totals[i])).toString() + "%)";
						FIELDS[i].x = stage.stageWidth * .5 - FIELDS[i].width * .5;
					}
					graphics.endFill();
				}
		}
		
		/*COMPARE*/
		private function compare(U1:User, U2:User):void
		{
			dispatchEvent(new E(E.COMPARE));
			u1 = U1;
			u2 = U2;
			addEventListener(Event.ENTER_FRAME, json);
			f = 0;
			//Tracer.t(this,"comparing badges for",N1.text,"&",N2.text);
		}
		
		/*CHECK JSON*/
		private function json(e:Event):void
		{
			if (f < 300)
			{
				if (u1.unity)
					if (u2.unity)
					{
						buildBadges();
						u[0] = u1;
						u[1] = u2;
						c[0] = c1;
						c[1] = c2;
						removeEventListener(Event.ENTER_FRAME, json);
						graphics.clear();
						drawGraphics();
					}
				++f;
			}
			else if (f == 300)
			{
				dispatchEvent(new E(E.TIMEOUT));
				graphics.clear();
				removeEventListener(Event.ENTER_FRAME, json);
			}
		}
		
		/*GET BADGES*/
		private function buildBadges():void
		{
			c1 = new <int>[u1.easy.length, u1.medium.length, u1.hard.length, u1.impossible.length, u1.action.length, u1.multiplayer.length, u1.shooter.length, u1.adventure.length, u1.sports.length, u1.defense.length, u1.puzzle.length, u1.music.length, u1.unity.length, u1.unearned.length];
			c2 = new <int>[u2.easy.length, u2.medium.length, u2.hard.length, u2.impossible.length, u2.action.length, u2.multiplayer.length, u2.shooter.length, u2.adventure.length, u2.sports.length, u2.defense.length, u2.puzzle.length, u2.music.length, u2.unity.length, u2.unearned.length];
		}
		
		/*DRAW*/
		internal function draw():void
		{
			var i:int = 0;
			for (; i < FIELDS.length; ++i) FIELDS[i].setFormat(SIZE, Local.D.d[11]);
			GO.draw();
			drawGraphics();
		}
		
		/*GET NAMES*/
		internal function getNames():String
		{
			return (N1.text + " & " + N2.text);
		}
		
		/*GET TOTALS*/
		internal function getTotals():void
		{
			totals = new <int>[Badges.easy.length, Badges.medium.length, Badges.hard.length, Badges.impossible.length, Badges.action.length, Badges.multiplayer.length, Badges.shooter.length, Badges.adventure.length, Badges.sports.length, Badges.defense.length, Badges.puzzle.length, Badges.music.length, Badges.unity.length, Badges.ids.length];
		}
	
	}
}