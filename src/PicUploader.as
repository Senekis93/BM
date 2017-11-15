package{        
        import flash.display.Sprite;
		import flash.display.BitmapData; 
		import flash.events.Event;
		import flash.net.URLLoader;
		import flash.net.URLRequest;
		import flash.net.URLRequestHeader;
		import flash.net.URLRequestMethod;
		import flash.net.URLVariables;
		import org.flashdevelop.utils.FlashConnect;
		import com.adobe.images.JPGEncoder;
		
		/**
		*
		*@Senekis
		*@Example:
			var uploader:GDRPicUploader=new GDRPicUploader();
			uploader.addEventListener(Event.COMPLETE,function(e:Event):void{
			trace("Image uploaded\nAccess it with code "+uploader.getCode());
			});
			uploader.upload(new BitmapData(400,400,true,0));
			
			The code is the file's name, without the extension.
			This is the full address:
			"http://senekis.net/pics/gdr/uploads/"+uploader.getCode()+".jpg"
		*
		**/
   

final internal class PicUploader extends Sprite{
       
private var
l:URLLoader,
r:URLRequest,
v:URLVariables,
s:String,
URL:String,
code:String;
                          
private const
J:JPGEncoder=new JPGEncoder(100);
       
public function PicUploader():void{}
       

/*ON SEND*/private function oS(e:Event):void{
	l.removeEventListener(Event.COMPLETE,oS);
    s=e.currentTarget.data.toString();
	v=new URLVariables();
    v.decode(s);  
	URL="http://"+(v.url.substr(0,v.url.indexOf("<!--"))+v.url.substr(v.url.lastIndexOf(">")+1,v.url.length-1)).split(/\s/).join("");
	code=URL.split(/[^0-9]/).join("");
	done();
}

/*DONE*/private function done():void{
//	FlashConnect.trace("Image uploaded to "+URL);
	dispatchEvent(new Event(Event.COMPLETE));
}


       
/*SEND*/internal function upload(bd:BitmapData):void{	
	r=new URLRequest("http://senekis.net/pics/badge_master/bm.php")
	r.method=URLRequestMethod.POST;
	r.requestHeaders.push(new URLRequestHeader("Content-type","application/octet-stream"));
	r.data=J.encode(bd);
	l=new URLLoader();
    l.addEventListener(Event.COMPLETE,oS);
    l.load(r);
}
		
/*CODE*/internal function getCode():String{
	return code;
}
                           
      }}