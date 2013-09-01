import flash.display.Sprite;
import flash.events.Event;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.Lib;
import openfl.display.Tilesheet;
import flash.geom.Rectangle;
import flash.geom.Point;
import flash.display.Shape;

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
	var mask_obj:Sprite;
	public var view:Sprite;
	var tilesheet:openfl.display.Tilesheet;
	var t0:Int;
	var ball:Ball;

	public function new()
	{
		output = new BitmapData(512, 512, true, 0x0);
		outputBMP = new Bitmap(output);
		outputBMP.x = -output.width / 2;
		outputBMP.y = -output.height / 2;
		outputBMP.smoothing = false;

		view = new Sprite();
		bg = new Sprite();
		spr = new Sprite();

		ball = new Ball();

		// MASK
		mask_obj = new Sprite();
		mask_obj.graphics.beginFill(0x0);
		mask_obj.graphics.drawRect(
			-output.width/2,
			-output.height/2,
			output.width,
			output.height);
		mask_obj.graphics.endFill();
		mask_obj.name = "mask_obj";


		view.addChild(mask_obj);
		view.addChild(outputBMP);
		view.addChild(spr);
		view.mask = mask_obj;

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
		var t = Lib.getTimer();
		var dt:Float = Math.min(34, t - t0);
		t0 = t;
		var dk:Float = dt / 17;


		if (ball.x < -output.width/2 || ball.x > output.width/2 ||
			ball.y < -output.height/2 || ball.y > output.height/2 )
			ball.dir *= -1;

		ball.update(dk);
		// trace(dk);
		spr.graphics.clear();
		tilesheet.drawTiles(spr.graphics,
			[
				ball.x,  // x pos
				ball.y, // y pos
				0, // index tile
				1 // scale
			],
			true, Tilesheet.TILE_SCALE
		);

	}

}


class Ball {
	public var x:Float;
	public var y:Float;
	public var dir:Int;

	public function new()
	{
		x = y = 0.0;
		dir = 1;
	}

	public function update(dt:Float)
	{
		x += 3.9 * dir * dt;
		y += 1.5 * dir * dt;
	}

}