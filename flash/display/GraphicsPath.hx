package flash.display;


import flash.Lib;


class GraphicsPath extends IGraphicsData {
	
	
	public var commands (get, set):Array<Int>;
	public var data (get, set):Array<Float>;
	
	
	public function new (commands:Array<Int> = null, data:Array<Float> = null, winding:String = GraphicsPathWinding.EVEN_ODD) {
		
		super (nme_graphics_path_create (commands, data, winding == GraphicsPathWinding.EVEN_ODD));
		
	}
	
	
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void {
		
		nme_graphics_path_curve_to (__handle, controlX, controlY, anchorX, anchorY);
		
	}
	
	
	public function lineTo (x:Float, y:Float):Void {
		
		nme_graphics_path_line_to (__handle, x, y);
		
	}
	
	
	public function moveTo (x:Float, y:Float):Void {
		
		nme_graphics_path_move_to (__handle, x, y);
		
	}
	
	
	public function wideLineTo (x:Float, y:Float):Void {
		
		nme_graphics_path_wline_to (__handle, x, y);
		
	}
	
	
	public function wideMoveTo (x:Float, y:Float):Void {
		
		nme_graphics_path_wmove_to (__handle, x, y);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_commands ():Array<Int> {
		
		var value = new Array<Int> ();
		nme_graphics_path_get_commands (__handle, value);
		return value;
		
	}
	
	
	private function set_commands (value:Array<Int>):Array<Int> {
		
		nme_graphics_path_set_commands (__handle, value);
		return value;
		
	}
	
	
	private function get_data ():Array<Float> {
		
		var value = new Array<Float> ();		
		nme_graphics_path_get_data (__handle, value);
		return value;
		
	}

	private function set_data (value:Array<Float>):Array<Float> {
		
		nme_graphics_path_set_data (__handle, value);	
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var nme_graphics_path_create = Lib.load ("nme", "nme_graphics_path_create", 3);
	private static var nme_graphics_path_curve_to = Lib.load ("nme", "nme_graphics_path_curve_to", 5);
	private static var nme_graphics_path_line_to = Lib.load ("nme", "nme_graphics_path_line_to", 3);
	private static var nme_graphics_path_move_to = Lib.load ("nme", "nme_graphics_path_move_to", 3);
	private static var nme_graphics_path_wline_to = Lib.load ("nme", "nme_graphics_path_wline_to", 3);
	private static var nme_graphics_path_wmove_to = Lib.load ("nme", "nme_graphics_path_wmove_to", 3);
	private static var nme_graphics_path_get_commands = Lib.load ("nme", "nme_graphics_path_get_commands", 2);
	private static var nme_graphics_path_set_commands = Lib.load ("nme", "nme_graphics_path_set_commands", 2);
	private static var nme_graphics_path_get_data = Lib.load ("nme", "nme_graphics_path_get_data", 2);
	private static var nme_graphics_path_set_data = Lib.load ("nme", "nme_graphics_path_set_data", 2);
	
	
}