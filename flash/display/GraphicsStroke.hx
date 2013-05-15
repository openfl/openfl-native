package flash.display;


import flash.Lib;


class GraphicsStroke extends IGraphicsData {
	
	
	public function new (thickness:Null<Float> = null, pixelHinting:Bool = false, scaleMode:LineScaleMode = null, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Float = 3, fill:IGraphicsData = null) {
		
		super (nme_graphics_stroke_create (thickness, pixelHinting, scaleMode == null ? 0 : Type.enumIndex (scaleMode), caps == null ? 0 : Type.enumIndex (caps), joints == null ? 0 : Type.enumIndex (joints), miterLimit, fill == null ? null : fill.__handle));
		
	}
	
	
	private static var nme_graphics_stroke_create = Lib.load ("nme", "nme_graphics_stroke_create", -1);
	
	
}