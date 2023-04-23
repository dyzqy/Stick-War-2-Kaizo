package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   
   public class ProtectEffect extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      public var target:Unit;
      
      public var timeToLive:int;
      
      public function ProtectEffect(param1:StickWar)
      {
         super();
         type = PROTECT_EFFECT;
         this.spellMc = new protectEffectMc();
         this.addChild(this.spellMc);
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         removeChild(this.spellMc);
         this.spellMc = null;
      }
      
      override public function update(param1:StickWar) : void
      {
         Util.animateMovieClip(this.spellMc,4);
         if(this.target != null && this.target.isAlive() && this.target.isProtected())
         {
            this.px = this.target.px;
            this.py = this.target.py;
            this.pz = this.target.pz;
            x = px;
            y = py + pz;
         }
         else
         {
            this.timeToLive = 0;
         }
      }
      
      override public function isReadyForCleanup() : Boolean
      {
         return this.timeToLive == 0;
      }
      
      override public function isInFlight() : Boolean
      {
         return this.timeToLive > 0;
      }
   }
}
