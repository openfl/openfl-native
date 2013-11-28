package openfl.utils;
#if (android)


import cpp.zip.Uncompress;
import flash.Lib;
import haxe.crypto.BaseCode;
import haxe.io.Bytes;


class JNI {
	
	
	private static var initialized = false;
	
	
	private static function init ():Void {
		
		if (!initialized) {
			
			initialized = true;
			var method = Lib.load ("lime", "lime_jni_init_callback", 1);
			method (onCallback);
			
		}
		
	}
	
	
	private static function onCallback (object:Dynamic, method:Dynamic, args:Dynamic):Dynamic {
		
		var field = Reflect.field (object, method);
		
		if (field != null) {
			
			return Reflect.callMethod (object, field, args);
			
		}
		
		trace ("onCallback - unknown field " + method);
		return null;
		
	}
	
	
	public static function createMemberField (className:String, memberName:String, signature:String):JNIMemberField {
		
		init ();
		
		return new JNIMemberField (lime_jni_create_field (className, memberName, signature, false));
		
	}
	
	
	public static function createMemberMethod (className:String, memberName:String, signature:String, useArray:Bool = false):Dynamic {
		
		init ();
		
		var method = new JNIMethod (lime_jni_create_method (className, memberName, signature, false));
		return method.getMemberMethod (useArray);
		
	}
	
	
	private static var alreadyCreated = new Map<String, Bool>();
	private static var base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

	public static function createInterface(haxeClass:Dynamic, className:String, classDef:String):Dynamic {
	    var bytes:Bytes = null;
	    if (!alreadyCreated.get(className)) {
	        bytes = Bytes.ofString(BaseCode.decode(classDef, base64));
	        bytes = Uncompress.run(bytes, 9);
	        alreadyCreated.set(className, true);
	    }
	    return null;
	    //return lime_jni_create_interface(haxeClass, className, bytes == null ? null : bytes.getData());
	}

	public static function createStaticField (className:String, memberName:String, signature:String):JNIStaticField {
		
		init ();
		
		return new JNIStaticField (lime_jni_create_field (className, memberName, signature, true));
		
	}
	
	
	public static function createStaticMethod (className:String, memberName:String, signature:String, useArray:Bool = false):Dynamic {
		
		init ();
		
		var method = new JNIMethod (lime_jni_create_method (className, memberName, signature, true));
		return method.getStaticMethod (useArray);
		
	}
	
	
	public static function getEnv ():Dynamic {
		
		init ();
		
		return lime_jni_get_env ();
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_jni_create_field = Lib.load ("lime", "lime_jni_create_field", 4);
	private static var lime_jni_create_method = Lib.load ("lime", "lime_jni_create_method", 4);
	private static var lime_jni_get_env = Lib.load ("lime", "lime_jni_get_env", 0);
	//private static var lime_jni_create_interface = Lib.load("lime", "lime_jni_create_interface", 3);
	
}


class JNIMemberField {
	
	
	private var field:Dynamic;
	
	
	public function new (field:Dynamic) {
		
		this.field = field;
		
	}
	
	
	public function get (jobject:Dynamic):Dynamic {
		
		return lime_jni_get_member (field, jobject);
		
	}
	
	
	public function set (jobject:Dynamic, value:Dynamic):Dynamic {
		
		lime_jni_set_member (field, jobject, value);
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_jni_get_member = Lib.load ("lime", "lime_jni_get_member", 2);
	private static var lime_jni_set_member = Lib.load ("lime", "lime_jni_set_member", 3);
	
	
}


class JNIStaticField {
	
	
	private var field:Dynamic;
	
	
	public function new (field:Dynamic) {
		
		this.field = field;
		
	}
	
	
	public function get ():Dynamic {
		
		return lime_jni_get_static (field);
		
	}
	
	
	public function set (value:Dynamic):Dynamic {
		
		lime_jni_set_static (field, value);
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_jni_get_static = Lib.load ("lime", "lime_jni_get_static", 1);
	private static var lime_jni_set_static = Lib.load ("lime", "lime_jni_set_static", 2);
	
	
}


class JNIMethod {
	
	
	private var method:Dynamic;
	
	
	public function new (method:Dynamic) {
		
		this.method = method;
		
	}

	public function callMember (args:Array<Dynamic>):Dynamic {
		
		var jobject = args.shift ();
		return lime_jni_call_member (method, jobject, args);
		
	}
	
	
	public function callStatic (args:Array<Dynamic>):Dynamic {
		
		return lime_jni_call_static (method, args);
		
	}
	
	
	public function getMemberMethod (useArray:Bool):Dynamic {
		
		if (useArray) {
			
			return callMember;
			
		} else {
			
			return Reflect.makeVarArgs (callMember);
			
		}
		
	}
	
	
	public function getStaticMethod (useArray:Bool):Dynamic {
		
		if (useArray) {
			
			return callStatic;
			
		} else {
			
			return Reflect.makeVarArgs (callStatic);
			
		}
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var lime_jni_call_member = Lib.load ("lime", "lime_jni_call_member", 3);
	private static var lime_jni_call_static = Lib.load ("lime", "lime_jni_call_static", 2);
	
	
}


#end
