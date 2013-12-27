package flash.media;


import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.SampleDataEvent;
import flash.media.Sound;
import flash.Lib;

#if (!audio_thread_disabled && !emscripten)
#if neko
import neko.vm.Thread;
import neko.vm.Mutex;
#else
import cpp.vm.Thread;
import cpp.vm.Mutex;
#end
#end


class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (get, null):Float;
	public var rightPeak (get, null):Float;
	public var position (get, set):Float;
	public var soundTransform (get, set):SoundTransform;
	
	@:noCompletion public static var __dynamicSoundCount = 0;
	@:noCompletion private static var __incompleteList = new Array<SoundChannel> ();
	
	@:noCompletion public var __dataProvider:EventDispatcher;
	@:noCompletion private var __handle:Dynamic;
	@:noCompletion public var __soundInstance:Sound;
	@:noCompletion private var __transform:SoundTransform;
	
	#if (!audio_thread_disabled && !emscripten)
	
	@:noCompletion private static var __audioMessageCheckComplete = 1;
	@:noCompletion private static var __audioState:AudioThreadState;
	@:noCompletion private static var __audioThreadIsIdle:Bool = true;
	@:noCompletion private static var __audioThreadRunning:Bool = false;
	
	@:noCompletion private var __addedToThread:Bool;
	
	#end	
	

	public function new (handle:Dynamic, startTime:Float, loops:Int, soundTransform:SoundTransform) {
		
		super ();

		if (soundTransform != null) {
			
			__transform = soundTransform.clone ();
			
		}
		
		if (handle != null) {
			
			__handle = lime_sound_channel_create (handle, startTime, loops, __transform);
			
		}
		
		if (__handle != null) {
			
			__incompleteList.push (this);
			
		}

	}
	
	
	public static function createDynamic (handle:Dynamic, soundTransform:SoundTransform, dataProvider:EventDispatcher):SoundChannel {
		
		var result = new SoundChannel (null, 0, 0, soundTransform);
		
		result.__dataProvider = dataProvider;
		result.__handle = handle;
		__incompleteList.push (result);
		
		__dynamicSoundCount ++;
		
		return result;
		
	}
	
	
	public function stop ():Void {
		
		#if (!audio_thread_disabled && !emscripten)
		
		if (__soundInstance != null && __soundInstance.__audioType == InternalAudioType.MUSIC) {
			
			__audioState.remove (this);
			
		}
		
		#end
		
		lime_sound_channel_stop (__handle);
		__handle = null;
		__soundInstance = null;
		
	}
	
	
	@:noCompletion private function __checkComplete ():Bool {
		
		if (__handle != null) {
			
			if (__dataProvider != null && lime_sound_channel_needs_data (__handle)) {
				
				var request = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
				request.position = lime_sound_channel_get_data_position (__handle);
				__dataProvider.dispatchEvent (request);
				
				if (request.data.length > 0) {
					
					lime_sound_channel_add_data (__handle, request.data);
					
				}
				
			}
			
			#if (!audio_thread_disabled && !emscripten)
			
			if (__addedToThread || (__soundInstance != null && __soundInstance.__audioType == InternalAudioType.MUSIC)) {
				
				if (__audioState == null) {
					
					__audioState = new AudioThreadState ();
					
					__audioThreadRunning = true;
					__audioThreadIsIdle = false;
					
					__audioState.mainThread = Thread.current ();
					__audioState.audioThread = Thread.create (__checkCompleteBackgroundThread);
					
				}
				
				if (!__addedToThread) {
					
					__audioState.add (this);
					__addedToThread = true;
					
				}
				
				__audioState.audioThread.sendMessage (__audioMessageCheckComplete);
				
			} else
			
			#end
			
			if (__runCheckComplete ()) {
				
				var completeEvent = new Event (Event.SOUND_COMPLETE);
				dispatchEvent (completeEvent);
				
				return true;
				
			}
			
			return false;
			
		} else {
			
			return true;
			
		}
		
	}
	
	
	#if (!audio_thread_disabled && !emscripten)
	
	private static function __checkCompleteBackgroundThread () {		
		
		while (__audioThreadRunning) {		
			
			var threadMessage:Dynamic = Thread.readMessage (false);
			
			if (threadMessage == __audioMessageCheckComplete) {
				
				__audioState.checkComplete ();
				
			}
			
			if (!__audioThreadIsIdle) {
				
				__audioState.updateComplete ();
				Sys.sleep (0.01);
				
			} else {
				
				Sys.sleep (0.2);
				
			}
			
		}
		
		__audioThreadRunning = false;
		__audioThreadIsIdle = true;
		
	}
	
	#end
	
	
	@:noCompletion public static function __completePending ():Bool {
		
		return __incompleteList.length > 0;
		
	}
	
	
	@:noCompletion public static function __pollComplete ():Void {
		
		var i = __incompleteList.length;
		
		while (--i >= 0) {
			
			if (__incompleteList[i].__checkComplete ()) {
				
				__incompleteList.splice (i, 1);
				
			}
			
		}
		
	}
	
	
	@:noCompletion public function __runCheckComplete ():Bool {
		
		if (lime_sound_channel_is_complete (__handle)) {
			
			__handle = null;
			__soundInstance = null;
			
			if (__dataProvider != null) {
				
				__dynamicSoundCount--;
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_leftPeak ():Float { return lime_sound_channel_get_left (__handle); }
	private function get_rightPeak ():Float { return lime_sound_channel_get_right (__handle); }
	private function get_position ():Float { return lime_sound_channel_get_position (__handle); }
	private function set_position (value:Float):Float { return lime_sound_channel_set_position (__handle, position); }
	
	
	private function get_soundTransform ():SoundTransform {
		
		if (__transform == null) {
			
			__transform = new SoundTransform ();
			
		}
		
		return __transform.clone ();
		
	}
	
	
	private function set_soundTransform (value:SoundTransform):SoundTransform {
		
		__transform = value.clone ();
		lime_sound_channel_set_transform (__handle, __transform);
		
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_sound_channel_is_complete = Lib.load ("lime", "lime_sound_channel_is_complete", 1);
	private static var lime_sound_channel_get_left = Lib.load ("lime", "lime_sound_channel_get_left", 1);
	private static var lime_sound_channel_get_right = Lib.load ("lime", "lime_sound_channel_get_right", 1);
	private static var lime_sound_channel_get_position = Lib.load ("lime", "lime_sound_channel_get_position", 1);
	private static var lime_sound_channel_set_position = Lib.load ("lime", "lime_sound_channel_set_position", 2);
	private static var lime_sound_channel_get_data_position = Lib.load ("lime", "lime_sound_channel_get_data_position", 1);
	private static var lime_sound_channel_stop = Lib.load ("lime", "lime_sound_channel_stop", 1);
	private static var lime_sound_channel_create = Lib.load ("lime", "lime_sound_channel_create", 4);
	private static var lime_sound_channel_set_transform = Lib.load ("lime", "lime_sound_channel_set_transform", 2);
	private static var lime_sound_channel_needs_data = Lib.load ("lime", "lime_sound_channel_needs_data", 1);
	private static var lime_sound_channel_add_data = Lib.load ("lime", "lime_sound_channel_add_data", 2);
	
	
}


#if (!audio_thread_disabled && !emscripten)

@:access(flash.media.SoundChannel) class AudioThreadState {
	
	
	public var audioThread:Thread;
	public var channelList:Map <SoundChannel, Bool>;
	public var mainThread:Thread;
	public var mutex:Mutex;
	
	
	public function new () {
		 
		mutex = new Mutex ();
		channelList = new Map ();
		
	}
	
	
	public function add (channel:SoundChannel):Void {
		
		mutex.acquire ();
		
		if (!channelList.exists (channel)) {
			
			channelList.set (channel, false);
			SoundChannel.__audioThreadIsIdle = false;
			
		}
		
		mutex.release ();
		
	}
	
	
	public function checkComplete () {
		
		for (channel in channelList.keys ()) {
			
			var isComplete = channelList.get (channel);
			
			if (isComplete) {
				
				var completeEvent = new Event (Event.SOUND_COMPLETE);
				channel.dispatchEvent (completeEvent);
				
				mutex.acquire ();
				channelList.remove (channel);
				mutex.release ();
				
			}
			
		}
			
	}
	
	
	public function remove (channel:SoundChannel):Void {
		
		mutex.acquire ();
		
		if (channelList.exists (channel)) {
			
			channelList.remove (channel);			
			
			if (Lambda.count (channelList) == 0) {
				
				SoundChannel.__audioThreadIsIdle = true;
				
			}
			
		}
			
		mutex.release ();
		
	}
	
	
	public function updateComplete () {
		
		mutex.acquire ();
		
		for (channel in channelList.keys ()) {
			
			channelList.set (channel, channel.__runCheckComplete ());
			
		}
		
		mutex.release ();
		
	}
	
	
}

#end