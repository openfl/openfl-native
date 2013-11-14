#include <Display.h>
#include "platform/tizen/TizenUIApp.h"
#include "renderer/common/Surface.h"
#include "renderer/common/HardwareSurface.h"
#include "renderer/common/HardwareContext.h"
#include <KeyCodes.h>
#include <FApp.h>
#include <FBase.h>
#include <stdio.h>

//using namespace Tizen::Base;
//using namespace Tizen::Base::Collection;



/*extern "C" {
	
	
	//extern int main (int argc, char* argv[]);
	Tizen::Base::Collection::ArrayList args;
	
	
	int _EXPORT_ OspMain (int argc, char* pArgv[]) {
		
		FILE *pFile = fopen ("/tmp/help.txt","w");
		fprintf(pFile, "LDKFJLDKJF");
		fclose(pFile);
		
		AppLog("Application started!!!!!!.");
		
		Tizen::Base::Collection::ArrayList args (Tizen::Base::Collection::SingleObjectDeleter);
		args.Construct ();
		
		for (int i = 0; i < argc; i++) {
			
			args.Add (new (std::nothrow) Tizen::Base::String (pArgv[i]));
			
		}
		//
		//AppLog("Application started.");
		//ArrayList args(SingleObjectDeleter);
		//args.Construct();
		//for (int i = 0; i < argc; i++)
		//{
			//args.Add(new (std::nothrow) String(pArgv[i]));
		//}
		//
		//result r = Tizen::App::UiApp::Execute(TizenGLSampleApp::CreateInstance, &args);
		//TryLog(r == E_SUCCESS, "[%s] Application execution failed.", GetErrorMessage(r));
		//AppLog("Application finished.");
		//
		//return static_cast< int >(r);
		
		result r = Tizen::App::UiApp::Execute(nme::TizenUIApp::CreateInstance, &args);
		
		while(true){
			
			AppLog("OY YO");
			
		}
		
		TryLog(r == E_SUCCESS, "[%s] Application execution failed.", GetErrorMessage(r));
		AppLog("Application finished.");
		
		return static_cast< int >(r);
		
		//return main (argc, pArgv);
		
	}
	
	
}*/


namespace nme {
	
	
	class TizenFrame;
	TizenFrame *sgTizenFrame;
	//#define MAX_JOYSTICKS 16
	
	
	class TizenStage : public Stage {
		
		public:
			
			
			TizenStage(/*Tizenwindow *inWindow,*/ int inWidth, int inHeight) : mOpenGLContext(0), mPrimarySurface(0) {
				
				//mWindow = inWindow;
				
				// size window for the first time
				//Resize (inWidth, inHeight);
				
			}
			
			
			~TizenStage () {
				
				mOpenGLContext->DecRef();
				mPrimarySurface->DecRef();
				
			}
			
			
			void SetCursor (Cursor inCursor) {
				
				switch (inCursor) {
					
					case curNone:
						break;
					case curPointer:
						break;
					case curHand:
						break;
				}
				
			}
			
			
			void GetMouse () {}
			
			
			Surface *GetPrimarySurface () {
				
				return mPrimarySurface;
				
			}
			
			
			bool isOpenGL () const { return true; }
			
			
			void Flip () {
				
				//glfwSwapBuffers (mWindow);
				
			}
			
			
			void Resize (const int inWidth, const int inHeight) {
				
				/*// Calling this recreates the gl context and we loose all our textures and
				// display lists. So Work around it.
				if (mOpenGLContext) {
					
					gTextureContextVersion++;
					mOpenGLContext->DecRef ();
					
				}
				
				mOpenGLContext = HardwareContext::CreateOpenGL (0, 0, true);
				mOpenGLContext->SetWindowSize (inWidth, inHeight);
				mOpenGLContext->IncRef ();
				
				if (mPrimarySurface) {
					
					mPrimarySurface->DecRef ();
					
				}
				
				mPrimarySurface = new HardwareSurface (mOpenGLContext);
				mPrimarySurface->IncRef ();*/
				
			}
			
			
			//Tizenwindow *mWindow;
			
		
		private:
			
			HardwareContext *mOpenGLContext;
			Surface *mPrimarySurface;
		
	};
	
	
	class TizenFrame : public Frame {
		
