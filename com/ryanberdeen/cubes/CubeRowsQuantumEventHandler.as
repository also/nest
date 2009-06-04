package com.ryanberdeen.cubes {

  import gs.TweenMax;
  import gs.easing.Quad;
  
  import com.ryanberdeen.nest.QuantumEventHandler;

  public class CubeRowsQuantumEventHandler implements QuantumEventHandler {
    private var vis:Cubes;
    private var cubes:Array;
    private var tatumIndex:int = 0;
    private var beatIndex:int = 0;
    
    public function CubeRowsQuantumEventHandler(vis:Cubes):void {
      this.vis = vis;
      this.cubes = vis.cubes;
    }

    public function barTriggerHandler():void {
      for (var rowIndex:int = 0; rowIndex < Cubes.CUBE_ROW_COUNT; rowIndex++) {
        for (var colIndex:int = 0; colIndex < Cubes.CUBES_PER_ROW; colIndex++) {
          TweenMax.to(cubes[rowIndex][colIndex], .1, {rotationZ: '+180', ease:Quad.easeInOut});
        }
      }
    }

    public function beatTriggerHandler():void {
      beatIndex++;
    }

    public function tatumTriggerHandler():void {
      var cubeIndex:int = 0;
      for (var rowIndex:int = 0; rowIndex < Cubes.CUBE_ROW_COUNT; rowIndex++) {
        for (var colIndex:int = 0; colIndex < Cubes.CUBES_PER_ROW; colIndex++) {
          TweenMax.to(cubes[rowIndex][colIndex], .1, {(tatumIndex % 2 == 0 ? 'rotationX' : 'rotationY'): '+45', ease:Quad.easeInOut});
          TweenMax.to(cubes[rowIndex][colIndex], .1, {y: (rowIndex + colIndex + tatumIndex) % 2 == 0 ? '+100' : '-100', ease:Quad.easeInOut});
          cubeIndex++;
        }
      }
      tatumIndex++;
    }
  }
}