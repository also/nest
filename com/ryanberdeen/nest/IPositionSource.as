package com.ryanberdeen.nest {
  import flash.events.IEventDispatcher;

  public interface IPositionSource extends IEventDispatcher {
    function start():void;
    function stop():void;
    function reset():void;
    function get position():Number;
  }
}
