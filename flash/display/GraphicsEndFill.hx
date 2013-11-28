package flash.display;


import flash.Lib;


class GraphicsEndFill extends IGraphicsData {
	
	
	public function new () {
		
		super (lime_graphics_end_fill_create ());
		
	}
	
	
	private static var lime_graphics_end_fill_create = Lib.load ("lime", "lime_graphics_end_fill_create", 0);
	
	
}