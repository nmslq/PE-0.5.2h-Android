package android;

import android.flixel.FlxButton;
import android.flixel.FlxHitbox;
import android.flixel.FlxVirtualPad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSave;
import flixel.util.FlxColor;
import flixel.input.touch.FlxTouch;
import flixel.text.FlxText;
import openfl.utils.Assets;

class AndroidControlsSubState extends FlxSubState
{
	final controlsItems:Array<String> = ['Pad-Right', 'Pad-Left', 'Pad-Custom', 'Pad-Duo', 'Hitbox', 'Keyboard'];
	var virtualPad:FlxVirtualPad;
	var hitbox:FlxHitbox;
	var upPosition:FlxText;
	var downPosition:FlxText;
	var leftPosition:FlxText;
	var rightPosition:FlxText;
	var grpControls:FlxText;
	var funitext:FlxText;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var curSelected:Int = 0;
	var buttonBinded:Bool = false;
	var bindButton:FlxButton;
	var resetButton:FlxButton;

	override function create()
	{
		for (i in 0...controlsItems.length)
			if (controlsItems[i] == AndroidControls.mode)
				curSelected = i;

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)));
		bg.scrollFactor.set();
		bg.alpha = 0.4;
		add(bg);

		var exitButton:FlxButton = new FlxButton(FlxG.width - 200, 50, 'Exit', function()
		{
			AndroidControls.mode = controlsItems[Math.floor(curSelected)];

			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
				AndroidControls.customVirtualPad = virtualPad;

			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		});
		exitButton.setGraphicSize(Std.int(exitButton.width) * 3);
		exitButton.label.setFormat(Assets.getFont('assets/images/android/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		exitButton.color = FlxColor.YELLOW;
		add(exitButton);

		resetButton = new FlxButton(FlxG.width - 200, 50, 'Reset', function()
		{
			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom' && resetButton.visible) // being sure about something
			{
				MobileControls.customVirtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
				reloadMobileControls('Pad-Custom');
			}
		});
		resetButton.setGraphicSize(Std.int(resetButton.width) * 3);
		resetButton.label.setFormat(Assets.getFont('assets/images/android/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		resetButton.color = FlxColor.RED;
		resetButton.visible = false;
		add(resetButton);

		funitext = new FlxText(0, 0, 0, 'No Android Controls!', 42);
		funitext.setFormat(Assets.getFont('assets/images/android/menu/Funkin Bold.otf').fontName, 42, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		funitext.borderSize = 3;
		funitext.borderQuality = 1;
		funitext.screenCenter();
		funitext.visible = false;
		add(funitext);

		grpControls = new FlxText(0, 100, 0, '', 42);
		grpControls.setFormat(Assets.getFont('assets/images/android/menu/Funkin Bold.otf').fontName, 42, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		grpControls.borderSize = 3;
		grpControls.borderQuality = 1;
		grpControls.screenCenter(X);
		add(grpControls);

		leftArrow = new FlxSprite(grpControls.x - 60, grpControls.y - 25);
		leftArrow.frames = Paths.getSparrowAtlas('android/menu/arrows');
		leftArrow.animation.addByPrefix('idle', 'arrow left');
		leftArrow.animation.play('idle');
		add(leftArrow);

		rightArrow = new FlxSprite(grpControls.x + grpControls.width + 10, grpControls.y - 25);
		rightArrow.frames = Paths.getSparrowAtlas('android/menu/arrows');
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.play('idle');
		add(rightArrow);

		rightPosition = new FlxText(10, FlxG.height - 24, 0, '', 21);
		rightPosition.setFormat(Assets.getFont('assets/images/android/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		rightPosition.borderSize = 3;
		rightPosition.borderQuality = 1;
		add(rightPosition);

		leftPosition = new FlxText(10, FlxG.height - 44, 0, '', 21);
		leftPosition.setFormat(Assets.getFont('assets/images/android/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		leftPosition.borderSize = 3;
		leftPosition.borderQuality = 1;
		add(leftPosition);

		downPosition = new FlxText(10, FlxG.height - 64, 0, '', 21);
		downPosition.setFormat(Assets.getFont('assets/images/android/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		downPosition.borderSize = 3;
		downPosition.borderQuality = 1;
		add(downPosition);

		upPosition = new FlxText(10, FlxG.height - 84, 0, '', 21;
		upPosition.setFormat(Assets.getFont('assets/images/android/menu/Funkin Bold.otf').fontName, 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE,
			FlxColor.BLACK, true);
		upPosition.borderSize = 3;
		upPosition.borderQuality = 1;
		add(upPosition);

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (touch in FlxG.touches.list)
		{
			if (touch.overlaps(leftArrow) && touch.justPressed)
				changeSelection(-1);
			else if (touch.overlaps(rightArrow) && touch.justPressed)
				changeSelection(1);

			if (controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
			{
				if (buttonBinded)
				{
					if (touch.justReleased)
					{
						bindButton = null;
						buttonBinded = false;
					}
					else
						moveButton(touch, bindButton);
				}
				else
				{
					if (virtualPad.buttonUp.justPressed)
						moveButton(touch, virtualPad.buttonUp);

					if (virtualPad.buttonDown.justPressed)
						moveButton(touch, virtualPad.buttonDown);

					if (virtualPad.buttonRight.justPressed)
						moveButton(touch, virtualPad.buttonRight);

					if (virtualPad.buttonLeft.justPressed)
						moveButton(touch, virtualPad.buttonLeft);
				}
			}

			for (i in [virtualPad.buttonUp, virtualPad.buttonDown, virtualPad.buttonRight, virtualPad.buttonLeft])
					for (j in [upPosition, downPosition, leftPosition, rightPosition])
						if (i == bindButton)
							j.addFormat(new FlxTextFormat(FlxColor.YELLOW), 0, j.text.length);
			}

		if (virtualPad != null && controlsItems[Math.floor(curSelected)] == 'Pad-Custom')
		{
			if (virtualPad.buttonUp != null)
				upPosition.text = 'Button Up X:' + virtualPad.buttonUp.x + ' Y:' + virtualPad.buttonUp.y;

			if (virtualPad.buttonDown != null)
				downPosition.text = 'Button Down X:' + virtualPad.buttonDown.x + ' Y:' + virtualPad.buttonDown.y;

			if (virtualPad.buttonLeft != null)
				leftPosition.text = 'Button Left X:' + virtualPad.buttonLeft.x + ' Y:' + virtualPad.buttonLeft.y;

			if (virtualPad.buttonRight != null)
				rightPosition.text = 'Button Right X:' + virtualPad.buttonRight.x + ' Y:' + virtualPad.buttonRight.y;
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = controlsItems.length - 1;
		else if (curSelected >= controlsItems.length)
			curSelected = 0;

		grpControls.text = controlsItems[curSelected].toUpperCase();
		grpControls.screenCenter(X);

		leftArrow.x = grpControls.x - 60;
		rightArrow.x = grpControls.x + grpControls.width + 10;

		var daChoice:String = controlsItems[Math.floor(curSelected)];

		reloadMobileControls(daChoice);

		funitext.visible = daChoice == 'Keyboard';
		resetButton.visible = daChoice == 'Pad-Custom';
		upPosition.visible = daChoice == 'Pad-Custom';
		downPosition.visible = daChoice == 'Pad-Custom';
		leftPosition.visible = daChoice == 'Pad-Custom';
		rightPosition.visible = daChoice == 'Pad-Custom';
	}

	function moveButton(touch:FlxTouch, button:FlxButton):Void
	{
		bindButton = button;
		bindButton.x = touch.x - Std.int(bindButton.width / 2);
		bindButton.y = touch.y - Std.int(bindButton.height / 2);

		if (!buttonBinded)
			buttonBinded = true;
	}

	function reloadMobileControls(daChoice:String):Void
	{

		switch (daChoice)
		{
			case 'Pad-Right':
				removeControls();
				virtualPad = new FlxVirtualPad(RIGHT_FULL, NONE);
				add(virtualPad);
			case 'Pad-Left':
				removeControls();
				virtualPad = new FlxVirtualPad(LEFT_FULL, NONE);
				add(virtualPad);
			case 'Pad-Custom':
				removeControls();
				virtualPad = AndroidControls.customVirtualPad;
				add(virtualPad);
			case 'Pad-Duo':
				removeControls();
				virtualPad = new FlxVirtualPad(BOTH_FULL, NONE);
				add(virtualPad);
			case 'Hitbox':
				removeControls();
				hitbox = new FlxHitbox();
				add(hitbox);
			default:
				removeControls();
		}

		if (virtualPad != null)
			virtualPad.visible = (daChoice != 'Hitbox' && daChoice != 'Keyboard');

		if (hitbox != null)
			hitbox.visible = (daChoice == 'hitbox');
	}

	private function removeControls():Void
	{
		if (virtualPad != null)
			remove(virtualPad);

		if (hitbox != null)
			remove(hitbox);
	}
}