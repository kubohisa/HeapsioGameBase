package pdbg;

class Grap {
	public static var parent: h2d.Scene;
	public static var engine: h3d.Engine;
	public static var dad: h2d.Object;
	
	public static var tile: Map<String, h2d.Tile> = [];
	
	static var radiPi: Float = Math.PI / 180;
	
	// Seting.
	public static var dispX: Int = 960; // PS Vita size.
	public static var dispY: Int = 544;
	
	// Grap.
	public static function init(p: h2d.Scene, e: h3d.Engine) {
		parent = p;
		engine = e;
		
		parent.defaultSmooth = true;
		backgroundColor(0xff000000);
		makeDisp();
		
//		tileResize(100);
	}
	
	public static function end() {
		tileClear();
		dad.remove();
		dad = null;
	}
	
	// Display.
	public static function makeDisp() {
		dad = new h2d.Object(parent);
	}
	
	public static function clearDisp() {
		dad.remove();
		makeDisp();
	}
	
	public static function resize() {
		parent.scaleMode = ScaleMode.LetterBox(dispX, dispY, false); 
	}
	
	public static function backgroundColor(c: Int) {
		engine.backgroundColor = c; 
	}
	
	public static function windowTitle(t: String) {
		//@:privateAccess hxd.Window.getInstance().window.title = t; 
	}
	
	// Push DELETE to Full Screen.
	public static function fullScreen() {
		if (hxd.Key.isReleased(hxd.Key.DELETE)) {
			engine.fullScreen = !engine.fullScreen;
		}
		if (hxd.Key.isDown(hxd.Key.ESCAPE)) {
			hxd.System.exit();
		}
	}
	
	// Tiles.
	public static function tileLoad(name: String, file: String) {
		tile[name] = hxd.Res.loader.load("images/"+file).toTile();
	}
	
/*	public static function tileResize(no: Int) {
		tile.resize(no);
	}
*/	
	public static function tileClear() {
		tile = [];
	}
	
	// Fade.
	public static function fader(c: Int, a: Int) {
		var obj = new h2d.Object(dad);
		new h2d.Bitmap(h2d.Tile.fromColor(c, dispX, dispY, 1 - a / 100), obj);
		
		return;
	}
	
	// Object.
	public static function objectAlpha(obj: h2d.Object, a: Float) {
		obj.alpha = a;
	}
	
	public static function objectBlur(obj: h2d.Object, a: Float) {
		obj.filter = new h2d.filter.Blur(a);
	}
	
	// Copy.
	public static function copy(name: String, x: Float, y: Float) : h2d.Object {
		var obj = new h2d.Object(dad);
		new h2d.Bitmap(tile[name], obj);
		obj.x = x;
		obj.y = y;
				
		return obj;
	}
	
	public static function copyDx(name: String, x: Float, y: Float, dx: Float, dy: Float, ?r: Float)  :h2d.Object {
		var obj = new h2d.Object(dad);

		var t = tile[name];
		t = t.center();
		new h2d.Bitmap(t, obj);
		
		obj.scaleX = dx;
		obj.scaleY = dy;
		obj.x = x + (t.width / 2);
		obj.y = y + (t.height / 2);
		
		if (r != null) {
			obj.rotate(radiPi * r);
		}
		
		return obj;
	}
	
	// Font.
	public static function font(text: String, x: Float, y: Float, size: Int) {
		// 8bit, xml, png
		var obj = new h2d.Object(dad);
		var tf = new h2d.Text(hxd.Res.fonts.Font100dot.toSdfFont(size, 0, 0.5, 0.5), obj);
		tf.text = text;
		tf.rotation = 3.1416;
		tf.x = x;
		tf.y = y;
	}
	
	// System.
	public static function error(text: String) {
		fader(0xff38b48b, 0);
		font("Error: "+text, 0, 30, 26);
	}
	
	static var fpsCounter: Int = 0;
	static var fpsPrev: Float = 0;
	static var fpsAdd: Float = 0;
	
	public static function fps() {
		var obj = new h2d.Object(dad);
		new h2d.Bitmap(h2d.Tile.fromColor(0xff000000, dispX, 30, 0.6), obj);

		if (fpsCounter == 5) {
			fpsPrev = fpsAdd / 6;
			fpsCounter = 0;
			fpsAdd = hxd.Timer.fps();
		} else {
			fpsCounter++;
			fpsAdd += hxd.Timer.fps();
		}
		font("FPS: " + fpsPrev, 0, 0, 26);
	}
}