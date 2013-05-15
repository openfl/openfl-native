package flash.filesystem;


import flash.events.EventDispatcher;
import flash.Lib;


class StorageVolumeInfo extends EventDispatcher {
	
	
	public static inline var isSupported = true;
	public static var storageVolumeInfo (get, null):StorageVolumeInfo;
	
	private static var __storageVolumeInfo:StorageVolumeInfo;
	
	private var __volumes:Array<StorageVolume>;
	
	
	private function new () {
		
		super ();
		
		__volumes = [];
		nme_filesystem_get_volumes (__volumes, function (args:Array<Dynamic>) {
			return new StorageVolume (new File (args[0]), args[1], args[2], args[3], args[4], args[5]);
		});
		
	}
	
	
	public function getStorageVolumes ():Array<StorageVolume> {
		
		return volumes.copy ();
		
	}
	
	
	public static function getInstance ():StorageVolumeInfo {
		
		if (__storageVolumeInfo == null) {
			
			__storageVolumeInfo = new StorageVolumeInfo ();
			
		}
		
		return __storageVolumeInfo;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_storageVolumeInfo ():StorageVolumeInfo { return getInstance (); }
	
	
	
	
	// Native Methods
	
	
	
	
	private static var nme_filesystem_get_volumes = Lib.load ("nme", "nme_filesystem_get_volumes", 2);
	
	
	
	
}