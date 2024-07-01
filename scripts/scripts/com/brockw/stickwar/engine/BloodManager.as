package com.brockw.stickwar.engine
{
      import com.brockw.game.*;
      import flash.display.Sprite;
      
      public class BloodManager extends Sprite
      {
            
            private static const NUM_BLOODS:int = 100;
            
            private static const NUM_ASHES:int = 25;
             
            
            private var bloodPool:Array;
            
            private var bloods:Array;
            
            private var ashPool:Array;
            
            private var ashs:Array;
            
            public function BloodManager()
            {
                  var _loc1_:int = 0;
                  var _loc2_:bloodSplat = null;
                  var _loc3_:_ash = null;
                  this.bloods = [];
                  this.bloodPool = [];
                  _loc1_ = 0;
                  while(_loc1_ < NUM_BLOODS)
                  {
                        _loc2_ = new bloodSplat();
                        _loc2_.cacheAsBitmap = true;
                        this.bloodPool.push(_loc2_);
                        _loc1_++;
                  }
                  this.ashs = [];
                  this.ashPool = [];
                  _loc1_ = 0;
                  while(_loc1_ < NUM_ASHES)
                  {
                        _loc3_ = new _ash();
                        _loc3_.cacheAsBitmap = true;
                        this.ashPool.push(_loc3_);
                        _loc1_++;
                  }
                  super();
            }
            
            public function addAsh(param1:Number, param2:Number, param3:int, param4:StickWar) : void
            {
                  var _loc5_:_ash = null;
                  if(this.ashPool.length > 0)
                  {
                        _loc5_ = this.ashPool.pop();
                  }
                  else
                  {
                        _loc5_ = this.ashs.shift();
                  }
                  this.ashs.push(_loc5_);
                  _loc5_.gotoAndStop(param4.random.nextInt() % _loc5_.totalFrames);
                  _loc5_.x = param1;
                  _loc5_.y = param2;
                  _loc5_.alpha = 0.9;
                  _loc5_.scaleX = -Util.sgn(param3) * param4.getPerspectiveScale(param2);
                  _loc5_.scaleY = param4.getPerspectiveScale(param2);
                  addChild(_loc5_);
            }
            
            public function addBlood(param1:Number, param2:Number, param3:int, param4:StickWar) : void
            {
                  var _loc5_:bloodSplat = null;
                  if(this.bloodPool.length > 0)
                  {
                        _loc5_ = this.bloodPool.pop();
                  }
                  else
                  {
                        _loc5_ = this.bloods.shift();
                  }
                  this.bloods.push(_loc5_);
                  _loc5_.gotoAndStop(param4.random.nextInt() % _loc5_.totalFrames);
                  _loc5_.x = param1;
                  _loc5_.y = param2;
                  _loc5_.alpha = 0.8;
                  _loc5_.scaleX = -Util.sgn(param3) * param4.getPerspectiveScale(param2);
                  _loc5_.scaleY = param4.getPerspectiveScale(param2);
                  addChild(_loc5_);
            }
      }
}
