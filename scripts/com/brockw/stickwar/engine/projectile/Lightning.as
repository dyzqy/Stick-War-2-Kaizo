package com.brockw.stickwar.engine.projectile
{
   import com.brockw.stickwar.engine.*;
   import com.brockw.stickwar.engine.units.*;
   import flash.display.*;
   
   public class Lightning extends DirectedProjectile
   {
       
      
      public var spellMc:lightningMc;
      
      public var target:Unit;
      
      public var burnRadius:Number;
      
      public function Lightning(param1:StickWar)
      {
         super(param1);
         type = LIGHTNING;
         this.spellMc = new lightningMc();
         addChild(this.spellMc);
         this.spellMc.scaleX *= 1.5;
         this.spellMc.scaleY *= 1.5;
      }
      
      override public function update(param1:StickWar) : void
      {
         visible = true;
         this.scaleX = param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale);
         this.scaleY = param1.backScale + py / param1.map.height * (param1.frontScale - param1.backScale);
         this.x = this.target.px;
         this.y = this.target.py + this.target.pz;
         t += 1;
         if(t == 5)
         {
            this.target.damage(0,0,inflictor);
            param1.bloodManager.addAsh(this.target.px,this.target.py,1,param1);
            splashNumHit = 0;
            param1.spatialHash.mapInArea(this.target.px - this.burnRadius,this.target.py - this.burnRadius,this.target.px + this.burnRadius,this.target.py + this.burnRadius,this.burnArea);
         }
         this.spellMc.lightning.nextFrame();
      }
      
      private function burnArea(param1:Unit) : void
      {
         if(splashNumHit < 4)
         {
            if(Unit(param1).team == this.target.team)
            {
               if(Math.pow(this.target.px - param1.px,2) + Math.pow(this.target.py - param1.py,2) < this.burnRadius * this.burnRadius)
               {
                  if(!param1.isOnFire)
                  {
                     ++splashNumHit;
                     param1.setFire(this.burnFrames,this.burnDamage);
                  }
               }
            }
         }
      }
      
      override public function isReadyForCleanup() : Boolean
      {
         return MovieClip(this.spellMc.lightning).currentFrame == MovieClip(this.spellMc.lightning).totalFrames;
      }
      
      override public function isInFlight() : Boolean
      {
         return MovieClip(this.spellMc.lightning).currentFrame != MovieClip(this.spellMc.lightning).totalFrames;
      }
   }
}
