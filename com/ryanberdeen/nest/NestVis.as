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
    private var g:Graphics;
    private var durationScale:Number;
    private var displayWidth:Number;
    private var displayHeight:Number;
    private var duration:Number;

    private var startTime:Number;
    private var sound:Sound;
    private var soundChannel:SoundChannel;
    private var soundChannelPosition:Number = 0;
    private var playing:Boolean;
    
    private var nextBeatIndex:int = 0;
    private var nextBeatPosition:int = -1;
    private var beatVisibleDuration:Number = 100;
    private var beatStartTime:Number = -1;
    private var beatIndicator:Shape;

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
      
      visShape = new Shape();
      this.g = visShape.graphics;
      addChild(visShape);
      
      beatIndicator = new Shape();
      beatIndicator.graphics.beginFill(0xffff00);
      beatIndicator.graphics.drawCircle(30, 30, 30);
      beatIndicator.graphics.endFill();
      addChild(beatIndicator);

      this.durationScale = 100;//(displayWidth - 20) / data.duration;
      drawQuantums(data.sections, 100, 0x00ffff);
      drawQuantums(data.bars, 70, 0xff0000);
      drawQuantums(data.beats, 50);
      drawQuantums(data.segments, 10);
      
      visShape.cacheAsBitmap = true;

      //addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
      addEventListener(MouseEvent.CLICK, mouseClickHandler);
      start();
    }

    private function start():void {
      startTime = getCurrentTime();
      sound = new Sound();
      sound.load(new URLRequest("http://static.ryanberdeen.com/projects/nest/pp.mp3"));
      loadNextBeatPosition();
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
      
      if (beatStartTime != -1 && beatStartTime + beatVisibleDuration <= getCurrentTime()) {
        hideBeatIndicator();
      }
      
      if (p >= nextBeatPosition) {
        beatHandler();
        loadNextBeatPosition();
      }
    }

    private function loadNextBeatPosition():void {
      if (nextBeatIndex < data.beats.length) {
        nextBeatPosition = data.beats[nextBeatIndex++].start * 1000;
      }
    }
    
    private function beatHandler():void {
      showBeatIndicator();
      beatStartTime = getCurrentTime();
    }
    
    private function hideBeatIndicator():void {
      beatIndicator.visible = false;
    }
    
    private function showBeatIndicator():void {
      beatIndicator.visible = true;
    }
  
    private function enterFrameHandler(e:Event):void {
      setVisPosition(soundChannel.position);
    }

    private function drawQuantums(quantums:Array, height:Number, color:uint = 0x000000):void {
      g.lineStyle(1, color);

      for each (var quantum:Object in quantums) {
        g.moveTo(quantum.start * durationScale, displayHeight);
        g.lineTo(quantum.start * durationScale, displayHeight - height);
      }
    }

    private function getCurrentTime():Number {
      return new Date().getTime();
    }
  }
}
