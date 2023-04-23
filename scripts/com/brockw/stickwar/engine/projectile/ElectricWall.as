package com.brockw.stickwar.engine.projectile
{
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class ElectricWall extends Projectile
   {
       
      
      internal var spellMc:MovieClip;
      
      private var wallArea:Number;
      
      private var frequency:Number;
      
      public function ElectricWall(param1:StickWar)
      {
         var _loc3_:DisplayObject = null;
         super();
         type = ELECTRIC_WALL;
         this.spellMc = new electricWallMc();
         this.addChild(this.spellMc);
         var _loc2_:* = 0;
         while(_loc2_ < this.spellMc.numChildren)
         {
            _loc3_ = this.spellMc.getChildAt(_loc2_);
            if(_loc3_ is MovieClip)
            {
               MovieClip(_loc3_).gotoAndStop(Math.floor(param1.random.nextNumber() * MovieClip(_loc3_).totalFrames));
            }
            _loc2_++;
         }
         this.wallArea = param1.xml.xml.Order.Units.magikill.electricWall.area;
         this.frequency = param1.xml.xml.Order.Units.magikill.electricWall.frequency;
      }
      
      override public function cleanUp() : void
      {
         super.cleanUp();
         removeChild(this.spellMc);
         this.spellMc = null;
      }
      
      override public function update(param1:StickWar) : void
      {
         var _loc3_:DisplayObject = null;
         this.visible = true;
         this.spellMc.nextFrame();
         var _loc2_:* = 0;
         while(_loc2_ < this.spellMc.numChildren)
         {
            _loc3_ = this.spellMc.getChildAt(_loc2_);
            if(_loc3_ is MovieClip)
            {
               MovieClip(_loc3_).nextFrame();
               if(MovieClip(_loc3_).currentFrame == MovieClip(_loc3_).totalFrames)
               {
                  MovieClip(_loc3_).gotoAndStop(1);
               }
            }
            _loc2_++;
         }
         if(param1.frame % this.frequency == 0)
         {
            param1.spatialHash.mapInArea(this.px - this.wallArea,0,this.px + this.wallArea,param1.map.height,this.hitElectricWall);
         }
         if(this.isReadyForCleanup())
         {
            this.visible = false;
         }
      }
      
      private function hitElectricWall(param1:Unit) : void
      {
         if(param1.team != this.team)
         {
            if(Math.abs(param1.px - this.px) < this.wallArea)
            {
               Entity(param1.damage(Unit.D_NO_SOUND | Unit.D_NO_BLOOD,damageToDeal,null));
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
