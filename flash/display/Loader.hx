package flash.display;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.LoaderInfo;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;
import flash.utils.ByteArray;


class Loader extends Sprite {
	
	
	public var content (default, null):DisplayObject;
	public var contentLoaderInfo (default, null):LoaderInfo;
	
	@:noCompletion private var __image:BitmapData;
	
	
	public function new () {
		
		super ();
		
		contentLoaderInfo = LoaderInfo.create (this);
		contentLoaderInfo.__onComplete = __onComplete;
		
	}


	public function load (request:URLRequest, context:LoaderContext = null):Void {
		
		contentLoaderInfo.load (request);
		
	}
	
	
	public function loadBytes (bytes:ByteArray, context:LoaderContext = null):Void {
		
		if (__onComplete(bytes)) {
			
			var event = new Event (Event.COMPLETE);
			event.currentTarget = this;
			contentLoaderInfo.dispatchEvent (event);
			
		} else {
			
			contentLoaderInfo.__dispatchIOErrorEvent ();
			
		}
		
	}
	
	
	public function unload ():Void {
		
		if (numChildren > 0) {
			
			while (numChildren > 0) {
				
				removeChildAt (0);
				
			}
			
			untyped {
				
				contentLoaderInfo.url = null;
				contentLoaderInfo.contentType = null;
				contentLoaderInfo.content = null;
				contentLoaderInfo.bytesLoaded = contentLoaderInfo.bytesTotal = 0;
				contentLoaderInfo.width = 0;
				contentLoaderInfo.height = 0;
				
			}
			
			var event = new Event (Event.UNLOAD);
			event.currentTarget = this;
			dispatchEvent (event);
			
		}
		
	}
	
	
	@:noCompletion private function __onComplete (bytes:ByteArray):Bool {
		
		if (bytes == null) {
			
			return false;
			
		}
		
		try {
			
			__image = BitmapData.loadFromBytes (bytes);
			var bitmap = new Bitmap (__image);
			content = bitmap;
			contentLoaderInfo.content = bitmap;
			
			while (numChildren > 0) {
				
				removeChildAt (0);
				
			}
			
			addChild (bitmap);
			return true;
			
		} catch (e:Dynamic) {
			
			return false;
			
		}
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function contentLoaderInfo_onData (event:Event):Void {
		
		event.stopImmediatePropagation ();
		__onComplete (contentLoaderInfo.bytes);
		
	}
	
	
}