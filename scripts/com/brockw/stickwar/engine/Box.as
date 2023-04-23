package com.brockw.stickwar.engine
{
   import flash.display.Shape;
   
   public class Box extends Shape
   {
       
      
      private var startX:int;
      
      private var startY:int;
      
      private var _isOn:Boolean;
      
      private var endX:int;
      
      private var endY:int;
      
      public function Box()
      {
         super();
         this.startX = 0;
         this.startY = 0;
         this.isOn = false;
      }
      
      public function get isOn() : Boolean
      {
         return this._isOn;
      }
      
      public function set isOn(param1:Boolean) : void
      {
         this._isOn = param1;
      }
      
      public function start(param1:int, param2:int) : void
      {
         this.isOn = true;
         this.endX = this.startX = param1;
         this.endY = this.startY = param2;
         this.update(this.endX,this.endY);
      }
      
      public function update(param1:int, param2:int) : void
      {
         if(this.isOn)
         {
            this.graphics.clear();
            this.graphics.lineStyle(2,65280,0.75);
            this.graphics.moveTo(this.startX,this.startY);
            this.graphics.beginFill(65280,0.2);
            this.graphics.lineTo(param1,this.startY);
            this.graphics.lineTo(param1,param2);
            this.graphics.lineTo(this.startX,param2);
            this.graphics.lineTo(this.startX,this.startY);
            this.endX = param1;
            this.endY = param2;
         }
      }
      
      public function end() : void
      {
         this.isOn = false;
      }
      
      public function isInside(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         var _loc5_:int = Math.min(this.endX,this.startX);
         var _loc6_:int = Math.min(this.endY,this.startY);
         var _loc7_:int = Math.max(this.endX,this.startX);
         var _loc8_:int = Math.max(this.endY,this.startY);
         return param1 > _loc5_ && param1 < _loc7_ && _loc6_ < param2 && param2 - param3 < _loc8_;
      }
   }
}
