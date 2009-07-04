package com.ryanberdeen.nest {
  import flash.events.Event;
  import flash.net.URLRequest;

  public class NestPlayer implements INestPlayer {
    private var barStatus:QuantumStatus;
    private var beatStatus:QuantumStatus;
    private var segmentStatus:QuantumStatus;
    private var tatumStatus:QuantumStatus;
    private var _options:Object;
    private var _data:Object;
    private var _positionSource:IPositionSource;
    private var _driver:IDriver;

    public function NestPlayer(options:Object = null):void {
      this.options = options || {};
      driver = new TimerDriver();
    }

    public function set options(options:Object):void {
      _options = options;
    }

    public function set positionSource(positionSource:IPositionSource):void {
      if (_positionSource != null) {
        // TODO throw exception
      }

      _positionSource = positionSource;
      _positionSource.addEventListener(Event.COMPLETE, completeHandler);
    }

    public function get driver():IDriver {
      return _driver;
    }

    public function set driver(driver:IDriver):void {
      if (_driver != null) {
        // TODO throw exception
      }

      _driver = driver;
      _driver.addEventListener(Event.CHANGE, driverEventHandler);
    }

    public function get data():Object {
      return _data;
    }

    public function set data(data:Object):void {
      _data = data;
      if (_options.bars) {
        barStatus = new QuantumStatus(data.bars, _options.bars);
      }
      if (_options.beats) {
        beatStatus = new QuantumStatus(data.beats, _options.beats);
      }

      if (_options.tatums) {
        tatumStatus = new QuantumStatus(data.tatums, _options.tatums);
      }

      if (_options.segments) {
        segmentStatus = new QuantumStatus(data.segments, _options.segments);
      }
    }

    public function get position():Number {
      return _positionSource.position;
    }

    public function start():void {
      _positionSource.start();
      _driver.start();
    }

    private function stop():void {
      _positionSource.stop();
      _driver.stop();
    }

    public function reset():void {
      _positionSource.reset();
    }

    private function completeHandler(e:Event):void {
      _driver.stop();
    }

    private function driverEventHandler(e:Event):void {
      if (barStatus) {
        barStatus.position = _positionSource.position;
      }
      if (beatStatus) {
        beatStatus.position = _positionSource.position;
      }
      if (tatumStatus) {
        tatumStatus.position = _positionSource.position;
      }
      if (segmentStatus) {
        segmentStatus.position = _positionSource.position;
      }
    }
  }
}
