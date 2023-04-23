package com.brockw.stickwar.engine
{
   public class Rain extends Entity
   {
       
      
      internal var game:StickWar;
      
      internal var rain:Array;
      
      internal var numParticles:int;
      
      public function Rain(param1:StickWar, param2:int)
      {
         super();
         this.rain = [];
         this.game = param1;
         this.numParticles = param2;
         this.init(param1);
         py = param1.map.height;
      }
      
      public function init(param1:StickWar) : void
      {
         var _loc3_:RainDrop = null;
         var _loc2_:* = 0;
         while(_loc2_ < this.numParticles)
         {
            _loc3_ = new RainDrop(param1);
            addChild(_loc3_);
            this.rain.push(_loc3_);
            _loc2_++;
         }
      }
      
      public function update(param1:StickWar) : void
      {
         x = param1.battlefield.x;
         var _loc2_:* = 0;
         while(_loc2_ < this.numParticles)
         {
            this.rain[_loc2_].update(param1);
            _loc2_++;
         }
      }
   }
}
