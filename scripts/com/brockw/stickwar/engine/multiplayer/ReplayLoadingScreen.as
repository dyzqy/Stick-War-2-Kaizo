package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import com.brockw.simulationSync.*;
   import com.brockw.stickwar.Main;
   import com.brockw.stickwar.engine.*;
   import com.smartfoxserver.v2.entities.data.*;
   import com.smartfoxserver.v2.requests.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class ReplayLoadingScreen extends Screen
   {
       
      
      private var main:Main;
      
      private var urlLoader:URLLoader;
      
      private var mc:replayLoadingScreenMc;
      
      private var link:String;
      
      private var index:int = 0;
      
      public function ReplayLoadingScreen(param1:Main)
      {
         this.main = param1;
         super();
         this.mc = new replayLoadingScreenMc();
         addChild(this.mc);
         this.urlLoader = new URLLoader();
         this.link = "";
      }
      
      public function loadReplay(param1:String) : void
      {
         this.link = param1;
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         var _loc2_:URLRequest = new URLRequest("http://s3.amazonaws.com/stickempiresReplays/" + param1);
         this.urlLoader.load(_loc2_);
         this.mc.loading.visible = true;
         this.mc.error.visible = false;
         if(Boolean(this.main.sfs) && Boolean(this.main.sfs.isConnected))
         {
            this.index = Number(param1.slice(6,param1.length));
         }
      }
      
      private function complete(param1:Event) : void
      {
         var _loc6_:SFSObject = null;
         var _loc7_:ExtensionRequest = null;
         trace("Loading replay finished",param1);
         if(!this.main.stickWar)
         {
            this.main.stickWar = new StickWar(this.main,this.main.replayGameScreen);
         }
         var _loc2_:SimulationSyncronizer = new SimulationSyncronizer(this.main.stickWar,this.main,null,null);
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeBytes(this.urlLoader.data);
         _loc3_.position = 0;
         trace("Array length:",_loc3_.length);
         var _loc4_:String = _loc3_.readUTFBytes(_loc3_.length);
         var _loc5_:Boolean;
         if((_loc5_ = _loc2_.gameReplay.fromString(_loc4_)) && _loc2_.gameReplay.version == this.main.version)
         {
            this.main.replayGameScreen.replayString = _loc4_;
            this.main.showScreen("replayGame");
            trace("Send replay link",this.link,this.index);
            (_loc6_ = new SFSObject()).putInt("saveId",this.index);
            _loc7_ = new ExtensionRequest("incrementReplayViewCount",_loc6_);
            this.main.sfs.send(_loc7_);
         }
         else
         {
            trace("Error loading replay");
            this.mc.loading.visible = false;
            this.mc.error.visible = true;
         }
      }
      
      private function error(param1:Event) : void
      {
         trace("Error loading replay",param1.type);
         this.mc.loading.visible = false;
         this.mc.error.visible = true;
      }
      
      private function securityError(param1:Event) : void
      {
         trace("Error Secutiry loading replay",param1);
         this.mc.loading.visible = false;
         this.mc.error.visible = true;
      }
      
      private function retry(param1:Event) : void
      {
         this.loadReplay(this.link);
      }
      
      private function quit(param1:Event) : void
      {
         if(this.main.isReplayMode)
         {
            this.main.showScreen("login");
         }
         else
         {
            this.main.showScreen("lobby");
         }
      }
      
      override public function enter() : void
      {
         this.main.setOverlayScreen("");
         this.urlLoader.addEventListener(Event.COMPLETE,this.complete);
         this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.error);
         this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityError);
         this.mc.loading.visible = true;
         this.mc.error.visible = false;
         this.mc.error.retryButton.addEventListener(MouseEvent.CLICK,this.retry);
         this.mc.error.quitButton.addEventListener(MouseEvent.CLICK,this.quit);
      }
      
      override public function leave() : void
      {
         this.urlLoader.removeEventListener(Event.COMPLETE,this.complete);
         this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.error);
         this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityError);
      }
   }
}
