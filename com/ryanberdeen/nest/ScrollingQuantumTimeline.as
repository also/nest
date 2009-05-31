package com.ryanberdeen.nest {
  import flash.display.Sprite;

  class ScrollingQuantumTimeline extends Sprite {
    private var timeline:QuantumTimeline;
    private var durationScale:Number;
    private var displayWidth:Number;

    public function ScrollingQuantumTimeline(data:Object, durationScale:Number, displayWidth:Number):void {
      this.durationScale = durationScale;
      this.displayWidth = displayWidth;
      timeline = new QuantumTimeline(data, durationScale);
      addChild(timeline);
    }

    public function set position(p:Number):void {
      timeline.x = -p * (durationScale / 1000) + displayWidth / 2;
    }
  }
}