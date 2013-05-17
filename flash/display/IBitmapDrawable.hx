package flash.display;


import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;


interface IBitmapDrawable {
	
	
	@:noCompletion public function __drawToSurface (surface:Dynamic, matrix:Matrix, colorTransform:ColorTransform, blendMode:String, clipRect:Rectangle, smoothing:Bool):Void;
	
	
}