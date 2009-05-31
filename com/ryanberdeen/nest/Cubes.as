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
    private var cubes:Array = [];
    private var mouseDownX:Number = 0;
    private var targetRotation:Number = 0;
    private var tween:TweenMax;
    private var cubeIndex:int = -1;
    private var cube:Cube;
    private static const CUBE_COUNT:int = 10;

    public function Cubes():void {
      opaqueBackground = 0x000000;
      camera.focus = 100;
      camera.zoom = 10;

      for (var i:int = 0; i < CUBE_COUNT; i++) {
        cubes[i] = createCube();
        cubes[i].x = i * 150 - ((CUBE_COUNT - 1) * 150) / 2;
        scene.addChild(cubes[i]);
      }

      cube = cubes[0];

      startRendering();
    }

    private function createCube():Cube {
      var materialsList:MaterialsList = new MaterialsList()
      materialsList.addMaterial(new ColorMaterial(0x00ffff), "front");
      materialsList.addMaterial(new ColorMaterial(0xff00ff), "back");
      materialsList.addMaterial(new ColorMaterial(0xffff00), "left");
      materialsList.addMaterial(new ColorMaterial(0xff0000), "right");
      materialsList.addMaterial(new ColorMaterial(0x00ff00), "top");
      materialsList.addMaterial(new ColorMaterial(0x0000ff), "bottom");
      var cube:Cube = new Cube(materialsList, 50, 50, 50);
      cube.z = 450;
      cube.rotationX = 10;
      //cube.rotationY = 10;
      return cube;
    }

    public function barTriggerHandler():void {
      cubeIndex++;
      cube = cubes[cubeIndex % cubes.length];
      tween = TweenMax.to(cube, .1, {rotationY: '+45', ease:Quad.easeInOut});
    }

    public function beatTriggerHandler():void {
      tween = TweenMax.to(cube, .1, {y: 0, bezierThrough: [{y: 50}], ease:Quad.easeInOut});
    }

    public function tatumTriggerHandler():void {
      tween = TweenMax.to(cube, .1, {rotationX: '+45', ease:Quad.easeInOut});
    }
  }
}
