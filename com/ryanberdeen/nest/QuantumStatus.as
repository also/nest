package com.ryanberdeen.nest {
  class QuantumStatus {
    private var quantums:Array;
    private var nextIndex:int = 0;
    private var currentPosition = -1;
    private var nextPosition:int = -1;
    private var triggerDuration:Number;
    private var startTime:Number = -1;

    private var triggerStartHandler:Function;
    private var triggerEndHandler:Function;

    public function QuantumStatus(quantums:Array, options:Object):void {
      this.quantums = quantums;
      this.triggerDuration = options.triggerDuration || 100;

      triggerStartHandler = options.triggerStartHandler;
      triggerEndHandler = options.triggerEndHandler;

      loadNextPosition();
    }

    public function set position(p:Number) {
      if (currentPosition != -1 && currentPosition + triggerDuration <= p) {
        if (triggerEndHandler != null) {
          triggerEndHandler();
        }
      }

      if (p >= nextPosition) {
        currentPosition = nextPosition;
        if (triggerStartHandler != null) {
          triggerStartHandler();
        }
        loadNextPosition();
      }
    }

    private function loadNextPosition():void {
      if (nextIndex < quantums.length) {
        nextPosition = quantums[nextIndex++].start * 1000;
      }
    }
  }
}
