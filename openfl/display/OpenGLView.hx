package openfl.display;
#if (cpp || neko)

import flash.Lib;
import flash.geom.Matrix3D;
import openfl.gl.GL;
//import flash.gl.GLInstance;
class OpenGLView extends DirectRenderer 
{
	public static inline var CONTEXT_LOST = "glcontextlost";
	public static inline var CONTEXT_RESTORED = "glcontextrestored";

	public static var isSupported(get_isSupported, null):Bool;

	//var context:GLInstance;
	public function new() 
	{
		super("OpenGLView");
	}

	// Getters & Setters
	private static inline function get_isSupported():Bool 
	{
		return true;
	}
}

#end