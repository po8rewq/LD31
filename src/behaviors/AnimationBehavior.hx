package behaviors;

import age.core.IBehavior;
import age.display.Entity;

import age.geom.Point2D;

class AnimationBehavior implements IBehavior
{
	public var entity : Entity;
	public var activated : Bool;

	var _from : Point2D;
	var _to : Point2D;

	inline static var SPEED : Int = 18;

	public function new(pEntity: Entity, goTo: Point2D)
	{
		activated = true;
		entity = pEntity;

		_from = {x:pEntity.x, y:pEntity.y};
		_to = goTo;
	}

	public function update():Void
	{
		var dx: Float = _to.x - entity.x;
		var dy: Float = _to.y - entity.y;

		if( dx*dx + dy*dy < SPEED*SPEED )
		{
			entity.x = _to.x;
			entity.y = _to.y;
			activated = false;
		}
		else
		{
			var angle = Math.atan2(dy, dx);
			var vx : Float = Math.cos(angle) * SPEED;
			var vy : Float = Math.sin(angle) * SPEED;

			entity.x += Math.round( vx );
			entity.y += Math.round( vy );
		}
	}

	public function destroy()
	{
		_from = _to = null;
	}
}