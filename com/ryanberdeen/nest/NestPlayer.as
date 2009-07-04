package com.ryanberdeen.nest {
  import flash.events.Event;
  import flash.net.URLRequest;

  public class NestPlayer implements INestPlayer {
    private var _barStatus:QuantumStatus;
    private var _beatStatus:QuantumStatus;
    private var _tatumStatus:QuantumStatus;
    private var _segmentStatus:QuantumStatus;
    private var _options:Object;
    private var _data:Object;
    private var _positionSource:IPositionSource;
    private var _driver:IDriver;
    private var prepared:Boolean;

    public function NestPlayer(options:Object = null):void {
      prepared = false;
      this.options = options || {};
      driver = new TimerDriver();
    }

    public function set options(options:Object):void {
      prepared = false;
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
      prepared = false;
      _data = data;
    }

    public function get position():Number {
      return _positionSource.position;
    }

    public function get barStatus():QuantumStatus {
      return _barStatus;
    }

    public function get beatStatus():QuantumStatus {
      return _beatStatus;
    }

    public function get tatumStatus():QuantumStatus {
      return _tatumStatus;
    }

    public function get segmentStatus():QuantumStatus {
      return _segmentStatus;
    }

    public function start():void {
      if (!prepared) {
        prepare();
        prepared = true;
      }
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

    public function prepare():void {
      _barStatus = new QuantumStatus(data.bars, _options.bars);
      _beatStatus = new QuantumStatus(data.beats, _options.beats);
      _tatumStatus = new QuantumStatus(data.tatums, _options.tatums);
      _segmentStatus = new QuantumStatus(data.segments, _options.segments);

      prepared = true;
    }

    private function completeHandler(e:Event):void {
      _driver.stop();
    }

    private function driverEventHandler(e:Event):void {
      var position:Number = _positionSource.position;

      _barStatus.position = position;
      _beatStatus.position = position;
      _tatumStatus.position = position;
      _segmentStatus.position = position;
    }
  }
}
