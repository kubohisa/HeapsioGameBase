package pdbg;

import mode.title.*;

class Loop {
	static var mode: String;
	static var state: String;
	
	// Api.
	public static function nextState (str: String) {
		//trace(str);
		state = str;
	}
	
	public static function changeMode (str: String) {
		nextState("start");
		mode = str;

		gc();
	}
	
	public static function gc () {
		var cache = new hxd.impl.CacheAllocator();
		cache.gc();		
	}

	public static function gameEnd () {
		pdbg.Sound.end();
		pdbg.Pad.end();
		pdbg.Grap.end();
		hxd.System.exit();
	}
	
	// Loop.
	public static function loop() {
		pdbg.Grap.fullScreen();
		pdbg.Grap.clearDisp();
		
		pdbg.Pad.hold();

		switch (mode){
			case "Title":
				ModeTitle.exec(state);
			default:
				pdbg.Grap.error("Loop.loop " + mode);
		}
		
		pdbg.Mouse.reset();
		
		pdbg.Grap.fps();
	}
}
