package com.brockw.game
{
   import com.smartfoxserver.v2.entities.data.SFSObject;
   import flash.display.*;
   
   public class Util
   {
      
      private static var sineTable:Array;
      
      private static var cosTable:Array;
      
      private static var tanTable:Array;
      
      private static const PI:Number = 3.14159265;
      
      private static const GRANULATIRY:Number = 360;
       
      
      public function Util()
      {
         super();
         this.preComputeMath();
      }
      
      public static function sin(param1:Number) : Number
      {
         param1 = param1 * 180 / PI;
         param1 %= 360;
         if(param1 < 0)
         {
            param1 += 360;
         }
         return Util.sineTable[Math.floor(param1)];
      }
      
      public static function cos(param1:Number) : Number
      {
         param1 = param1 * 180 / PI;
         param1 %= 360;
         if(param1 < 0)
         {
            param1 += 360;
         }
         return Util.cosTable[Math.floor(param1)];
      }
      
      public static function tan(param1:Number) : Number
      {
         param1 = param1 * 180 / PI;
         param1 %= 360;
         if(param1 < 0)
         {
            param1 += 360;
         }
         return Util.tanTable[Math.floor(param1)];
      }
      
      public static function sgn(param1:Number) : int
      {
         if(param1 < 0)
         {
            return -1;
         }
         return 1;
      }
      
      public static function clearSFSObject(param1:SFSObject) : void
      {
         var _loc3_:String = null;
         var _loc2_:Array = param1.getKeys();
         for(_loc3_ in _loc2_)
         {
            param1.removeElement(_loc3_);
         }
      }
      
      public static function animateMovieClipBasic(param1:MovieClip) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.currentFrameLabel == "stop")
         {
            return;
         }
         if(param1.currentFrame == param1.totalFrames)
         {
            param1.gotoAndStop(1);
         }
         else
         {
            param1.nextFrame();
         }
      }
      
      public static function animateMovieClip(param1:MovieClip, param2:int = 0, param3:int = -1) : void
      {
         var _loc5_:DisplayObject = null;
         if(param3 == 0)
         {
            return;
         }
         var _loc4_:* = 0;
         while(_loc4_ < param1.numChildren)
         {
            if((_loc5_ = param1.getChildAt(_loc4_)) is MovieClip)
            {
               animateMovieClip(MovieClip(_loc5_),param2 - 1,param3 - 1);
               if(MovieClip(_loc5_).currentFrameLabel == null)
               {
                  if(MovieClip(_loc5_).currentFrame == MovieClip(_loc5_).totalFrames)
                  {
                     if(param2 <= 0)
                     {
                        MovieClip(_loc5_).gotoAndStop(1);
                     }
                  }
                  else
                  {
                     MovieClip(_loc5_).nextFrame();
                  }
               }
            }
            _loc4_++;
         }
      }
      
      public static function animateToNeutral(param1:MovieClip, param2:int = -1) : void
      {
         var _loc4_:DisplayObject = null;
         if(param2 == 0)
         {
            return;
         }
         var _loc3_:* = 0;
         while(_loc3_ < param1.numChildren)
         {
            if((_loc4_ = param1.getChildAt(_loc3_)) is MovieClip)
            {
               MovieClip(_loc4_).gotoAndStop(1);
               animateToNeutral(MovieClip(_loc4_),param2 - 1);
            }
            _loc3_++;
         }
      }
      
      public static function recursiveRemoval(param1:Sprite) : void
      {
         var _loc2_:DisplayObject = null;
         while(param1 != null && param1.numChildren > 0)
         {
            _loc2_ = param1.getChildAt(0);
            if(_loc2_ == null)
            {
               break;
            }
            if(_loc2_ is Sprite || _loc2_ is MovieClip)
            {
               recursiveRemoval(Sprite(_loc2_));
            }
            param1.removeChild(_loc2_);
         }
      }
      
      public function preComputeMath() : void
      {
         Util.sineTable = [];
         Util.cosTable = [];
         Util.tanTable = [];
         var _loc1_:* = 0;
         while(_loc1_ < GRANULATIRY)
         {
            Util.sineTable[_loc1_] = Math.sin(_loc1_ * PI / 180);
            Util.cosTable[_loc1_] = Math.cos(_loc1_ * PI / 180);
            Util.tanTable[_loc1_] = Math.tan(_loc1_ * PI / 180);
            _loc1_++;
         }
      }
   }
}
