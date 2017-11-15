package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.filters.DropShadowFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import com.adobe.images.PNGEncoder;
	
	public class Stats extends Sprite
	{
		
		private var current:Vector.<int>, totals:Vector.<int>;
		
		private const SAVE:BaseButton = new BaseButton(560, 220, "    Save"), C1:Sprite = new Sprite(), SHADOW:DropShadowFilter = new DropShadowFilter(10, 45, 0, 1, 2, 2, 2, 3, false), FILL:String = "linear", ALPHAS:Array = [1, 1], RATIOS:Array = [0x00, 0xFF], MATRIX:Matrix = new Matrix(), SPREAD:String = "reflect", WIDTH:int = 50, HEIGHT:int = 130, BASE:int = 200, BASE2:int = BASE + 190, SIZE:int = 22, CIRT:NovaField = new NovaField(SIZE, 0), FIELDS:Vector.<NovaField> = new <NovaField>[new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0)], FIELDS2:Vector.<NovaField> = new <NovaField>[new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0), new NovaField(SIZE, 0)], NAMES:Vector.<String> = new <String>["Easy", "Medium", "Hard", "Impossible", "Action", "Multiplayer", "Shooter", "Adventure", "Sports", "Strategy", "Puzzle", "Music", "Unity", "All"];
		
		public var user:User;
		
		public function Stats():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			addChild(C1);
			addChild(SAVE);
			SAVE.scaleX = 0.7;
			removeEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		/*GET HEIGHT*/
		private function getHeight(total:int, cur:int):Number
		{
			return ((total - cur) / total) * HEIGHT;
		}
		
		/*DRAW*/
		internal function draw():void
		{
			var i:int;
			current = new <int>[user.easy.length, user.medium.length, user.hard.length, user.impossible.length, user.action.length, user.multiplayer.length, user.shooter.length, user.adventure.length, user.sports.length, user.defense.length, user.puzzle.length, user.music.length, user.unity.length, user.unearned.length];
			C1.graphics.clear();
			C1.graphics.beginFill(Local.D.d[6]);
			C1.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			C1.graphics.endFill();
			MATRIX.createGradientBox(100, 1, 225, 0, 0);
			C1.graphics.beginGradientFill(FILL, [Local.D.d[9], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
			for (i = 0; i < 4; ++i)
			{
				C1.graphics.drawRect(30 + (60 * i), BASE, WIDTH, -getHeight(totals[i], current[i]));
				C1.addChild(FIELDS[i]);
				FIELDS[i].text = NAMES[i];
				FIELDS[i].setFormat(SIZE, Local.D.d[11]);
				FIELDS[i].x = 30 + (60 * i) + WIDTH * .5 - FIELDS[i].width * .5;
				FIELDS[i].y = BASE;
				C1.addChild(FIELDS2[i]);
				FIELDS2[i].text = (Math.floor((((totals[i] - current[i]) * 100) / totals[i]))).toFixed(0) + "%\n" + (totals[i] - current[i]).toString() + "/" + (totals[i]).toString();
				FIELDS2[i].setFormat(SIZE, Local.D.d[11]);
				FIELDS2[i].x = (30 + (60 * (i))) + (WIDTH * .5 - (FIELDS2[i].width * .5));
				FIELDS2[i].y = BASE - getHeight(totals[i], current[i]) - 40;
			}
			for (i = 4; i < totals.length - 1; ++i)
			{
				C1.graphics.drawRect(30 + (60 * (i - 4)), BASE2, WIDTH, -getHeight(totals[i], current[i]));
				C1.addChild(FIELDS[i]);
				FIELDS[i].text = NAMES[i];
				FIELDS[i].setFormat(SIZE, Local.D.d[11]);
				FIELDS[i].x = (30 + (60 * (i - 4))) + (WIDTH * .5 - (FIELDS[i].width * .5));
				FIELDS[i].y = BASE2;
				C1.addChild(FIELDS2[i]);
				FIELDS2[i].text = (Math.floor((((totals[i] - current[i]) * 100) / totals[i]))).toFixed(0) + "%\n" + (totals[i] - current[i]).toString() + "/" + (totals[i]).toString();
				FIELDS2[i].setFormat(SIZE, Local.D.d[11]);
				FIELDS2[i].x = (30 + (60 * (i - 4))) + (WIDTH * .5 - (FIELDS2[i].width * .5));
				FIELDS2[i].y = BASE2 - getHeight(totals[i], current[i]) - 40;
			}
			var cir:int = ((totals[totals.length - 1] - current[current.length - 1]) * 360) / totals[totals.length - 1], d:int;
			//C1.graphics.drawRect(395,95,210,210);
			C1.graphics.lineStyle(3);
			C1.graphics.lineGradientStyle("linear", [Local.D.d[9], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
			for (d = -90; d < cir - 90; ++d)
			{
				C1.graphics.moveTo(500, 130);
				C1.graphics.lineTo(500 + (80 * Math.cos(d * (Math.PI / 180))), 130 + (80 * Math.sin(d * (Math.PI / 180))));
			}
			C1.graphics.beginFill(0, 0);
			C1.graphics.drawCircle(500, 130, 80);
			C1.addChild(CIRT);
			CIRT.x = 330;
			CIRT.y = 65;
			CIRT.text = "All badges\n\n\n" + Math.floor((((totals[totals.length - 1] - current[current.length - 1]) * 100) / totals[totals.length - 1])).toFixed(0) + "%\n" + (totals[totals.length - 1] - current[current.length - 1]).toString() + "/" + (totals[totals.length - 1]).toString();
			CIRT.setFormat(SIZE + 10, Local.D.d[11]);
			//filters=[SHADOW];
			C1.graphics.endFill();
			C1.graphics.lineStyle(3);
			C1.graphics.lineGradientStyle("linear", [Local.D.d[9], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
			C1.graphics.moveTo(25, BASE + 3);
			C1.graphics.lineTo(25, BASE - HEIGHT);
			C1.graphics.moveTo(25, BASE + 3);
			C1.graphics.lineTo(265, BASE + 3);
			C1.graphics.moveTo(25, BASE2 + 3);
			C1.graphics.lineTo(25, BASE2 - HEIGHT);
			C1.graphics.moveTo(25, BASE2 + 3);
			C1.graphics.lineTo(565, BASE2 + 3);
			SAVE.draw();
			SAVE.addEventListener(MouseEvent.CLICK, save);
		}
		
		/*GET TOTALS*/
		internal function getTotals():void
		{
			totals = new <int>[Badges.easy.length, Badges.medium.length, Badges.hard.length, Badges.impossible.length, Badges.action.length, Badges.multiplayer.length, Badges.shooter.length, Badges.adventure.length, Badges.sports.length, Badges.defense.length, Badges.puzzle.length, Badges.music.length, Badges.unity.length, Badges.ids.length];
		}
		
		/*SAVE*/
		private function save(e:MouseEvent):void
		{
			var bd:BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight), f:FileReference = new FileReference(), ba:ByteArray;
			bd.draw(C1);
			ba = PNGEncoder.encode(bd);
			f.save(ba, "BadgeMaster" + new Date().getTime() + ".png");
		}
	}
}