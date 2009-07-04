package com.ryanberdeen.nest {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.utils.Timer;

  public class TimerDriver extends EventDispatcher implements IDriver {
    private var timer:Timer;

    public function TimerDriver():void {
      timer = new Timer(10);
      timer.addEventListener('timer', timerEventHandler);
    }

    public function start():void {
      timer.start();
    }

    public function stop():void {
      timer.stop();
    }

    private function timerEventHandler(e:Event):void {
      dispatchEvent(new Event(Event.CHANGE));
    }
  }
}
