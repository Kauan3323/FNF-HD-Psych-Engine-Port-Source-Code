package;

import flixel.addons.display.FlxExtendedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.animation.FlxAnimation;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import lime.utils.AssetCache;
import flixel.util.FlxTimer;
import flixel.FlxObject;

class Gallery extends MusicBeatState
{
	var weeks:Array<String> = ['week1', 'week2', 'week3', 'week4', 'week7', 'weekC'];
	var weekImages:Array<Dynamic> = [
		['bf', 'gf', 'dad'],
		['skump','monster', 'void'],
		['pico','darnell','nene'],
		['void', 'mom', 'void'],
		['void', 'sonic', 'void'],
		['void', 'carol', 'void']
	];
	var weekTexts:FlxTypedGroup<FlxSprite>;
	var selectionBG:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 0;
	var art:FlxSprite;
	var logoBl:FlxSprite;
	public static var artSprites:FlxTypedGroup<FlxSprite>;
	var stopspamming:Bool = false;
	var canSelect:Bool = true;
	var isDebug:Bool = false;
	private var shit:FlxObject;
	override function create()
	{

		#if debug
		isDebug = true;
		#end
		
		shit = new FlxObject(0, 0, 1, 1);

		Conductor.changeBPM(95);
		FlxG.sound.playMusic(Paths.music('gallery'), 1);
		var bg:FlxSprite = new FlxSprite(0,0).makeGraphic(1280,720,FlxColor.fromRGB(69,108,207),false);
		add(bg);

		var checkers:FlxBackdrop = new FlxBackdrop(Paths.image('gallery/checkers'),0,0,true,true,0,0);
		checkers.velocity.x = 20;
		checkers.velocity.y = 20;
		add(checkers);

		weekTexts = new FlxTypedGroup<FlxSprite>();
		selectionBG = new FlxTypedGroup<FlxSprite>();
		add(selectionBG);
		add(weekTexts);

		logoBl = new FlxSprite(0, 0);
		logoBl.screenCenter();
		if(!ClientPrefs.OldHDbg) {
			logoBl.x -= 260;
			logoBl.y -= 150;
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		} else {
			logoBl.x -= 190;
			logoBl.y -= 100;
			logoBl.frames = Paths.getSparrowAtlas('logoBumpinOld');
		}
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.alpha = 0.4;
		logoBl.setGraphicSize(Std.int(logoBl.width * 0.5));
		logoBl.updateHitbox();
		add(logoBl);
	
		for (i in 0...weeks.length) {
			var weekText:FlxSprite = new FlxSprite(20 + (300 * i), 40).loadGraphic(Paths.image('storymenu/' + weeks[i]));
			weekText.antialiasing = ClientPrefs.globalAntialiasing;
			weekText.ID = i;
			weekText.setGraphicSize(Std.int(weekText.width * 0.7));
			weekTexts.add(weekText);
		}

		artSprites = new FlxTypedGroup<FlxSprite>();
		add(artSprites);

		for (i in 0...weekImages[0].length) {
			art = new FlxSprite(80 +(400 * i), 150).loadGraphic(Paths.image('gallery/art/' + weekImages[0][i]));
			art.setGraphicSize(Std.int(art.width * 0.15));
			art.updateHitbox();
			art.antialiasing = ClientPrefs.globalAntialiasing;
			artSprites.add(art);
		}

		changeWeek();

		#if android
		addVirtualPad(LEFT_FULL, A_B);
		#end
			
		super.create();
	}

	override public function update(elapsed:Float) {
	
		if (controls.UI_RIGHT_P && canSelect)
			changeWeek(1);
		if (controls.UI_LEFT_P && canSelect)
			changeWeek(-1);
		if (controls.BACK){
			persistentUpdate = true;
			persistentDraw = true;
			FlxG.sound.music.stop();
			MusicBeatState.switchState(new MainMenuState());
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		if (controls.ACCEPT && !stopspamming){
			selectWeek(curSelected);
			stopspamming = true;
			canSelect = false;
		}

		if (FlxG.sound.music != null)
		Conductor.songPosition = FlxG.sound.music.time;
		super.update(elapsed);
	}

	public function changeWeek(change:Int = 0):Void {
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);

		curSelected += change;

		if (curSelected >= weeks.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = weeks.length - 1;

		weekTexts.forEach(function(weekText:FlxSprite) {
			if (weekText.ID == curSelected)
				FlxTween.tween(weekText, {alpha: 0}, 1,{type:PINGPONG});
			else
			{
				FlxTween.cancelTweensOf(weekText);
				weekText.alpha = 1;
			}
		});
		//for (shit in weekTexts.members) {
			//if (curSelected == 1) {
			//	shit.x = 0;
			//}
			//if (curSelected == 7) {
			//	shit.x += 150;
			//}
		//}
		artSprites.members[0].loadGraphic(Paths.image('gallery/art/' + weekImages[curSelected][0]));
		artSprites.members[1].loadGraphic(Paths.image('gallery/art/' + weekImages[curSelected][1]));
		artSprites.members[2].loadGraphic(Paths.image('gallery/art/' + weekImages[curSelected][2]));
	}

	override function beatHit()
	{
		super.beatHit();
		logoBl.animation.play('bump', true);
	}

	function selectWeek(selection:Int) {
		FlxFlicker.flicker(weekTexts.members[curSelected],0);
		FlxG.sound.play(Paths.sound('confirmMenu'));
		new FlxTimer().start(1, function(tmr:FlxTimer) {
			persistentUpdate = false;
			persistentDraw = false;
			FlxFlicker.stopFlickering(weekTexts.members[curSelected]);
			openSubState(new GallerySubState(weekImages[curSelected]));
		});
	}

	override function closeSubState() {
		shit.screenCenter();
		canSelect = true;
		FlxG.camera.focusOn(shit.getPosition());
		FlxG.camera.zoom = 1;
		stopspamming = false;
		super.closeSubState();
	}
}
