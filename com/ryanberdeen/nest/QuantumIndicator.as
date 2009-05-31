package com.ryanberdeen.nest {
  import flash.display.Shape;

  class QuantumIndicator extends Shape {
    private var quantums:Array;
    public var nextIndex:int = 0;
    public var currentPosition = -1;
    public var nextPosition:int = -1;
    public var visibleDuration:Number;
    public var startTime:Number = -1;

    public function QuantumIndicator(quantums:Array, visibleDuration:Number, color:uint):void {
      this.quantums = quantums;
      this.visibleDuration = visibleDuration;
      graphics.beginFill(color);
      graphics.drawCircle(30, 30, 30);
      graphics.endFill();

      visible = false;
      loadNextPosition();
    }

    public function setPosition(p:Number) {
      if (currentPosition != -1 && currentPosition + visibleDuration <= p) {
        visible = false;
      }

      if (p >= nextPosition) {
        currentPosition = nextPosition;
        visible = true;
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