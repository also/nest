package com.ryanberdeen.cubes {
  import com.ryanberdeen.nest.QuantumEventHandler;

  import flash.display.Sprite;

  import gs.TweenMax;
  import gs.easing.Quad;

  import org.papervision3d.materials.utils.MaterialsList;
  import org.papervision3d.materials.ColorMaterial
  import org.papervision3d.objects.primitives.Cube;
  import org.papervision3d.objects.primitives.Plane;
  import org.papervision3d.view.BasicView;

  public class Cubes extends BasicView {
    public static const CUBES_PER_ROW:int = 15;
    public static const CUBE_ROW_COUNT:int = 15;

    public static const CUBE_START_Y:int = 2000;

    var cubes:Array = [];
    private var qeh:QuantumEventHandler;
    private var tween:TweenMax;
    private var colIndex:int = -1;
    private var rowIndex:int = 0;
    private var cube:Cube;

    private var coloredMaterials:MaterialsList;
    private var whiteMaterials:MaterialsList;

    public function Cubes():void {
      opaqueBackground = 0x000000;
      camera.focus = 100;
      camera.zoom = 10;
      camera.y = -1000;
      camera.x = -2000;

      var plane:Plane = new Plane(new ColorMaterial(0xffffff), 1000, 1000);
      plane.x = 0;
      plane.y = -200;
      plane.rotationX = 90;
      //scene.addChild(plane);

      coloredMaterials = new MaterialsList();
      coloredMaterials.addMaterial(new ColorMaterial(0xFC2C79), "front");
      coloredMaterials.addMaterial(new ColorMaterial(0xFC2C79), "back");
      coloredMaterials.addMaterial(new ColorMaterial(0xF7FA84), "left");
      coloredMaterials.addMaterial(new ColorMaterial(0xE0286B), "right");
      coloredMaterials.addMaterial(new ColorMaterial(0x81DDC5), "top");
      coloredMaterials.addMaterial(new ColorMaterial(0x8B4D6F), "bottom");

      whiteMaterials = new MaterialsList();
      whiteMaterials.addMaterial(new ColorMaterial(0xffffff), "front");
      whiteMaterials.addMaterial(new ColorMaterial(0xffffff), "back");
      whiteMaterials.addMaterial(new ColorMaterial(0xffffff), "left");
      whiteMaterials.addMaterial(new ColorMaterial(0xffffff), "right");
      whiteMaterials.addMaterial(new ColorMaterial(0xffffff), "top");
      whiteMaterials.addMaterial(new ColorMaterial(0xffffff), "bottom");

      for (var rowIndex:int = 0; rowIndex < CUBE_ROW_COUNT; rowIndex++) {
        var row:Array = [];
        var cubeZ:Number = rowIndex * 150 - ((CUBE_ROW_COUNT - 1) * 150) / 2;
        cubes[rowIndex] = row;
        for (var i:int = 0; i < CUBES_PER_ROW; i++) {
          row[i] = createCube(coloredMaterials);
          row[i].x = i * 150 - ((CUBES_PER_ROW - 1) * 150) / 2;
          row[i].z = cubeZ;
          row[i].y = CUBE_START_Y;
          scene.addChild(row[i]);
        }
      }

      qeh = new CubeRowsQuantumEventHandler(this);

      startRendering();

      TweenMax.to(camera, 10, {y: 2000, z: -1000, yoyo: 0});
      TweenMax.to(camera, 20, {x: 1000, yoyo: 0});

      dropCubes();
    }

    private function dropCubes():void {
      for (var rowIndex:int = 0; rowIndex < Cubes.CUBE_ROW_COUNT; rowIndex++) {
        for (var colIndex:int = 0; colIndex < Cubes.CUBES_PER_ROW; colIndex++) {
          TweenMax.to(cubes[rowIndex][colIndex], 1 + Math.random() * 2, {y: 0, ease:Quad.easeInOut});
        }
      }
    }

    private function raiseCubes():void {
      for (var rowIndex:int = 0; rowIndex < Cubes.CUBE_ROW_COUNT; rowIndex++) {
        for (var colIndex:int = 0; colIndex < Cubes.CUBES_PER_ROW; colIndex++) {
          TweenMax.to(cubes[rowIndex][colIndex], 1 + Math.random() * 2, {y: CUBE_START_Y, ease:Quad.easeInOut});
        }
      }
    }

    public function stop():void {
      raiseCubes();
    }

    public function pause():void {
      dropCubes();
    }

    private function createCube(materials:MaterialsList):Cube {
      var cube:Cube = new Cube(materials, 50, 50, 50);
      cube.z = 450;
      return cube;
    }

    public function barTriggerHandler():void {
      qeh.barTriggerHandler();
    }

    public function beatTriggerHandler():void {
      qeh.beatTriggerHandler();
    }

    public function tatumTriggerHandler():void {
      qeh.tatumTriggerHandler();
    }

    private function replaceCube(rowIndex:int, colIndex:int, materials:MaterialsList):Cube {
      var cube:Cube = cubes[rowIndex][colIndex];
      var newCube = createCube(materials);
      newCube.copyPosition(cube);
      newCube.copyTransform(cube);
      scene.removeChild(cube);
      scene.addChild(newCube);
      cubes[rowIndex][colIndex] = newCube;
      return newCube;
    }
  }
}
