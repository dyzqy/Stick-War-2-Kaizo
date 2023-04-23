package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class LavaRain extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      internal var explosionRadius:Number;
      
      internal var explosionDamage:Number;
      
      public function LavaRain(param1:StickWar)
      {
         super();
         type = LAVA_RAIN;
         this.spellMc = new lavaRainMc();
         this.addChild(this.spellMc);
         this.explosionRadius = 50;
         this.explosionDamage = param1.xml.xml.Elemental.Units.firestormElemental.firebreath.rainDamage;
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
         this.scaleX = scale * 1 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.scaleY = Math.abs(scale) * 1 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         visible = true;
         if(this.spellMc.currentFrame == 25)
         {
            hasHit = false;
            param1.spatialHash.mapInArea(px - this.explosionRadius,py - this.explosionRadius,px + this.explosionRadius,py + this.explosionRadius,this.damageUnit);
         }
      }
      
      private function damageUnit(param1:Unit) : void
      {
         if(!hasHit && param1.team != this.team)
         {
            if(Math.pow(param1.px - this.px,2) + Math.pow(param1.py - this.py,2) < Math.pow(this.explosionRadius,2))
            {
               dz = dx = dy = 0;
               hasHit = true;
               param1.damage(Unit.D_FIRE,this.explosionDamage,null);
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
