package com.brockw.stickwar.engine.projectile
{
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   
   public class FistAttack extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      public var startX:Number;
      
      public var startY:Number;
      
      public var endX:Number;
      
      public var endY:Number;
      
      private var fistRange:Number;
      
      public function FistAttack(param1:StickWar)
      {
         super();
         type = FIST_ATTACK;
         this.spellMc = new skullHand();
         this.addChild(this.spellMc);
         this.spellMc.scaleX *= 1.5;
         this.spellMc.scaleY *= 1.5;
         this.fistRange = param1.xml.xml.Chaos.Units.skelator.fist.area;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         removeChild(this.spellMc);
         this.spellMc = null;
      }
      
      private function damageUnit(param1:Unit) : void
      {
         if(this.team != param1.team)
         {
            param1.damage(0,damageToDeal,null);
         }
      }
      
      override public function update(param1:StickWar) : void
      {
         if(this.spellMc.currentFrame == 1)
         {
            param1.soundManager.playSound("Hellfistin",px,py);
         }
         else if(this.spellMc.currentFrame == 24)
         {
            param1.soundManager.playSoundRandom("Hellfistout",3,px,py);
         }
         this.visible = true;
         this.spellMc.nextFrame();
         this.scaleX = 1 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.scaleY = 1 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         if(this.spellMc.currentFrame == 10)
         {
            param1.spatialHash.mapInArea(this.px - this.fistRange,this.py - this.fistRange,this.px + this.fistRange,this.py + this.fistRange,this.damageUnit);
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
