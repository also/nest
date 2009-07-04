package com.ryanberdeen.nest {
  public class QuantumStatus {
    private var quantums:Array;
    private var nextIndex:int = 0;
    private var currentPosition:int = -1;
    private var nextPosition:int = -1;
    private var triggerStartOffset:Number;
    private var triggerEndOffset:Number;

    private var triggerStartHandler:Function;
    private var triggerEndHandler:Function;

    public function QuantumStatus(quantums:Array, options:Object = null):void {
      this.quantums = quantums;
      options ||= {};
      this.triggerStartOffset = options.triggerStartOffset || 0;
      this.triggerEndOffset = options.triggerEndOffset || 100;

      triggerStartHandler = options.triggerStartHandler;
      triggerEndHandler = options.triggerEndHandler;

      loadNextPosition();
    }

    public function set position(p:Number):void {
      if (currentPosition != -1 && currentPosition + triggerEndOffset <= p) {
        if (triggerEndHandler != null) {
          triggerEndHandler();
        }
      }

      if (nextPosition != -1 && p >= nextPosition + triggerStartOffset) {
        currentPosition = nextPosition;
        if (triggerStartHandler != null) {
          triggerStartHandler();
        }
        loadNextPosition();
      }
    }

    private function loadNextPosition():void {
      if (nextIndex < quantums.length) {
        nextPosition = quantums[nextIndex++][0] * 1000;
      }
      else {
        nextPosition = -1;
      }
    }

    public function get index():int {
      return nextIndex - 1;
    }

    public function get quantum():Array {
      return quantums[index];
    }
  }
}