		public:
			
			TizenFrame (/*Tizenwindow *inSurface,*/ int inW, int inH) {
				
				mStage = new TizenStage (/*inSurface,*/ inW, inH);
				mStage->IncRef();
				// SetTimer(mHandle,timerFrame, 10,0);
				
			}
			
			
			~TizenFrame () {
				
				mStage->DecRef ();
				
			}
			
			
			void Resize (const int inWidth, const int inHeight) {
				
				mStage->Resize(inWidth, inHeight);
				
			}
			
			
			void SetTitle () {}
			void SetIcon () {}
			
			
			Stage *GetStage () {
				
				return mStage;
				
			}
			
			
			inline void HandleEvent (Event &event) {
				
				mStage->HandleEvent (event);
				
			}
			
			
			/*Tizenwindow *GetWindow () {
				
				return mStage->mWindow;
				
			}*/
			
		
		private:
			
			TizenStage *mStage;
			
		
	};
	
	
	void StartAnimation () {
		
		/*while (!glfwWindowShouldClose(sgGLFWFrame->GetWindow()))
		{
		  glfwPollEvents();

		  int i, count;
		  for (int joy = 0; joy < MAX_JOYSTICKS; joy++)
		  {
			 if (glfwJoystickPresent(joy) == GL_TRUE)
			 {
				// printf("joystick %s\n", glfwGetJoystickName(joy));

				const float *axes = glfwGetJoystickAxes(joy, &count);
				for (i = 0; i < count; i++)
				{
					Event joystick(etJoyAxisMove);
					joystick.id = joy;
					joystick.code = i;
					joystick.value = axes[i];
					sgGLFWFrame->HandleEvent(joystick);
				}

				const unsigned char *pressed = glfwGetJoystickButtons(joy, &count);
				for (i = 0; i < count; i++)
				{
					Event joystick(pressed[i] == GLFW_PRESS ? etJoyButtonDown : etJoyButtonUp);
					joystick.id = joy;
					joystick.code = i;
					sgGLFWFrame->HandleEvent(joystick);
				}
			 }
		  }

		  Event poll(etPoll);
		  sgGLFWFrame->HandleEvent(poll);
		}*/
	}
	
	
	void PauseAnimation () {}
	void ResumeAnimation () {}
	
	
	void StopAnimation () {
		
		//GLFWwindow *window = sgGLFWFrame->GetWindow();
		//glfwDestroyWindow(window);
		//glfwTerminate();
		
	}
	
	
	/*#define TIZEN_TRANS(x) case TIZEN_KEY_##x: return key##x;
	
	
	int TizenKeyToFlash(int inKey, bool &outRight) {
		
		outRight = (inKey == GLFW_KEY_RIGHT_SHIFT || inKey == GLFW_KEY_RIGHT_CONTROL ||
					inKey == GLFW_KEY_RIGHT_ALT || inKey == GLFW_KEY_RIGHT_SUPER);
		if (inKey >= keyA && inKey <= keyZ)
		  return inKey;
		if (inKey >= GLFW_KEY_0 && inKey <= GLFW_KEY_9)
		  return inKey - GLFW_KEY_0 + keyNUMBER_0;
		if (inKey >= GLFW_KEY_KP_0 && inKey <= GLFW_KEY_KP_9)
		  return inKey - GLFW_KEY_KP_0 + keyNUMPAD_0;

		if (inKey >= GLFW_KEY_F1 && inKey <= GLFW_KEY_F15)
		  return inKey - GLFW_KEY_F1 + keyF1;

		switch (inKey)
		{
		  case GLFW_KEY_RIGHT_ALT:
		  case GLFW_KEY_LEFT_ALT:
			 return keyALTERNATE;
		  case GLFW_KEY_RIGHT_SHIFT:
		  case GLFW_KEY_LEFT_SHIFT:
			 return keySHIFT;
		  case GLFW_KEY_RIGHT_CONTROL:
		  case GLFW_KEY_LEFT_CONTROL:
			 return keyCONTROL;
		  case GLFW_KEY_RIGHT_SUPER:
		  case GLFW_KEY_LEFT_SUPER:
			 return keyCOMMAND;

		  case GLFW_KEY_LEFT_BRACKET: return keyLEFTBRACKET;
		  case GLFW_KEY_RIGHT_BRACKET: return keyRIGHTBRACKET;
		  case GLFW_KEY_APOSTROPHE: return keyQUOTE;
		  case GLFW_KEY_GRAVE_ACCENT: return keyBACKQUOTE;

		  GLFW_TRANS(BACKSLASH)
		  GLFW_TRANS(BACKSPACE)
		  GLFW_TRANS(CAPS_LOCK)
		  GLFW_TRANS(COMMA)
		  GLFW_TRANS(DELETE)
		  GLFW_TRANS(DOWN)
		  GLFW_TRANS(END)
		  GLFW_TRANS(ENTER)
		  GLFW_TRANS(EQUAL)
		  GLFW_TRANS(ESCAPE)
		  GLFW_TRANS(HOME)
		  GLFW_TRANS(INSERT)
		  GLFW_TRANS(LEFT)
		  GLFW_TRANS(MINUS)
		  GLFW_TRANS(PAGE_UP)
		  GLFW_TRANS(PAGE_DOWN)
		  GLFW_TRANS(PERIOD)
		  GLFW_TRANS(RIGHT)
		  GLFW_TRANS(SEMICOLON)
		  GLFW_TRANS(SLASH)
		  GLFW_TRANS(SPACE)
		  GLFW_TRANS(TAB)
		  GLFW_TRANS(UP)

		  case GLFW_KEY_KP_ADD: return keyNUMPAD_ADD;
		  case GLFW_KEY_KP_DECIMAL: return keyNUMPAD_DECIMAL;
		  case GLFW_KEY_KP_DIVIDE: return keyNUMPAD_DIVIDE;
		  case GLFW_KEY_KP_ENTER: return keyNUMPAD_ENTER;
		  case GLFW_KEY_KP_MULTIPLY: return keyNUMPAD_MULTIPLY;
		  case GLFW_KEY_KP_SUBTRACT: return keyNUMPAD_SUBTRACT;
		}
		return inKey;
		
	}
	
	
	static void key_callback(GLFWwindow* window, int key, int scancode, int action, int mods)
	{
		Event event(action == GLFW_RELEASE ? etKeyUp : etKeyDown);
		bool right;
		event.value = GLFWKeyToFlash(key, right);
		if (right) event.flags |= efLocationRight;
		event.code = scancode;
		sgGLFWFrame->HandleEvent(event);
	}

	static void mouse_button_callback(GLFWwindow *window, int button, int action, int mods)
	{
		double xpos, ypos;
		glfwGetCursorPos(window, &xpos, &ypos);
		Event event(action == GLFW_RELEASE ? etMouseUp : etMouseDown, xpos, ypos, button);
		sgGLFWFrame->HandleEvent(event);
	}

	static void cursor_pos_callback(GLFWwindow *window, double xpos, double ypos)
	{
		Event event(etMouseMove, xpos, ypos);
		event.flags |= efPrimaryTouch;
		sgGLFWFrame->HandleEvent(event);
	}

	static void window_size_callback(GLFWwindow *window, int inWidth, int inHeight)
	{
		Event resize(etResize, inWidth, inHeight);
		sgGLFWFrame->Resize(inWidth, inHeight);
		sgGLFWFrame->HandleEvent(resize);
	}

	static void window_focus_callback(GLFWwindow *window, int inFocus)
	{
		Event activate( inFocus == GL_TRUE ? etGotInputFocus : etLostInputFocus );
		sgGLFWFrame->HandleEvent(activate);
	}

	static void window_close_callback(GLFWwindow *window)
	{
		Event close(etQuit);
		sgGLFWFrame->HandleEvent(close);
	}*/
	
	
	TizenFrame *createWindowFrame (const char *inTitle, int inWidth, int inHeight, unsigned int inFlags) {
		
		/*bool fullscreen = (inFlags & wfFullScreen) != 0;
		
		if (inFlags & wfResizable)
		  glfwWindowHint(GLFW_RESIZABLE, GL_TRUE);
		else
		  glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
		
		if (inFlags & wfBorderless)
		  glfwWindowHint(GLFW_DECORATED, GL_FALSE);
		
		glfwWindowHint(GLFW_DEPTH_BITS, (inFlags & wfDepthBuffer ? 24 : 0));
		glfwWindowHint(GLFW_STENCIL_BITS, (inFlags & wfStencilBuffer ? 8 : 0));
		
		if (inFlags & wfVSync)
		  glfwSwapInterval(1);
		
		GLFWwindow *window = glfwCreateWindow(inWidth, inHeight, inTitle, fullscreen ? glfwGetPrimaryMonitor() : NULL, NULL);
		if (!window)
		{
		  fprintf(stderr, "Failed to create GLFW window\n");
		  glfwTerminate();
		  return 0;
		}
		glfwMakeContextCurrent(window);
		
		glfwSetKeyCallback(window, key_callback);
		glfwSetMouseButtonCallback(window, mouse_button_callback);
		glfwSetCursorPosCallback(window, cursor_pos_callback);
		glfwSetWindowSizeCallback(window, window_size_callback);
		glfwSetWindowFocusCallback(window, window_focus_callback);
		// glfwSetWindowCloseCallback(window, window_close_callback);*/
		
		return new TizenFrame (/*window,*/ inWidth, inHeight);
		
	}
	
	
	void CreateMainFrame (FrameCreationCallback inOnFrame, int inWidth, int inHeight, unsigned int inFlags, const char *inTitle, Surface *inIcon) {
		
		AppLog("SDLKFJLDSJFLKSDJFLSDKFJ");
		
		while (true) {
			
			AppLog("SFKJ SLDKFJ");
			
		}
		
		Tizen::Base::Collection::ArrayList args (Tizen::Base::Collection::SingleObjectDeleter);
		args.Construct ();
		
		result r = Tizen::App::UiApp::Execute(TizenUIApp::CreateInstance, &args);
		
		/*bool opengl = (inFlags & wfHardware) != 0;
		// sgShaderFlags = (inFlags & (wfAllowShaders|wfRequireShaders) );
		
		if (!glfwInit())
		{
		  fprintf(stderr, "Could not initialize GLFW\n");
		  inOnFrame(0);
		  return;
		}
		*/
		sgTizenFrame = createWindowFrame (inTitle, inWidth, inHeight, inFlags);
		//inOnFrame (sgTizenFrame);
		
		StartAnimation ();
		
	}
	
	
	void SetIcon (const char *path) {}
	
	
	QuickVec<int>* CapabilitiesGetScreenResolutions () {
		
		// glfwInit();
		int count;
		QuickVec<int> *out = new QuickVec<int>();
		/*const GLFWvidmode *modes = glfwGetVideoModes(glfwGetPrimaryMonitor(), &count);
		for (int i = 0; i < count; i++)
		{
		  out->push_back( modes[i].width );
		  out->push_back( modes[i].height );
		}*/
		return out;
		
	}
	
	
	double CapabilitiesGetScreenResolutionX () {
		
		// glfwInit();
		//const GLFWvidmode *mode = glfwGetVideoMode(glfwGetPrimaryMonitor());
		//return mode->width;
		return 0;
		
	}
	
	
	double CapabilitiesGetScreenResolutionY () {
		
		// glfwInit();
		//const GLFWvidmode *mode = glfwGetVideoMode(glfwGetPrimaryMonitor());
		//return mode->width;
		return 0;
		
	}
	
	
	std::string CapabilitiesGetLanguage () {
		
		return "en-US";
		
	}
	
	double CapabilitiesGetScreenDPI() {
		
		return 200;
		
	}
	
	
	double CapabilitiesGetPixelAspectRatio() {
		
		return 1;
		
	}
	
	
	bool LaunchBrowser (const char *inUtf8URL) {
		
		return false;	
		
	}
	
	
	std::string FileDialogFolder( const std::string &title, const std::string &text ) {
		return ""; 
	}

	std::string FileDialogOpen( const std::string &title, const std::string &text, const std::vector<std::string> &fileTypes ) { 
		return ""; 
	}

	std::string FileDialogSave( const std::string &title, const std::string &text, const std::vector<std::string> &fileTypes ) { 
		return ""; 
	}    
	
	
}



