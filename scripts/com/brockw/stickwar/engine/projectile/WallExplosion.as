package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import flash.display.*;
   
   public class WallExplosion extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      internal var explosionRadius:Number;
      
      internal var explosionDamage:Number;
      
      public function WallExplosion(param1:StickWar)
      {
         super();
         type = WALL_EXPLOSION;
         this.spellMc = new wallExplosion();
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
         this.scaleX = 0.4 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.scaleY = 0.4 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
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
