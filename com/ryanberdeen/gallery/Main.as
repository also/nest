package com.ryanberdeen.gallery {
  import com.ryanberdeen.connector.Connector;
  import com.ryanberdeen.gallery.Gallery;

  import flash.display.Sprite;

  public class Main extends Sprite {
    public static var connector:Connector;
    public static var options:Object;

    public function Main():void {
      options = root.loaderInfo.parameters;

      connector = new Connector();
      connector.connect(options.connectorHost || 'ryan-berdeens-macbook-pro.local', options.connectorPort || 1843);

      var gallery:Gallery = new Gallery();
      addChild(gallery);
    }
  }
}
