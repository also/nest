package com.ryanberdeen.nest {
  import flash.display.Shape;

  public class QuantumIndicator extends Shape {
    private var status:QuantumStatus;
    public function QuantumIndicator(color:uint):void {
      graphics.beginFill(color);
      graphics.drawCircle(30, 30, 30);
      graphics.endFill();

      visible = false;
    }

    public function show():void {
      visible = true;
    }

    public function hide():void {
      visible = false;
    }
  }
}
