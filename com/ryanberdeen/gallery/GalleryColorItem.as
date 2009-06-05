package com.ryanberdeen.gallery {
  import org.papervision3d.materials.ColorMaterial;
  import org.papervision3d.objects.primitives.Plane;

  class GalleryColorItem extends GalleryItem {
    public function GalleryColorItem(gallery:Gallery, color:uint) {
      super(gallery);
      var plane:Plane = new Plane(new ColorMaterial(color), Gallery.ITEM_WIDTH, Gallery.ITEM_HEIGHT);
      sprite = plane;
      ready();
    }
  }
}
