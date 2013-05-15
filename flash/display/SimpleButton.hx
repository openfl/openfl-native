package flash.display;


import flash.Lib;


class SimpleButton extends InteractiveObject {
	
	
	public var downState (default, set):DisplayObject;
	public var enabled (get, set):Bool;
	public var hitTestState (default, set):DisplayObject;
	public var overState (default, set):DisplayObject;
	public var upState (default, set):DisplayObject;
	public var useHandCursor (get, set):Bool;
	
	
	public function new (upState:DisplayObject = null, overState:DisplayObject = null, downState:DisplayObject = null, hitTestState:DisplayObject = null) {
		
		super (nme_simple_button_create (), "SimpleButton");
		
		this.upState = upState;
		this.overState = overState;
		this.downState = downState;
		this.hitTestState = hitTestState;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function set_downState (value:DisplayObject):DisplayObject {
		
		downState = value;
		nme_simple_button_set_state (__handle, 1, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	private function get_enabled ():Bool { return nme_simple_button_get_enabled (__handle); }
	private function set_enabled (value):Bool {
		
		nme_simple_button_set_enabled (__handle, value);
		return value;
		
	}
	
	
	private function get_useHandCursor ():Bool { return nme_simple_button_get_hand_cursor (__handle); }
	private function set_useHandCursor (value):Bool {
		
		nme_simple_button_set_hand_cursor (__handle, value);
		return value;
		
	}
	
	
	private function set_hitTestState (value:DisplayObject):DisplayObject {
		
		hitTestState = value;
		nme_simple_button_set_state (__handle, 3, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	public function set_overState (value:DisplayObject):DisplayObject {
		
		overState = value;
		nme_simple_button_set_state (__handle, 2, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	public function set_upState (value:DisplayObject):DisplayObject {
		
		upState = value;
		nme_simple_button_set_state (__handle, 0, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var nme_simple_button_set_state = Lib.load ("nme", "nme_simple_button_set_state", 3);
	private static var nme_simple_button_get_enabled = Lib.load ("nme", "nme_simple_button_get_enabled", 1);
	private static var nme_simple_button_set_enabled = Lib.load ("nme", "nme_simple_button_set_enabled", 2);
	private static var nme_simple_button_get_hand_cursor = Lib.load ("nme", "nme_simple_button_get_hand_cursor", 1);
	private static var nme_simple_button_set_hand_cursor = Lib.load ("nme", "nme_simple_button_set_hand_cursor", 2);
	private static var nme_simple_button_create = Lib.load ("nme", "nme_simple_button_create", 0);
	
	
}