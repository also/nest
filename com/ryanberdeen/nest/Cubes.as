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
    private var colIndex:int = -1;
    private var rowIndex:int = 0;
    private var cube:Cube;
    private var tatumIndex:int = 0;
    private var beatIndex:int = 0;
    private static const CUBES_PER_ROW:int = 10;
    private static const CUBE_ROW_COUNT:int = 7;

    public function Cubes():void {
      opaqueBackground = 0x000000;
      camera.focus = 100;
      camera.zoom = 10;
      camera.y = -1000;
      camera.x = -1000;

      for (var rowIndex:int = 0; rowIndex < CUBE_ROW_COUNT; rowIndex++) {
        var row:Array = [];
        var cubeY:Number = rowIndex * 150 - ((CUBE_ROW_COUNT - 1) * 150) / 2;
        cubes[rowIndex] = row;
        for (var i:int = 0; i < CUBES_PER_ROW; i++) {
          row[i] = createCube();
          row[i].x = i * 150 - ((CUBES_PER_ROW - 1) * 150) / 2;
          row[i].y = cubeY;
          scene.addChild(row[i]);
        }
      }

      cube = cubes[0][0];

      startRendering();

      TweenMax.to(camera, 10, {y: 1000, z: -1000, yoyo: 0});
      TweenMax.to(camera, 20, {x: 1000, yoyo: 0});
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
      return cube;
    }

    public function barTriggerHandler():void {
      colIndex++;
      if (colIndex >= CUBES_PER_ROW) {
        colIndex = 0;
      }
      for (var rowIndex:int = 0; rowIndex < CUBE_ROW_COUNT; rowIndex++) {
        for (var colIndex:int = 0; colIndex < CUBES_PER_ROW; colIndex++) {
          TweenMax.to(cubes[rowIndex][colIndex], .1, {rotationZ: '+180', ease:Quad.easeInOut});
        }
      }
    }

    public function beatTriggerHandler():void {

      beatIndex++;
    }

    public function tatumTriggerHandler():void {
      for (var rowIndex:int = 0; rowIndex < CUBE_ROW_COUNT; rowIndex++) {
        for (var colIndex:int = 0; colIndex < CUBES_PER_ROW; colIndex++) {
          TweenMax.to(cubes[rowIndex][colIndex], .1, {(tatumIndex % 2 == 0 ? 'rotationX' : 'rotationY'): '+45', ease:Quad.easeInOut});
          //TweenMax.to(cubes[rowIndex][colIndex], .1, {z: '+0', bezierThrough: [{z: (rowIndex + colIndex) % 2 == 0 ? '+100' : '-100'}], ease:Quad.easeInOut});
          TweenMax.to(cubes[rowIndex][colIndex], .1, {z: (rowIndex + colIndex + tatumIndex) % 2 == 0 ? '+100' : '-100', ease:Quad.easeInOut});
        }
      }
      tatumIndex++;
    }
  }
}
