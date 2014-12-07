package ;

import js.html.Element;
import js.Browser;
import haxe.Timer;

class ColorChanger
{
	private static var _timer : Timer;
	private static inline var INCREMENT_STOP : Int = 50;

	public static function createTransition(pId: String, ?forcedColor: RGB)
	{
		if(_timer != null)
			_timer.stop();

		var elm : Element = Browser.document.getElementById(pId);
		var currentColor : RGB = getElementBG(elm);
		var endColor : RGB = forcedColor == null ? generateRGB() : forcedColor;

		if(currentColor.r == endColor.r && currentColor.g == endColor.g && currentColor.b == endColor.b) return;

		var distance : RGB = calculateDistance(currentColor, endColor);
		var increment : RGB = calculateIncrement(distance);

		var iteration = Math.round(1000 / (INCREMENT_STOP/2));
		_timer = new haxe.Timer(iteration);
		_timer.run = function() 
		{
			if (currentColor.r > endColor.r) 
			{
				currentColor.r -= increment.r;
				if (currentColor.r <= endColor.r)
					increment.r = 0;		
			} 
			else 
			{
				currentColor.r += increment.r;
				if (currentColor.r >= endColor.r)
					increment.r = 0;
			}
		
			if (currentColor.g > endColor.g) 
			{
				currentColor.g -= increment.g;
				if (currentColor.g <= endColor.g)
					increment.g = 0;
			} 
			else 
			{
				currentColor.g += increment.g;
				if (currentColor.g >= endColor.g)
					increment.g = 0;
			}
			
			if (currentColor.b > endColor.b) 
			{
				currentColor.b -= increment.b;
				if (currentColor.b <= endColor.b)
					increment.b = 0;
			} 
			else 
			{
				currentColor.b += increment.b;
				if (currentColor.b >= endColor.b)
					increment.b = 0;
			}
			elm.style.background = rgb2hex(currentColor);
			
			if (increment.r == 0 && increment.g == 0 && increment.b == 0) 
			{
				_timer.stop();
				_timer = null;
			}
		};
	}

	private static function getElementBG(pElem: Element):RGB
	{
		// sequence rgb(r,g,b) => faire un truc plus propre
		var bg : String = Browser.window.getComputedStyle(pElem).backgroundColor;
		bg = StringTools.replace(bg, "rgb(", "");
		bg = StringTools.replace(bg, ")", "");
		var rgbStr : Array<String> = bg.split(",");
		
		return {
			r: Std.parseInt(rgbStr[0]),
			g: Std.parseInt(rgbStr[1]),
			b: Std.parseInt(rgbStr[2])
		};
	}

	private static function generateRGB():RGB
	{
		return {
			r: getRandomValue(),
			g: getRandomValue(),
			b: getRandomValue()
		};
	}

	private static function getRandomValue():Int
	{
		var num = Math.floor(Math.random()*225);
		while (num < 25)
			num = Math.floor(Math.random()*225);
		return num; // ATTENTION INF LOOP
	}

	/**
	 * Retourne un objet RGB contenant les distances entre chaque nuance
	 */
	private static function calculateDistance(current: RGB, next: RGB): RGB
	{
		return {
			r: Math.round(Math.abs(current.r - next.r)),
			g: Math.round(Math.abs(current.g - next.g)),
			b: Math.round(Math.abs(current.b - next.b))
		};
	}

	private static function calculateIncrement(distance: RGB) : RGB
	{
		var incR = Std.int( Math.abs( Math.floor(distance.r / INCREMENT_STOP) ) );
		var incG = Std.int( Math.abs( Math.floor(distance.g / INCREMENT_STOP) ) );
		var incB = Std.int( Math.abs( Math.floor(distance.b / INCREMENT_STOP) ) );
		return {
			r: incR + (incR == 0 ? 1 : 0),
			g: incG + (incG == 0 ? 1 : 0),
			b: incB + (incB == 0 ? 1 : 0)
		};
	}

	private static function rgb2hex(color: RGB): String
	{
		return "#" + StringTools.hex(color.r, 2) + StringTools.hex(color.g, 2) + StringTools.hex(color.b, 2);
	}

}

typedef RGB = {
	var r : Int;
	var g : Int;
	var b : Int;
}