package com.ryanberdeen.nest {
  import flash.display.Shape;

  class QuantumIndicator extends Shape {
    private var status:QuantumStatus;
    public function QuantumIndicator(data:Array, triggerDuration:Number, color:uint):void {
      graphics.beginFill(color);
      graphics.drawCircle(30, 30, 30);
      graphics.endFill();

      visible = false;
      status = new QuantumStatus(data, {
        triggerDuration: triggerDuration,
        triggerStartHandler: show,
        triggerEndHandler: hide
      });
    }

    public function show():void {
      visible = true;
    }

    public function hide():void {
      visible = false;
    }

    public function set position(p:Number) {
      status.position = p;
    }
  }
}