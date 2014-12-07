package states;

import age.display.State;
import age.display.EntityContainer;
import age.utils.Key;
import age.core.Input;
import age.display.text.TextAlignEnum.TextAlign;
import age.display.text.TextBaselineEnum.TextBaseline;
import age.display.text.BasicText;
import age.core.Global;
import age.display.ui.Rect;

import entities.Card;
import CardColorHelper.CardColor;

import js.html.MouseEvent;

class GameState extends State
{
	var _textContainer : EntityContainer;
	var _backgroundContainer : EntityContainer;
	var _boardContainer : EntityContainer;
	var _explosionsContainer : EntityContainer;

	var _currentCard : Card;
	var _movingCard: Card;

	var _gameStarted : Bool;

	var _authColors : Array<CardColor>;

	//
	static inline var BOARD_LEFT: Int = 13;
	static inline var BOARD_RIGHT: Int = BOARD_LEFT + 323;
	static inline var BOARD_TOP: Int = 142;
	static inline var BOARD_BOTTOM: Int = BOARD_TOP + 323;

	static inline var CARD_SIZE: Int = 81;

	static inline var BLACK_LIMIT : Int = 3;

	//
	var _cards : List<Card>;
	var _wait : Bool;

	static inline var SCORE_UNLOCK_BLACK: Int = 120;
	var _totalBlackOnBoard : Int;

    public function new()
    {
    	_gameStarted = false;
        super();
        canClick = false;
    }

    public override function create()
    {
    	var credits = new BasicText("Made for LD31 by RevoluGame.com", 175, 480);
        credits.setStyle(Main.DEFAULT_FONT, 20, "#000", false, TextAlign.CENTER);
        add(credits);

    	_textContainer = new EntityContainer();
    	add(_textContainer);

    	var inst = new BasicText("Press [SPACE] when ready", 175, 190);
        inst.setStyle(Main.DEFAULT_FONT, 25, "#000", false, TextAlign.CENTER);
        _textContainer.add(inst);
    }

    private function initGame()
    {
    	remove(_textContainer);
    	_textContainer = new EntityContainer();

    	var inst = new BasicText("Press [SPACE] to restart", 175, 110);
        inst.setStyle(Main.DEFAULT_FONT, 20, "#000", false, TextAlign.CENTER);
        _textContainer.add(inst);

        ScoreManager.init(_textContainer);

        _totalBlackOnBoard = 0;

    	_cards = new List();
    	_authColors = [CardColor.GREY];
    	ColorChanger.createTransition( Main.GAME_DIV_ID, CardColorHelper.getRgbColorFromColor(CardColor.GREY) );
    	_wait = false;

    	if(_backgroundContainer == null)
    	{
	    	_backgroundContainer = new EntityContainer();
	    	
	    	var bg = new age.display.Entity(338, 338, "bg-layer");
	    	bg.x = BOARD_LEFT - 7;
	    	bg.y = BOARD_TOP - 7;
	    	_backgroundContainer.add(bg);

	    	var bgcard = new age.display.Entity(90, 90, "bg-card");
	    	bgcard.x = 250;
	    	bgcard.y = 10;
			_backgroundContainer.add(bgcard);
	    	
	    	add(_backgroundContainer);
	    }

	    if(_boardContainer == null)
	    {
	    	_boardContainer = new EntityContainer();
	    	add(_boardContainer);
	    }

	    if(_explosionsContainer == null)
	    {
	    	_explosionsContainer = new EntityContainer();
	    	add(_explosionsContainer);
	    }
	    ExplosionsManager.init(_explosionsContainer);

	    add(_textContainer);

    	// init decords
    	for(i in 0...4)
    		for(j in 0...4)
    			_backgroundContainer.add(new Card(CARD_SIZE*j + BOARD_LEFT, CARD_SIZE*i + BOARD_TOP, CardColor.WHITE));

    	createNextCards();

    	Input.registerGlobalClickHandler(clickHandler);
    	canClick = true;
    }

    private function restartGame()
    {
    	_textContainer.removeAll();

		for(c in _cards)
			_boardContainer.remove(c);
    	_cards.clear();

    	_currentCard = null;

    	initGame();
    }

    function createNextCards()
    {
    	_currentCard = new Card(255, 15, CardColorHelper.getRandomColor(_authColors, _totalBlackOnBoard >= BLACK_LIMIT ? [CardColor.BLACK] : null));
    	_boardContainer.add(_currentCard);

    	if(_currentCard.color == CardColor.BLACK)
    		_totalBlackOnBoard++;
    }

