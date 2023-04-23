package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   
   public class Bolt extends Projectile
   {
       
      
      private var mc:boltMc;
      
      public function Bolt(param1:StickWar)
      {
         super();
         isFire = false;
         type = BOLT;
         hasArrowDeath = true;
         this.mc = new boltMc();
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
