package com.brockw.stickwar.market
{
   import flash.display.MovieClip;
   
   public class UnitButton
   {
       
      
      public var mc:MovieClip;
      
      public var id:int;
      
      public var xOffset:Number = 0;
      
      public var yOffset:Number = 0;
      
      public function UnitButton(param1:int, param2:MovieClip, param3:Number = 0, param4:Number = 0)
      {
         super();
         this.id = param1;
         this.mc = param2;
         this.xOffset = param3;
         this.yOffset = param4;
         param2.buttonMode = true;
         param2.mouseEnabled = true;
         param2.mouseChildren = false;
      }
   }
}
