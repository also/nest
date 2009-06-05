package com.ryanberdeen.gallery {
  import gs.TweenMax;
  import gs.easing.Quad;

  import org.papervision3d.materials.ColorMaterial
  import org.papervision3d.objects.DisplayObject3D;
  import org.papervision3d.objects.primitives.Plane;
  import org.papervision3d.view.BasicView;

  public class Gallery extends BasicView {
    public static const ITEMS_PER_ROW = 5;
    public static const ITEM_WIDTH = 800;
    public static const ITEM_HEIGHT = 600;
    public static const ITEM_X_SPACING = 1100;
    public static const ITEM_Z_SPACING = 1000;
    public static const ITEM_START_Y = 5000;
    public static const ITEM_MIN_X = ((ITEMS_PER_ROW - 1) * ITEM_X_SPACING) / -2;
    public static const COLORS:Array = [0xFC2C79, 0xF7FA84, 0xE0286B, 0x81DDC5, 0x8B4D6F, 0xffffff];
    private var items:Array = [];

    public function Gallery():void {
      camera.focus = 100;
      camera.zoom = 10;
      camera.y = 3000;
      camera.z = -5000;
      camera.target.z = 5000;

      for (var i:int = 0; i < 100; i++) {
        addItem();
      }

      startRendering();

      TweenMax.to(camera, 1, {z: '-10000', yoyo: 0, ease:Quad.easeInOut});

      TweenMax.to(camera.target, 1, {z: '-10000', yoyo: 0, ease:Quad.easeInOut});
    }

    private function addItem():void {
      var row:int = items.length / ITEMS_PER_ROW;
      var col:int = items.length % ITEMS_PER_ROW;

      var plane:Plane = new Plane(new ColorMaterial(COLORS[items.length % COLORS.length]), ITEM_WIDTH, ITEM_HEIGHT);
      plane.x = col * ITEM_X_SPACING + ITEM_MIN_X;
      plane.y = ITEM_START_Y;
      plane.z = -row * ITEM_Z_SPACING;
      scene.addChild(plane);
      items[items.length] = plane;
      TweenMax.to(plane, Math.random() * 5, {y: 0, ease: Quad.easeInOut});
    }

  }
}