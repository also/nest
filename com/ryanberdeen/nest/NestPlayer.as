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
    private var _options:Object;
    public var positionListener:Object;
    private var _data:Object;

    public var sound:Sound;
    private var soundChannel:SoundChannel;
    private var soundChannelPosition:Number = 0;
    private var playing:Boolean;

    public function NestPlayer(options:Object = null):void {
      this.options = options || {};
    }

    public function set options(options:Object):void {
      _options = options;
    }

    public function get data():Object {
      return _data;
    }

    public function set data(data:Object):void {
      _data = data;
      if (_options.bars) {
        barStatus = new QuantumStatus(data.bars, _options.bars);
      }
      if (_options.beats) {
        beatStatus = new QuantumStatus(data.beats, _options.beats);
      }

      if (_options.tatums) {
        tatumStatus = new QuantumStatus(data.tatums, _options.tatums);
      }

      if (_options.segments) {
        segmentStatus = new QuantumStatus(data.segments, _options.segments);
      }
      if (_options.positionListener) {
        positionListener = _options.positionListener;
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
      if (_options.pauseHandler != null) {
        _options.pauseHandler();
      }
    }

    private function soundCompleteHandler(e:Event):void {
      if (_options.soundCompleteHandler != null) {
        _options.soundCompleteHandler();
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
      if (positionListener) {
        positionListener.position = soundChannel.position;
      }
    }
  }
}
