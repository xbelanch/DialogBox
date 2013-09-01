import flash.display.Sprite;
import flash.Lib;
import flash.events.Event;
import openfl.display.FPS;

class Main
{
	
	static public var root:Sprite;
	static private var app:DialogBox;

	public function new ()
	{
				
		DI.init(640);
		root = Lib.current;
		app = new DialogBox(root);

		var fps = new FPS();
		root.stage.addChild(fps);

	}
	
	
}