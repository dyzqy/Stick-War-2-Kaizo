package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   
   public class SandstormEye extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      public var unit:Unit;
      
      private var _isCure:Boolean;
      
      public var lifeFrames:int;
      
      public function SandstormEye(param1:StickWar)
      {
         super();
         type = SANDSTORM_EYE;
         this.lifeFrames = 0;
         this.spellMc = new eyeballEyeEffect();
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
         --this.lifeFrames;
         Util.animateMovieClip(this.spellMc);
         this.spellMc.nextFrame();
         scaleX *= 1;
         scaleY *= 1;
         x = px;
         y = py + pz;
      }
      
      override public function isReadyForCleanup() : Boolean
      {
         return this.lifeFrames == 0;
      }
      
      override public function isInFlight() : Boolean
      {
         return this.lifeFrames > 0;
      }
   }
}
