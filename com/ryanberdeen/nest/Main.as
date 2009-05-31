package com.ryanberdeen.nest {
  import com.adobe.serialization.json.JSON;

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLRequest;

  public class Main extends Sprite {
    private var loader:URLLoader;
    private var nestVis:NestVis;

    public function Main():void {
      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, nestDataCompleteHandler);
      
      var request:URLRequest = new URLRequest('http://static.ryanberdeen.com/projects/nest/lo.json');
      loader.load(request);
    }
    
    private function nestDataCompleteHandler(e:Event):void {
      var result:Object = JSON.decode(loader.data);
      addNestVis(result);
    }
    
    private function addNestVis(data:Object):void {
      nestVis = new NestVis(data, stage.stageWidth);
      addChild(nestVis);
    }
  }
}
