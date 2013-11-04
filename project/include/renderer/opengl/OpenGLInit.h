#ifndef RENDERER_OPENGL_INIT_H
#define RENDERER_OPENGL_INIT_H


#ifdef NEED_EXTENSIONS
#define DEFINE_EXTENSION
#include "renderer/opengl/OGLExtensions.h"
#undef DEFINE_EXTENSION
#endif

#include "OpenGLContext.h"
#include "OpenGL2Context.h"


namespace nme {
	
	
	bool HasShaderSupport ();
	void InitExtensions ();
	void ResetHardwareContext ();
	#ifdef NME_USE_VBO
	void ReleaseVertexBufferObject (unsigned int inVBO);
	#endif
	
	
}


#endif
