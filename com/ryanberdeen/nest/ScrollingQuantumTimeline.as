package com.ryanberdeen.nest {
  import flash.display.Shape;
  import flash.display.Sprite;

  public class ScrollingQuantumTimeline extends Sprite {
    private var timeline:QuantumTimeline;
    private var durationScale:Number;
    private var displayWidth:Number;

    public function ScrollingQuantumTimeline(data:Object, durationScale:Number, displayWidth:Number):void {
      this.durationScale = durationScale;
      this.displayWidth = displayWidth;

      var pointer:Shape = new Shape();
      pointer.graphics.beginFill(0x000000);
      pointer.graphics.moveTo(5, 0);
      pointer.graphics.lineTo(10, 10);
      pointer.graphics.lineTo(0, 10);
      pointer.graphics.lineTo(5, 0);
      pointer.graphics.endFill();
      pointer.y = 50;
      pointer.x = displayWidth / 2 - 5;
      addChild(pointer);

      timeline = new QuantumTimeline(data, durationScale);
      addChild(timeline);
      position = 0;
    }

    public function set position(p:Number):void {
      timeline.x = -p * (durationScale / 1000) + displayWidth / 2;
    }
  }
}