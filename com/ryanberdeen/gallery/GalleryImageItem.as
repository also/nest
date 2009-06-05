package com.ryanberdeen.gallery {
  import org.papervision3d.materials.BitmapMaterial;
  import org.papervision3d.objects.primitives.Plane;

  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.events.*;
  import flash.net.URLRequest;

  class GalleryImageItem extends GalleryItem {
    var loader:Loader;

    public function GalleryImageItem(gallery:Gallery, url:String):void {
      super(gallery);
      loader = new Loader();

      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
      loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);

      var request:URLRequest = new URLRequest(url);
      loader.load(request);
    }

    private function completeHandler(e:Event):void {
      ready();
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
      //trace("ioErrorHandler: " + event);
    }

    private function progressHandler(event:ProgressEvent):void {
      //trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
    }

    override public function prepare():void {
      var bitmap:Bitmap = Bitmap(loader.content);
      var width:Number;
      var height:Number;
      var scale:Number = Math.min(1, Gallery.ITEM_MAX_DIMENSION / Math.max(bitmap.width, bitmap.height));
      sprite = new Plane(new BitmapMaterial(bitmap.bitmapData, true), bitmap.width * scale, bitmap.height * scale);
    }

    override public function cancel():void {
      loader.close();
    }
  }
}
