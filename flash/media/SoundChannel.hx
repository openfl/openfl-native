package flash.media;


import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.SampleDataEvent;
import flash.Lib;

#if !audio_thread_disabled 
	#if cpp
		import cpp.vm.Thread;
	#end
	#if neko
		import neko.vm.Thread;
	#end
#end


class SoundChannel extends EventDispatcher {
	
	
	public var leftPeak (get, null):Float;
	public var rightPeak (get, null):Float;
	public var position (get, set):Float;
	public var soundTransform (get, set):SoundTransform;
	
	@:noCompletion public var __sound_instance : flash.media.Sound;

	@:noCompletion public static var __dynamicSoundCount = 0;
	@:noCompletion private static var __incompleteList = new Array<SoundChannel> ();
	
	@:noCompletion private var __handle:Dynamic;
	@:noCompletion private var __transform:SoundTransform;
	@:noCompletion public var __dataProvider:EventDispatcher;

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
		
		#if !audio_thread_disabled
			__background_thread_running = false;
		#end //audio_thread_disabled

		lime_sound_channel_stop (__handle);
		__handle = null;
		
	}
	
#if !audio_thread_disabled

		var __background_thread_running : Bool = false;
		var __background_thread_should_check : Bool = false;
		var __background_thread : Thread;
		var __main_thread : Thread;	

		var __audio_message_check_complete = 1;
		var __audio_message_complete = 2;

	@:noCompletion function __check_complete_background_thread() {		

		var _last_complete = false;

		while(__background_thread_running) {			

				//first time we want to wait for the message, after that we don't
			var thread_message : Dynamic = Thread.readMessage( (__main_thread == null) );

				//the first message is always the calling thread
			if(__main_thread == null) {

				__main_thread = thread_message;
				__background_thread_should_check = true;

			} else {

				switch(thread_message) {

					case __audio_message_check_complete :
						if(_last_complete == true) {
							__main_thread.sendMessage( __audio_message_complete );	
						} 

				} //switch thread message

			} //if main thread != null

			if(__background_thread_should_check) {				
				_last_complete = __run_check_complete();				
			}

				//10 ms sleep time, 
				//should be configurable
			Sys.sleep( 0.01 );

		} //keep running

			//clean up
		__background_thread = null;
		__background_thread_running = false;
		__background_thread_should_check = false;

	} //__check_complete_background_thread

	@:noCompletion function __ping_check_complete_thread() {

			//If no background thread right now, create one
		if(__background_thread == null) {

			__background_thread_running = true;
			__background_thread = Thread.create(__check_complete_background_thread);
			__background_thread.sendMessage( Thread.current() );

			return;
		}

		if(__background_thread_running != true) {			
			return;
		}

			//check if there are any messages from the background thread
		var _message : Dynamic = Thread.readMessage(false);

		if(_message != null) {			
			switch (_message) {
				case __audio_message_complete:

					var complete_event = new Event (Event.SOUND_COMPLETE);
						dispatchEvent (complete_event);

					return;

			} //switch message
		} //message != null

		__background_thread.sendMessage( __audio_message_check_complete );

	} //__ping_check_complete_thread

#end //audio_thread_disabled

	@:noCompletion function __run_check_complete() {

		if (lime_sound_channel_is_complete (__handle)) {
			
			__handle = null;
			
			if (__dataProvider != null) {
				
				__dynamicSoundCount--;
				
			}
						
			return true;
			
		}

		return false;

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
				
			#if audio_thread_disabled

				if(__run_check_complete()) {

					var complete_event = new Event (Event.SOUND_COMPLETE);
						dispatchEvent (complete_event);

				}

			#else

				if( __sound_instance != null && __sound_instance.__audio_type == flash.media.Sound.InternalAudioType.music ) {

					__ping_check_complete_thread();

				} else { //sound doesn't thread, only music

					if(__run_check_complete()) {

						var complete_event = new Event (Event.SOUND_COMPLETE);
							dispatchEvent (complete_event);

					} //if complete

				} //not music

			#end
			
			return false;
			
		} else {
			
			return true;
			
		}
		
	}
	
	
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