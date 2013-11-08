#include <Graphics.h>
#include "renderer/common/Surface.h"


namespace nme {
	
	
	const uint8 *BitmapCache::DestRow (int inRow) const {
		
		return mBitmap->Row (inRow-(mRect.y+mTY)) - mBitmap->BytesPP () * (mRect.x + mTX);
		
	}
	
	
	PixelFormat BitmapCache::Format () const {
		
		return mBitmap->Format ();
		
	}
	
	
	const uint8 *BitmapCache::Row (int inRow) const {
		
		return mBitmap->Row (inRow);
		
	}
	
	
}
