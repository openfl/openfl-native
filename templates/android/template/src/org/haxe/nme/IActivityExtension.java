package org.haxe.nme;

import android.os.Bundle;

public interface IActivityExtension {

	/**
	 * Called when the activity is starting.
	 */
	void onCreate(Bundle savedInstanceState);

	/**
	 * Called after {@link #onCreate} &mdash; or after {@link #onRestart} when  
	 * the activity had been stopped, but is now again being displayed to the 
	 * user.
	 */
	void onStart();

	/**
	 * Called after {@link #onStop} when the current activity is being 
	 * re-displayed to the user (the user has navigated back to it).
	 */
	void onRestart();

	/**
	 * Called after {@link #onRestart}, or {@link #onPause}, for your activity 
	 * to start interacting with the user.
	 */
	void onResume();

	/**
	 * Called as part of the activity lifecycle when an activity is going into
	 * the background, but has not (yet) been killed.
	 */
	void onPause();

	/**
	 * Called when the activity is no longer visible to the user, because 
	 * another activity has been resumed and is covering this one. 
	 */
	void onStop();

	/**
	 * Perform any final cleanup before an activity is destroyed.
	 */
	void onDestroy();

}
