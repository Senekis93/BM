package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	import com.foxarc.images.BitmapEncoder;
	
	public class Colors extends Sprite
	{
		
		private var l:Loader, ref:FileReference, selecting:Boolean, selected:int = 0, COLOR:Array;
		//color:int;
		
		private const HEX:InputField = new InputField(), PREVIEW:Sprite = new Sprite(), SELECTOR:ColorPicker = new ColorPicker(), NAMES:Vector.<String> = new <String>["Scrolling text (top)", "Title background color", "Title text color", "Borders and lines", "Badge information", "Background", "Button text color", "Button background color", "Graphics color 1", "Graphics color 2", "Default text color"], SHORT:Vector.<String> = new <String>["Top text", "Title back", "Title text", "Borders", "Badge text", "Background", "Button text", "Button back", "Graphics 1", "Graphics 2", "Text"], 
		//INDEX:Vector.<int>=new <int>[1],
		FILL:String = "linear", ALPHAS:Array = [1, 1], RATIOS:Array = [0x00, 0xFF], MATRIX:Matrix = new Matrix(), SPREAD:String = "reflect", SAMPLES:Array = [], BUTTONS:Vector.<ColorButton> = new <ColorButton>[new ColorButton(480, 100, SHORT[0]), new ColorButton(480, 100, SHORT[1]), new ColorButton(480, 100, SHORT[2]), new ColorButton(480, 100, SHORT[3]), new ColorButton(480, 100, SHORT[4]), new ColorButton(480, 100, SHORT[5]), new ColorButton(480, 100, SHORT[6]), new ColorButton(480, 100, SHORT[7]), new ColorButton(480, 100, SHORT[8]), new ColorButton(480, 100, SHORT[9]), new ColorButton(480, 100, SHORT[10])], INFO:Div = new Div(40, "Current selection: " + NAMES[selected]), TEMP:Array = [], APPLY:BaseButton = new BaseButton(200, 325, "Apply"), SAVE:BaseButton = new BaseButton(90, 350, "Save"), LOAD:BaseButton = new BaseButton(310, 350, "Load"), ARROW:Arrow = new Arrow(2, 597, 114, 0.53), CUSTOM:BaseButton = new BaseButton(360, 200, "Custom"), SIMPLE:BaseButton = new BaseButton(360, 250, "Simple"), SHARE:BaseButton = new BaseButton(200, 375, "Share");
		
		public function Colors():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			COLOR = [Local.D.d[1], Local.D.d[2], Local.D.d[3], Local.D.d[4], Local.D.d[5], Local.D.d[6], Local.D.d[7], Local.D.d[8], Local.D.d[9], Local.D.d[10], Local.D.d[11]];
			addChild(INFO);
			addChild(SELECTOR);
			SELECTOR.x = 480;
			SELECTOR.y = 150;
			SELECTOR.scaleX = SELECTOR.scaleY = 0.35;
			SELECTOR.addEventListener(E.SET_COLOR, getColor);
			addChild(PREVIEW);
			PREVIEW.x = 570;
			PREVIEW.y = 315;
			addChild(HEX);
			HEX.x = 480;
			HEX.y = 360;
			HEX.addEventListener(Event.CHANGE, getColor2);
			MATRIX.createGradientBox(100, 1, 225, 0, 0);
			getLocal();
			buildSamples();
			updateSelection(selected);
			addChild(SHARE);
			addChild(APPLY);
			SHARE.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				dispatchEvent(new E(E.SHARE_SKIN));
			});
			APPLY.addEventListener(MouseEvent.CLICK, apply);
			addChild(SAVE);
			SAVE.addEventListener(MouseEvent.CLICK, save);
			addChild(LOAD);
			LOAD.addEventListener(MouseEvent.CLICK, load);
			addChild(ARROW);
			ARROW.addEventListener(MouseEvent.CLICK, showAll);
			addChild(CUSTOM);
			CUSTOM.visible = false;
			CUSTOM.addEventListener(MouseEvent.CLICK, loadBG);
			addChild(SIMPLE);
			SIMPLE.visible = false;
			SIMPLE.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				Local.update(12, 0);
				Local.update(0, "hello,world");
				dispatchEvent(new E(E.COLORS));
			});
		}
		
		/*LOAD BACKGROUND*/
		private function loadBG(e:MouseEvent):void
		{
			var fil:FileFilter = new FileFilter("Images. Suggested 640x480 px.", "*.jpg;*.gif;*.png");
			ref = new FileReference();
			ref.browse([fil]);
			ref.addEventListener(Event.SELECT, selectPic);
		}
		
		/*SELECT PIC*/
		private function selectPic(e:Event):void
		{
			ref.removeEventListener(Event.SELECT, selectFile);
			ref.load();
			ref.addEventListener(Event.COMPLETE, picComplete);
		}
		
		/*PIC LOADED*/
		private function picComplete(e:Event):void
		{
			ref.removeEventListener(Event.COMPLETE, picComplete);
			l = new Loader();
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, pic);
			l.loadBytes(ref.data);
			ref = null;
		}
		
		/*PIC LOADED*/
		private function pic(e:Event):void
		{
			l.contentLoaderInfo.removeEventListener(Event.COMPLETE, pic);
			var bd:BitmapData, bd2:BitmapData, m:Matrix, scale:Number = 1.0;
			bd = new BitmapData(l.width, l.height, true, 0);
			bd.draw(l);
			if (l.width > l.height)
			{
				if (l.width > stage.stageWidth) scale = stage.stageWidth / l.width;
			}
			else
			{
				if (l.height > stage.stageHeight) scale = stage.stageHeight / l.height;
			}
			m = new Matrix;
			m.scale(scale, scale);
			try
			{
				bd2 = new BitmapData(l.width * scale, l.height * scale, true, 0);
				bd2.draw(bd, m);
				Local.D.d[0] = BitmapEncoder.encodeBase64(bd2);
				Local.update(12, 1);
				dispatchEvent(new E(E.COLORS));
				dispatchEvent(new E(E.BACKGROUND));
			}
			catch (e:Error)
			{
				dispatchEvent(new E(E.BACKGROUND_ERROR));
				Local.update(12, 0);
			}
		}
		
		/*LOAD*/
		private function load(e:MouseEvent):void
		{
			var fil:FileFilter = new FileFilter("Badge Master Skin", "*.bms");
			ref = new FileReference();
			ref.browse([fil]);
			ref.addEventListener(Event.SELECT, selectFile);
		}
		
		/*SELECT LOCAL*/
		private function selectFile(e:Event):void
		{
			ref.removeEventListener(Event.SELECT, selectFile);
			ref.load();
			ref.addEventListener(Event.COMPLETE, complete);
		}
		
		/*DATA LOADED*/
		private function complete(e:Event):void
		{
			var s:String = e.target.data.toString();
			ref.removeEventListener(Event.COMPLETE, complete);
			Local.D.d = s.split(":");
			var i:int, l:int = Local.D.d.length;
			for (i = 1; i < l; ++i) Local.D.d[i] = parseInt(Local.D.d[i]);
			ref = null;
			l = COLOR.length;
			for (i = 0; i < l; ++i) COLOR[i] = Local.D.d[i + 1];
			setPreview(COLOR[selected]);
			HEX.setText(int(COLOR[selected]).toString(16).toUpperCase());
			updateSelection(selected);
			dispatchEvent(new E(E.COLORS));
			setPreview(int("0x" + (HEX.text.substr(1, HEX.text.length))));
		}
		
		/*SAVE*/
		private function save(e:MouseEvent):void
		{
			var s:String = Local.D.d.join(":"), f:FileReference = new FileReference();
			f.save(s, "BadgeMasterColors" + new Date().getTime() + ".bms");
		}
		
		/*UPDATE SELECTION*/
		private function updateSelection(s:int):void
		{
			if (s == 0) SAMPLES[s].setFormat(40, COLOR[selected]);
			else if (s == 1) SAMPLES[s].drawBack(COLOR[selected]);
			else if (s == 2) SAMPLES[s].drawText(COLOR[selected]);
			else if (s == 3)
			{
				SAMPLES[s].graphics.clear();
				SAMPLES[s].graphics.beginFill(0, 0);
				SAMPLES[s].graphics.lineStyle(3, COLOR[selected]);
				SAMPLES[s].graphics.drawRect(0, 0, 100, 100);
				SAMPLES[s].graphics.drawRect(0, 0, 100, 100);
				SAMPLES[s].graphics.drawRect(100, 0, 100, 100);
				SAMPLES[s].graphics.drawRect(200, 0, 100, 100);
				SAMPLES[s].graphics.endFill();
			}
			else if (s == 4) SAMPLES[s].setFormat(35, COLOR[selected]);
			else if (s == 5)
			{
				SAMPLES[s].graphics.clear();
				SAMPLES[s].graphics.beginFill(COLOR[selected]);
				SAMPLES[s].graphics.drawRect(0, 0, 300, 100);
				SAMPLES[s].graphics.endFill();
			}
			else if (s == 6) SAMPLES[s].drawText(COLOR[selected]);
			else if (s == 7) SAMPLES[s].drawBack(COLOR[selected]);
			else if (s == 8)
			{
				SAMPLES[s].graphics.clear();
				SAMPLES[s].graphics.beginGradientFill(FILL, [COLOR[selected], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
				SAMPLES[s].graphics.drawRect(0, 0, 290, 100);
				SAMPLES[s].graphics.endFill();
			}
			else if (s == 9)
			{
				SAMPLES[s].graphics.clear();
				SAMPLES[s].graphics.beginGradientFill(FILL, [Local.D.d[9], COLOR[selected]], ALPHAS, RATIOS, MATRIX, SPREAD);
				SAMPLES[s].graphics.drawRect(0, 0, 290, 100);
				SAMPLES[s].graphics.endFill();
			}
			else if (s == 10) SAMPLES[s].setFormat(32, COLOR[selected]);
			var i:int = 0;
		}
		
		/*APPLY*/
		private function apply(e:MouseEvent):void
		{
			Local.update(selected + 1, COLOR[selected]);
			dispatchEvent(new E(E.COLORS));
			//buildSamples();
		}
		
		/*GET LOCAL*/
		private function getLocal():void
		{
			var i:int;
			TEMP.splice(0, TEMP.length);
			for (i = 1; i < Local.D.d.length; ++i) TEMP[i] = Local.D.d[i];
		}
		
		/*GET COLOR*/
		private function getColor(e:E):void
		{
			COLOR[selected] = SELECTOR.getColor();
			setPreview(COLOR[selected]);
			HEX.setText(COLOR[selected].toString(16).toUpperCase());
			TEMP[selected + 1] = COLOR[selected];
			updateSelection(selected);
		}
		
		/*GET COLOR2*/
		private function getColor2(e:Event = null):void
		{
			COLOR[selected] = int("0x" + (HEX.text.substr(1, HEX.text.length)));
			setPreview(COLOR[selected]);
			TEMP[selected + 1] = COLOR[selected];
			updateSelection(selected);
		}
		
		/*SET PREVIEW*/
		private function setPreview(c:int):void
		{
			PREVIEW.graphics.clear();
			PREVIEW.graphics.beginFill(c);
			PREVIEW.graphics.drawRect(0, 0, 35, 35);
			PREVIEW.graphics.endFill();
		}
		
		/*SHOW ALL*/
		private function showAll(e:MouseEvent):void
		{
			selecting = selecting ? false : true;
			var i:int = 0;
			if (selecting)
			{
				for (; i < BUTTONS.length; ++i)
				{
					BUTTONS[i].y = 100 + (i * BUTTONS[0].height);
					BUTTONS[i].visible = true;
					SELECTOR.visible = HEX.visible = PREVIEW.visible = APPLY.visible = false;
					BUTTONS[i].addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
					{
						select(BUTTONS.indexOf(e.currentTarget));
						var j:int = 0;
						for (; j < BUTTONS.length; ++j) BUTTONS[j].removeEventListener(e.type, arguments.callee);
						i = 0;
						for (; i < BUTTONS.length; ++i)
						{
							BUTTONS[i].y = 100;
							BUTTONS[i].visible = i == selected;
							SELECTOR.visible = HEX.visible = PREVIEW.visible = APPLY.visible = true;
							selecting = false;
						}
					});
				}
			}
			else
			{
				for (; i < BUTTONS.length; ++i)
				{
					BUTTONS[i].y = 100;
					BUTTONS[i].visible = i == selected;
					SELECTOR.visible = HEX.visible = PREVIEW.visible = APPLY.visible = true;
				}
			}
		}
		
		/*SELECT*/
		private function select(i:int):void
		{
			selected = i;
			INFO.setText("Current selection: " + NAMES[selected]);
			var s:int = 0;
			for (; s < SAMPLES.length; ++s) SAMPLES[s].visible = s == selected;
			setPreview(COLOR[selected]);
			HEX.setText(int(COLOR[selected]).toString(16).toUpperCase());
			CUSTOM.visible = SIMPLE.visible = i == 5;
		}
		
		/*BUILD SAMPLES*/
		private function buildSamples():void
		{
			SAMPLES[0] = new NovaField(40, Local.D.d[1]);
			SAMPLES[0].background = true;
			SAMPLES[0].backgroundColor = 0;
			SAMPLES[0].text = "Scrolling Text sample...";
			SAMPLES[1] = new Div(120, "");
			SAMPLES[1].scaleX = 0.65;
			SAMPLES[2] = new Div(120, "Title text sample... ");
			SAMPLES[2].scaleX = 0.65;
			SAMPLES[3] = new Sprite();
			SAMPLES[3].graphics.beginFill(0, 0);
			SAMPLES[3].graphics.lineStyle(3, Local.D.d[4]);
			SAMPLES[3].graphics.drawRect(0, 0, 100, 100);
			SAMPLES[3].graphics.drawRect(100, 0, 100, 100);
			SAMPLES[3].graphics.drawRect(200, 0, 100, 100);
			SAMPLES[3].graphics.endFill();
			SAMPLES[4] = new NovaField(35, Local.D.d[5]);
			SAMPLES[4].text = "Badge title, description\nand points text sample...";
			SAMPLES[4].setFormat(35, Local.D.d[5]);
			SAMPLES[5] = new Sprite();
			SAMPLES[5].graphics.beginFill(Local.D.d[6]);
			SAMPLES[5].graphics.drawRect(0, 0, 300, 100);
			SAMPLES[5].graphics.endFill();
			SAMPLES[6] = new LoaderButton(0, 0, "Button");
			SAMPLES[7] = new LoaderButton(0, 0, "Button");
			SAMPLES[8] = new Sprite();
			SAMPLES[8].graphics.beginGradientFill(FILL, [Local.D.d[9], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
			SAMPLES[8].graphics.drawRect(0, 0, 290, 100);
			SAMPLES[8].graphics.endFill();
			SAMPLES[9] = new Sprite();
			SAMPLES[9].graphics.beginGradientFill(FILL, [Local.D.d[9], Local.D.d[10]], ALPHAS, RATIOS, MATRIX, SPREAD);
			SAMPLES[9].graphics.drawRect(0, 0, 290, 100);
			SAMPLES[9].graphics.endFill();
			SAMPLES[10] = new NovaField(32, Local.D.d[11]);
			SAMPLES[10].text = "Sample default text";
			SAMPLES[10].setFormat(32, Local.D.d[11]);
			var i:int, drawable:Vector.<int> = new <int>[1, 2, 6, 7], X:Vector.<Array> = new <Array>[[1, 130], [2, 130], [3, -50], [5, -50]];
			for (i = 0; i < SAMPLES.length; ++i)
			{
				addChild(SAMPLES[i]);
				SAMPLES[i].visible = i == selected;
				SAMPLES[i].x = 150 - SAMPLES[i].width * .5;
				SAMPLES[i].y = 130;
				var j:int;
				for (j = 0; j < drawable.length; ++j)
					if (drawable[j] == i) SAMPLES[i].draw();
				for (j = 0; j < X.length; ++j)
					if (X[j][0] == i) SAMPLES[i].x -= X[j][1];
			}
		}
		
		/*DRAW*/
		internal function draw():void
		{
			graphics.clear();
			var i:int;
			for (i = 0; i < BUTTONS.length; ++i)
			{
				addChild(BUTTONS[i]);
				BUTTONS[i].draw();
				BUTTONS[i].visible = selected == i;
			}
			INFO.draw();
			INFO.setText("Current selection: " + NAMES[selected]);
			setPreview(TEMP[selected + 1]);
			HEX.setText(int(COLOR[selected]).toString(16).toUpperCase());
			ARROW.draw();
			APPLY.draw();
			SAVE.draw();
			LOAD.draw();
			SHARE.draw();
			graphics.lineStyle(6, 0xFFFFFF);
			graphics.beginFill(0, 0);
			graphics.drawRect(SELECTOR.x, SELECTOR.y, SELECTOR.width, SELECTOR.height * .7);
			addChild(SELECTOR);
			CUSTOM.draw();
			SIMPLE.draw();
		}
	
	}
}