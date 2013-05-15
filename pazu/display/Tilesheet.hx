package pazu.display;


import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;


class Tilesheet {
	
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	public static inline var TILE_TRANS_2x2 = 0x0010;
	public static inline var TILE_BLEND_NORMAL = 0x00000000;
	public static inline var TILE_BLEND_ADD = 0x00010000;
	
	public var __bitmap:BitmapData;
	public var __handle:Dynamic;
	
	
	public function new (image:BitmapData) {
		
		__bitmap = image;
		__handle = nme_tilesheet_create (image.__handle);
		
	}
	
	
	public function addTileRect (rectangle:Rectangle, centerPoint:Point = null):Int {
		
		return nme_tilesheet_add_rect (__handle, rectangle, centerPoint);
		
	}
	
	
	public function drawTiles (graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0):Void {
		
		graphics.drawTiles (this, tileData, smooth, flags);
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var nme_tilesheet_create = Lib.load ("nme", "nme_tilesheet_create", 1);
	private static var nme_tilesheet_add_rect = Lib.load ("nme", "nme_tilesheet_add_rect", 3);
	
	
}