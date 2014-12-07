package entities;

import age.display.Entity;
import age.geom.Point2D;

import behaviors.AnimationBehavior;

import CardColorHelper.CardColor;

import js.html.CanvasRenderingContext2D;

class Card extends Entity
{
	public var color(default, null) : CardColor;
	public var isMoving(get_isMoving, null) : Bool;

	public var position(default, null): Point2D;

	public var nbTurnOnScreen(default, null) : Int;
	public var nbTurnMaxOnScreen(default, null) : Int;

	public function new(pX: Int, pY: Int, pColor: CardColor)
	{
		super(80, 80);

		isMoving = false;

		x = pX;
		y = pY;

		color = pColor;
		nbTurnOnScreen = 0;

		nbTurnMaxOnScreen = 0;
		if(color == CardColor.BLACK)
			nbTurnMaxOnScreen = 5;

		var img = CardColorHelper.getImageFromColor(color);

		addImage("card", img, true);
	}

	public function moveTo(pX: Int, pY: Int)
	{
		removeBehavior("move");
		addBehavior("move", new AnimationBehavior(this, {x:pX, y:pY}));
	}

	public function block(pCol: Int, pRow:Int)
	{
		position = {x: pCol, y: pRow};
	}

	function get_isMoving():Bool{return getBehavior("move")!=null;}

	public override function update()
	{
		var mb = getBehavior("move");
		if( mb != null && !mb.activated )
			removeBehavior("move");
		
		super.update();
	}

	public function firstTimeOnBoard()
	{
		if(color == CardColor.BLACK)
		{
			var img = CardColorHelper.getImageFromColor(color)+"-"+nbTurnMaxOnScreen;
			addImage("card", img, true);
		}
	}

	public function newTurn()
	{
		nbTurnOnScreen++;
		if(color == CardColor.BLACK)
		{
			var nb = nbTurnMaxOnScreen - nbTurnOnScreen;
			if(nb > 0)
			{
				var img = CardColorHelper.getImageFromColor(color)+"-"+(nbTurnMaxOnScreen-nbTurnOnScreen);
				addImage("card", img, true);
			}
		}
	}
}