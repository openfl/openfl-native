package flash.events;


import flash.events.Event;
import flash.events.IEventDispatcher;
import pazu.utils.WeakRef;


class EventDispatcher implements IEventDispatcher {
	
	
	private var __eventMap:EventMap;
	private var __target:IEventDispatcher;
	
	
	public function new (target:IEventDispatcher = null):Void {
		
		__target = (target == null ? this : target);
		__eventMap = null;
		
	}
	
	
	public function addEventListener (type:String, listener:Function, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		
		if (__eventMap == null) {
			
			__eventMap = new EventMap ();
			
		}
		
		var list = __eventMap.get (type);
		
		if (list == null) {
			
			list = new ListenerList ();
			__eventMap.set (type, list);
			
		}
		
		list.push (new WeakRef<Listener> (new Listener (listener, useCapture, priority), useWeakReference));
		
	}
	

	public function dispatchEvent (event:Event):Bool {
		
		if (__eventMap == null) {
			
			return false;
			
		}
		
		if (event.target == null) {
			
			event.target = __target;
			
		}
		
		if (event.currentTarget == null) {
			
			event.currentTarget = __target;
			
		}
		
		var list = __eventMap.get (event.type);
		var capture = (event.eventPhase == EventPhase.CAPTURING_PHASE);
		
		if (list != null) {
			
			var index = 0;
			
			var listItem, listener;
			
			while (index < list.length) {
				
				listItem = list[index];
				listener = (listItem != null ? listItem.get () : null);
				
				if (listener == null) {
					
					list.splice (index, 1);
					
				} else {
					
					if (listener.useCapture == capture) {
						
						listener.dispatchEvent (event);
						
						if (event.__getIsCancelledNow ()) {
							
							return true;
							
						}
						
					}
					
					index++;
					
				}
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	public function hasEventListener (type:String):Bool {
		
		if (__eventMap == null) {
			
			return false;
			
		}
		
		var list = __eventMap.get (type);
		
		if (list != null) {
			
			for (item in list) {
				
				if (item != null) return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	public function removeEventListener (type:String, listener:Function, capture:Bool = false):Void {
		
		if (__eventMap == null || !__eventMap.exists (type)) {
			
			return;
			
		}
		
		var list = __eventMap.get (type);
		var item;
		
		for (i in 0...list.length) {
			
			if (list[i] != null) {
				
				item = list[i].get ();
				if (item != null && item.is (listener, capture)) {
					
					list[i] = null;
					return;
					
				}
				
			}
			
		}
		
	}
	
	
	public function toString ():String {
		
		return "[object " + Type.getClassName (Type.getClass (this)) + "]";
		
	}
	
	
	public function willTrigger (type:String):Bool {
		
		if (__eventMap == null) {
			
			return false;
			
		}
		
		return __eventMap.exists (type);
		
	}
	
	
	public function __dispatchCompleteEvent ():Void {
		
		dispatchEvent (new Event (Event.COMPLETE));
		
	}
	
	
	public function __dispatchIOErrorEvent ():Void {
		
		dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR));
		
	}
	
	
}


class Listener {
	
	
	public var id:Int;
	public var listener:Function;
	public var priority:Int;
	public var useCapture:Bool;

	private static var __id = 1;
	
	
	public function new (listener:Function, useCapture:Bool, priority:Int) {
		
		this.listener = listener;
		this.useCapture = useCapture;
		this.priority = priority;
		id = __id++;
		
	}
	
	
	public function dispatchEvent (event:Event):Void {
		
		listener (event);
		
	}
	
	
	public function is (listener:Function, useCapture:Bool) {
		
		return (Reflect.compareMethods (this.listener, listener) && this.useCapture == useCapture);
		
	}
	
	
}


typedef ListenerList = Array<WeakRef<Listener>>;
typedef EventMap = haxe.ds.StringMap<ListenerList>;