package pazu.ui;


import flash.Lib;


class Accelerometer {
	
	
	public static function get ():Acceleration {
		
		return nme_input_get_acceleration ();
		
	}
	
	
	private static var nme_input_get_acceleration = Lib.load ("nme", "nme_input_get_acceleration", 0);
	
	
}