#if (!macro || !haxe3)
import pazu.Assets;


class ApplicationMain
{
	
	public static function main()
	{
		flash.Lib.setPackage("::APP_COMPANY::", "::APP_FILE::", "::APP_PACKAGE::", "::APP_VERSION::");
		::if (sslCaCert != "")::
		flash.net.URLLoader.initialize(nme.installer.Assets.getResourceName("::sslCaCert::"));
		::end::
		
		flash.display.Stage.shouldRotateInterface = function(orientation:Int):Bool
		{
			::if (WIN_ORIENTATION == "portrait")::
			if (orientation == flash.display.Stage.OrientationPortrait || orientation == flash.display.Stage.OrientationPortraitUpsideDown)
			{
				return true;
			}
			return false;
			::elseif (WIN_ORIENTATION == "landscape")::
			if (orientation == flash.display.Stage.OrientationLandscapeLeft || orientation == flash.display.Stage.OrientationLandscapeRight)
			{
				return true;
			}
			return false;
			::else::
			return true;
			::end::
		}
		
		flash.Lib.create(function()
			{
				//if (::WIN_WIDTH:: == 0 && ::WIN_HEIGHT:: == 0)
				//{
					flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
					flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
				//}
				
				flash.Lib.current.loaderInfo = flash.display.LoaderInfo.create (null);
				
				//flash.Lib.current.stage.addEventListener (flash.events.Event.RESIZE, initialize);
				initialize ();
			},
			::WIN_WIDTH::, ::WIN_HEIGHT::,
			::WIN_FPS::,
			::WIN_BACKGROUND::,
			(::WIN_HARDWARE:: ? flash.Lib.HARDWARE : 0) |
			(::WIN_ALLOW_SHADERS:: ? flash.Lib.ALLOW_SHADERS : 0) |
			(::WIN_REQUIRE_SHADERS:: ? flash.Lib.REQUIRE_SHADERS : 0) |
			(::WIN_DEPTH_BUFFER:: ? flash.Lib.DEPTH_BUFFER : 0) |
			(::WIN_STENCIL_BUFFER:: ? flash.Lib.STENCIL_BUFFER : 0) |
			(::WIN_RESIZABLE:: ? flash.Lib.RESIZABLE : 0) |
			(::WIN_ANTIALIASING:: == 4 ? flash.Lib.HW_AA_HIRES : 0) |
			(::WIN_ANTIALIASING:: == 2 ? flash.Lib.HW_AA : 0),
			"::APP_TITLE::"
		);
		
	}
	
	
	private static function initialize ():Void
	{
		//flash.Lib.current.stage.removeEventListener (flash.events.Event.RESIZE, initialize);
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields(::APP_MAIN::))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod (::APP_MAIN::, Reflect.field (::APP_MAIN::, "main"), []);
		}
		else
		{
			flash.Lib.current.addChild(cast (Type.createInstance(DocumentClass, []), flash.display.DisplayObject));	
		}
	}
	
}


#if haxe3 @:build(DocumentClass.build()) #end
class DocumentClass extends ::APP_MAIN:: { }

#else

import haxe.macro.Context;
import haxe.macro.Expr;

class DocumentClass {
	
	macro public static function build ():Array<Field> {
		var classType = Context.getLocalClass().get();
		var searchTypes = classType;
		while (searchTypes.superClass != null) {
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				var fields = Context.getBuildFields();
				var method = macro {
					return flash.Lib.current.stage;
				}
				fields.push ({ name: "get_stage", access: [ APrivate, AOverride ], kind: FFun({ args: [], expr: method, params: [], ret: macro :flash.display.Stage }), pos: Context.currentPos() });
				return fields;
			}
			searchTypes = searchTypes.superClass.t.get();
		}
		return null;
	}
	
}
#end
