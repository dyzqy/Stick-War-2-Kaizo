package com.brockw.stickwar.engine.maps
{
   import com.brockw.stickwar.engine.*;
   import flash.display.*;
   
   public class GrassHills extends Map
   {
       
      
      private var _width:int;
      
      private var _height:int;
      
      private var _y:int;
      
      private var _screenWidth:int;
      
      private var _screenHeight:int;
      
      private var _gold:Vector.<Ore>;
      
      private var _hills:Vector.<Hill>;
      
      public function GrassHills(param1:StickWar)
      {
         super();
         this.init(param1);
      }
      
      override public function init(param1:StickWar) : void
      {
         var _loc2_:Vector.<MovieClip> = new Vector.<MovieClip>();
         _loc2_.push(new grassForeground());
         _loc2_.push(new grassMiddleground());
         _loc2_.push(new grassClouds());
         _loc2_.push(new grassSky());
         param1.background = new Background(_loc2_,param1);
         param1.addChild(param1.background);
         setDimensions(param1);
         createMiningBlock(param1,this.screenWidth + 670,1);
         createMiningBlock(param1,this.width - this.screenWidth - 670,-1);
         createMiningBlock(param1,this.screenWidth + 1200,1);
         createMiningBlock(param1,this.width - this.screenWidth - 1200,-1);
         this.addHill(this.width / 2,this.height / 2,param1);
         combiner = grassCombiner;
         super.init(param1);
      }
      
      private function addHill(param1:Number, param2:Number, param3:*) : void
      {
         var _loc4_:Hill;
         (_loc4_ = new Hill(param3)).init(param1,param2,param3);
         hills.push(_loc4_);
      }
   }
}
