package com.ryanberdeen.nest {
  import flash.display.Shape;
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.net.URLRequest;

  public class NestVis extends Sprite {
    private var data:Object;
    private var visShape:Shape;
    private var displayWidth:Number;
    private var displayHeight:Number;
    private var duration:Number;
    private var durationScale:Number;

    private var startTime:Number;
    private var sound:Sound;
    private var soundChannel:SoundChannel;
    private var soundChannelPosition:Number = 0;
    private var playing:Boolean;

    private var barIndicator:QuantumIndicator;
    private var beatIndicator:QuantumIndicator;
    private var segmentIndicator:QuantumIndicator;
    private var tatumIndicator:QuantumIndicator;

    public function NestVis(data:Object, displayWidth:Number):void {
      this.data = data;
      this.displayWidth = displayWidth;
      displayHeight = 200;
      trace('key: ' + data.key);
      trace('duration: ' + data.duration);
      trace('tempo: ' + data.tempo);
      trace('time_signature: ' + data.time_signature);
      trace('mode: ' + data.mode);
      trace('loudness: ' + data.loudness);
      trace('end_of_fade_in: ' + data.end_of_fade_in);
      trace('start_of_fade_out: ' + data.start_of_fade_out);
      trace('sections: ' + data.sections.length);
      trace('bars: ' + data.bars.length);
      trace('beats: ' + data.beats.length);
      trace('segments: ' + data.segments.length);
      trace('tatums: ' + data.tatums.length);

      duration = data.duration * 1000;

      var background:Shape = new Shape();
      background.graphics.beginFill(0xffffff);
      background.graphics.drawRect(0, 0, displayWidth, displayHeight);
      background.graphics.endFill();
      addChild(background);

      var pointer:Shape = new Shape();
      pointer.graphics.beginFill(0x000000);
      pointer.graphics.moveTo(5, 0);
      pointer.graphics.lineTo(10, 10);
      pointer.graphics.lineTo(0, 10);
      pointer.graphics.lineTo(5, 0);
      pointer.graphics.endFill();
      pointer.y = displayHeight;
      pointer.x = displayWidth / 2 - 5;
      addChild(pointer);

      barIndicator = new QuantumIndicator(data.bars, 200, 0x00ffff);
      barIndicator.x = 10;
      barIndicator.y = 10;
      addChild(barIndicator);

      beatIndicator = new QuantumIndicator(data.beats, 200, 0xffff00);
      beatIndicator.x = 80;
      beatIndicator.y = 10;
      addChild(beatIndicator);

      segmentIndicator = new QuantumIndicator(data.segments, 50, 0xff00ff);
      segmentIndicator.x = 150;
      segmentIndicator.y = 10;
      addChild(segmentIndicator);

      tatumIndicator = new QuantumIndicator(data.tatums, 50, 0xdddddd);
      tatumIndicator.x = 220;
      tatumIndicator.y = 10;
      addChild(tatumIndicator);

      this.durationScale = 100;//(displayWidth - 20) / data.duration;
      visShape = new QuantumTimeline(data, durationScale);
      addChild(visShape);

      //addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
      addEventListener(MouseEvent.CLICK, mouseClickHandler);
      start();
    }

    private function start():void {
      startTime = getCurrentTime();
      sound = new Sound();
      sound.load(new URLRequest("http://static.ryanberdeen.com/projects/nest/lo.mp3"));
      play();
      addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function stop():void {
      removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function play():void {
      soundChannel = sound.play(soundChannelPosition);
      playing = true;
    }

    private function pause():void {
      soundChannelPosition = soundChannel.position;
      soundChannel.stop();
      playing = false;
    }

    private function mouseMoveHandler(e:MouseEvent):void {
      setVisPosition(e.localX / displayWidth);
    }

    private function mouseClickHandler(e:MouseEvent):void {
      playing ? pause() : play();
    }

    private function setVisPosition(p:Number):void {
      visShape.x = -p * (durationScale / 1000) + displayWidth / 2;
      barIndicator.setPosition(p);
      beatIndicator.setPosition(p);
      segmentIndicator.setPosition(p);
      tatumIndicator.setPosition(p);
    }

    private function enterFrameHandler(e:Event):void {
      setVisPosition(soundChannel.position);
    }

    private function getCurrentTime():Number {
      return new Date().getTime();
    }
  }
}
