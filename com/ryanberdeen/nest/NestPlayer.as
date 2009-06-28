package com.ryanberdeen.nest {
  import gs.TweenMax;

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;
  import flash.net.URLRequest;

  public class NestPlayer extends Sprite {
    private var barStatus:QuantumStatus;
    private var beatStatus:QuantumStatus;
    private var segmentStatus:QuantumStatus;
    private var tatumStatus:QuantumStatus;
    private var options:Object;
    private var _data:Object;

    public var sound:Sound;
    private var soundChannel:SoundChannel;
    private var soundChannelPosition:Number = 0;
    private var playing:Boolean;

    public function NestPlayer(options:Object = null):void {
      this.options = options || {};
    }

    public function get data():Object {
      return _data;
    }

    public function set data(data:Object):void {
      _data = data;
      if (options.bars) {
        barStatus = new QuantumStatus(data.bars, options.bars);
      }
      if (options.beats) {
        beatStatus = new QuantumStatus(data.beats, options.beats);
      }

      if (options.tatums) {
        tatumStatus = new QuantumStatus(data.tatums, options.tatums);
      }

      if (options.segments) {
        segmentStatus = new QuantumStatus(data.segments, options.segments);
      }
    }

    public function start():void {
      play();
      addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function stop():void {
      pause();
      soundChannelPosition = 0;
      removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    public function fadeOut():void {
      TweenMax.to(soundChannel, 3, {volume: 0, onComplete: pause});
    }

    private function play():void {
      soundChannel = sound.play(soundChannelPosition);
      soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
      playing = true;
    }

    private function pause():void {
      soundChannelPosition = soundChannel.position;
      soundChannel.stop();
      playing = false;
      if (options.pauseHandler != null) {
        options.pauseHandler();
      }
    }

    private function soundCompleteHandler(e:Event):void {
      if (options.soundCompleteHandler != null) {
        options.soundCompleteHandler();
      }
    }

    private function enterFrameHandler(e:Event):void {
      if (barStatus) {
        barStatus.position = soundChannel.position;
      }
      if (beatStatus) {
        beatStatus.position = soundChannel.position;
      }
      if (tatumStatus) {
        tatumStatus.position = soundChannel.position;
      }
      if (segmentStatus) {
        segmentStatus.position = soundChannel.position;
      }
    }
  }
}
