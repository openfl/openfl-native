package flash.ui;


import flash.Lib;


class Mouse {
	
	
	public static function hide ():Void {
		
		if (Lib.stage != null) {
			
			Lib.stage.showCursor (false);
			
		}
		
	}
	
	
	public static function show ():Void {
		
		if (Lib.stage != null) {
			
			Lib.stage.showCursor (true);
			
		}
		
	}
	
	
}