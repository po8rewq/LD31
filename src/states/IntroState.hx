package states;

import age.display.text.TextAlignEnum.TextAlign;
import age.display.text.TextBaselineEnum.TextBaseline;
import age.display.text.BasicText;
import age.display.State;
import age.core.Global;
import age.utils.Key;
import age.core.Input;

class IntroState extends State
{
    public function new()
    {
        super();
    }

    public override function create()
    {
    	var title = new BasicText("???", 175, 50);
        title.textBaseline = TextBaseline.MIDDLE;
        title.setStyle(Main.DEFAULT_FONT, 42, "#000", true, TextAlign.CENTER);
        add(title);

        var txt = new BasicText("Game created for the Ludum Dare #31 in 48 hours by RevoluGame", 175, 130);
        txt.setStyle(Main.DEFAULT_FONT, 25, "#000", false, TextAlign.CENTER);
        add(txt);

        var inst = new BasicText("Press [SPACE] when ready", 175, 190);
        inst.setStyle(Main.DEFAULT_FONT, 25, "#000", false, TextAlign.CENTER);
        add(inst);
    }

    public override function update()
    {
        if(Input.pressed(Key.SPACE))
            Global.engine.switchState( new GameState() );
        super.update();
    }

}