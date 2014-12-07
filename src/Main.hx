package;

import states.GameState;

import age.core.Engine;
import age.Loader;

class Main extends Engine
{
	public static inline var DEFAULT_FONT : String = "pixelade";
	public static inline var GAME_DIV_ID : String = "game";

	#if debug
	static inline var URI : String = "/img/";
	#else
	static inline var URI : String = "/assets/img/portfolio/ld31/";
	#end

	public function new()
	{
		super(350, 500, new GameState(), true, 60, "", GAME_DIV_ID);
	}
	
	public static function main()
	{
		Loader.addResource(URI+'card.png', ResourceType.IMAGE, 'card');
		Loader.addResource(URI+'card-blue.png', ResourceType.IMAGE, 'card-blue');
		Loader.addResource(URI+'card-pink.png', ResourceType.IMAGE, 'card-pink');
		Loader.addResource(URI+'card-green.png', ResourceType.IMAGE, 'card-green');
		Loader.addResource(URI+'card-red.png', ResourceType.IMAGE, 'card-red');
		Loader.addResource(URI+'card-yellow.png', ResourceType.IMAGE, 'card-yellow');
		Loader.addResource(URI+'card-orange.png', ResourceType.IMAGE, 'card-orange');
		Loader.addResource(URI+'card-green4.png', ResourceType.IMAGE, 'card-green4');
		Loader.addResource(URI+'card-seashell3.png', ResourceType.IMAGE, 'card-seashell');

		Loader.addResource(URI+'card-black.png', ResourceType.IMAGE, 'card-black');
		Loader.addResource(URI+'card-black-1.png', ResourceType.IMAGE, 'card-black-1');
		Loader.addResource(URI+'card-black-2.png', ResourceType.IMAGE, 'card-black-2');
		Loader.addResource(URI+'card-black-3.png', ResourceType.IMAGE, 'card-black-3');
		Loader.addResource(URI+'card-black-4.png', ResourceType.IMAGE, 'card-black-4');
		Loader.addResource(URI+'card-black-5.png', ResourceType.IMAGE, 'card-black-5');
		Loader.addResource(URI+'card-black-6.png', ResourceType.IMAGE, 'card-black-6');
		Loader.addResource(URI+'card-black-7.png', ResourceType.IMAGE, 'card-black-7');
		Loader.addResource(URI+'card-black-8.png', ResourceType.IMAGE, 'card-black-8');
		Loader.addResource(URI+'card-black-9.png', ResourceType.IMAGE, 'card-black-9');

		Loader.addResource(URI+'bg.png', ResourceType.IMAGE, 'bg-layer');
		Loader.addResource(URI+'bg-card.png', ResourceType.IMAGE, 'bg-card');

		Loader.addResource(URI+'explosion.png', ResourceType.IMAGE, 'explosion');
		
		Loader.start( function() { new Main(); } );
	}
	
}