package com.ryanberdeen.gallery {
  import flash.events.Event;
  import flash.utils.Timer;

  import gs.TweenMax;
  import gs.easing.Quad;

  import org.papervision3d.materials.ColorMaterial;
  import org.papervision3d.objects.DisplayObject3D;
  import org.papervision3d.objects.primitives.Plane;
  import org.papervision3d.view.BasicView;

  public class Gallery extends BasicView {
    public static const ITEMS_PER_ROW = 5;
    public static const ITEM_WIDTH = 800;
    public static const ITEM_HEIGHT = 600;
    public static const ITEM_MAX_DIMENSION = 800;
    public static const ITEM_X_SPACING = 1100;
    public static const ITEM_Z_SPACING = 1000;
    public static const ITEM_START_Y = 5000;
    public static const ITEM_MIN_X = ((ITEMS_PER_ROW - 1) * ITEM_X_SPACING) / -2;
    public static const COLORS:Array = [0xFC2C79, 0xF7FA84, 0xE0286B, 0x81DDC5, 0x8B4D6F, 0xffffff];
    private var items:Array = [];
    private var loadingItems = [];
    private var timer:Timer;
    private var currentRow:int = 0;

    public function Gallery():void {
      camera.focus = 100;
      camera.zoom = 10;
      camera.y = 3000;

      addImageItem('http://farm4.static.flickr.com/3337/3593699793_78c2c1904c_b_d.jpg');
      addImageItem('http://farm4.static.flickr.com/3380/3584629030_e1e94a344e_b_d.jpg');
      addImageItem('http://farm4.static.flickr.com/3608/3584627844_d841d60270_b_d.jpg');

      for (var i:int = 0; i < 20; i++) {
        addItem();
      }

      startRendering();

      timer = new Timer(5000);
      timer.addEventListener('timer', timerHandler);
      timer.start();
      showRow(0);
    }

    private function addItem():void {
      addLoadingItem(new GalleryColorItem(this, COLORS[items.length % COLORS.length]));
    }

    public function addImageItem(url:String):void {
      addLoadingItem(new GalleryImageItem(this, url));
    }

    private function addLoadingItem(item:GalleryItem):void {
      loadingItems[loadingItems.length] = item;
    }

    function itemReady(item:GalleryItem):void {
      var row:int = items.length / ITEMS_PER_ROW;
      var col:int = items.length % ITEMS_PER_ROW;

      var sprite:DisplayObject3D = item.sprite;

      sprite.x = col * ITEM_X_SPACING + ITEM_MIN_X;
      sprite.y = ITEM_START_Y;
      sprite.z = -row * ITEM_Z_SPACING;
      scene.addChild(sprite);
      items[items.length] = item;
      TweenMax.to(sprite, Math.random() * 5, {y: 0, ease: Quad.easeInOut});
    }

    public function timerHandler(e:Event):void {
      currentRow = (currentRow\n 1) % (items.length / ITEMS_PER_ROW);
      showRow(currentRow);
    }

    public function showRow(row:int, time:Number = 1) {
      var rowZ:Number = -row * ITEM_Z_SPACING;
      TweenMax.to(camera, time, {z: rowZ - 5000, ease:Quad.easeInOut});
      TweenMax.to(camera.target, time, {z: rowZ + 5000, ease:Quad.easeInOut});
    }
  }
}