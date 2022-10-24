package android;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import flixel.FlxSprite;

class FlxHitbox extends FlxSpriteGroup {
    public var hitbox:FlxSpriteGroup;

    public var array:Array<FlxButton> = [];

    public var K1:FlxButton;
    public var K2:FlxButton;
    public var K3:FlxButton;
    public var K4:FlxButton;
    public var K5:FlxButton;
    public var K6:FlxButton;
    public var K7:FlxButton;
    public var K8:FlxButton;
    public var K9:FlxButton;

    public var orgType:HitboxType = FOUR;
    public var orgAlpha:Float = 0.75;
    public var orgAntialiasing:Bool = true;
    
    public function new(type:HitboxType = FOUR, ?alphaAlt:Float = 0.75, ?antialiasingAlt:Bool = true)
    {
        super();

	orgType = type;
	orgAlpha = alphaAlt;
	orgAntialiasing = antialiasingAlt;

        hitbox = new FlxSpriteGroup();
        hitbox.scrollFactor.set();

        K1 = new FlxButton(0, 0);
        K2 = new FlxButton(0, 0);
        K3 = new FlxButton(0, 0);
        K4 = new FlxButton(0, 0);
        K5 = new FlxButton(0, 0);
        K6 = new FlxButton(0, 0);
        K7 = new FlxButton(0, 0);
        K8 = new FlxButton(0, 0);
        K9 = new FlxButton(0, 0);

        var hitbox_hint:FlxSprite = new FlxSprite(0, 0);

        switch (type)
        {
            case FOUR:
                hitbox_hint.loadGraphic(Paths.image('android/hitbox_hint'));

                hitbox.add(add(K1 = createhitbox(0, 0, "K1")));
                hitbox.add(add(K2 = createhitbox(320, 0, "K2")));
                hitbox.add(add(K3 = createhitbox(640, 0, "K3")));
                hitbox.add(add(K4 = createhitbox(960, 0, "K4")));
            case SIX:
                hitbox_hint.loadGraphic(Paths.image('android/6k_hint'));

                hitbox.add(add(K1 = createhitbox(0, 0, "K1")));
                hitbox.add(add(K2 = createhitbox(213, 0, "K2")));
                hitbox.add(add(K3 = createhitbox(426, 0, "K3")));
                hitbox.add(add(K4 = createhitbox(639, 0, "K4")));
                hitbox.add(add(K5 = createhitbox(852, 0, "K5")));
                hitbox.add(add(K6 = createhitbox(1065, 0, "K6")));
            case NINE:
                hitbox_hint.loadGraphic(Paths.image('android/9k_hint'));

                hitbox.add(add(K1 = createhitbox(0, 0, "K1")));
                hitbox.add(add(K2 = createhitbox(142, 0, "K2")));
                hitbox.add(add(K3 = createhitbox(284, 0, "K3")));
                hitbox.add(add(K4 = createhitbox(426, 0, "K4")));
                hitbox.add(add(K5 = createhitbox(568, 0, "K5")));
                hitbox.add(add(K6 = createhitbox(710, 0, "K6")));
                hitbox.add(add(K7 = createhitbox(852, 0, "K7")));
                hitbox.add(add(K8 = createhitbox(994, 0, "K8")));
                hitbox.add(add(K9 = createhitbox(1136, 0, "K9")));
        }

        array = [K1, K2, K3, K4, K5, K6, K7, K8, K9];

	hitbox_hint.antialiasing = orgAntialiasing;
	hitbox_hint.alpha = orgAlpha;
	add(hitbox_hint);
    }

    public function createhitbox(x:Float = 0, y:Float = 0, frames:String) {
	var button = new FlxButton(x, y);
	button.loadGraphic(FlxGraphic.fromFrame(getFrames().getByName(frames)));
	button.antialiasing = orgAntialiasing;
	button.alpha = 0;// sorry but I can't hard lock the hitbox alpha
	button.onDown.callback = function (){FlxTween.num(0, 0.75, 0.075, {ease:FlxEase.circInOut}, function(alpha:Float){ button.alpha = alpha;});};
	button.onUp.callback = function (){FlxTween.num(0.75, 0, 0.1, {ease:FlxEase.circInOut}, function(alpha:Float){ button.alpha = alpha;});}
	button.onOut.callback = function (){FlxTween.num(button.alpha, 0, 0.2, {ease:FlxEase.circInOut}, function(alpha:Float){ button.alpha = alpha;});}
	return button;
    }

    public function getFrames():FlxAtlasFrames {
        return switch (orgType)
        {
            case FOUR:
                Paths.getSparrowAtlas('android/hitbox');
            case SIX:
                Paths.getSparrowAtlas('android/6k');
            case NINE:
                Paths.getSparrowAtlas('android/9k');
        }
    }

    override public function destroy():Void
    {
            super.destroy();

            K1 = null;
            K2 = null;
            K3 = null;
            K4 = null;
            K5 = null;
            K6 = null;
            K7 = null;
            K8 = null;
            K9 = null;
    }
}

enum HitboxType {
    FOUR;
    SIX;
    NINE;
}
