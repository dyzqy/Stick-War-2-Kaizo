package com.brockw.stickwar.engine.projectile
{
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class Heal extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      public function Heal(param1:StickWar)
      {
         super();
         type = HEAL;
         this.spellMc = new healSpellMc();
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
         var _loc4_:int = 0;
         this.spellMc.nextFrame();
         this.scaleX = 0.4 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.scaleY = 0.4 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         var _loc2_:Vector.<Entity> = param1.spatialHash.getNearbyEntitysXY(this.px,this.py);
         var _loc3_:int = param1.spatialHash.getNumberOfNearbyEntitysXY(this.px,this.py);
         if(this.spellMc.currentFrame == Math.floor(this.spellMc.totalFrames / 4))
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(Unit(_loc2_[_loc4_]).team == this.team)
               {
                  if(Math.pow(Unit(_loc2_[_loc4_]).px - this.px,2) + Math.pow(Unit(_loc2_[_loc4_]).py - this.py,2) < Math.pow(param1.xml.xml.Order.Units.monk.healArea,2))
                  {
                     dz = dx = dy = 0;
                     Unit(_loc2_[_loc4_]).heal(param1.xml.xml.Order.Units.monk.healAmount,param1.xml.xml.Order.Units.monk.healDuration);
                  }
               }
               _loc4_++;
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
