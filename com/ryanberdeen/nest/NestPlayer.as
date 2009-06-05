package com.ryanberdeen.nest {
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.net.URLRequest;

  public class NestPlayer extends Sprite {
    private var barStatus:QuantumStatus;
    private var beatStatus:QuantumStatus;
    private var segmentStatus:QuantumStatus;
    private var tatumStatus:QuantumStatus;
    private var options:Object;

    private var sound:Sound;
    private var soundChannel:SoundChannel;
    private var soundChannelPosition:Number = 0;
    private var playing:Boolean;
    private var audioUrl:String;

    public function NestPlayer(audioUrl:String, options = null):void {
      sound = new Sound();
      sound.load(new URLRequest(audioUrl));
      this.audioUrl = audioUrl;

      this.options = options || {};
    }

    public function set data(data:Object):void {
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

    private function play():void {
      soundChannel = sound.play(soundChannelPosition);
      soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
      playing = true;
    }

    private function pause():void {
      soundChannelPosition = soundChannel.position;
      soundChannel.stop();
      playing = false;
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
