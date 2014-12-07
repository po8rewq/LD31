import age.display.text.TextAlignEnum.TextAlign;
import age.display.text.TextBaselineEnum.TextBaseline;
import age.display.text.BasicText;
import age.display.EntityContainer;
import haxe.Timer;

class ScoreManager
{
	private static var _score : Int;
	private static var _best : Int;
	private static var _text : BasicText;

	private static var _comboTimer : Timer;

	// palier de 100
	private static var _stage : Int;

	public static function init(pParent: EntityContainer)
	{
		if(_score == null)
			_best = 0;
		else
			_best = Std.int( Math.max(_score, _best) );

		_score = 0;
		_stage = 0;

		_text = new BasicText("SCORE: 0", 10, 30);
	    _text.setStyle(Main.DEFAULT_FONT, 20, "#000", false, TextAlign.LEFT);
	    pParent.add(_text);

	    var bestText = new BasicText("BEST: "+_best, 10, 60);
	    bestText.setStyle(Main.DEFAULT_FONT, 20, "#000", false, TextAlign.LEFT);
	    pParent.add(bestText);
	}

	public static function add(pValue: Float)
	{
		_score += Std.int(pValue);
		_text.text = "SCORE: " + _score;

		_stage += Std.int(pValue);
		if(_stage >= 100)
		{
			ColorChanger.createTransition(Main.GAME_DIV_ID);
			_stage -= 100;
		}
	}

	public static function getScore():Int
	{
		return _score;
	}

}