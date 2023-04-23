package com.brockw.stickwar.engine.projectile
{
   import com.brockw.game.*;
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.*;
   import flash.utils.Dictionary;
   
   public class Hurricane extends Projectile
   {
       
      
      public var endX:Number;
      
      public var endY:Number;
      
      public var arrived:Boolean;
      
      internal var spellMc:MovieClip;
      
      private var stunFrames:int;
      
      private var stunForce:Number;
      
      private var hurricaneDamage:Number;
      
      private var hurricaneArea:Number;
      
      public var alreadyHit:Dictionary;
      
      public function Hurricane(param1:StickWar)
      {
         super();
         type = HURRICANE;
         this.spellMc = new tornadoMc();
         this.addChild(this.spellMc);
         this.stunFrames = param1.xml.xml.Elemental.Units.hurricaneElement.hurricane.stunFrames;
         this.stunForce = param1.xml.xml.Elemental.Units.hurricaneElement.hurricane.stunForce;
         this.hurricaneDamage = param1.xml.xml.Elemental.Units.hurricaneElement.hurricane.damage;
         this.hurricaneArea = param1.xml.xml.Elemental.Units.hurricaneElement.hurricane.area;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         removeChild(this.spellMc);
         this.spellMc = null;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc2_:Number = NaN;
         Util.animateMovieClipBasic(this.spellMc);
         this.scaleX = 7 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         this.scaleY = 7 * (param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale));
         _loc2_ = Math.sqrt(Math.pow(this.endX - px,2) + Math.pow(this.endY - py,2));
         var _loc3_:Number = (this.endX - px) / _loc2_;
         var _loc4_:Number = (this.endY - py) / _loc2_;
         this.px += _loc3_ * 10;
         this.py += _loc4_ * 10;
         x = px;
         y = py + pz;
         var _loc5_:Number = Math.sqrt(Math.pow(this.endX - px,2) + Math.pow(this.endY - py,2));
         if(_loc2_ < 100)
         {
            alpha = _loc2_ / 100;
         }
         else
         {
            alpha = 1;
         }
         if(_loc5_ > _loc2_)
         {
            this.arrived = true;
         }
         else
         {
            param1.spatialHash.mapInArea(px - this.hurricaneArea,py - this.hurricaneArea,px + this.hurricaneArea,py + this.hurricaneArea,this.damageUnit);
         }
      }
      
      private function damageUnit(param1:Unit) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.team != this.team && !(param1 in this.alreadyHit))
         {
            if(Math.pow(param1.px - this.px,2) + Math.pow(param1.py - this.py,2) < Math.pow(this.hurricaneArea,2))
            {
               dz = dx = dy = 0;
               this.alreadyHit[param1] = 1;
               _loc2_ = Number(this.hurricaneDamage);
               _loc3_ = Number(this.hurricaneDamage);
               param1.damage(1,_loc2_,null);
               param1.stun(this.stunFrames,this.stunForce);
            }
         }
      }
      
      override public function isReadyForCleanup() : Boolean
      {
         return this.arrived == true;
      }
      
      override public function isInFlight() : Boolean
      {
         return this.arrived == false;
      }
   }
}
