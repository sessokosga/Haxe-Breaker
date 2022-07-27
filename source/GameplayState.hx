package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

enum ObjectType
{
	BALL;
	PAD;
	BLOCK;
}

/**
 * ...
 * @author ...
 */
class GameplayState extends FlxState
{
	static inline var WIDTH:Int = 640;
	static inline var HEIGHT:Int = 480;
	static inline var MAX_LEVEL:Int = 5;

	var level = 1;

	var soundPad:FlxSound;
	var soundLoose:FlxSound;
	var soundBlock:FlxSound;
	var listBlocks:FlxTypedGroup<FlxSprite>;
	var pad:Pad;
	var ball:Ball;
	var line:FlxSprite;

	override public function create()
	{
		super.create();
		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.S31_Night_Prowler__ogg);
		}

		soundPad = FlxG.sound.load(AssetPaths.arkanoid_raquette__wav);
		soundLoose = FlxG.sound.load(AssetPaths.arkanoid_perdu__wav);
		soundBlock = FlxG.sound.load(AssetPaths.arkanoid_brique__wav);

		FlxG.mouse.visible = false;
		line = new FlxSprite(0, 45);
		line.makeGraphic(640, 2, FlxColor.WHITE);
		add(line);

		// Pad
		pad = new Pad(320, 480 - 25);

		add(pad);

		// Ball
		ball = new Ball(pad.x+50, pad.y);
		add(ball);

		// Blocks
		listBlocks = new FlxTypedGroup<FlxSprite>();
		add(listBlocks);
		loadLevel(5);
	}

	public function loadLevel(pLevel:Int)
	{
		switch (pLevel)
		{
			case 1:
				for (line in 0...5 + 1)
				{
					for (column in 1...15 + 1)
					{

						listBlocks.add(new Block(column * 35, line*30));
					}
				}
			case 2:
				for (line in 0...5 + 1)
				{
					for (column in 1...15 + 1)
					{
						if (column%4!=0)
							listBlocks.add(new Block(column * 35, line*30));
					}
				}
			case 3:
				for (line in 0...5 + 1)
				{
					if (line%3!=0)
					{
						for (column in 1...15 + 1)
						{
							listBlocks.add(new Block(column * 35, line*30));
						}
					}
				}
			case 4:
				for (line in 0...5 + 1)
				{
					for (column in 1...18 + 1)
					{
						if (column%3!=0)
							listBlocks.add(new Block(column * 35, line*30));
					}
				}
			case 5:
				for (line in 0...7 + 1)
				{
					if (line%4!=0)
					{
						for (column in 1...15 + 1)
						{
							if (column%4!=0)
								listBlocks.add(new Block(column * 35, line*30));
						}
					}
				}
		}

	}

	override public function update(elapsed:Float)
	{
		//FlxG.overlap(ball, pad, ballTouchedPad);
		FlxG.collide(ball, listBlocks, ballTouchedBlocks);
		if (FlxG.pixelPerfectOverlap(ball, pad))
		{
			ball.hitPad(pad);
			soundPad.play();
		}

		if (ball.y  > HEIGHT && !ball.isOff)
		{
			pad.hurt(1);
			ball.isOff = true;
			soundLoose.play();

		}

		super.update(elapsed);
	}

	public function ballTouchedPad(b:FlxSprite, p:FlxSprite)
	{
		ball.hitPad(pad);
		soundPad.play();
	}

	public function ballTouchedBlocks(b:FlxSprite, block:FlxSprite)
	{
		if (b.isTouching(FlxObject.LEFT) || b.isTouching(FlxObject.RIGHT))
			ball.changeDirX();
		if (b.isTouching(FlxObject.UP) || b.isTouching(FlxObject.DOWN))
			ball.changeDirY();
		soundBlock.play();
		listBlocks.remove(block);

	}
}
