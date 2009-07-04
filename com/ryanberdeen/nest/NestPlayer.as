package com.ryanberdeen.nest {
  import flash.events.Event;
  import flash.net.URLRequest;
  import flash.utils.Timer;

  public class NestPlayer implements INestPlayer {
    private var barStatus:QuantumStatus;
    private var beatStatus:QuantumStatus;
    private var segmentStatus:QuantumStatus;
    private var tatumStatus:QuantumStatus;
    private var _options:Object;
    public var _positionListener:Object;
    private var _data:Object;
    private var _positionSource:IPositionSource;
    private var timer:Timer;

    public function NestPlayer(options:Object = null):void {
      this.options = options || {};
      timer = new Timer(10);
      timer.addEventListener('timer', timerEventHandler);
    }

    public function set options(options:Object):void {
      _options = options;
    }

    public function set positionSource(positionSource:IPositionSource):void {
      if (_positionSource != null) {
        _positionSource.removeEventListener(Event.COMPLETE, completeHandler);
      }

      _positionSource = positionSource;
      _positionSource.removeEventListener(Event.COMPLETE, completeHandler);
    }

    public function set positionListener(positionListener:Object):void {
      _positionListener = positionListener;
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
      if (_options.positionListener) {
        positionListener = _options.positionListener;
      }
    }

    public function start():void {
      _positionSource.start();
      timer.start();
    }

    private function stop():void {
      _positionSource.stop();
      timer.stop();
    }

    public function reset():void {
      _positionSource.reset();
    }

    private function completeHandler(e:Event):void {

    }

    private function timerEventHandler(e:Event):void {
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
      if (_positionListener) {
        _positionListener.position = _positionSource.position;
      }
    }
  }
}
