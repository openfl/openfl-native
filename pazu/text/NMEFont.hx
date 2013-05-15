package pazu.text;


import flash.display.BitmapData;


class NMEFont {
	
	
	private static var factories = new Map<String, NMEFontFactory> ();
	
	private var ascent:Int;
	private var descent:Int;
	private var height:Int;
	private var isRGB:Bool;
	
	
	public function new (height:Int, ascent:Int, descent:Int, isRGB:Bool) {
		
		this.height = height;
		this.ascent = ascent;
		this.descent = descent;
		this.isRGB = isRGB;
		
	}
	
	
	private static function createFont (definition:NMEFontDef):NMEFont {
		
		if (factories.exists (definition.name)) {
			
			return factories.get (definition.name) (definition);
			
		}
		
		return null;
		
	}
	
	
	public function getGlyphInfo (char:Int):NMEGlyphInfo {
		
		trace ("Warning: You should override getGlyphInfo");
		return null;
		
	}
	
	
	static public function registerFont (name:String, factory:NMEFontFactory):Void {
		
		factories.set (name, factory);
		
		var register = Lib.load ("nme", "nme_font_set_factory", 1);
		register (createFont);
		
	}
	
	
	public function renderGlyph (char:Int):BitmapData {
		
		trace ("Warning: You should override renderGlyph");
		return new BitmapData (1, 1);
		
	}
	
	
	private function renderGlyphInternal (char:Int):Dynamic {
		
		var result = renderGlyph (char);
		
		if (result != null) {
			
			return result.__handle;
			
		}
		
		return null;
		
	}
	
	
}


typedef NMEFontDef = {
	
	name:String,
	height:Int,
	bold:Bool,
	italic:Bool,
	
};


typedef NMEFontFactory = NMEFontDef -> NMEFont;


typedef NMEGlyphInfo = {
	
	width:Int,
	height:Int,
	advance:Int,
	offsetX:Int,
	offsetY:Int,
	
};