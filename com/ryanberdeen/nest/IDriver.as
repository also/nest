package com.ryanberdeen.nest {
  import flash.events.IEventDispatcher;

  public interface IDriver extends IEventDispatcher {
    function start():void;
    function stop():void;
  }
}
