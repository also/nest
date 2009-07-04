package com.ryanberdeen.nest {
  public interface INestPlayer {
    function set options(options:Object):void;
    function get data():Object;
    function get driver():IDriver;
    function get position():Number;
  }
}