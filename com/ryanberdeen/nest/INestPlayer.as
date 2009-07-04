package com.ryanberdeen.nest {
  public interface INestPlayer {
    function set options(options:Object):void;
    function get data():Object;
    function get driver():IDriver;
    function get position():Number;
    function get barStatus():QuantumStatus;
    function get beatStatus():QuantumStatus;
    function get tatumStatus():QuantumStatus;
    function get segmentStatus():QuantumStatus;

    function prepare():void;
  }
}
