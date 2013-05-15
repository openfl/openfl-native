package flash.filters;


class ColorMatrixFilter extends BitmapFilter {
	
	
	private var matrix:Array<Float>;
	
	
	public function new (matrix:Array<Float>) {
		
		super ("ColorMatrixFilter");
	  
		this.matrix = matrix;
		
	}
	
	
	override public function clone ():BitmapFilter {
		
		return new ColorMatrixFilter (matrix);
		
	}
	
	
}