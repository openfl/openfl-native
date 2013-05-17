package flash.display;


class MovieClip extends Sprite {
	
	
	public var currentFrame (get, null):Int;
	public var enabled:Bool;
	public var framesLoaded (get, null):Int;
	public var totalFrames (get, null):Int;
	
	@:noCompletion private var __currentFrame:Int;
	@:noCompletion private var __totalFrames:Int;
	
	
	public function new () {
		
		super ();
		
		__currentFrame = 0;
		__totalFrames = 0;
		
	}
	
	
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void {
		
		
		
	}
	
	
	public function nextFrame ():Void {
		
		
		
	}
	
	
	@:noCompletion override private function __getType ():String {
		
		return "MovieClip";
		
	}
	
	
	public function play ():Void {
		
		
		
	}
	
	
	public function prevFrame ():Void {
		
		
		
	}
	
	
	public function stop ():Void {
		
		
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_currentFrame ():Int { return __currentFrame; }
	private function get_framesLoaded ():Int { return __totalFrames; }
	private function get_totalFrames ():Int { return __totalFrames; }
	
	
}