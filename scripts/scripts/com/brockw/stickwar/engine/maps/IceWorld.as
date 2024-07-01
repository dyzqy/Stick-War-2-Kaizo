package com.brockw.stickwar.engine.maps
{
      import com.brockw.stickwar.engine.*;
      import flash.display.*;
      
      public class IceWorld extends Map
      {
             
            
            private var _width:int;
            
            private var _height:int;
            
            private var _y:int;
            
            private var _screenWidth:int;
            
            private var _screenHeight:int;
            
            private var _gold:Vector.<Ore>;
            
            private var _hills:Vector.<Hill>;
            
            public function IceWorld(param1:StickWar)
            {
                  super();
                  this.init(param1);
            }
            
            override public function init(param1:StickWar) : void
            {
                  var _loc2_:Vector.<MovieClip> = new Vector.<MovieClip>();
                  _loc2_.push(new iceHillsForeground());
                  _loc2_.push(new iceHillsMountains());
                  _loc2_.push(new iceHillsMiddleground());
                  _loc2_.push(new iceHillsBackgroundSky());
                  param1.background = new Background(_loc2_,param1);
                  param1.addChild(param1.background);
                  setDimensions(param1);
                  createMiningBlock(param1,this.screenWidth + 670,1);
                  createMiningBlock(param1,this.width - this.screenWidth - 670,-1);
                  createMiningBlock(param1,this.screenWidth + 1200,1);
                  createMiningBlock(param1,this.width - this.screenWidth - 1200,-1);
                  var _loc3_:Hill = new Hill(param1);
                  _loc3_.init(this.width / 2,this.height / 2,param1);
                  hills.push(_loc3_);
                  super.init(param1);
            }
      }
}
