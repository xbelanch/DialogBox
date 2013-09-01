import flash.display.Sprite;
import flash.events.Event;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.Lib;
import openfl.display.Tilesheet;
import flash.geom.Rectangle;
import flash.geom.Point;

@:bitmap("landscape.png")
	class LandscapePNG extends BitmapData {
}

@:bitmap("bubbles.png")
	class BubblesPNG extends BitmapData {
}

class DialogBox 
{

	var root:Sprite;
	var logo:Logo;

	public function new(root:Sprite)
	{
		
		this.root = root;
		logo = new Logo();
		

		root.addChild(logo.view);


		root.stage.addEventListener(Event.RESIZE, resize);
		// si no fas la següent instrucció
		// tens el problema que, en el moment que obres l'aplicació
		// no s'aplica el resize()!
		resize(null);
	}

	private function resize(e:Event):Void
	{
		if (logo != null)
		{
			logo.view.x = DI.stageWidth >> 1;
			logo.view.y = DI.stageHeight >> 1;
		}
	}

}


class Logo
{
	
	var output:BitmapData;
	var outputBMP:Bitmap;
	var spr:Sprite;
	var bg:Sprite;
	public var view:Sprite;
	var tilesheet:openfl.display.Tilesheet;

	public function new()
	{
		output = new BitmapData(512, 512, false, 0x0);
		outputBMP = new Bitmap(output);
		outputBMP.x = -output.width / 2;
		outputBMP.y = -output.height / 2;
		outputBMP.smoothing = false;

		view = new Sprite();
		bg = new Sprite();
		spr = new Sprite();
		view.addChild(outputBMP);
		view.addChild(spr);
		init();

	}

	private function init()
	{

		tilesheet = new Tilesheet(new BubblesPNG(0, 0));
		tilesheet.addTileRect(new Rectangle(0, 0, 128, 128), new Point(64, 64));

		var imgBMPDATA = new LandscapePNG(0, 0);
		var imgBMP = new Bitmap(imgBMPDATA);
		bg.addChild(imgBMP);
		output.draw(bg);
		view.addEventListener(Event.ENTER_FRAME, enterFrame);
		enterFrame(null);
	}

	// RENDER LOOP
	private function enterFrame(e:Event):Void
	{

		spr.graphics.clear();
		tilesheet.drawTiles(spr.graphics,
			[
				-output.width/2, // x pos
				-output.height/2, // y pos
				0, // index tile
				1 // scale
			],
			true, Tilesheet.TILE_SCALE
		);

	}

}