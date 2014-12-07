class CardColorHelper
{

	public static function getImageFromColor(pColor: CardColor):String
	{
		return switch(pColor){
			case CardColor.GREY: "card-seashell";
			case CardColor.WHITE: "card";
			case CardColor.BLUE: "card-blue";
			case CardColor.PINK: "card-pink";
			case CardColor.GREEN: "card-green";
			case CardColor.DARK_GREEN: "card-green4";
			case CardColor.RED: "card-red";
			case CardColor.YELLOW: "card-yellow";
			case CardColor.ORANGE: "card-orange";
			case CardColor.BLACK: "card-black";
		}
	}

	public static function getRandomColor(pAuthColors: Array<CardColor>, ?pIgnore: Array<CardColor>):CardColor
	{
		var colors : Array<CardColor> = pAuthColors.copy();
		if(pIgnore != null)
			for(c in pIgnore)
				colors.remove(c);

		var rnd : Int = Std.int( Math.random() * colors.length );
		return colors[rnd];
	}

	public static function getNextColor(pColor: CardColor):CardColor
	{
		// ordre : Y G B P R 
		return switch(pColor)
		{
			case CardColor.GREY: CardColor.YELLOW;
			case CardColor.YELLOW: CardColor.GREEN;
			case CardColor.GREEN: CardColor.DARK_GREEN;
			case CardColor.DARK_GREEN: CardColor.BLUE;
			case CardColor.BLUE: CardColor.PINK;
			case CardColor.PINK: CardColor.ORANGE;
			case CardColor.ORANGE: CardColor.RED;
			default: null;
		}
	}

	public static function getScoreFromColor(pColor: CardColor):Int
	{
		return switch(pColor)
		{
			case CardColor.GREY: 1;
			case CardColor.YELLOW: 2;
			case CardColor.GREEN: 3;
			case CardColor.DARK_GREEN: 5;
			case CardColor.BLUE: 8;
			case CardColor.PINK: 13;
			case CardColor.ORANGE: 21;
			case CardColor.RED: 34;
			default: 0;
		}
	}

	public static function getRgbColorFromColor(pColor: CardColor): ColorChanger.RGB
	{
		return switch(pColor)
		{
			case CardColor.GREY: {r: 205, g: 197, b: 191};
			case CardColor.YELLOW: {r: 254, g: 233, b: 141};
			case CardColor.GREEN: {r: 188, g: 227, b: 104};
			case CardColor.DARK_GREEN: {r: 0, g: 139, b: 0};
			case CardColor.BLUE: {r: 125, g: 184, b: 236};
			case CardColor.PINK: {r: 207, g: 140, b: 190};
			case CardColor.ORANGE: {r: 255, g: 165, b: 0};
			case CardColor.RED: {r: 255, g: 100, b: 126};
			default: null;
		}
	}
}

enum CardColor {
	GREY;
	WHITE;
	BLUE;
	RED;
	GREEN;
	DARK_GREEN;
	PINK;
	YELLOW;
	ORANGE;
	BLACK;
}