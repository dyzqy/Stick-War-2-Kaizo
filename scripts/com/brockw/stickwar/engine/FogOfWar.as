package com.brockw.stickwar.engine
{
   import flash.display.*;
   import flash.geom.*;
   
   public class FogOfWar extends Entity
   {
      
      private static const TARGET_ALPHA:Number = 0.7;
       
      
      private var X_SIZE:Number = 100;
      
      private var Y_SIZE:Number = 700;
      
      private var VISION_LENGTH:int;
      
      private var oldForwardPosition:Number;
      
      private var movingFog:Array;
      
      internal var fog:_fog;
      
      internal var fogLowQuality:_fogLowQuality;
      
      internal var fogBlur:_fogFade;
      
      internal var xPos:Number;
      
      public var isFogOn:Boolean;
      
      private var blockMc:MovieClip;
      
      public function FogOfWar(param1:StickWar)
      {
         super();
         this.xPos = 0;
         this.isFogOn = true;
         this.fog = new _fog();
         this.fog.y = 0;
         this.setTint(this.fog,0,0.9);
         this.fog.alpha = TARGET_ALPHA;
         addChild(this.fog);
         this.VISION_LENGTH = param1.xml.xml.visionSize;
         this.fog.cacheAsBitmap = true;
         this.fogLowQuality = new _fogLowQuality();
         this.fogLowQuality.y = 0;
         this.fogLowQuality.alpha = 1;
         addChild(this.fogLowQuality);
         this.VISION_LENGTH = param1.xml.xml.visionSize;
         this.fogLowQuality.cacheAsBitmap = true;
      }
      
      internal function setTint(param1:DisplayObject, param2:uint, param3:Number) : void
      {
         var _loc4_:ColorTransform = new ColorTransform();
         _loc4_.redMultiplier = _loc4_.greenMultiplier = _loc4_.blueMultiplier = 1 - param3;
         _loc4_.redOffset = Math.round(((param2 & 16711680) >> 16) * param3);
         _loc4_.greenOffset = Math.round(((param2 & 65280) >> 8) * param3);
         _loc4_.blueOffset = Math.round((param2 & 255) * param3);
         param1.transform.colorTransform = _loc4_;
      }
      
      public function update(param1:StickWar) : void
      {
         var _loc2_:* = param1.team.getVisionRange();
         if(!this.isFogOn)
         {
            this.alpha = 0;
         }
         else
         {
            alpha = 1;
         }
         if(this.xPos == 0)
         {
            this.xPos = _loc2_;
         }
         this.xPos += (_loc2_ - this.xPos) * 1;
         if(param1.gameScreen.hasAlphaOnFogOfWar)
         {
            if(!contains(this.fog))
            {
               addChild(this.fog);
            }
            if(contains(this.fogLowQuality))
            {
               removeChild(this.fogLowQuality);
            }
            if(param1.team == param1.teamB)
            {
               this.fog.scaleX = -1;
            }
            else
            {
               this.fog.scaleX = 1;
            }
            if(param1.team.direction == 1)
            {
               this.fog.x = Math.max(this.xPos,param1.screenX);
            }
            else
            {
               this.fog.x = Math.min(this.xPos,param1.screenX + param1.map.screenWidth);
            }
         }
         else
         {
            if(!contains(this.fogLowQuality))
            {
               addChild(this.fogLowQuality);
            }
            if(contains(this.fog))
            {
               removeChild(this.fog);
            }
            if(param1.team == param1.teamB)
            {
               this.fogLowQuality.scaleX = -1;
            }
            else
            {
               this.fogLowQuality.scaleX = 1;
            }
            if(param1.team.direction == 1)
            {
               this.fogLowQuality.x = Math.max(this.xPos,param1.screenX);
            }
            else
            {
               this.fogLowQuality.x = Math.min(this.xPos,param1.screenX + param1.map.screenWidth);
            }
         }
      }
   }
}
