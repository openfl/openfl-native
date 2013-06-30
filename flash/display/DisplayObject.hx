package flash.display;


import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.EventPhase;
import flash.filters.BitmapFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Transform;
import flash.Lib;


class DisplayObject extends EventDispatcher implements IBitmapDrawable {

	
	public var alpha (get, set):Float;
	public var blendMode (get, set):BlendMode;
	public var cacheAsBitmap (get, set):Bool;
	public var filters (get, set):Array<Dynamic>;
	public var graphics (get, null):Graphics;
	public var height (get, set):Float;
	public var loaderInfo:LoaderInfo;
	public var mask (default, set):DisplayObject;
	public var mouseX (get, null):Float;
	public var mouseY (get, null):Float;
	public var name (get, set):String;
	public var opaqueBackground (get, set):Null <Int>;
	public var parent (get, null):DisplayObjectContainer;
	public var pedanticBitmapCaching (get, set):Bool;
	public var pixelSnapping (get, set):PixelSnapping;
	public var rotation (get, set):Float;
	public var scale9Grid (get, set):Rectangle;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	public var scrollRect (get, set):Rectangle;
	public var stage (get, null):Stage;
	public var transform (get, set):Transform;
	public var visible (get, set):Bool;
	public var width (get, set):Float;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	@:noCompletion public var __handle:Dynamic;
	@:noCompletion private var __filters:Array<Dynamic>;
	@:noCompletion private var __graphicsCache:Graphics;
	@:noCompletion private var __id:Int;
	@:noCompletion private var __parent:DisplayObjectContainer;
	@:noCompletion private var __scale9Grid:Rectangle;
	@:noCompletion private var __scrollRect:Rectangle;
	
	
	public function new (handle:Dynamic, type:String) {
		
		super (this);
		
		__parent = null;
		__handle = handle;
		__id = nme_display_object_get_id (__handle);
		this.name = type + " " + __id;
		
	}
	
	
	override public function dispatchEvent (event:Event):Bool {
		
		var result = __dispatchEvent (event);
		
		if (event.__getIsCancelled ())
			return true;
		
		if (event.bubbles && parent != null) {
			
			parent.dispatchEvent (event);
			
		}
		
		return result;
		
	}
	
	
	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle {
		
		var result = new Rectangle ();
		nme_display_object_get_bounds (__handle, targetCoordinateSpace.__handle, result, true);
		return result;
		
	}
	
	
	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle {
		
		var result = new Rectangle ();
		nme_display_object_get_bounds (__handle, targetCoordinateSpace.__handle, result, false);
		return result;
		
	}
	
	
	public function globalToLocal (point:Point):Point {
		
		var result = point.clone ();
		nme_display_object_global_to_local (__handle, result);
		return result;
		
	}
	
	
	public function hitTestObject (object:DisplayObject):Bool {
		
		if (object != null && object.parent != null && parent != null) {
			
			var currentMatrix = transform.concatenatedMatrix;
			var targetMatrix = object.transform.concatenatedMatrix;
			
			var xPoint = new Point (1, 0);
			var yPoint = new Point (0, 1);
			
			var currentWidth = width * currentMatrix.deltaTransformPoint (xPoint).length;
			var currentHeight = height * currentMatrix.deltaTransformPoint (yPoint).length;
			var targetWidth = object.width * targetMatrix.deltaTransformPoint (xPoint).length;
			var targetHeight = object.height * targetMatrix.deltaTransformPoint (yPoint).length;
			
			var currentRect = new Rectangle (currentMatrix.tx, currentMatrix.ty, currentWidth, currentHeight);
			var targetRect = new Rectangle (targetMatrix.tx, targetMatrix.ty, targetWidth, targetHeight);
			
			return currentRect.intersects (targetRect);
			
		}
		
		return false;
		
	}
	
	
	public function hitTestPoint (x:Float, y:Float, shapeFlag:Bool = false):Bool {
		
		return nme_display_object_hit_test_point (__handle, x, y, shapeFlag, true);
		
	}
	
	
	public function localToGlobal (point:Point):Point {
		
		var result = point.clone ();
		nme_display_object_local_to_global (__handle, result);
		return result;
		
	}
	
	
	public override function toString ():String {
		
		return name;
		
	}
	
	
	@:noCompletion private function __asInteractiveObject ():InteractiveObject {
		
		return null;
		
	}
	
	
	@:noCompletion public function __broadcast (event:Event):Void {
		
		__dispatchEvent (event);
		
	}
	
	
	@:noCompletion public function __dispatchEvent (event:Event):Bool {
		
		if (event.target == null) {
			
			event.target = this;
			
		}
		
		event.currentTarget = this;
		return super.dispatchEvent (event);
		
	}
	
	
	@:noCompletion public function __drawToSurface (surface:Dynamic, matrix:Matrix, colorTransform:ColorTransform, blendMode:String, clipRect:Rectangle, smoothing:Bool):Void {
		
		nme_display_object_draw_to_surface (__handle, surface, matrix, colorTransform, blendMode, clipRect);
		
	}
	
	
	@:noCompletion private function __findByID (id:Int):DisplayObject {
		
		if (__id == id) {
			
			return this;
			
		}
		
		return null;
		
	}
	
	
	@:noCompletion private function __fireEvent (event:Event):Void {
		
		var stack:Array<InteractiveObject> = [];
		
		if (__parent != null) {
			
			__parent.__getInteractiveObjectStack (stack);
			
		}
		
		if (stack.length > 0) {
			
			event.__setPhase (EventPhase.CAPTURING_PHASE);
			stack.reverse ();
			
			for (object in stack) {
				
				event.currentTarget = object;
				object.__dispatchEvent (event);
				
				if (event.__getIsCancelled ()) {
					
					return;
					
				}
				
			}
			
		}
		
		event.__setPhase (EventPhase.AT_TARGET);
		event.currentTarget = this;
		__dispatchEvent (event);
		
		if (event.__getIsCancelled ()) {
			
			return;
			
		}
		
		if (event.bubbles) {
			
			event.__setPhase (EventPhase.BUBBLING_PHASE);
			stack.reverse ();
			
			for (object in stack) {
				
				event.currentTarget = object;
				object.__dispatchEvent (event);
				
				if (event.__getIsCancelled ()) {
					
					return;
					
				}
				
			}
			
		}
		
	}
	
	
	@:noCompletion public function __getColorTransform ():ColorTransform {
		
		var colorTransform = new ColorTransform ();
		nme_display_object_get_color_transform (__handle, colorTransform, false);
		return colorTransform;
		
	}
	
	
	@:noCompletion public function __getConcatenatedColorTransform ():ColorTransform {
		
		var colorTransform = new ColorTransform();
		nme_display_object_get_color_transform (__handle, colorTransform, true);
		return colorTransform;
		
	}
	
	
	@:noCompletion public function __getConcatenatedMatrix ():Matrix {
		
		var matrix = new Matrix();
		nme_display_object_get_matrix (__handle, matrix, true);
		return matrix;
		
	}
	
	
	@:noCompletion public function __getInteractiveObjectStack (stack:Array<InteractiveObject>):Void {
		
		var interactive = __asInteractiveObject ();
		
		if (interactive != null) {
			
			stack.push (interactive);
			
		}
		
		if (__parent != null) {
			
			__parent.__getInteractiveObjectStack (stack);
			
		}
		
	}
	
	
	@:noCompletion public function __getMatrix ():Matrix {
		
		var matrix = new Matrix ();
		nme_display_object_get_matrix (__handle, matrix, false);
		return matrix;
		
	}
	
	
	@:noCompletion public function __getObjectsUnderPoint (point:Point, result:Array<DisplayObject>):Void {
		
		if (nme_display_object_hit_test_point (__handle, point.x, point.y, true, false)) {
			
			result.push (this);
			
		}
		
	}
	
	
	@:noCompletion public function __getPixelBounds ():Rectangle {
		
		var bounds = new Rectangle();
		nme_display_object_get_pixel_bounds (__handle, bounds);
		return bounds;
		
	}
	
	
	@:noCompletion private function __onAdded (object:DisplayObject, isOnStage:Bool):Void {
		
		if (object == this) {
			
			var event = new Event (Event.ADDED, true, false);
			event.target = this;
			dispatchEvent (event);
			
		}
		
		if (isOnStage) {
			
			var event = new Event (Event.ADDED_TO_STAGE, false, false);
			event.target = object;
			dispatchEvent (event);
			
		}
		
	}
	
	
	@:noCompletion private function __onRemoved (object:DisplayObject, wasOnStage:Bool):Void {
		
		if (object == this) {
			
			var event = new Event (Event.REMOVED, true, false);
			event.target = this;
			dispatchEvent (event);
			
		}
		
		if (wasOnStage) {
			
			var event = new Event (Event.REMOVED_FROM_STAGE, false, false);
			event.target = object;
			dispatchEvent (event);
			
		}
		
	}
	
	
	@:noCompletion public function __setColorTransform (colorTransform:ColorTransform):Void {
		
		nme_display_object_set_color_transform (__handle, colorTransform);
		
	}
	
	
	@:noCompletion public function __setMatrix (matrix:Matrix):Void {
		
		nme_display_object_set_matrix (__handle, matrix);
		
	}
	
	
	@:noCompletion public function __setParent (parent:DisplayObjectContainer):DisplayObjectContainer {
		
		if (parent == __parent) {
			
			return parent;
			
		}
		
		if (__parent != null) {
			
			__parent.__removeChildFromArray (this);
			
		}
		
		if (__parent == null && parent != null) {
			
			__parent = parent;
			__onAdded (this, (stage != null));
			
		} else if (__parent != null && parent == null) {
			
			var wasOnStage = (stage != null);
			__parent = parent;
			__onRemoved (this, wasOnStage);
			
		} else {
			
			__parent = parent;
			
		}
		
		return parent;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private function get_alpha ():Float { return nme_display_object_get_alpha (__handle); }
	private function set_alpha (value:Float):Float {
		
		nme_display_object_set_alpha (__handle, value);
		return value;
		
	}
	
	
	private function get_opaqueBackground ():Null<Int> {
		
		var i:Int = nme_display_object_get_bg (__handle);
		
		if ((i & 0x01000000) == 0) {
			
			return null;
			
		}
		
		return i & 0xffffff;
		
	}
	
	
	private function set_opaqueBackground (value:Null<Int>):Null<Int> {
		
		if (value == null) {
			
			nme_display_object_set_bg (__handle, 0);
			
		} else {
			
			nme_display_object_set_bg (__handle, value);
			
		}
		
		return value;
		
	}
	
	
	private function get_blendMode ():BlendMode {
		
		var i:Int = nme_display_object_get_blend_mode (__handle);
		return Type.createEnumIndex (BlendMode, i);
		
	}
	
	
	private function set_blendMode (value:BlendMode):BlendMode {
		
		nme_display_object_set_blend_mode (__handle, Type.enumIndex (value));
		return value;
		
	}
	
	
	private function get_cacheAsBitmap ():Bool { return nme_display_object_get_cache_as_bitmap (__handle); }
	private function set_cacheAsBitmap (value:Bool):Bool {
		
		nme_display_object_set_cache_as_bitmap (__handle, value);
		return value;
		
	}
	
	
	private function get_pedanticBitmapCaching ():Bool { return nme_display_object_get_pedantic_bitmap_caching (__handle); }
	private function set_pedanticBitmapCaching (value:Bool):Bool {
		
		nme_display_object_set_pedantic_bitmap_caching (__handle, value);
		return value;
		
	}
	
	
	private function get_pixelSnapping ():PixelSnapping {
		
		var i:Int = nme_display_object_get_pixel_snapping (__handle);
		return Type.createEnumIndex (PixelSnapping, i);
		
	}
	
	
	private function set_pixelSnapping (value:PixelSnapping):PixelSnapping {
		
		if (value == null) {
			
			nme_display_object_set_pixel_snapping (__handle, 0);
			
		} else {
			
			nme_display_object_set_pixel_snapping (__handle, Type.enumIndex (value));
			
		}
		
		return value;
		
	}
	
	
	private function get_filters ():Array<Dynamic> {
		
		if (__filters == null) return [];
		var result = new Array<Dynamic> ();
		
		for (filter in __filters) {
			
			result.push (filter.clone ());
			
		}
		
		return result;
		
	}
	
	
	private function set_filters (value:Array<Dynamic>):Array<Dynamic> {
		
		if (filters == null || value == null) {
			
			__filters = null;
			
		} else {
			
			__filters = new Array<Dynamic> ();
			
			for (filter in value) {
				
				__filters.push (filter.clone ());
				
			}
			
		}
		
		nme_display_object_set_filters (__handle, __filters);
		return filters;
		
	}
	
	
	private function get_graphics ():Graphics {
		
		if (__graphicsCache == null) {
			
			__graphicsCache = new Graphics (nme_display_object_get_graphics (__handle));
			
		}
		
		return __graphicsCache;
		
	}
	
	
	private function get_height ():Float { return nme_display_object_get_height (__handle); }
	private function set_height (value:Float):Float {
		
		nme_display_object_set_height (__handle, value);
		return value;
		
	}
	
	
	private function set_mask (value:DisplayObject):DisplayObject {
		
		mask = value;
		nme_display_object_set_mask (__handle, value == null ? null : value.__handle);
		return value;
		
	}
	
	
	private function get_mouseX ():Float { return nme_display_object_get_mouse_x (__handle); }
	private function get_mouseY ():Float { return nme_display_object_get_mouse_y (__handle); }
	
	
	private function get_name ():String { return nme_display_object_get_name (__handle); }
	private function set_name (value:String):String {
		
		nme_display_object_set_name (__handle, value);
		return value;
		
	}
	
	
	private function get_parent ():DisplayObjectContainer { return __parent; }
	
	
	private function get_rotation ():Float { return nme_display_object_get_rotation (__handle); }
	private function set_rotation (value:Float):Float {
		
		nme_display_object_set_rotation (__handle, value);
		return value;
		
	}
	
	
	private function get_scale9Grid ():Rectangle { return (__scale9Grid == null) ? null : __scale9Grid.clone (); }
	private function set_scale9Grid (value:Rectangle):Rectangle {
		
		__scale9Grid = (value == null) ? null : value.clone ();
		nme_display_object_set_scale9_grid (__handle, __scale9Grid);
		return value;
		
	}
	
	
	private function get_scaleX ():Float { return nme_display_object_get_scale_x (__handle); }
	private function set_scaleX (value:Float):Float {
		
		nme_display_object_set_scale_x (__handle, value);
		return value;
		
	}
	
	
	private function get_scaleY ():Float { return nme_display_object_get_scale_y (__handle); }
	private function set_scaleY (value:Float):Float {
		
		nme_display_object_set_scale_y (__handle, value);
		return value;
		
	}
	
	
	private function get_scrollRect ():Rectangle { return (__scrollRect == null) ? null : __scrollRect.clone (); }
	private function set_scrollRect (value:Rectangle):Rectangle {
		
		__scrollRect = (value == null) ? null : value.clone ();
		nme_display_object_set_scroll_rect (__handle, __scrollRect);
		return value;
		
	}
	
	
	private function get_stage ():Stage {
		
		if (__parent != null) {
			
			return __parent.stage;
			
		}
		
		return null;
		
	}
	
	
	private function get_transform ():Transform { return new Transform (this); }
	private function set_transform (value:Transform):Transform {
		
		__setMatrix (value.matrix);
		__setColorTransform (value.colorTransform);
		return value;
		
	}
	
	
	private function get_visible ():Bool { return nme_display_object_get_visible (__handle);	}
	private function set_visible (value:Bool):Bool {
		
		nme_display_object_set_visible (__handle, value);
		return value;
		
	}
	
	
	private function get_width ():Float { return nme_display_object_get_width (__handle); }
	private function set_width (value:Float):Float {
		
		nme_display_object_set_width (__handle, value);
		return value;
		
	}
	
	
	private function get_x ():Float { return nme_display_object_get_x (__handle); }
	private function set_x (value:Float):Float {
		
		nme_display_object_set_x (__handle, value);
		return value;
		
	}
	
	
	private function get_y ():Float { return nme_display_object_get_y (__handle); }
	private function set_y (value:Float):Float {
		
		nme_display_object_set_y (__handle, value);
		return value;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	private static var nme_create_display_object = Lib.load ("nme", "nme_create_display_object", 0);
	private static var nme_display_object_get_graphics = Lib.load ("nme", "nme_display_object_get_graphics", 1);
	private static var nme_display_object_draw_to_surface = Lib.load ("nme", "nme_display_object_draw_to_surface", -1);
	private static var nme_display_object_get_id = Lib.load ("nme", "nme_display_object_get_id", 1);
	private static var nme_display_object_get_x = Lib.load ("nme", "nme_display_object_get_x", 1);
	private static var nme_display_object_set_x = Lib.load ("nme", "nme_display_object_set_x", 2);
	private static var nme_display_object_get_y = Lib.load ("nme", "nme_display_object_get_y", 1);
	private static var nme_display_object_set_y = Lib.load ("nme", "nme_display_object_set_y", 2);
	private static var nme_display_object_get_scale_x = Lib.load ("nme", "nme_display_object_get_scale_x", 1);
	private static var nme_display_object_set_scale_x = Lib.load ("nme", "nme_display_object_set_scale_x", 2);
	private static var nme_display_object_get_scale_y = Lib.load ("nme", "nme_display_object_get_scale_y", 1);
	private static var nme_display_object_set_scale_y = Lib.load ("nme", "nme_display_object_set_scale_y", 2);
	private static var nme_display_object_get_mouse_x = Lib.load ("nme", "nme_display_object_get_mouse_x", 1);
	private static var nme_display_object_get_mouse_y = Lib.load ("nme", "nme_display_object_get_mouse_y", 1);
	private static var nme_display_object_get_rotation = Lib.load ("nme", "nme_display_object_get_rotation", 1);
	private static var nme_display_object_set_rotation = Lib.load ("nme", "nme_display_object_set_rotation", 2);
	private static var nme_display_object_get_bg = Lib.load ("nme", "nme_display_object_get_bg", 1);
	private static var nme_display_object_set_bg = Lib.load ("nme", "nme_display_object_set_bg", 2);
	private static var nme_display_object_get_name = Lib.load ("nme", "nme_display_object_get_name", 1);
	private static var nme_display_object_set_name = Lib.load ("nme", "nme_display_object_set_name", 2);
	private static var nme_display_object_get_width = Lib.load ("nme", "nme_display_object_get_width", 1);
	private static var nme_display_object_set_width = Lib.load ("nme", "nme_display_object_set_width", 2);
	private static var nme_display_object_get_height = Lib.load ("nme", "nme_display_object_get_height", 1);
	private static var nme_display_object_set_height = Lib.load ("nme", "nme_display_object_set_height", 2);
	private static var nme_display_object_get_alpha = Lib.load ("nme", "nme_display_object_get_alpha", 1);
	private static var nme_display_object_set_alpha = Lib.load ("nme", "nme_display_object_set_alpha", 2);
	private static var nme_display_object_get_blend_mode = Lib.load ("nme", "nme_display_object_get_blend_mode", 1);
	private static var nme_display_object_set_blend_mode = Lib.load ("nme", "nme_display_object_set_blend_mode", 2);
	private static var nme_display_object_get_cache_as_bitmap = Lib.load ("nme", "nme_display_object_get_cache_as_bitmap", 1);
	private static var nme_display_object_set_cache_as_bitmap = Lib.load ("nme", "nme_display_object_set_cache_as_bitmap", 2);
	private static var nme_display_object_get_pedantic_bitmap_caching = Lib.load ("nme", "nme_display_object_get_pedantic_bitmap_caching", 1);
	private static var nme_display_object_set_pedantic_bitmap_caching = Lib.load ("nme", "nme_display_object_set_pedantic_bitmap_caching", 2);
	private static var nme_display_object_get_pixel_snapping = Lib.load ("nme", "nme_display_object_get_pixel_snapping", 1);
	private static var nme_display_object_set_pixel_snapping = Lib.load ("nme", "nme_display_object_set_pixel_snapping", 2);
	private static var nme_display_object_get_visible = Lib.load ("nme", "nme_display_object_get_visible", 1);
	private static var nme_display_object_set_visible = Lib.load ("nme", "nme_display_object_set_visible", 2);
	private static var nme_display_object_set_filters = Lib.load ("nme", "nme_display_object_set_filters", 2);
	private static var nme_display_object_global_to_local = Lib.load ("nme", "nme_display_object_global_to_local", 2);
	private static var nme_display_object_local_to_global = Lib.load ("nme", "nme_display_object_local_to_global", 2);
	private static var nme_display_object_set_scale9_grid = Lib.load ("nme", "nme_display_object_set_scale9_grid", 2);
	private static var nme_display_object_set_scroll_rect = Lib.load ("nme", "nme_display_object_set_scroll_rect", 2);
	private static var nme_display_object_set_mask = Lib.load ("nme", "nme_display_object_set_mask", 2);
	private static var nme_display_object_set_matrix = Lib.load ("nme", "nme_display_object_set_matrix", 2);
	private static var nme_display_object_get_matrix = Lib.load ("nme", "nme_display_object_get_matrix", 3);
	private static var nme_display_object_get_color_transform = Lib.load ("nme", "nme_display_object_get_color_transform", 3);
	private static var nme_display_object_set_color_transform = Lib.load ("nme", "nme_display_object_set_color_transform", 2);
	private static var nme_display_object_get_pixel_bounds = Lib.load ("nme", "nme_display_object_get_pixel_bounds", 2);
	private static var nme_display_object_get_bounds = Lib.load ("nme", "nme_display_object_get_bounds", 4);
	private static var nme_display_object_hit_test_point = Lib.load ("nme", "nme_display_object_hit_test_point", 5);
	
	
}