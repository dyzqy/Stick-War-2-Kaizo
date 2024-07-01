package com.brockw.stickwar.engine.projectile
{
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.units.Unit;
      import flash.display.*;
      
      public class IceFreezeEffect extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            public var unit:Unit;
            
            private var _isCure:Boolean;
            
            public function IceFreezeEffect(param1:StickWar)
            {
                  super();
                  type = ICE_FREEZE_EFFECT;
                  this.spellMc = new snowburstMc();
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
                  x = px;
                  y = py;
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