	private var canClick : Bool;
    private function clickHandler(pEvt: MouseEvent)
    {
    	if(_currentCard == null || _wait || !canClick) return;

		canClick = false;
		haxe.Timer.delay(function(){
			canClick = true;
		}, 800);

    	var bounds = Input.getCanvasBounds();
        var mouseX = pEvt.clientX - bounds.left;
        var mouseY = pEvt.clientY - bounds.top;

        if(mouseX >= BOARD_LEFT && mouseX <= BOARD_RIGHT && mouseY >= BOARD_TOP && mouseY <= BOARD_BOTTOM)
        {
        	var col : Int = Std.int( (mouseX - BOARD_LEFT) / CARD_SIZE);
        	var row : Int = Std.int( (mouseY - BOARD_TOP) / CARD_SIZE);
        	
        	_movingCard = _currentCard;
        	moveCardToCol(_currentCard, col);
        }
    }

    function moveCardToCol(pCard: Card, pCol: Int)
    {
    	var row = getPositionInCol(pCol);
    	if(row == -1)
    		return;

    	_wait = true;

    	var colX = pCol * CARD_SIZE + BOARD_LEFT;
    	var rowX = row * CARD_SIZE + BOARD_TOP;

    	_currentCard.moveTo(colX, rowX);
    	_currentCard.block(pCol, row);

    	_cards.add(_currentCard);
    	createNextCards();
    }

    /**
     * Retourne la position en Y libre d'une colonne
     */
    function getPositionInCol(pCol: Int):Int
    {
    	// recuperation des cellules de la colonne en question
    	var cells : List<Card> = new List();
    	for(c in _cards)
    		if(c.position.x == pCol)
    			cells.add(c);

    	if(cells.length == 0)
    		return 3;
    	
    	if(cells.length <= 3)
    		return 3 - cells.length;
    	
    	return -1;
    }

    public override function update()
    {
        if(!_gameStarted && Input.pressed(Key.SPACE))
        {
        	_gameStarted = true;
        	_textContainer.removeAll();

        	if(_cards != null) restartGame();
        	else
        		initGame();
        }
        else if(_gameStarted)
        {
        	ExplosionsManager.update();

        	if(Input.pressed(Key.SPACE))
        		restartGame();

        	if(_wait && !_movingCard.isMoving)
        	{
        		if(_movingCard != null)
        			updateCollisions(_movingCard);
        		if(_movingCard != null)
        			_movingCard.firstTimeOnBoard();
        		
        		_wait = false;
        		_movingCard = null;

        		handleEndOfTurn();
        	}

        	if( ScoreManager.getScore() >= SCORE_UNLOCK_BLACK && _authColors.indexOf(CardColor.BLACK) == -1 )
        	{
        		_authColors.push(CardColor.BLACK);
        	}
        }

        super.update();
    }

    function updateCollisions(pCard: Card)
    {
    	// on regarde si on a des voisins de la meme couleur
        var listCards = getNeighbourSameColor(pCard);
        if(listCards.length == 0)
        	return;

      	var cols : Map<Int, Int> = new Map();
      	for(c in listCards)
        {
        	if(!cols.exists(c.position.x) || (cols.exists(c.position.x) && cols.get(c.position.x) > c.position.y) )
       			cols.set(c.position.x, c.position.y);

       		_cards.remove(c);
       		_boardContainer.remove(c);

       		ExplosionsManager.add(c.x + 40, c.y + 40);
      	}

      	// on check si on doit ajouter une nouvelle carte
      	var newColor = CardColorHelper.getNextColor(pCard.color);
      	if( newColor != null )
      	{
      		if( newColor != CardColor.RED && _authColors.indexOf(newColor) == -1 )
      			_authColors.push(newColor);

      		ColorChanger.createTransition( Main.GAME_DIV_ID, CardColorHelper.getRgbColorFromColor(newColor) );

      		var newRow = 3 - getLowerCardsInCol(pCard.position.x, pCard.position.y).length;
      		var newY = newRow * CARD_SIZE + BOARD_TOP;

      		var newCard = new Card(pCard.x, newY, newColor);
    		_boardContainer.add(newCard);
    		
    		newCard.block(pCard.position.x, newRow);
    		_cards.add(newCard);

    		updateCollisions(newCard);
      	}

       	// on descend les autres carte des colonnes concernées
       	for(col in cols.keys())
       	{
   			var row = cols.get(col);

   			var cardsToMove = getUpperCardsInCol(col, row);
        	for(ctm in cardsToMove)
        	{
        		var newRow = 3 - getLowerCardsInCol(ctm.position.x, ctm.position.y).length;
        		ctm.moveTo(ctm.x, newRow * CARD_SIZE + BOARD_TOP);
        		ctm.block(ctm.position.x, newRow);
        	}
        }

        haxe.Timer.delay( function(){
        	for(c in _cards)
        		updateCollisions(c);
        }, 300);

        ScoreManager.add( CardColorHelper.getScoreFromColor(pCard.color) * Math.max(1, listCards.length - 1) );
    }

