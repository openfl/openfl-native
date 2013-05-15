package flash.filters;


class GlowFilter extends DropShadowFilter {
	
	
	public function new (color:Int = 0, alpha:Float = 1.0, blurX:Float = 6.0, blurY:Float = 6.0, strength:Float = 2.0, quality:Int = 1, inner:Bool = false, knockout:Bool = false) {
		
		super (0, 0, color, alpha, blurX, blurY, strength, quality, inner, knockout, false);
		
	}
	
	
}