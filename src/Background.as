package
{
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import com.foxarc.images.BitmapEncoder;
	
	public class Background extends Sprite
	{
		private var bit:Bitmap;
		
		public function Background():void
		{
		
		}
		
		internal function draw():void
		{
			if (bit && bit.stage) removeChild(bit);
			graphics.clear();
			if (!Local.D.d[12])
			{
				graphics.beginFill(Local.D.d[6]);
				graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				graphics.endFill();
			}
			else
			{
				var bd:BitmapData = BitmapEncoder.decodeBase64(Local.D.d[0]);
				bit = new Bitmap(bd);
				addChild(bit);
			}
			x = stage.stageWidth * .5 - width * .5;
			y = stage.stageHeight * .5 - height * .5;
		}
	
	}
}