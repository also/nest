package com.ryanberdeen.nest {
  import flash.events.Event;
  import flash.events.EventDispatcher;

  public class TimePositionSource extends EventDispatcher implements IPositionSource {
    private var length:Number;
    private var offset:Number;
    private var stopPosition:Number;
    private var started:Boolean;
    private var playing:Boolean;

    public function TimePositionSource(length:Number):void {
      this.length = length;
      reset();
    }

    public function start():void {
      offset = getTime();

      if (started) {
        offset -= stopPosition;
      }
      playing = started = true;
    }

    public function stop():void {
      stopPosition = position;
      playing = false;
    }

    public function reset():void {
      playing = false;
      started = false;
      stopPosition = 0;
    }

    public function get position():Number {
      if (playing) {
        var result:Number = getTime() - offset;
        if (result >= length) {
          dispatchEvent(new Event(Event.COMPLETE));
        }
        return result;
      }
      else {
        return stopPosition;
      }
    }

    private function getTime():Number {
      return new Date().getTime();
    }
  }
}
