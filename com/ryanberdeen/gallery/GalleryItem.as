package com.ryanberdeen.gallery {
  import org.papervision3d.objects.DisplayObject3D;

  class GalleryItem {
    protected var gallery:Gallery;
    var sprite:DisplayObject3D;

    public function GalleryItem(gallery:Gallery):void {
      this.gallery = gallery;
    }

    protected function ready():void {
      gallery.itemReady(this);
    }

    public function prepare():void {}

    public function cancel():void {

    }
  }
}
