package com.ryanberdeen.nest {
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.net.URLRequest;

  public class NestPlayer extends Sprite {
    private var nestVis:NestVis;
    private var sound:Sound;
    private var soundChannel:SoundChannel;
    private var soundChannelPosition:Number = 0;
    private var playing:Boolean;
    private var audioUrl:String;

    public function NestPlayer(data:Object, audioUrl:String, displayWidth:Number):void {
      this.audioUrl = audioUrl;

      nestVis = new NestVis(data, displayWidth);
      addChild(nestVis);
      
      addEventListener(MouseEvent.CLICK, mouseClickHandler);
      start();
    }

    private function start():void {
      sound = new Sound();
      sound.load(new URLRequest(audioUrl));
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

    private function enterFrameHandler(e:Event):void {
      nestVis.position = soundChannel.position;
    }

    private function mouseClickHandler(e:MouseEvent):void {
      playing ? pause() : play();
    }

  }
}
