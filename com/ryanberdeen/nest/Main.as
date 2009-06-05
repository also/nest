package com.ryanberdeen.nest {
  import com.adobe.serialization.json.JSON;

  import com.ryanberdeen.cubes.Cubes;

  import flash.display.Sprite;
  import flash.events.Event;
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

      var request:URLRequest = new URLRequest('http://static.ryanberdeen.com/projects/nest/lo.json');
      loader.load(request);

      cubes = new Cubes();
      addChild(cubes);

      player = new NestPlayer('http://static.ryanberdeen.com/projects/nest/lo.mp3', {
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
        soundCompleteHandler: cubes.stop
      });
    }

    private function nestDataCompleteHandler(e:Event):void {
      var data:Object = JSON.decode(loader.data);
      player.data = data;

      timer = new Timer(5000, 1);
      timer.addEventListener('timer', timerHandler);
      timer.start();
    }

    private function timerHandler(e:TimerEvent) {
      player.start();
    }
  }
}
