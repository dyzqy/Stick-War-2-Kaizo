package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   import flash.filters.*;
   
   public class FirestormBack extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      internal var radiantSpellGlow:GlowFilter;
      
      public var stunForce:Number;
      
      private var explosionRadius:Number;
      
      public function FirestormBack(param1:StickWar)
      {
         super();
         type = FIRESTORM_BACK;
         this.spellMc = new fireCircleBackMc();
         this.addChild(this.spellMc);
         this.radiantSpellGlow = new GlowFilter();
         this.radiantSpellGlow.color = 16711680;
         this.radiantSpellGlow.blurX = 20;
         this.radiantSpellGlow.blurY = 10;
         this.explosionRadius = param1.xml.xml.Elemental.Units.firestormElement.firestorm.area;
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
         Util.animateMovieClip(this.spellMc);
         scaleX *= 1;
         scaleY *= 1;
         if(this.spellMc.currentFrame == 20)
         {
            param1.soundManager.playSound("rumbleshortSound",px,py);
         }
         if(this.spellMc.currentFrame == 70)
         {
            team.game.soundManager.playSound("largeDragonRoarSound",px,py);
         }
         if(this.spellMc.currentFrame > 76)
         {
            this.spellMc.filters = [this.radiantSpellGlow];
         }
         else
         {
            this.spellMc.filters = [];
         }
         if(this.spellMc.currentFrame == 95)
         {
            param1.spatialHash.mapInArea(px - this.explosionRadius,py - this.explosionRadius,px + this.explosionRadius,py + this.explosionRadius,this.damageUnit);
         }
      }
      
      private function damageUnit(param1:Unit) : void
      {
         if(param1.team != this.team)
         {
            if(Math.pow(param1.px - this.px,2) + Math.pow(param1.py - this.py,2) < Math.pow(this.explosionRadius,2))
            {
               dz = dx = dy = 0;
               param1.damage(1,this.damageToDeal,null);
               param1.setFire(burnFrames,burnDamage);
               param1.stun(50,this.stunForce);
            }
         }
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
