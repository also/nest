package com.ryanberdeen.nest {
  import flash.display.Sprite;
  import flash.display.Graphics;

  public class QuantumTimeline extends Sprite {
    private var durationScale:Number;

    public function QuantumTimeline(data:Object, durationScale:Number):void {
      this.durationScale = durationScale;
      opaqueBackground = 0xffffff;
      cacheAsBitmap = true;

      drawQuantums(data.sections, 0, 0x00ffff);
      drawQuantums(data.bars, 10, 0xff0000);
      drawQuantums(data.beats, 20);
      drawQuantums(data.tatums, 30);
      drawQuantums(data.segments, 40, 0xaaaaaa);
    }

    private function drawQuantums(quantums:Array, height:Number, color:uint = 0x000000):void {
      graphics.lineStyle(1, color);

      for each (var quantum:Object in quantums) {
        graphics.moveTo(quantum[0] * durationScale, height);
        graphics.lineTo(quantum[0] * durationScale, height + 10);
      }
    }
  }
}
