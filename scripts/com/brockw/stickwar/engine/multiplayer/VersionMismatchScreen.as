package com.brockw.stickwar.engine.multiplayer
{
   import com.brockw.game.Screen;
   import flash.events.*;
   
   public class VersionMismatchScreen extends Screen
   {
       
      
      private var mc:versionMismatchMc;
      
      private var framesLeft:int;
      
      public function VersionMismatchScreen()
      {
         super();
         this.mc = new versionMismatchMc();
         addChild(this.mc);
      }
      
      override public function enter() : void
      {
         this.framesLeft = 30 * 5;
         addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(param1:Event) : void
      {
         --this.framesLeft;
         var _loc2_:int = Math.floor(this.framesLeft / 30);
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         this.mc.refreshText.text = "Refresh this page to load the new version.";
         if(_loc2_ <= 0)
         {
         }
      }
   }
}
