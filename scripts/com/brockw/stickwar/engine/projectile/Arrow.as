package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   
   public class Arrow extends Projectile
   {
       
      
      private var mc:arrowMc;
      
      public function Arrow(param1:StickWar)
      {
         super();
         isFire = false;
         type = ARROW;
         hasArrowDeath = true;
         this.mc = new arrowMc();
         addChild(this.mc);
      }
      
      public function setArrowGraphics(param1:Boolean) : void
      {
         if(param1)
         {
            this.mc.gotoAndStop(2);
         }
         else
         {
            this.mc.gotoAndStop(1);
         }
      }
      
      override public function update(param1:StickWar) : void
      {
         super.update(param1);
         Util.animateMovieClip(this.mc);
         if(!this.isInFlight())
         {
            this.mc.gotoAndStop(3);
         }
      }
   }
}
