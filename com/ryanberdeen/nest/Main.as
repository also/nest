package com.ryanberdeen.nest {
  import com.adobe.serialization.json.JSON;

  import com.ryanberdeen.cubes.Cubes;

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.Timer;
  import flash.events.TimerEvent;

  public class Main extends Sprite {
    private var loader:URLLoader;
    private var player:NestPlayer;
    private var cubes:Cubes;
    private var timer:Timer;

    public function Main():void {
      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, nestDataCompleteHandler);

      cubes = new Cubes();
      addChild(cubes);

      play('http://static.ryanberdeen.com/projects/nest/lo');
    }

    private function play(url:String):void {
      var request:URLRequest = new URLRequest(url + '.json');
      loader.load(request);

      player = new NestPlayer(url + '.mp3', {
        bars: {
          triggerStartHandler: cubes.barTriggerHandler,
          triggerStartOffset: -50
        },
        beats: {
          triggerStartHandler: cubes.beatTriggerHandler,
          triggerStartOffset: -100
        },
        tatums: {
          triggerStartHandler: cubes.tatumTriggerHandler,
          triggerStartOffset: -50
        },
        soundCompleteHandler: soundCompleteHandler,
        pauseHandler: pauseHandler
      });
    }

    private function nestDataCompleteHandler(e:Event):void {
      var data:Object = JSON.decode(loader.data);
      player.data = data;

      timer = new Timer(5000, 1);
      timer.addEventListener('timer', startTimerHandler);
      timer.start();
    }

    private function startTimerHandler(e:TimerEvent):void {
      player.start();
    }

    private function advance():void {
      player.fadeOut();
    }

    private function soundCompleteHandler():void {
      cubes.stop();
    }

    private function pauseHandler():void {
      cubes.pause();
      play('http://static.ryanberdeen.com/projects/nest/pp');
    }
  }
}
