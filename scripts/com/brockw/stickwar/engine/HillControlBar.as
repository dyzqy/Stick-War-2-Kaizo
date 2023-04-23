package com.brockw.stickwar.engine
{
   import flash.display.Sprite;
   
   public class HillControlBar extends Sprite
   {
      
      private static const BAR_WIDTH:Number = 30;
      
      private static const BAR_HEIGHT:Number = 5;
       
      
      public function HillControlBar()
      {
         super();
      }
      
      public function update(param1:Number, param2:int) : void
      {
         this.graphics.clear();
         this.graphics.moveTo(-BAR_WIDTH / 2,-BAR_HEIGHT / 2);
         this.graphics.beginFill(0,0.5);
         this.graphics.lineTo(BAR_WIDTH / 2,-BAR_HEIGHT / 2);
         this.graphics.lineTo(BAR_WIDTH / 2,BAR_HEIGHT / 2);
         this.graphics.lineTo(-BAR_WIDTH / 2,BAR_HEIGHT / 2);
         this.graphics.lineTo(-BAR_WIDTH / 2,-BAR_HEIGHT / 2);
         this.graphics.moveTo(0,-BAR_HEIGHT / 2);
         this.graphics.beginFill(param2,1);
         this.graphics.lineTo(0 + BAR_WIDTH * param1,-BAR_HEIGHT / 2);
         this.graphics.lineTo(0 + BAR_WIDTH * param1,BAR_HEIGHT / 2);
         this.graphics.lineTo(0,BAR_HEIGHT / 2);
         this.graphics.lineTo(0,-BAR_HEIGHT / 2);
      }
   }
}
