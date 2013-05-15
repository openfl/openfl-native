package flash.display;


import flash.Lib;


class GraphicsEndFill extends IGraphicsData {
	
	
	public function new () {
		
		super (nme_graphics_end_fill_create ());
		
	}
	
	
	private static var nme_graphics_end_fill_create = Lib.load ("nme", "nme_graphics_end_fill_create", 0);
	
	
}