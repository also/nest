package com.ryanberdeen.nest {
  import flash.display.Sprite;
  import flash.events.MouseEvent;

  import gs.TweenMax;
  import gs.easing.Quad;

  import org.papervision3d.materials.utils.MaterialsList;
  import org.papervision3d.materials.ColorMaterial
  import org.papervision3d.objects.primitives.Cube;
  import org.papervision3d.view.BasicView;

  public class Cubes extends BasicView {
    private var cube:Cube;
    private var mouseDownX:Number = 0;
    private var targetRotation:Number = 0;

    public function Cubes():void {
      opaqueBackground = 0x000000;
      camera.focus = 100;
      camera.zoom = 10;

      var materialsList:MaterialsList = new MaterialsList()
      materialsList.addMaterial(new ColorMaterial(0x00ffff), "front");
      materialsList.addMaterial(new ColorMaterial(0xff00ff), "back");
      materialsList.addMaterial(new ColorMaterial(0xffff00), "left");
      materialsList.addMaterial(new ColorMaterial(0xff0000), "right");
      materialsList.addMaterial(new ColorMaterial(0x00ff00), "top");
      materialsList.addMaterial(new ColorMaterial(0x0000ff), "bottom");
      cube = new Cube(materialsList, 500, 500, 500);
      cube.z = 450;
      scene.addChild(cube);

      startRendering();

      addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
      addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

      //TweenMax.to(cube, 200, {rotationZ:40000, rotationY:90000, z:450, bezierThrough:[{z:700}], ease:Quad.easeInOut});
      TweenMax.to(cube, 1, {rotationX:180, y: 200, yoyo: 0, ease:Quad.easeInOut});
    }

    private function mouseDownHandler(event:MouseEvent):void {
      mouseDownX = event.localX;
    }

    private function mouseUpHandler(event:MouseEvent):void {
      var currentMouseX:Number = event.localX;
      if (currentMouseX < mouseDownX) {
        targetRotation += 900;
      }
      else {
        targetRotation -= 900;
      }
      TweenMax.to(cube, 2, {rotationY:targetRotation, z:450, bezierThrough:[{z:700}], ease:Quad.easeInOut});
    }
  }
}