    function getNeighbourSameColor(pCard: Card): List<Card>
    {
    	var list : List<Card> = new List();

    	if(pCard.isMoving || pCard.color == CardColor.BLACK) return list;

    	var leftCard = getCardAt(pCard.position.x - 1, pCard.position.y);
    	var rightCard = getCardAt(pCard.position.x + 1, pCard.position.y);
    	var topCard = getCardAt( pCard.position.x, pCard.position.y - 1); // devrait normalement pas arriver
    	var bottomCard = getCardAt(pCard.position.x, pCard.position.y + 1);

    	if(leftCard != null && leftCard.color == pCard.color) 
    	{
    		list.add(leftCard);
    	}
    	if(rightCard != null && rightCard.color == pCard.color) 
    	{
    		list.add(rightCard);
    	}
    	if(topCard != null && topCard.color == pCard.color) list.add(topCard);
    	if(bottomCard != null && bottomCard.color == pCard.color) 
    	{
    		list.add(bottomCard);
    	}

    	if(list.length > 0)
    	{
    		list.add(pCard);
    	}
    	return list;
    }

    function getUpperCardsInCol(pCol: Int, pRow: Int):List<Card>
    {
    	var list : List<Card> = new List();
    	for(c in _cards)
    		if(c.position.x == pCol && c.position.y < pRow)
    			list.add(c);
    	return list;
    }

    function getLowerCardsInCol(pCol: Int, pRow: Int): List<Card>
    {
    	var list : List<Card> = new List();
    	for(c in _cards)
    		if(c.position.x == pCol && c.position.y > pRow)
    			list.add(c);
    	return list;
    }

    function getCardAt(pX: Int, pY: Int): Card
    {
    	if(pX >= 0 && pX <= 3 && pY >= 0 && pY <= 3)
    	{
    		for(c in _cards)
    			if(c.position.x == pX && c.position.y == pY)
    				return c;
    	}
    	return null;
    }

    function endGame()
    {
    	_gameStarted = false;

    	_currentCard = null;
    	_movingCard = null;

    	var rect = new Rect( 0 , 160 , 350, 47, "#FFFFFF", 0.8 );
    	_textContainer.add(rect);

    	var inst = new BasicText("GAME OVER", 175, 170);
        inst.setStyle(Main.DEFAULT_FONT, 28, "#000", false, TextAlign.CENTER);
    	_textContainer.add(inst);
    }

    /**
     * Actions a effectuer a chaque tour
     */
    function handleEndOfTurn()
    {
		for(c in _cards)
		{
			c.newTurn();
			if(c.color == CardColor.BLACK && c.nbTurnOnScreen >= c.nbTurnMaxOnScreen)
			{
				c.dead = true;
				_cards.remove(c);
       			_boardContainer.remove(c);

       			ExplosionsManager.add(c.x + 40, c.y + 40);

				var cardsToMove = getUpperCardsInCol(c.position.x, c.position.y);
	        	for(ctm in cardsToMove)
	        	{
	        		var newRow = 3 - getLowerCardsInCol(ctm.position.x, ctm.position.y).length;
	        		ctm.moveTo(ctm.x, newRow * CARD_SIZE + BOARD_TOP);
	        		ctm.block(ctm.position.x, newRow);

	        		haxe.Timer.delay( function(){
	        			updateCollisions(ctm);
	        		}, 300);
	        	}

	        	_totalBlackOnBoard--;
			}
		}

		if(_cards.length >= 16)
				endGame();
    }
}