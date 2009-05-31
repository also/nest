package com.ryanberdeen.nest {
  import flash.display.Shape;
  import flash.display.Graphics;

  class QuantumTimeline extends Shape {
    private var displayHeight:Number;
    private var durationScale:Number;

    public function QuantumTimeline(data:Object, durationScale:Number):void {
      this.durationScale = durationScale;
      opaqueBackground = 0xffffff;
      cacheAsBitmap = true;
      displayHeight = 200;

      drawQuantums(data.sections, 100, 0x00ffff);
      drawQuantums(data.bars, 70, 0xff0000);
      drawQuantums(data.beats, 60);
      drawQuantums(data.tatums, 50);
      drawQuantums(data.segments, 40, 0xaaaaaa);
    }

    private function drawQuantums(quantums:Array, height:Number, color:uint = 0x000000):void {
      graphics.lineStyle(1, color);

      for each (var quantum:Object in quantums) {
        graphics.moveTo(quantum.start * durationScale, displayHeight - height - 10);
        graphics.lineTo(quantum.start * durationScale, displayHeight - height);
      }
    }
  }
}
