package com.ryanberdeen.nest {
  import flash.display.Shape;
  import flash.display.Graphics;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.net.URLRequest;

  public class NestVis extends Sprite {
    private var nestPlayer:INestPlayer;
    private var displayWidth:Number;
    private var displayHeight:Number;
    private var duration:Number;
    private var durationScale:Number;

    private var timeline:ScrollingQuantumTimeline;

    private var barIndicator:QuantumIndicator;
    private var beatIndicator:QuantumIndicator;
    private var segmentIndicator:QuantumIndicator;
    private var tatumIndicator:QuantumIndicator;

    public function NestVis(nestPlayer:INestPlayer, displayWidth:Number):void {
      this.nestPlayer = nestPlayer;
      this.displayWidth = displayWidth;
      displayHeight = 200;

      nestPlayer.driver.addEventListener(Event.CHANGE, onChangeHandler);

      var data:Object = nestPlayer.data;

      duration = data.duration * 1000;

      var background:Shape = new Shape();
      background.graphics.beginFill(0xffffff);
      background.graphics.drawRect(0, 0, displayWidth, displayHeight);
      background.graphics.endFill();
      addChild(background);

      barIndicator = new QuantumIndicator(0x00ffff);
      barIndicator.x = 10;
      barIndicator.y = 10;
      addChild(barIndicator);

      beatIndicator = new QuantumIndicator(0xffff00);
      beatIndicator.x = 80;
      beatIndicator.y = 10;
      addChild(beatIndicator);

      tatumIndicator = new QuantumIndicator(0xff00ff);
      tatumIndicator.x = 150;
      tatumIndicator.y = 10;
      addChild(tatumIndicator);

      segmentIndicator = new QuantumIndicator(0xdddddd);
      segmentIndicator.x = 220;
      segmentIndicator.y = 10;
      addChild(segmentIndicator);

      nestPlayer.options = {
        bars: {
          triggerStartHandler: barIndicator.show,
          triggerEndHandler: barIndicator.hide
        },
        beats: {
          triggerStartHandler: beatIndicator.show,
          triggerEndHandler: beatIndicator.hide
        },
        tatums: {
          triggerStartHandler: tatumIndicator.show,
          triggerEndHandler: tatumIndicator.hide
        },
        segments: {
          triggerStartHandler: segmentIndicator.show,
          triggerEndHandler: segmentIndicator.hide
        }
      };

      durationScale = 100;//(displayWidth - 20) / data.duration;
      timeline = new ScrollingQuantumTimeline(data, durationScale, displayWidth);
      timeline.y = 80;
      addChild(timeline);
    }

    private function onChangeHandler(e:Event):void {
      timeline.position = nestPlayer.position;
    }
  }
}
