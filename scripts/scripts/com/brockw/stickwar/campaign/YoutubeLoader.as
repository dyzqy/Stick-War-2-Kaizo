package com.brockw.stickwar.campaign
{
      import flash.display.*;
      import flash.events.*;
      import flash.net.*;
      import flash.system.*;
      
      public class YoutubeLoader extends MovieClip
      {
             
            
            private var my_player:Object;
            
            private var hadError:Boolean;
            
            private var ready:Boolean;
            
            public function YoutubeLoader(param1:String)
            {
                  var my_loader:Loader = null;
                  var onLoaderInit:* = undefined;
                  var onError:* = undefined;
                  var onPlayerReady:* = undefined;
                  var link:String = param1;
                  onLoaderInit = function(param1:Event):void
                  {
                        addChild(my_loader);
                        my_player = my_loader.content;
                        my_player.addEventListener("onReady",onPlayerReady);
                        my_player.addEventListener("onError",onError);
                  };
                  onError = function(param1:Event):void
                  {
                        hadError = true;
                        trace("YOUTUBE LOADER HAD ERROR");
                  };
                  onPlayerReady = function(param1:Event):void
                  {
                        my_player.setSize(640,360);
                        my_player.loadVideoById(link,0);
                        my_player.stopVideo();
                        ready = true;
                  };
                  super();
                  Security.allowDomain("www.youtube.com");
                  this.ready = false;
                  my_loader = new Loader();
                  my_loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
                  my_loader.contentLoaderInfo.addEventListener(Event.INIT,onLoaderInit);
                  this.hadError = false;
            }
            
            public function isWorking() : Boolean
            {
                  return !this.hadError && Boolean(this.ready);
            }
            
            public function playVideo() : void
            {
                  if(this.ready)
                  {
                        this.my_player.playVideo();
                  }
            }
            
            public function stopVideo() : void
            {
                  if(this.ready)
                  {
                        this.my_player.stopVideo();
                  }
            }
            
            public function pauseVideo() : void
            {
                  if(this.ready)
                  {
                        this.my_player.pauseVideo();
                  }
            }
            
            public function getTimePlayed() : Number
            {
                  if(this.ready)
                  {
                        return this.my_player.getCurrentTime();
                  }
                  return 0;
            }
      }
}
