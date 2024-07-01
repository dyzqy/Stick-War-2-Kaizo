package com.brockw.stickwar.engine.projectile
{
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.*;
      
      public class SmokePuff extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            public var unit:Unit;
            
            private var _isCure:Boolean;
            
            public function SmokePuff(param1:StickWar)
            {
                  super();
                  type = SMOKE_PUFF;
                  this.spellMc = new smokeFromFireElement();
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
                  scaleX *= 1;
                  scaleY *= 1;
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
