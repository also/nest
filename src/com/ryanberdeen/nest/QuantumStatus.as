package com.ryanberdeen.nest {
  import flash.events.Event;
  import flash.events.EventDispatcher;

  public class QuantumStatus extends EventDispatcher {
    private var _quantums:Array;
    private var nextIndex:int = 0;
    private var currentPosition:int = -1;
    private var nextPosition:int = -1;
    private var triggerStartOffset:Number;
    private var triggerEndOffset:Number;

    private var triggerStartHandler:Function;
    private var triggerEndHandler:Function;

    private var hasChangeListener:Boolean = false;

    internal function set quantums(quantums:Array):void {
      _quantums = quantums;
    }

    internal function set options(options:Object):void {
      options ||= {};
      this.triggerStartOffset = options.triggerStartOffset || 0;
      this.triggerEndOffset = options.triggerEndOffset || 100;

      triggerStartHandler = options.triggerStartHandler;
      triggerEndHandler = options.triggerEndHandler;
    }

    internal function set position(p:Number):void {
      if (currentPosition != -1 && currentPosition + triggerEndOffset <= p) {
        if (triggerEndHandler != null) {
          triggerEndHandler();
        }
      }

      if (nextPosition != -1 && p >= nextPosition + triggerStartOffset) {
        currentPosition = nextPosition;
        if (triggerStartHandler != null) {
          triggerStartHandler();
        }

        // TODO shoudln't be offset
        if (hasChangeListener) {
          dispatchEvent(new Event(Event.CHANGE));
        }
        loadNextPosition();
      }
    }

    public function get index():int {
      return nextIndex - 1;
    }

    public function get quantum():Array {
      return _quantums[index];
    }

    internal function prepare():void {
      loadNextPosition();
       hasChangeListener = hasEventListener(Event.CHANGE);
    }

    private function loadNextPosition():void {
      if (nextIndex < _quantums.length) {
        nextPosition = _quantums[nextIndex++][0] * 1000;
      }
      else {
        nextPosition = -1;
      }
    }
  }
}
