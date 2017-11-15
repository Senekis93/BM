package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	public class About extends Sprite
	{
		private const SIZE:int = 30, TEXT:NovaField = new NovaField(SIZE, 0), BUTTON:BaseButton = new BaseButton(0, 350, "Bug?"), URL:String = "http://www.kongregate.com/forums/3-general-gaming/topics/203017-badge-master-changelog";
		
		public function About():void
		{
			addEventListener(Event.ADDED_TO_STAGE, go);
		}
		
		private function go(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, go);
			addChild(TEXT);
			TEXT.x = TEXT.y = 30;
			TEXT.width = stage.stageWidth - 60;
			TEXT.wordWrap = true;
			TEXT.text = "Thanks for using Badge Master!\n\nIf you find a bug, please use the button below and report it.\n" + "I'll try to fix it asap.\n\nLike the application? You can contribute by rating it with 5 stars and by sharing it with your friends." + "\nYou can also donate some kreds and buy me a burger. <3\nThanks for the support!\n\n\n                - Senekis.";
			addChild(BUTTON);
			BUTTON.draw();
			BUTTON.x = stage.stageWidth * .5 - BUTTON.width * .5;
			BUTTON.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				navigateToURL(new URLRequest(URL), "_blank");
			});
		}
		
		public function draw():void
		{
			TEXT.setFormat(SIZE, Local.D.d[11]);
			BUTTON.draw();
		}
	}
}