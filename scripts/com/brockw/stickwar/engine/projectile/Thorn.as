package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   
   public class Thorn extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      public var target:Unit = null;
      
      public var hasBloomed:Boolean;
      
      public function Thorn(param1:StickWar)
      {
         super();
         type = THORN;
         this.spellMc = new thornspawn();
         this.addChild(this.spellMc);
         scale = 1;
         this.hasBloomed = false;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         removeChild(this.spellMc);
         this.spellMc = null;
      }
      
      override public function update(param1:StickWar) : void
      {
         Util.animateMovieClipBasic(this.spellMc);
         if(this.target != null && this.target.isAlive() && this.spellMc.currentFrame < 10)
         {
            x = px = this.target.px;
            y = py = this.target.py;
         }
         if(this.spellMc.currentFrame == 11 && this.target != null)
         {
            this.target.damage(0,this.damageToDeal,null);
            this.target.stun(this.stunTime,2);
         }
         this.scaleX = scale * team.direction;
         this.scaleY = scale;
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
