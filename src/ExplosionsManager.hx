package ;

import entities.Explosion;
import age.display.EntityContainer;

class ExplosionsManager
{
	private static var _explosions : List<Explosion>;
	static var _container : EntityContainer;

	public static function init(pCtr: EntityContainer)
	{
		if(_explosions != null)
		{
			for(e in _explosions)
				_container.remove(e);
		}

		_explosions = new List();
		_container = pCtr;
	}
	
	public static function add(pX: Float, pY: Float)
	{
		var ex = new Explosion( Math.round(pX), Math.round(pY));
		_container.add(ex);
		_explosions.add(ex);
	}

	public static function update()
	{
		for(e in _explosions)
		{
			if(e.removeMe)
			{
				_container.remove(e);
				_explosions.remove(e);
			}
		}
	}

}