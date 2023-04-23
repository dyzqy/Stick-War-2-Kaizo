package com.brockw.stickwar.engine.projectile
{
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   
   public class Firebreath extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      public var unit:Unit;
      
      private var _isCure:Boolean;
      
      public function Firebreath(param1:StickWar)
      {
         super();
         type = FIREBREATH;
         this.spellMc = new firebreathBall();
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
         this.spellMc.nextFrame();
         x = px;
         y = py + pz;
      }
      
      override public function isReadyForCleanup() : Boolean
      {
         return this.spellMc.currentFrame == this.spellMc.totalFrames;
      }
      
      override public function isInFlight() : Boolean
      {
         return this.spellMc.currentFrame != this.spellMc.totalFrames;
      }
   }
}
