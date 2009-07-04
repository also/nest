package com.ryanberdeen.nest {
  import gs.TweenMax;

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;

  public class SoundPositionSource extends EventDispatcher implements IPositionSource {
    private var sound:Sound;
    private var soundChannel:SoundChannel;
    private var soundChannelPosition:Number = 0;
    private var playing:Boolean;

    public function SoundPositionSource(sound:Sound):void {
      this.sound = sound;
    }

    public function start():void {
      if (soundChannel != null) {
        soundChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
      }

      soundChannel = sound.play(soundChannelPosition);
      soundChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
      playing = true;
    }

    public function stop():void {
      soundChannelPosition = soundChannel.position;
      soundChannel.stop();
      playing = false;
    }

    public function reset():void {
      soundChannelPosition = 0;
    }

    public function fadeOut():void {
      TweenMax.to(soundChannel, 3, {volume: 0, onComplete: stop});
    }

    public function get position():Number {
      return soundChannel.position;
    }

    private function soundCompleteHandler(e:Event):void {
      dispatchEvent(new Event(Event.COMPLETE));
    }
  }
}
