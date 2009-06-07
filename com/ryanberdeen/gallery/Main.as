package com.ryanberdeen.gallery {
  import com.ryanberdeen.connector.Connector;
  import com.ryanberdeen.gallery.Gallery;
  import com.ryanberdeen.support.JsonLoader;

  import flash.display.Sprite;

  public class Main extends Sprite {
    public static var connector:Connector;
    public static var options:Object;

    private var gallery:Gallery;

    public function Main():void {
      options = root.loaderInfo.parameters;

      connector = new Connector();
      connector.connect(options.connectorHost || 'ryan-berdeens-macbook-pro.local', options.connectorPort || 1843);

      gallery = new Gallery();
      addChild(gallery);

      if (options.indexUrl) {
        new JsonLoader(options.indexUrl, indexLoadedHandler).load();
      }
    }

    private function indexLoadedHandler(index:Object):void {
      for each (var item:Object in index) {
        gallery.addImageItem(item.image_url);
      }
    }
  }
}
