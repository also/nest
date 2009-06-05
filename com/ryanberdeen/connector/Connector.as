package com.ryanberdeen.connector {
  import com.adobe.serialization.json.JSON;

  import flash.events.DataEvent;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.XMLSocket;

  public class Connector {
    private var socket:XMLSocket;
    private var started:Boolean = false;
    private var pathPrefix:String = 'display_';
    private var actionPrefix = 'handle_';
    private var subscribers:Object = {};

    public function connect(hostname:String, port:Number):void {
      socket = new XMLSocket();
      socket.addEventListener(Event.CONNECT, onSocketConnect);
      socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
      socket.addEventListener(DataEvent.DATA, onSocketData);
      socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIoError);
      socket.addEventListener(Event.CLOSE, onSocketClose);

      socket.connect(hostname, port);
    }

    public function send(data:String):void {
      if (socket.connected) {
        socket.send(data);
      }
    }

    public function close():void {
      if (socket.connected) {
        socket.close();
      }
    }

    private function onSocketConnect(event:Event):void {
      // my rjs server requires 'hi' to be the first message received
      send('hi');
      started = true;
      for (var path:String in subscribers) {
        send('server subscribe ' + path);
      }
      subscribe('connector', this);
      onEvent(event);
    }

    private function onSocketSecurityError(event:SecurityErrorEvent):void {
      onEvent(event);
    }

    private function onSocketData(event:DataEvent):void {
      var message:String = event.data;
      var spaceIndex:int = message.indexOf(' ');
      var path:String = message.substring(0, spaceIndex);
      notifySubscribers(path, message.substring(spaceIndex + 1));
    }

    public function notifySubscribers(path:String, message:String) {
      var pathSubscribers:Array = subscribers[path];
      if (pathSubscribers) {
        for (var i:int = 0; i < pathSubscribers.length; i++) {
          notifySubscriber(pathSubscribers[i], message);
        }
      }
    }

    public function sendEvent(source:String, ...args:Array):void {
      var eventString:String = '';
      for each (var arg in args) {
        if (eventString != '') {
          eventString += ' ';
        }
        if (arg is String) {
          eventString += arg;
        }
        else {
          eventString += JSON.encode(arg);
        }
      }
      send(pathPrefix + source + '_event ' + eventString);
    }

    public function notifySubscriber(subscriber:Object, message:String):void {
      var spaceIndex:int = message.indexOf(' ');
      var actionSuffix:String;
      var data:String;
      if (spaceIndex > 0) {
        actionSuffix = message.substring(0, spaceIndex);
        data = message.substring(spaceIndex + 1);
      }
      else {
        actionSuffix = message;
      }
      var action:String = actionPrefix + actionSuffix;
      if (action in subscriber) {
        subscriber[action](data);
        return;
      }
      else if ('handleSubscribedMessage' in subscriber) {
        subscriber.handleSubscribedMessage(message);
      }
    }

    private function onSocketIoError(event:IOErrorEvent):void {
      onEvent(event);
    }

    // NOTE: only called when the server closes the connection
    private function onSocketClose(event:Event):void {
      onEvent(event);
    }

    private function onEvent(event:Event):void {
      trace('socket event: ' + event.type);
    }

    public function subscribe(pathSuffix:String, subscriber:Object):void {
      var path:String = pathPrefix + pathSuffix;
      var pathSubscribers:Array = subscribers[path];
      if (!pathSubscribers) {
        pathSubscribers = [];
        subscribers[path] = pathSubscribers;
      }
      pathSubscribers[pathSubscribers.length] = subscriber;
      if (started) {
        send('server subscribe ' + path);
      }
    }
  }
}