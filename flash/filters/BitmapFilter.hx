package flash.filters;


class BitmapFilter {
	
	
	private var type:String;
	
	
	public function new (type:String) {
		
		this.type = type;
		
	}
	
	
	public function clone ():BitmapFilter {
		
		throw ("clone not implemented");
		return null;
		
	}
	
	
}