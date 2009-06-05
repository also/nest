package com.ryanberdeen.gallery {
  import com.ryanberdeen.nest.Main;
  import flash.events.Event;
  import flash.utils.Timer;

  import gs.TweenMax;
  import gs.easing.Quad;

  import org.papervision3d.materials.ColorMaterial;
  import org.papervision3d.objects.DisplayObject3D;
  import org.papervision3d.objects.primitives.Plane;
  import org.papervision3d.view.BasicView;

  public class Gallery extends BasicView {
    public static const ITEMS_PER_ROW:int = 5;
    public static const ITEM_WIDTH:Number = 800;
    public static const ITEM_HEIGHT:Number = 600;
    public static const ITEM_MAX_DIMENSION:Number = 800;
    public static const ITEM_X_SPACING:Number = 900;
    public static const ITEM_Z_SPACING:Number = 1000;
    public static const ITEM_START_Y:Number = 5000;
    public static const ITEM_MIN_X:Number = ((ITEMS_PER_ROW - 1) * ITEM_X_SPACING) / -2;
    public static const COLORS:Array = [0xFC2C79, 0xF7FA84, 0xE0286B, 0x81DDC5, 0x8B4D6F, 0xffffff];
    public static const ROW_CAMERA_Y:Number = 3000;
    public static const ITEM_CAMERA_Y:Number = ITEM_MAX_DIMENSION / 2;
    public static const ITEM_CAMERA_Z_DIST:Number = 1000;
    private var items:Array = [];
    private var loadingItems = [];
    private var readyItems = [];
    private var timer:Timer;
    private var currentRow:int = -1;
    private var showingItem:Boolean = false;
    private var droppingItemCount:int = 0;
    private var selectedRow:int = 0;
    private var selectedCol:int = 0;

    public function Gallery():void {
      Main.connector.subscribe('gallery', this);
      opaqueBackground = 0xeeeeee;
      camera.focus = 100;
      camera.zoom = 10;
      camera.y = ROW_CAMERA_Y;
      camera.z = -20000;

      startRendering();
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
      readyItems.push(item);
      dropReadyItems();
    }

    private function dropReadyItems():void {
      if (droppingItemCount > 0) {
        return;
      }
      // prepare all items
      for each (var item:GalleryItem in readyItems) {
        item.prepare();
      }
      if (readyItems.length > 0) {
        var item:GalleryItem = readyItems.pop();

        var sprite:DisplayObject3D = item.sprite;

        var row:int = row(items.length);
        showRow(row);

        sprite.x = col(items.length) * ITEM_X_SPACING + ITEM_MIN_X;
        sprite.y = ITEM_START_Y;
        sprite.z = -row * ITEM_Z_SPACING;
        scene.addChild(sprite);
        items[items.length] = item;
        droppingItemCount++;
        TweenMax.to(sprite, 1, {y: 0, ease: Quad.easeInOut, onComplete: itemDropCompleteHandler});
      }
    }

    private function itemDropCompleteHandler():void {
      droppingItemCount--;
      if (droppingItemCount == 0) {
        dropReadyItems();
      }
    }

    public function timerHandler(e:Event):void {
      showRandom();
    }

    private function showRandom():void {
      if (droppingItemCount > 0) {
        return;
      }
      if (showingItem) {
        showRow();
      }
      else if (Math.random() > .6) {
        showItem(Math.round(Math.random() * (items.length - 1)))
      }
      else {
        showRow((currentRow + 1) % (items.length / ITEMS_PER_ROW));
      }
    }

    public function showRow(row:int = -1, time:Number = 1) {
      if (!showingItem && row == currentRow) {
        return;
      }
      if (row == -1) {
        row = currentRow;
      }
      showingItem = false;
      var rowZ:Number = rowZ(row);
      TweenMax.to(camera, time, {x: 0, y: ROW_CAMERA_Y, z: rowZ - 5000, ease:Quad.easeInOut});
      TweenMax.to(camera.target, time, {x: 0, y: 0, z: rowZ + 5000, ease:Quad.easeInOut});
      currentRow = row;
    }

    public function showItem(index:int, time:Number = 1):void {
      showPosition(row(index), col(index));
    }

    public function showPosition(row:int, col:int, time:Number = 1):void {
      showingItem = true;
      currentRow = row;
      var rowZ:Number = rowZ(row);
      var colX:Number = colX(col);

      var cameraZ = rowZ - ITEM_CAMERA_Z_DIST;
      TweenMax.to(camera, time, {x: colX, y: 0, z: cameraZ, ease:Quad.easeInOut});
      TweenMax.to(camera.target, time, {x: colX, y: 0, z: rowZ, ease:Quad.easeInOut});
    }

    public function highlightSelected():void {
      if (showingItem) {
        showPosition(selectedRow, selectedCol);
      }
      else {
        showRow(selectedRow);
      }
    }

    private function startRandom():void {
      if (timer != null) {
        return;
      }
      showRandom();
      timer = new Timer(5000);
      timer.addEventListener('timer', timerHandler);
      timer.start();
    }

    private function stopRandom():void {
      if (timer == null) {
        return;
      }
      timer.stop();
      timer = null;
      showRow();
    }

    public function handle_add_image(url:String):void {
      stopRandom();
      addImageItem(url);
    }

    public function handle_start_random(m:String):void {
      startRandom();
    }

    public function handle_stop_random(m:String):void {
      stopRandom();
    }

    public function handle_up(m:String):void {
      stopRandom();
      selectedRow--;
      highlightSelected();
    }

    public function handle_down(m:String):void {
      stopRandom();
      selectedRow++;
      highlightSelected();
    }

    public function handle_left(m:String):void {
      stopRandom();
      selectedCol--;
      highlightSelected();
    }

    public function handle_right(m:String):void {
      stopRandom();
      selectedCol++;
      highlightSelected();
    }

    public function handle_enter(m:String):void {
      stopRandom();
      if (showingItem) {
        showRow();
      }
      else {
        showingItem = true;
        highlightSelected();
      }
    }

    public function row(index:int):int {
      return index / ITEMS_PER_ROW;
    }

    public function colX(col:int):Number {
      return col * ITEM_X_SPACING + ITEM_MIN_X
    }

    public function rowZ(row:int):Number {
      return -row * ITEM_Z_SPACING;
    }

    public function col(index:int):int {
      return index % ITEMS_PER_ROW;
    }
  }
}