package flash.media;


import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.SampleDataEvent;
import flash.Lib;

#if !audio_thread_disabled 
	#if cpp
		import cpp.vm.Thread;
		import cpp.vm.Mutex;
	#end
	#if neko
		import neko.vm.Thread;
		import neko.vm.Mutex;
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
			if( __sound_instance != null && __sound_instance.__audio_type == flash.media.Sound.InternalAudioType.music ) {
				_audio_state.remove(this);				
			}
		#end //audio_thread_disabled

		lime_sound_channel_stop (__handle);
		__handle = null;
		
	}
	
#if !audio_thread_disabled

		@:noCompletion private static var _audio_thread_running : Bool = false;
		@:noCompletion public static var _audio_thread_is_idle : Bool = true;
		@:noCompletion private static var _audio_message_check_complete = 1;
		@:noCompletion public static var _audio_state : AudioThreadState;

	@:noCompletion private static function __check_complete_background_thread() {		

		var _last_complete = false;

		while(_audio_thread_running) {			

			var thread_message : Dynamic = Thread.readMessage( false );

			if(thread_message == _audio_message_check_complete) {
					//check the status, firing events and otherwise
				_audio_state.check_complete();
			} //thread message == check complete
			
				//Now, if we are supposed to be updating 
			if(!_audio_thread_is_idle) {

					//Update the list of channels complete status
				_audio_state.update_complete();

					//10 ms sleep time, 
					//todo:should be configurable
				Sys.sleep( 0.01 );

			} else { //!idle

					//during idle we can sleep a bit longer
					//for cpu saving purpose

				Sys.sleep( 0.2 );
			}

		} //keep running

			//clean up
		_audio_thread_running = false;
		_audio_thread_is_idle = true;

	} //__check_complete_background_thread	

	@:noCompletion private static function _audio_create_state() {

		_audio_state = new AudioThreadState();

		_audio_thread_running = true;
		_audio_thread_is_idle = false;

		_audio_state.main_thread = Thread.current();
		_audio_state.audio_thread = Thread.create(__check_complete_background_thread);

	} //_audio_create_state

	@:noCompletion private static function _audio_thread_check( _sound_channel : SoundChannel ) {

			//If no background thread right now, create one
		if(_audio_state == null) {
			_audio_create_state();
		} //_audio_state == null

			//add it to the list
		_audio_state.add(_sound_channel);
			//Tell the thread to check the status
		_audio_state.audio_thread.sendMessage( _audio_message_check_complete );

	} //_audio_thread_check

#end //audio_thread_disabled	

	@:noCompletion public function __run_check_complete() : Bool {

		if (lime_sound_channel_is_complete (__handle)) {
			
			__handle = null;
			
			if (__dataProvider != null) {
				
				__dynamicSoundCount--;
				
			}
						
			return true;
			
		}

		return false;

	} //__run_check_complete
	
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

					_audio_thread_check( this );

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

	//This class will handle the state of the audio thread
	//and make sure that touching the items is safe from either thread.

class AudioThreadState {

	public var mutex:Mutex;
	public var channel_list : Map<SoundChannel, Bool>;

	public var audio_thread : Thread;
	public var main_thread : Thread;

	public function new(){ 
		mutex = new Mutex();
		channel_list = new Map();
	}

	public function add( _channel:SoundChannel ) {
		mutex.acquire();

			if(!channel_list.exists(_channel)) {
					//push into the list
				channel_list.set(_channel, false);
					//can never be idle when adding sounds
				SoundChannel._audio_thread_is_idle = false;
			} //if doesn't exist in list

		mutex.release();
	} //add

	public function remove( _channel:SoundChannel ) {
		mutex.acquire();

			if(channel_list.exists(_channel)) {

				channel_list.remove(_channel);			
				if(Lambda.count(channel_list) == 0) {
					SoundChannel._audio_thread_is_idle = true;
				}	

			} //if exists in list
			
		mutex.release();
	} //remove

	public function check_complete() {
		
		for(_channel in channel_list.keys()) {
			var is_complete = channel_list.get(_channel);

			if(is_complete) {

				var complete_event = new Event (Event.SOUND_COMPLETE);
					_channel.dispatchEvent (complete_event);

				mutex.acquire();
					channel_list.remove(_channel);
				mutex.release();
			} //if channel is complete
		} //for each channel in list
			
	} //check complete

	public function update_complete() {

		mutex.acquire();

				//run over the list and check if they are complete
			for(_channel in channel_list.keys()) {
				channel_list.set( _channel, _channel.__run_check_complete() );
			}

		mutex.release();

	} //update complete

} //AudioThreadState