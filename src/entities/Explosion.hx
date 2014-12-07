package entities;

import age.display.AnimatedEntity;

class Explosion extends AnimatedEntity
{
	public var removeMe : Bool;

	public function new(pX: Int, pY: Int)
	{
		super(47, 47, "explosion", 6, 15);

		x = pX - 23;
		y = pY - 23;
		
		removeMe = false;
		_loop = false;
	}

	private override function onAnimationComplete()
	{
		removeMe = true;
	}
}