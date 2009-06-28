package com.ryanberdeen.nest {
  import flash.display.Shape;
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.net.URLRequest;

  public class NestVis extends Sprite {
    private var data:Object;
    private var displayWidth:Number;
    private var displayHeight:Number;
    private var duration:Number;
    private var durationScale:Number;

    private var timeline:ScrollingQuantumTimeline;

    private var barIndicator:QuantumIndicator;
    private var beatIndicator:QuantumIndicator;
    private var segmentIndicator:QuantumIndicator;
    private var tatumIndicator:QuantumIndicator;

    public function NestVis(data:Object, displayWidth:Number):void {
      this.data = data;
      this.displayWidth = displayWidth;
      displayHeight = 200;

      duration = data.duration * 1000;

      var background:Shape = new Shape();
      background.graphics.beginFill(0xffffff);
      background.graphics.drawRect(0, 0, displayWidth, displayHeight);
      background.graphics.endFill();
      addChild(background);

      barIndicator = new QuantumIndicator(data.bars, 200, 0x00ffff);
      barIndicator.x = 10;
      barIndicator.y = 10;
      addChild(barIndicator);

      beatIndicator = new QuantumIndicator(data.beats, 200, 0xffff00);
      beatIndicator.x = 80;
      beatIndicator.y = 10;
      addChild(beatIndicator);

      tatumIndicator = new QuantumIndicator(data.tatums, 50, 0xff00ff);
      tatumIndicator.x = 150;
      tatumIndicator.y = 10;
      addChild(tatumIndicator);

      segmentIndicator = new QuantumIndicator(data.segments, 50, 0xdddddd);
      segmentIndicator.x = 220;
      segmentIndicator.y = 10;
      addChild(segmentIndicator);

      durationScale = 100;//(displayWidth - 20) / data.duration;
      timeline = new ScrollingQuantumTimeline(data, durationScale, displayWidth);
      timeline.y = 80;
      addChild(timeline);
    }

    public function set position(p:Number):void {
      timeline.position = p;
      barIndicator.position = p;
      beatIndicator.position = p;
      segmentIndicator.position = p;
      tatumIndicator.position = p;
    }
  }
}
